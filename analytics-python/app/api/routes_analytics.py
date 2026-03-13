from fastapi import APIRouter
from app.schemas.analytics import JobAccepted
from app.services.daily_report_service import DailyReportService
from app.services.data_quality_service import DataQualityService
from app.services.risk_rules_service import RiskRulesService

router = APIRouter(prefix="/analytics", tags=["analytics"])

_daily = DailyReportService()
_dq = DataQualityService()
_risk = RiskRulesService()


@router.post("/run/daily-report", response_model=JobAccepted)
def run_daily_report() -> JobAccepted:
    _daily.generate()
    return JobAccepted(status="accepted", job="daily-report")


@router.post("/run/data-quality", response_model=JobAccepted)
def run_data_quality() -> JobAccepted:
    _dq.run()
    return JobAccepted(status="accepted", job="data-quality")


@router.post("/run/risk-check", response_model=JobAccepted)
def run_risk_check() -> JobAccepted:
    _risk.run()
    return JobAccepted(status="accepted", job="risk-check")


@router.get("/reports/latest")
def reports_latest() -> dict[str, dict[str, int]]:
    r = _daily.generate()
    return {
        "daily": {
            "totalTransactions": r.total_transactions,
            "successfulTransactions": r.successful_transactions,
            "failedTransactions": r.failed_transactions,
            "suspiciousCount": r.suspicious_count,
        }
    }
