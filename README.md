# AccountFlow

AccountFlow is a portfolio-grade banking-style demo platform with:
- Flutter Web frontend
- Java Spring Boot core API
- Python FastAPI analytics service
- PostgreSQL
- Docker Compose orchestration

## Current status
This repository now includes completed baseline implementation across the three services
plus hardening updates (CI pipeline, analytics persistence hooks, role-aware navigation,
runbook, and smoke scripts).

## Quick start
1. Copy env templates:
   - `cp .env.example .env`
   - `cp backend-java/.env.example backend-java/.env`
   - `cp analytics-python/.env.example analytics-python/.env`
2. Start infrastructure and services:
   - `docker compose up --build`

## Entry UX rule
No full login form is implemented by design. The frontend uses a minimal entry action (`Enter Portal`) for demo-authenticated flow.


## Phase 2 progress
- Core APIs added: `/api/accounts`, `/api/payments`, `/api/transactions`, `/api/reports/daily`, `/api/reports/summary`, `/api/admin/audit-logs`.
- Admin demo access for audit endpoint is controlled by header: `X-Demo-Role: ADMIN`.
- Frontend pages added: Dashboard, Accounts, Make Payment, Transactions, Reports, Audit Logs.


## Phase 3-4 progress
- Reports endpoint now includes `GET /api/reports/suspicious-flags`.
- Transactions endpoint supports basic query paging/filter params: `status`, `page`, `size`.
- Error responses now use a consistent envelope with `error`, `message`, `status`, `path`, `timestamp`.
- Payment creation writes audit records; admin audit endpoint enforces role guard through centralized demo security component.


## Remaining implementation focus
- Run and pass full end-to-end validation in a runnable environment (compose boot + smoke + test matrix).
- Harden analytics persistence with richer rules, idempotency semantics, and Postgres-backed integration tests.
- Complete frontend production polish (responsive spacing, consistency, accessibility pass, screenshot parity checks).
- Expand release readiness with stricter CI quality gates (linting, artifact checks, repeatable release verification).

See `docs/NEXT_PHASES.md` for a phase-by-phase plan with completion estimate.


## API documentation
- See `docs/API_CONTRACTS.md` for concrete request/response examples.


## OpenAPI / Swagger
- Swagger UI: `http://localhost:8080/swagger-ui/index.html`

## Runbook and demo checks
- Operational runbook: `docs/RUNBOOK.md`
- Automated demo smoke checks: `./scripts/demo-smoke.sh`

- Full local E2E validation: `./scripts/e2e-compose-check.sh`
