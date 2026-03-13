#!/usr/bin/env bash
set -euo pipefail

BASE_API=${BASE_API:-http://localhost:8080}
BASE_ANALYTICS=${BASE_ANALYTICS:-http://localhost:8090}

echo "[1] Health"
curl -sf "$BASE_API/api/health" >/dev/null

echo "[2] Demo session"
curl -sf -X POST "$BASE_API/api/demo/session" >/dev/null

echo "[3] Accounts"
curl -sf "$BASE_API/api/accounts" -H 'X-Demo-User-Id: 1' >/dev/null

echo "[4] Reports summary"
curl -sf "$BASE_API/api/reports/summary" >/dev/null

echo "[5] Analytics latest"
curl -sf "$BASE_ANALYTICS/analytics/reports/latest" >/dev/null

echo "Smoke checks passed."
