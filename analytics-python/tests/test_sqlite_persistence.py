from datetime import date

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.db.models import Base, DataQualityResult, Report, SuspiciousFlag, Transaction
from app.services.daily_report_service import DailyReportService
from app.services.data_quality_service import DataQualityService
from app.services.risk_rules_service import RiskRulesService


def _session_local() -> sessionmaker:
    engine = create_engine("sqlite+pysqlite:///:memory:", future=True)
    Base.metadata.create_all(engine)
    return sessionmaker(bind=engine, autoflush=False, autocommit=False, future=True)


def test_daily_report_and_risk_persistence_idempotent(monkeypatch) -> None:
    monkeypatch.setenv("ENABLE_DB_PERSIST", "true")
    sqlite_session = _session_local()
    monkeypatch.setattr("app.db.session.SessionLocal", sqlite_session)

    with sqlite_session() as db:
        db.add_all(
            [
                Transaction(id=1, amount=15000, status="COMPLETED", risk_flag=False),
                Transaction(id=2, amount=90, status="FAILED", risk_flag=False),
            ]
        )
        db.commit()

    risk = RiskRulesService().run()
    report = DailyReportService().generate()

    assert risk.flagged == 1
    assert report.total_transactions == 2
    assert report.successful_transactions == 1
    assert report.failed_transactions == 1

    # second run should not duplicate suspicious flags
    risk_again = RiskRulesService().run()
    assert risk_again.flagged == 0

    with sqlite_session() as db:
        flags = db.query(SuspiciousFlag).all()
        daily = db.query(Report).filter(Report.report_date == date.today()).all()
        assert len(flags) == 1
        assert len(daily) == 1


def test_data_quality_persistence_idempotent(monkeypatch) -> None:
    monkeypatch.setenv("ENABLE_DB_PERSIST", "true")
    sqlite_session = _session_local()
    monkeypatch.setattr("app.db.session.SessionLocal", sqlite_session)

    service = DataQualityService()

    first = service.run()
    second = service.run()

    assert first.issues == 0
    assert second.issues == 0

    with sqlite_session() as db:
        rows = db.query(DataQualityResult).filter(DataQualityResult.report_date == date.today()).all()
        assert len(rows) == len(first.checks)
