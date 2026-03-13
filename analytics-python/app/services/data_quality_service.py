import os
from dataclasses import dataclass
from datetime import date


@dataclass
class DataQualityResultOut:
    issues: int
    checks: list[str]


class DataQualityService:
    def run(self) -> DataQualityResultOut:
        checks = [
            "MISSING_CRITICAL_FIELDS",
            "DUPLICATE_TRANSACTION_REFERENCE",
            "INVALID_CURRENCY",
            "IMPOSSIBLE_AMOUNT",
            "INCONSISTENT_STATUS",
        ]
        if os.getenv("ENABLE_DB_PERSIST", "false").lower() == "true":
            return self.persist(checks)
        return DataQualityResultOut(issues=0, checks=checks)

    def persist(self, checks: list[str]) -> DataQualityResultOut:
        from app.db.models import DataQualityResult, Transaction
        from app.db.session import SessionLocal

        today = date.today()
        issue_counts = {check: 0 for check in checks}

        with SessionLocal() as db:
            try:
                transactions = db.query(Transaction).all()
                refs: dict[str, int] = {}
                for txn in transactions:
                    if not txn.transaction_reference or not txn.destination_account_number:
                        issue_counts["MISSING_CRITICAL_FIELDS"] += 1
                    if txn.amount is None or txn.amount <= 0:
                        issue_counts["IMPOSSIBLE_AMOUNT"] += 1
                    if txn.status not in {"COMPLETED", "FAILED", "REJECTED", "PENDING"}:
                        issue_counts["INCONSISTENT_STATUS"] += 1
                    if txn.transaction_reference:
                        refs[txn.transaction_reference] = refs.get(txn.transaction_reference, 0) + 1

                issue_counts["DUPLICATE_TRANSACTION_REFERENCE"] = sum(count - 1 for count in refs.values() if count > 1)
                issue_counts["INVALID_CURRENCY"] = 0

                total_issues = 0
                for check in checks:
                    count = issue_counts.get(check, 0)
                    total_issues += count
                    exists = db.query(DataQualityResult).filter(
                        DataQualityResult.check_name == check,
                        DataQualityResult.report_date == today,
                    ).first()
                    if exists is None:
                        db.add(DataQualityResult(check_name=check, issue_count=count, report_date=today))
                    else:
                        exists.issue_count = count
                db.commit()
                return DataQualityResultOut(issues=total_issues, checks=checks)
            except Exception:
                db.rollback()
                raise
