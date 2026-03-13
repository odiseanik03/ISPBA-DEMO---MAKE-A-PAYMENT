#!/usr/bin/env bash
set -euo pipefail

require_in_file() {
  local needle="$1"
  local file="$2"
  if ! rg -F --quiet "$needle" "$file"; then
    echo "[contracts] missing '$needle' in $file" >&2
    exit 1
  fi
}

DOC=docs/API_CONTRACTS.md

# Backend API contracts
require_in_file 'POST `/api/demo/session`' "$DOC"
require_in_file 'GET `/api/accounts`' "$DOC"
require_in_file 'POST `/api/payments`' "$DOC"
require_in_file 'GET `/api/transactions?status=PENDING&page=0&size=10`' "$DOC"
require_in_file 'GET `/api/reports/summary`' "$DOC"
require_in_file 'GET `/api/reports/suspicious-flags`' "$DOC"
require_in_file 'GET `/api/admin/audit-logs?page=0&size=20`' "$DOC"

# Analytics contracts
require_in_file 'POST `/analytics/run/risk-check`' "$DOC"
require_in_file 'POST `/analytics/run/data-quality`' "$DOC"
require_in_file 'POST `/analytics/run/daily-report`' "$DOC"
require_in_file 'GET `/analytics/reports/latest`' "$DOC"

# Verify routes exist in code
require_in_file '@router.post("/run/risk-check"' analytics-python/app/api/routes_analytics.py
require_in_file '@router.post("/run/data-quality"' analytics-python/app/api/routes_analytics.py
require_in_file '@router.post("/run/daily-report"' analytics-python/app/api/routes_analytics.py
require_in_file '@router.get("/reports/latest")' analytics-python/app/api/routes_analytics.py

require_in_file '@PostMapping' backend-java/src/main/java/com/accountflow/payments/controller/PaymentController.java
require_in_file '@GetMapping("/summary")' backend-java/src/main/java/com/accountflow/reports/controller/ReportsController.java
require_in_file '@GetMapping("/suspicious-flags")' backend-java/src/main/java/com/accountflow/reports/controller/ReportsController.java
require_in_file '@GetMapping("/audit-logs")' backend-java/src/main/java/com/accountflow/admin/controller/AdminAuditController.java

echo "[contracts] API contract sync checks passed"
