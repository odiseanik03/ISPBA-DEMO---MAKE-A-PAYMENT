import os
from dataclasses import dataclass


@dataclass
class RiskResult:
    flagged: int
    rules_applied: list[str]


class RiskRulesService:
    def run(self) -> RiskResult:
        rules = ["AMOUNT_THRESHOLD", "REPEATED_DESTINATION", "FAILURE_PATTERN"]
        if os.getenv("ENABLE_DB_PERSIST", "false").lower() == "true":
            return self.persist_and_return(rules)
        return RiskResult(flagged=0, rules_applied=rules)

    def persist_and_return(self, rules: list[str]) -> RiskResult:
        from app.db.models import SuspiciousFlag, Transaction
        from app.db.session import SessionLocal

        threshold = 10000
        flagged = 0
        with SessionLocal() as db:
            try:
                high_amount_txns = db.query(Transaction).filter(Transaction.amount > threshold).all()
                for txn in high_amount_txns:
                    already = db.query(SuspiciousFlag).filter(
                        SuspiciousFlag.transaction_id == txn.id,
                        SuspiciousFlag.rule_code == "AMOUNT_THRESHOLD",
                    ).first()
                    if already is not None:
                        continue
                    txn.risk_flag = True
                    db.add(SuspiciousFlag(
                        transaction_id=txn.id,
                        rule_code="AMOUNT_THRESHOLD",
                        rule_description=f"Amount above {threshold}",
                        severity="HIGH",
                    ))
                    flagged += 1
                db.commit()
            except Exception:
                db.rollback()
                raise
        return RiskResult(flagged=flagged, rules_applied=rules)
