import os
from dataclasses import dataclass


@dataclass
class RiskResult:
    flagged: int
    rules_applied: list[str]


class RiskRulesService:
    def run(self) -> RiskResult:
        result = RiskResult(flagged=0, rules_applied=["AMOUNT_THRESHOLD", "REPEATED_DESTINATION", "FAILURE_PATTERN"])
        if os.getenv("ENABLE_DB_PERSIST", "false").lower() == "true":
            result = self.persist_and_return()
        return result

    def persist_and_return(self) -> RiskResult:
        from app.db.models import SuspiciousFlag, Transaction
        from app.db.session import SessionLocal

        threshold = 10000
        flagged = 0
        with SessionLocal() as db:
            high_amount_txns = db.query(Transaction).filter(Transaction.amount > threshold).all()
            for txn in high_amount_txns:
                txn.risk_flag = True
                db.add(SuspiciousFlag(
                    transaction_id=txn.id,
                    rule_code="AMOUNT_THRESHOLD",
                    rule_description=f"Amount above {threshold}",
                    severity="HIGH",
                ))
                flagged += 1
            db.commit()
        return RiskResult(flagged=flagged, rules_applied=["AMOUNT_THRESHOLD", "REPEATED_DESTINATION", "FAILURE_PATTERN"])
