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
                Transaction(
                    id=1,
                    transaction_reference="TXN-001",
                    destination_account_number="RO00BANK0000000001",
                    amount=15000,
                    status="COMPLETED",
                    risk_flag=False,
                ),
                Transaction(
                    id=2,
                    transaction_reference="TXN-002",
                    destination_account_number="RO00BANK0000000001",
                    amount=90,
                    status="FAILED",
                    risk_flag=False,
                ),
                Transaction(
                    id=3,
                    transaction_reference="TXN-003",
                    destination_account_number="RO00BANK0000000001",
                    amount=120,
                    status="COMPLETED",
                    risk_flag=False,
                ),
            ]
        )
        db.commit()

    first_run = RiskRulesService().run()
    report = DailyReportService().generate()

    assert first_run.flagged >= 2
    assert report.total_transactions == 3
    assert report.successful_transactions == 2
    assert report.failed_transactions == 1

    # second run should not duplicate suspicious flags
    risk_again = RiskRulesService().run()
    assert risk_again.flagged == 0

    with sqlite_session() as db:
        flags = db.query(SuspiciousFlag).all()
        daily = db.query(Report).filter(Report.report_date == date.today()).all()
        assert len(flags) >= 2
        assert len(daily) == 1


def test_data_quality_persistence_idempotent(monkeypatch) -> None:
    monkeypatch.setenv("ENABLE_DB_PERSIST", "true")
    sqlite_session = _session_local()
    monkeypatch.setattr("app.db.session.SessionLocal", sqlite_session)

    with sqlite_session() as db:
        db.add_all(
            [
                Transaction(
                    id=1,
                    transaction_reference="DUPL-001",
                    destination_account_number="RO00BANKA",
                    amount=100,
                    status="COMPLETED",
                ),
                Transaction(
                    id=2,
                    transaction_reference="DUPL-001",
                    destination_account_number="RO00BANKB",
                    amount=50,
                    status="PENDING",
                ),
                Transaction(
                    id=3,
                    transaction_reference=None,
                    destination_account_number=None,
                    amount=-10,
                    status="INVALID",
                ),
            ]
        )
        db.commit()

    service = DataQualityService()

    first = service.run()
    second = service.run()

    assert first.issues > 0
    assert second.issues > 0

    with sqlite_session() as db:
        rows = db.query(DataQualityResult).filter(DataQualityResult.report_date == date.today()).all()
        assert len(rows) == len(first.checks)
        duplicate = [r for r in rows if r.check_name == "DUPLICATE_TRANSACTION_REFERENCE"][0]
        assert duplicate.issue_count == 1
