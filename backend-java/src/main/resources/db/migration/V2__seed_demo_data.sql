INSERT INTO users (id, username, email, password_hash, first_name, last_name, status)
VALUES (1, 'demo.customer', 'customer@accountflow.demo', 'bcrypt-demo', 'Olisea', 'Customer', 'ACTIVE')
ON CONFLICT (id) DO NOTHING;

INSERT INTO roles (id, name) VALUES (1, 'CUSTOMER') ON CONFLICT (id) DO NOTHING;
INSERT INTO roles (id, name) VALUES (2, 'ADMIN') ON CONFLICT (id) DO NOTHING;
INSERT INTO user_roles (user_id, role_id) VALUES (1, 1) ON CONFLICT DO NOTHING;

INSERT INTO accounts (id, user_id, account_number, currency, account_type, available_balance, current_balance, status)
VALUES (1, 1, 'DE89370400440532013000', 'EUR', 'CURRENT', 5000.00, 5000.00, 'ACTIVE')
ON CONFLICT (id) DO NOTHING;
