#!/usr/bin/env bash
set -euo pipefail

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

echo "[phase] shell checks"
bash -n scripts/bootstrap.sh scripts/demo-smoke.sh scripts/e2e-compose-check.sh

echo "[phase] python compile checks"
python3 -m compileall analytics-python/app analytics-python/tests

if has_cmd docker; then
  echo "[phase] running compose e2e"
  ./scripts/e2e-compose-check.sh
else
  echo "[phase] docker not available; skipped compose e2e"
fi

if has_cmd flutter; then
  echo "[phase] running flutter tests"
  (cd frontend-flutter && flutter test)
else
  echo "[phase] flutter not available; skipped flutter tests"
fi

if has_cmd mvn; then
  echo "[phase] running java tests"
  (cd backend-java && mvn -q test)
else
  echo "[phase] maven not available; skipped java tests"
fi

echo "[phase] validation complete"
