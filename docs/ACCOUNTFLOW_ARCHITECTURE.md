# AccountFlow - Initial Architecture Blueprint

## 1) Full Recommended Folder Structure

```text
accountflow/
├─ README.md
├─ .gitignore
├─ .editorconfig
├─ docker-compose.yml
├─ .env.example
├─ scripts/
│  ├─ bootstrap.sh
│  ├─ seed-demo-data.sh
│  └─ run-local-checks.sh
├─ docs/
│  ├─ ACCOUNTFLOW_ARCHITECTURE.md
│  ├─ API_CONTRACTS.md
│  ├─ SECURITY_MODEL.md
│  ├─ DATA_MODEL.md
│  └─ UI_RECONSTRUCTION_GUIDE.md
├─ infra/
│  ├─ postgres/
│  │  ├─ init/
│  │  └─ backups/
│  └─ monitoring/
│     ├─ prometheus.yml
│     └─ grafana/
├─ backend-java/
│  ├─ pom.xml
│  ├─ Dockerfile
│  ├─ .env.example
│  └─ src/
│     ├─ main/
│     │  ├─ java/com/accountflow/
│     │  │  ├─ AccountFlowApplication.java
│     │  │  ├─ common/
│     │  │  │  ├─ config/
│     │  │  │  ├─ exception/
│     │  │  │  ├─ security/
│     │  │  │  └─ util/
│     │  │  ├─ auth/
│     │  │  │  ├─ controller/
│     │  │  │  ├─ dto/
│     │  │  │  └─ service/
│     │  │  ├─ accounts/
│     │  │  │  ├─ controller/
│     │  │  │  ├─ dto/
│     │  │  │  ├─ entity/
│     │  │  │  ├─ mapper/
│     │  │  │  ├─ repository/
│     │  │  │  └─ service/
│     │  │  ├─ payments/
│     │  │  ├─ transactions/
│     │  │  ├─ reports/
│     │  │  ├─ audit/
│     │  │  └─ admin/
│     │  └─ resources/
│     │     ├─ application.yml
│     │     ├─ db/migration/
│     │     └─ seed/
│     └─ test/java/com/accountflow/
│        ├─ payments/
│        ├─ accounts/
│        ├─ reports/
│        └─ security/
├─ analytics-python/
│  ├─ pyproject.toml
│  ├─ requirements.txt
│  ├─ Dockerfile
│  ├─ .env.example
│  ├─ app/
│  │  ├─ main.py
│  │  ├─ api/
│  │  │  ├─ routes_analytics.py
│  │  │  └─ schemas.py
│  │  ├─ core/
│  │  │  ├─ config.py
│  │  │  └─ logging.py
│  │  ├─ db/
│  │  │  ├─ session.py
│  │  │  └─ models_read.py
│  │  ├─ services/
│  │  │  ├─ daily_report_service.py
│  │  │  ├─ risk_rules_service.py
│  │  │  └─ data_quality_service.py
│  │  └─ repositories/
│  └─ tests/
│     ├─ test_daily_report.py
│     ├─ test_risk_rules.py
│     └─ test_data_quality.py
└─ frontend-flutter/
   ├─ pubspec.yaml
   ├─ web/
   ├─ test/
   │  ├─ widget/
   │  ├─ forms/
   │  └─ navigation/
   └─ lib/
      ├─ main.dart
      ├─ app/
      │  ├─ router.dart
      │  ├─ theme.dart
      │  └─ app_shell.dart
      ├─ core/
      │  ├─ constants/
      │  ├─ networking/
      │  ├─ state/
      │  └─ utils/
      ├─ features/
      │  ├─ entry/
      │  ├─ dashboard/
      │  ├─ accounts/
      │  ├─ payments/
      │  ├─ transactions/
      │  ├─ reports/
      │  └─ audit_logs/
      └─ shared/
         ├─ widgets/
         ├─ layout/
         └─ models/
```

## 2) Architecture Diagram (Text)

```text
[Flutter Web - AccountFlow Portal]
  - Entry button (mock session)
  - Authenticated app shell (sidebar + header + pages)
  - Calls Java API for core banking flows
  - Calls Python analytics endpoints for report triggers/reads
            |
            | HTTPS (JWT or demo token)
            v
[Spring Boot Core API]
  - Auth/session facade (minimal demo session)
  - Account query services
  - Payment orchestration (transactional)
  - Transaction management
  - Audit log writer
  - Admin-protected audit/report endpoints
            |
            | JDBC/JPA
            v
[PostgreSQL]
  - users, roles, user_roles
  - accounts, payments, transactions
  - audit_logs
  - reports, suspicious_flags, data_quality_results
            ^
            | SQLAlchemy + SQL / Scheduled jobs / API-triggered runs
            |
[FastAPI Analytics Service]
  - Daily aggregation
  - Suspicious transaction rules
  - Data quality checks
  - Writes report/flag/quality outputs to PostgreSQL
```

## 3) Database Schema (Core Tables)

- `users(id PK, username UNIQUE, email UNIQUE, password_hash, first_name, last_name, status, created_at, updated_at)`
- `roles(id PK, name UNIQUE)`
- `user_roles(user_id FK->users.id, role_id FK->roles.id, PK(user_id, role_id))`
- `accounts(id PK, user_id FK->users.id, account_number UNIQUE, currency, account_type, available_balance, current_balance, status, created_at, updated_at)`
- `payments(id PK, source_account_id FK->accounts.id, destination_account_number, beneficiary_name, amount, currency, description, execution_date, status, created_by FK->users.id, created_at, updated_at)`
- `transactions(id PK, payment_id FK->payments.id, transaction_reference UNIQUE, source_account_id FK->accounts.id, destination_account_number, beneficiary_name, amount, currency, transaction_type, status, risk_flag, created_at, updated_at)`
- `audit_logs(id PK, actor_user_id FK->users.id, action_type, entity_type, entity_id, details_json, created_at)`
- `reports(id PK, report_date UNIQUE, total_transactions, successful_transactions, failed_transactions, total_amount, avg_amount, suspicious_count, created_at)`
- `suspicious_flags(id PK, transaction_id FK->transactions.id, rule_code, rule_description, severity, created_at)`
- `data_quality_results(id PK, check_name, issue_count, details_json, report_date, created_at)`

