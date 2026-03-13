import os

from app.services.daily_report_service import DailyReportService
from app.services.data_quality_service import DataQualityService
from app.services.risk_rules_service import RiskRulesService


def test_services_run_without_db_when_persist_disabled() -> None:
    os.environ["ENABLE_DB_PERSIST"] = "false"

    daily = DailyReportService().generate()
    dq = DataQualityService().run()
    risk = RiskRulesService().run()

    assert daily.total_transactions >= 0
    assert dq.issues >= 0
    assert isinstance(risk.rules_applied, list)
