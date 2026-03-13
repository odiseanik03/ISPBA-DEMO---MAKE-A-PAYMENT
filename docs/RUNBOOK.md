# AccountFlow Runbook

## Local startup
1. `./scripts/bootstrap.sh`
2. `docker compose up --build`

## Service URLs
- Java API: `http://localhost:8080`
- Swagger UI: `http://localhost:8080/swagger-ui/index.html`
- FastAPI analytics: `http://localhost:8090`
- PostgreSQL: `localhost:5432`

## Smoke checks
- `GET /api/health`
- `POST /api/demo/session`
- `GET /api/accounts`
- `GET /api/reports/summary`
- `GET /analytics/reports/latest`

## Notes
- To enable analytics DB writes in local compose, `ENABLE_DB_PERSIST=true` is set for analytics service.


## End-to-end check
- Run `./scripts/e2e-compose-check.sh` to boot full stack and execute smoke checks.
