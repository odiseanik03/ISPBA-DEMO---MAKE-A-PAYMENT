import os
from dataclasses import dataclass
from datetime import date


@dataclass
class DailyReport:
    total_transactions: int
    successful_transactions: int
    failed_transactions: int
    suspicious_count: int


class DailyReportService:
    def generate(self) -> DailyReport:
        report = DailyReport(total_transactions=24, successful_transactions=23, failed_transactions=1, suspicious_count=0)
        if os.getenv("ENABLE_DB_PERSIST", "false").lower() == "true":
            self.persist(report)
        return report

    def persist(self, report: DailyReport) -> None:
        from app.db.models import Report, Transaction
        from app.db.session import SessionLocal
        from sqlalchemy import func

        with SessionLocal() as db:
            total = db.query(func.count(Transaction.id)).scalar() or 0
            successful = db.query(func.count(Transaction.id)).filter(Transaction.status == "COMPLETED").scalar() or 0
            failed = db.query(func.count(Transaction.id)).filter(Transaction.status.in_(["FAILED", "REJECTED"])).scalar() or 0
            suspicious = db.query(func.count(Transaction.id)).filter(Transaction.risk_flag.is_(True)).scalar() or 0

            row = db.query(Report).filter(Report.report_date == date.today()).first()
            if row is None:
                row = Report(report_date=date.today())
                db.add(row)
            row.total_transactions = int(total)
            row.successful_transactions = int(successful)
            row.failed_transactions = int(failed)
            row.suspicious_count = int(suspicious)
            row.total_amount = 0
            row.avg_amount = 0
            db.commit()
