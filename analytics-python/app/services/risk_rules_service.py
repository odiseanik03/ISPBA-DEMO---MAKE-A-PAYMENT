import os
from collections import Counter
from dataclasses import dataclass


@dataclass
class RiskResult:
    flagged: int
    rules_applied: list[str]


class RiskRulesService:
    def run(self) -> RiskResult:
        rules = [
            "AMOUNT_THRESHOLD",
            "REPEATED_DESTINATION",
            "FAILURE_PATTERN",
            "HIGH_FREQUENCY_DESTINATION",
        ]
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
                transactions = db.query(Transaction).all()
                destination_counts = Counter([t.destination_account_number for t in transactions if t.destination_account_number])

                for txn in transactions:
                    matched_rules: list[tuple[str, str, str]] = []
                    if txn.amount is not None and txn.amount > threshold:
                        matched_rules.append(("AMOUNT_THRESHOLD", f"Amount above {threshold}", "HIGH"))
                    if txn.status in {"FAILED", "REJECTED"}:
                        matched_rules.append(("FAILURE_PATTERN", "Transaction status indicates failure pattern", "MEDIUM"))
                    if txn.destination_account_number and destination_counts[txn.destination_account_number] >= 3:
                        matched_rules.append(("REPEATED_DESTINATION", "Destination appears in multiple transactions", "MEDIUM"))
                    if txn.destination_account_number and destination_counts[txn.destination_account_number] >= 5:
                        matched_rules.append(("HIGH_FREQUENCY_DESTINATION", "Destination appears with unusually high frequency", "HIGH"))

                    for code, description, severity in matched_rules:
                        already = db.query(SuspiciousFlag).filter(
                            SuspiciousFlag.transaction_id == txn.id,
                            SuspiciousFlag.rule_code == code,
                        ).first()
                        if already is not None:
                            continue
                        txn.risk_flag = True
                        db.add(
                            SuspiciousFlag(
                                transaction_id=txn.id,
                                rule_code=code,
                                rule_description=description,
                                severity=severity,
                            )
                        )
                        flagged += 1
                db.commit()
            except Exception:
                db.rollback()
                raise

        return RiskResult(flagged=flagged, rules_applied=rules)
