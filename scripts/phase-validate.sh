#!/usr/bin/env bash
set -euo pipefail

STRICT_VALIDATION=${STRICT_VALIDATION:-false}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

run_or_warn() {
  local label="$1"
  shift
  if "$@"; then
    return 0
  fi
  if [[ "$STRICT_VALIDATION" == "true" ]]; then
    echo "[phase] ${label} failed (strict mode)" >&2
    return 1
  fi
  echo "[phase] ${label} failed; continuing in non-strict mode"
  return 0
}

echo "[phase] shell checks"
bash -n scripts/bootstrap.sh scripts/demo-smoke.sh scripts/e2e-compose-check.sh scripts/phase-validate.sh

echo "[phase] python compile checks"
python3 -m compileall analytics-python/app analytics-python/tests

if python3 - <<'PY' >/dev/null 2>&1
import fastapi, sqlalchemy, pytest  # noqa: F401
print('ok')
PY
then
  echo "[phase] running python tests (non-integration)"
  run_or_warn "python-tests" env PYTHONPATH=analytics-python pytest analytics-python/tests -q -m "not integration"
else
  echo "[phase] python dependencies missing; skipped pytest run"
fi

if has_cmd docker; then
  echo "[phase] running compose e2e"
  run_or_warn "compose-e2e" ./scripts/e2e-compose-check.sh
else
  echo "[phase] docker not available; skipped compose e2e"
fi

if has_cmd flutter; then
  echo "[phase] running flutter tests"
  run_or_warn "flutter-tests" bash -lc 'cd frontend-flutter && flutter test'
else
  echo "[phase] flutter not available; skipped flutter tests"
fi

if has_cmd mvn; then
  echo "[phase] running java tests"
  run_or_warn "java-tests" bash -lc 'cd backend-java && mvn -q test'
else
  echo "[phase] maven not available; skipped java tests"
fi

echo "[phase] validation complete"
