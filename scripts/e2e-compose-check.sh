#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  docker compose down -v >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "[e2e] booting stack"
docker compose up -d --build

echo "[e2e] waiting for Java health"
for i in {1..45}; do
  if curl -sf http://localhost:8080/api/health >/dev/null; then
    break
  fi
  sleep 2
  if [[ $i -eq 45 ]]; then
    echo "Java API did not become healthy" >&2
    docker compose logs backend-java >&2 || true
    exit 1
  fi
done

echo "[e2e] waiting for Analytics health"
for i in {1..45}; do
  if curl -sf http://localhost:8090/health >/dev/null; then
    break
  fi
  sleep 2
  if [[ $i -eq 45 ]]; then
    echo "Analytics API did not become healthy" >&2
    docker compose logs analytics-python >&2 || true
    exit 1
  fi
done

./scripts/demo-smoke.sh

echo "[e2e] validating analytics persistence tables"
run_sql() {
  docker compose exec -T postgres psql -U "${POSTGRES_USER:-accountflow}" -d "${POSTGRES_DB:-accountflow}" -t -A -c "$1"
}

reports_count=$(run_sql "select count(*) from reports;")
flags_count=$(run_sql "select count(*) from suspicious_flags;")
dq_count=$(run_sql "select count(*) from data_quality_results;")

echo "[e2e] reports=$reports_count suspicious_flags=$flags_count data_quality_results=$dq_count"

if [[ "$reports_count" -lt 1 ]]; then
  echo "Expected at least 1 report row after analytics jobs" >&2
  exit 1
fi

if [[ "$dq_count" -lt 1 ]]; then
  echo "Expected at least 1 data_quality_results row after analytics jobs" >&2
  exit 1
fi

echo "[e2e] complete"
