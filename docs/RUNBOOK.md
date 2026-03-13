# AccountFlow Runbook

## 1) Local startup
1. Bootstrap env files:
   - `./scripts/bootstrap.sh`
2. Start stack:
   - `docker compose up --build`

## 2) Service URLs
- Java API: `http://localhost:8080`
- Swagger UI: `http://localhost:8080/swagger-ui/index.html`
- FastAPI analytics: `http://localhost:8090`
- PostgreSQL: `localhost:5432`

## 3) Final phase execution

Run the single final-phase orchestrator:
- `./scripts/final-phase.sh`

Or run strict validation directly:
- `STRICT_VALIDATION=true ./scripts/phase-validate.sh`

## 4) Smoke checks covered by scripts
- `GET /api/health`
- `POST /api/demo/session`
- `GET /api/accounts`
- `GET /api/reports/summary`
- `POST /analytics/run/risk-check`
- `POST /analytics/run/data-quality`
- `POST /analytics/run/daily-report`
- `GET /analytics/reports/latest`
- Post-run DB row assertions in:
  - `reports`
  - `suspicious_flags`
  - `data_quality_results`

## 5) Important notes
- Analytics persistence is enabled in compose via `ENABLE_DB_PERSIST=true`.
- `scripts/e2e-compose-check.sh` is the primary end-to-end validation artifact and should pass before demo/release.

## 6) Final go/no-go checklist
- [ ] `python-tests` job passes in CI.
- [ ] `python-postgres-integration` job passes in CI.
- [ ] `java-tests` job passes in CI.
- [ ] `flutter-tests` job passes in CI.
- [ ] `shell-checks` job passes in CI.
- [ ] `compose-smoke` job passes in CI.
- [ ] Swagger endpoint and API contracts are in sync.
- [ ] Demo smoke script passes in local/staging environment.

## 7) Latest validation status (this branch)
- ✅ Shell scripts syntax checks passed.
- ✅ Python source/test compile checks passed.
- ⚠️ Full local compose e2e could not be executed in this environment (no docker binary available).
- ⚠️ Full Flutter test execution could not be executed in this environment (flutter SDK unavailable).
- ⚠️ Full Python dependency install from package index failed in this environment due proxy/network restrictions.

Use CI `accountflow-ci` as the source of truth for final 95–100% completion status.
