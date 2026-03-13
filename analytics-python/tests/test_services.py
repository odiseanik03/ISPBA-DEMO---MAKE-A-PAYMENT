from app.services.daily_report_service import DailyReportService
from app.services.data_quality_service import DataQualityService
from app.services.risk_rules_service import RiskRulesService


def test_daily_report_service() -> None:
    report = DailyReportService().generate()
    assert report.total_transactions >= report.successful_transactions


def test_risk_service() -> None:
    result = RiskRulesService().run()
    assert isinstance(result.rules_applied, list)


def test_data_quality_service() -> None:
    result = DataQualityService().run()
    assert result.issues >= 0
