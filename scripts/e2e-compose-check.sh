#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  docker compose down -v >/dev/null 2>&1 || true
}
trap cleanup EXIT

echo "[e2e] booting stack"
docker compose up -d --build

echo "[e2e] waiting for Java health"
for i in {1..30}; do
  if curl -sf http://localhost:8080/api/health >/dev/null; then
    break
  fi
  sleep 2
  if [[ $i -eq 30 ]]; then
    echo "Java API did not become healthy" >&2
    exit 1
  fi
done

echo "[e2e] waiting for Analytics health"
for i in {1..30}; do
  if curl -sf http://localhost:8090/health >/dev/null; then
    break
  fi
  sleep 2
  if [[ $i -eq 30 ]]; then
    echo "Analytics API did not become healthy" >&2
    exit 1
  fi
done

./scripts/demo-smoke.sh

echo "[e2e] complete"
