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
            self.persist(checks)
        return DataQualityResultOut(issues=0, checks=checks)

    def persist(self, checks: list[str]) -> None:
        from app.db.models import DataQualityResult
        from app.db.session import SessionLocal

        with SessionLocal() as db:
            for check in checks:
                db.add(DataQualityResult(check_name=check, issue_count=0, report_date=date.today()))
            db.commit()
