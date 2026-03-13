#!/usr/bin/env bash
set -euo pipefail

BASE_API=${BASE_API:-http://localhost:8080}
BASE_ANALYTICS=${BASE_ANALYTICS:-http://localhost:8090}

json_get() {
  local url="$1"
  curl -sf "$url"
}

json_post() {
  local url="$1"
  curl -sf -X POST "$url"
}

echo "[1] Health"
json_get "$BASE_API/api/health" >/dev/null
json_get "$BASE_ANALYTICS/health" >/dev/null

echo "[2] Demo session"
json_post "$BASE_API/api/demo/session" >/dev/null

echo "[3] Accounts"
curl -sf "$BASE_API/api/accounts" -H 'X-Demo-User-Id: 1' >/dev/null

echo "[4] Reports summary"
json_get "$BASE_API/api/reports/summary" >/dev/null

echo "[5] Trigger analytics jobs"
json_post "$BASE_ANALYTICS/analytics/run/risk-check" >/dev/null
json_post "$BASE_ANALYTICS/analytics/run/data-quality" >/dev/null
json_post "$BASE_ANALYTICS/analytics/run/daily-report" >/dev/null

echo "[6] Validate analytics latest payload"
LATEST=$(json_get "$BASE_ANALYTICS/analytics/reports/latest")
echo "$LATEST" | python3 -c 'import json,sys; d=json.load(sys.stdin); assert "daily" in d and "totalTransactions" in d["daily"]'

echo "Smoke checks passed."
