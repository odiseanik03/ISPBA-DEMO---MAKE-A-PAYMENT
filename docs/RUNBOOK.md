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

## 3) Validation commands by phase

### Phase A — integrated validation
- Full stack + smoke + DB assertions:
  - `./scripts/e2e-compose-check.sh`

### Phase B — analytics semantics and persistence quality
- Analytics tests:
  - `PYTHONPATH=analytics-python pytest analytics-python/tests -q`
- Focused persistence tests:
  - `PYTHONPATH=analytics-python pytest analytics-python/tests/test_sqlite_persistence.py -q`

### Phase C — frontend quality
- Flutter test suite:
  - `cd frontend-flutter && flutter test`

### Phase D — release gates
- Java tests:
  - `cd backend-java && mvn -q test`
- Shell scripts syntax checks:
  - `bash -n scripts/bootstrap.sh scripts/demo-smoke.sh scripts/e2e-compose-check.sh`

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

## 6) Release checklist (go/no-go)
- [ ] `python-tests` job passes in CI.
- [ ] `java-tests` job passes in CI.
- [ ] `flutter-tests` job passes in CI.
- [ ] `shell-checks` job passes in CI.
- [ ] `compose-smoke` job passes in CI.
- [ ] Swagger endpoint and API contracts are in sync.
- [ ] Demo smoke script passes in local/staging environment.
