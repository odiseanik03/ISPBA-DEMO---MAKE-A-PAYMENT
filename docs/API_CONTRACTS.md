# AccountFlow API Contracts (Draft)

## Demo session

### POST `/api/demo/session`
Response:
```json
{
  "token": "demo-customer-token",
  "role": "CUSTOMER",
  "username": "demo.customer"
}
```

## Accounts

### GET `/api/accounts`
Headers: `X-Demo-User-Id: 1`
Response:
```json
[
  {
    "id": 1,
    "maskedAccountNumber": "**** **** **** 3000",
    "accountType": "CURRENT",
    "availableBalance": 5000.00,
    "currency": "EUR",
    "status": "ACTIVE"
  }
]
```

## Payments

### POST `/api/payments`
Request:
```json
{
  "sourceAccountId": 1,
  "destinationAccountNumber": "DE99999999999999999999",
  "beneficiaryName": "Acme Ltd",
  "amount": 120.50,
  "currency": "EUR",
  "description": "Invoice 1023",
  "executionDate": "2026-03-15"
}
```
Response:
```json
{
  "paymentId": 10,
  "transactionReference": "TXN-AB12CD34",
  "status": "PENDING",
  "remainingBalance": 4879.50
}
```

### GET `/api/payments`
### GET `/api/payments/{id}`
Headers: `X-Demo-User-Id: 1`

## Transactions

### GET `/api/transactions?status=PENDING&page=0&size=10`
Headers: `X-Demo-User-Id: 1`
Response:
```json
{
  "items": [
    {
      "id": 25,
      "reference": "TXN-AB12CD34",
      "status": "PENDING",
      "amount": 120.50,
      "currency": "EUR",
      "destinationAccountNumber": "DE9999...",
      "beneficiaryName": "Acme Ltd",
      "riskFlag": false
    }
  ],
  "page": 0,
  "size": 10,
  "total": 1
}
```

## Reports

### GET `/api/reports/daily`
### GET `/api/reports/summary`
### GET `/api/reports/suspicious-flags`

## Admin / Audit

### GET `/api/admin/audit-logs?page=0&size=20`
Headers:
- `X-Demo-User-Id: 1`
- `X-Demo-Role: ADMIN`

Response:
```json
{
  "items": [
    {
      "id": 88,
      "actorUserId": 1,
      "actionType": "ADMIN_VIEW_AUDIT_LOGS",
      "entityType": "AUDIT_LOG",
      "entityId": null,
      "detailsJson": "{}",
      "createdAt": "2026-03-15T08:15:00Z"
    }
  ],
  "page": 0,
  "size": 20,
  "total": 1
}
```

## Error Envelope

```json
{
  "error": "VALIDATION_ERROR",
  "message": "Insufficient balance",
  "status": 400,
  "path": "/api/payments",
  "timestamp": "2026-03-15T08:00:00Z"
}
```

## Analytics

### POST `/analytics/run/risk-check`
Response:
```json
{
  "status": "accepted",
  "job": "risk-check"
}
```

### POST `/analytics/run/data-quality`
Response:
```json
{
  "status": "accepted",
  "job": "data-quality"
}
```

### POST `/analytics/run/daily-report`
Response:
```json
{
  "status": "accepted",
  "job": "daily-report"
}
```

### GET `/analytics/reports/latest`
Response:
```json
{
  "daily": {
    "totalTransactions": 42,
    "successfulTransactions": 39,
    "failedTransactions": 3,
    "suspiciousCount": 5
  }
}
```