**Suggested indexes**
- `accounts(user_id, status)`
- `payments(source_account_id, created_at DESC)`
- `transactions(source_account_id, created_at DESC)`
- `transactions(status, created_at DESC)`
- `audit_logs(actor_user_id, created_at DESC)`
- `suspicious_flags(transaction_id, severity)`
- `data_quality_results(report_date, check_name)`

## 4) Spring Boot Module Design

- `common`
  - Security config, global exception handling, API error envelope, OpenAPI config, DTO mappers.
- `auth`
  - Minimal demo session endpoints (`POST /api/demo/session`, `GET /api/auth/me`).
- `accounts`
  - Account read APIs with ownership checks and masking at DTO boundary.
- `payments`
  - Payment create/list/detail, business validations, transactional write to `payments` + `transactions` + `audit_logs`.
- `transactions`
  - Paginated/filterable transaction APIs and detail endpoint.
- `reports`
  - Daily and summary report reads; suspicious flags read model.
- `audit`
  - Audit log query services (admin-only).
- `admin`
  - Role-guarded controllers for audit and sensitive operational endpoints.

**Layering per module**
- `controller` → `service` → `repository` → `entity`
- `dto` and `mapper` isolate API contracts from entities.

## 5) Flutter Page/Component Design

**Routing**
- `/` Entry page with one CTA: **Enter Portal**.
- `/dashboard`, `/accounts`, `/payments/new`, `/transactions`, `/reports`, `/admin/audit-logs`.

**Core UI skeleton**
- `AppShell`: left sidebar + top bar + responsive body.
- `SidebarNav`: icon + label items, orange active state.
- `TopHeader`: logo, search/help prompt, circular action icons.

**Pages**
- `EntryPage`: minimal logo/title/one-button mock session entry.
- `DashboardPage`: account summary cards, quick actions, recent transactions.
- `AccountsPage`: masked account cards/table.
- `MakePaymentPage`: screenshot-faithful white form card with From/To/Payment sections and orange CTA.
- `TransactionsPage`: paginated table with filters.
- `ReportsPage`: KPI cards + trend/suspicious/data-quality summary widgets.
- `AuditLogsPage` (admin): paginated action log list.

**Reusable components**
- `AfCard`, `AfInput`, `AfSelect`, `AfCurrencyAmountField`, `AfStatusBadge`, `AfPrimaryButton`, `AfSectionHeader`, `AfBreadcrumb`, `AfProgressChip`, `AfMaskedText`.

## 6) Screenshot-Based UI Reconstruction Strategy

1. **Layout first**: implement fixed left rail (240–280px), top strip, and pale gray app background.
2. **Spacing system**: 4/8/12/16/24/32 scale with generous card padding.
3. **Color system**: white surfaces + muted grays + single orange accent token.
4. **Typography mapping**: strong dark titles, muted subtitles, bold form labels.
5. **Make Payment priority**:
   - breadcrumb + page title + help icon + step chip;
   - greeting header in card;
   - From/To/Payment sections with clear dividers;
   - connected amount+currency control;
   - orange circular utility buttons;
   - disabled-to-enabled primary CTA behavior.
6. **Responsive behavior**:
   - desktop: full rail + wide form card;
   - tablet: narrower rail and tighter gutters;
   - mobile: drawer + stacked fields + simplified top actions.
7. **Privacy by design in UI**: account masking defaults and optional balance visibility toggle.

## 7) Python Analytics Service Design

**Modules**
- `daily_report_service.py`
  - aggregates totals/success/failure/avg/suspicious_count by `report_date`.
- `risk_rules_service.py`
  - rule engine:
    - amount above threshold,
    - repeated destination in short interval,
    - unusual frequency,
    - repeated failures.
  - writes `suspicious_flags` and updates transaction `risk_flag`.
- `data_quality_service.py`
  - checks missing critical fields, duplicate references, invalid currencies, impossible amounts, inconsistent statuses, orphan relations.
  - writes `data_quality_results`.

**Endpoints**
- `POST /analytics/run/daily-report`
- `POST /analytics/run/risk-check`
- `POST /analytics/run/data-quality`
- `GET /analytics/reports/latest`

## 8) Phased Roadmap

### Phase 1: Foundations
- Monorepo scaffold, Docker Compose, env templates, README baseline.
- Spring Boot skeleton + Flyway baseline migration.
- Flutter skeleton + routing + theme + app shell.
- FastAPI skeleton + DB connectivity.

### Phase 2: Core Banking Flow
- Seed users/accounts/roles.
- Accounts API + UI list.
- Make Payment API (validation + transactional writes).
- Payment UI implementation (screenshot-faithful).
- Transaction list API/UI with filters and pagination.

### Phase 3: Analytics & Auditability
- Audit logging pipeline and admin endpoint.
- FastAPI daily report + risk checks + data quality jobs.
- Reports UI cards/tables.
- Admin audit logs UI.

### Phase 4: Security, Quality, and Polish
- Role guards, DTO hardening, error model consistency.
- Tests: Java service/controller, Python rules/data quality, Flutter widget/form/nav.
- Privacy polish (masking, safe logging), UX polish, accessibility checks.
- Final docs and demo scripts.
