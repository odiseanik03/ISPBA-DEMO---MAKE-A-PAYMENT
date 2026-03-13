import os
from datetime import date

import pytest
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

from app.db.models import Base, DataQualityResult, Report, SuspiciousFlag, Transaction
from app.services.daily_report_service import DailyReportService
from app.services.data_quality_service import DataQualityService
from app.services.risk_rules_service import RiskRulesService


@pytest.mark.integration
def test_postgres_persistence_end_to_end(monkeypatch) -> None:
    if os.getenv("POSTGRES_INTEGRATION") != "true":
        pytest.skip("POSTGRES_INTEGRATION not enabled")

    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        pytest.skip("DATABASE_URL not configured")

    engine = create_engine(db_url, future=True)
    Base.metadata.drop_all(engine)
    Base.metadata.create_all(engine)
    SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False, future=True)

    monkeypatch.setenv("ENABLE_DB_PERSIST", "true")
    monkeypatch.setattr("app.db.session.SessionLocal", SessionLocal)

    with SessionLocal() as db:
        db.add_all(
            [
                Transaction(
                    id=1,
                    transaction_reference="PG-TXN-1",
                    destination_account_number="RO99BANK00001",
                    amount=25000,
                    status="COMPLETED",
                    risk_flag=False,
                ),
                Transaction(
                    id=2,
                    transaction_reference="PG-TXN-2",
                    destination_account_number="RO99BANK00001",
                    amount=15,
                    status="FAILED",
                    risk_flag=False,
                ),
                Transaction(
                    id=3,
                    transaction_reference="PG-TXN-2",
                    destination_account_number=None,
                    amount=-1,
                    status="INVALID",
                    risk_flag=False,
                ),
            ]
        )
        db.commit()

    risk_result = RiskRulesService().run()
    quality_result = DataQualityService().run()
    report = DailyReportService().generate()

    assert risk_result.flagged >= 2
    assert quality_result.issues > 0
    assert report.total_transactions == 3

    with SessionLocal() as db:
        reports = db.query(Report).filter(Report.report_date == date.today()).all()
        flags = db.query(SuspiciousFlag).all()
        dq = db.query(DataQualityResult).filter(DataQualityResult.report_date == date.today()).all()
        assert len(reports) == 1
        assert len(flags) >= 2
        assert len(dq) == 5

    with engine.connect() as conn:
        count = conn.execute(text("select count(*) from reports")).scalar_one()
        assert int(count) == 1
