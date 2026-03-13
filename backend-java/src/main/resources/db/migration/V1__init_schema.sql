CREATE TABLE IF NOT EXISTS users (
  id BIGSERIAL PRIMARY KEY,
  username VARCHAR(120) NOT NULL UNIQUE,
  email VARCHAR(180) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  first_name VARCHAR(120) NOT NULL,
  last_name VARCHAR(120) NOT NULL,
  status VARCHAR(30) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS roles (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS user_roles (
  user_id BIGINT NOT NULL REFERENCES users(id),
  role_id BIGINT NOT NULL REFERENCES roles(id),
  PRIMARY KEY (user_id, role_id)
);

CREATE TABLE IF NOT EXISTS accounts (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGINT NOT NULL REFERENCES users(id),
  account_number VARCHAR(34) NOT NULL UNIQUE,
  currency VARCHAR(3) NOT NULL,
  account_type VARCHAR(30) NOT NULL,
  available_balance NUMERIC(19,2) NOT NULL,
  current_balance NUMERIC(19,2) NOT NULL,
  status VARCHAR(30) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS payments (
  id BIGSERIAL PRIMARY KEY,
  source_account_id BIGINT NOT NULL REFERENCES accounts(id),
  destination_account_number VARCHAR(34) NOT NULL,
  beneficiary_name VARCHAR(180) NOT NULL,
  amount NUMERIC(19,2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  description TEXT,
  execution_date DATE NOT NULL,
  status VARCHAR(30) NOT NULL,
  created_by BIGINT NOT NULL REFERENCES users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS transactions (
  id BIGSERIAL PRIMARY KEY,
  payment_id BIGINT NOT NULL REFERENCES payments(id),
  transaction_reference VARCHAR(60) NOT NULL UNIQUE,
  source_account_id BIGINT NOT NULL REFERENCES accounts(id),
  destination_account_number VARCHAR(34) NOT NULL,
  beneficiary_name VARCHAR(180) NOT NULL,
  amount NUMERIC(19,2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  transaction_type VARCHAR(30) NOT NULL,
  status VARCHAR(30) NOT NULL,
  risk_flag BOOLEAN NOT NULL DEFAULT FALSE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS audit_logs (
  id BIGSERIAL PRIMARY KEY,
  actor_user_id BIGINT REFERENCES users(id),
  action_type VARCHAR(80) NOT NULL,
  entity_type VARCHAR(80) NOT NULL,
  entity_id VARCHAR(80),
  details_json JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS reports (
  id BIGSERIAL PRIMARY KEY,
  report_date DATE NOT NULL UNIQUE,
  total_transactions BIGINT NOT NULL,
  successful_transactions BIGINT NOT NULL,
  failed_transactions BIGINT NOT NULL,
  total_amount NUMERIC(19,2) NOT NULL,
  avg_amount NUMERIC(19,2) NOT NULL,
  suspicious_count BIGINT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS suspicious_flags (
  id BIGSERIAL PRIMARY KEY,
  transaction_id BIGINT NOT NULL REFERENCES transactions(id),
  rule_code VARCHAR(80) NOT NULL,
  rule_description TEXT NOT NULL,
  severity VARCHAR(30) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS data_quality_results (
  id BIGSERIAL PRIMARY KEY,
  check_name VARCHAR(120) NOT NULL,
  issue_count BIGINT NOT NULL,
  details_json JSONB,
  report_date DATE NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_accounts_user_status ON accounts (user_id, status);
CREATE INDEX IF NOT EXISTS idx_payments_account_created ON payments (source_account_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_account_created ON transactions (source_account_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_transactions_status_created ON transactions (status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_actor_created ON audit_logs (actor_user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_suspicious_txn_severity ON suspicious_flags (transaction_id, severity);
CREATE INDEX IF NOT EXISTS idx_dq_report_check ON data_quality_results (report_date, check_name);
