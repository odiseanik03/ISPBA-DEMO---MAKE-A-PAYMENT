from fastapi import APIRouter

router = APIRouter(prefix="/analytics", tags=["analytics"])


@router.post("/run/daily-report")
def run_daily_report() -> dict[str, str]:
    return {"status": "accepted", "job": "daily-report"}


@router.post("/run/data-quality")
def run_data_quality() -> dict[str, str]:
    return {"status": "accepted", "job": "data-quality"}


@router.post("/run/risk-check")
def run_risk_check() -> dict[str, str]:
    return {"status": "accepted", "job": "risk-check"}


@router.get("/reports/latest")
def reports_latest() -> dict[str, dict[str, int]]:
    return {
        "daily": {
            "totalTransactions": 0,
            "successfulTransactions": 0,
            "failedTransactions": 0,
            "suspiciousCount": 0,
        }
    }
