# AccountFlow

AccountFlow is a portfolio-grade banking-style demo platform with:
- Flutter Web frontend
- Java Spring Boot core API
- Python FastAPI analytics service
- PostgreSQL
- Docker Compose orchestration

## Current status
This repository now includes **Phase 1 scaffolding** for all modules and baseline configuration.

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


## Next implementation steps
- Wire all Flutter pages to real backend APIs with loading/error/empty states and role-aware guards.
- Persist analytics outputs (`reports`, `suspicious_flags`, `data_quality_results`) using SQLAlchemy against PostgreSQL.
- Add deeper Java tests (controllers, ownership validation, role validation), Python API tests, and Flutter widget/form tests.
- Add Swagger/OpenAPI docs and API contract examples.


## API documentation
- See `docs/API_CONTRACTS.md` for concrete request/response examples.
