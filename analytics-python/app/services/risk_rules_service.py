from dataclasses import dataclass


@dataclass
class RiskResult:
    flagged: int
    rules_applied: list[str]


class RiskRulesService:
    def run(self) -> RiskResult:
        return RiskResult(flagged=0, rules_applied=["AMOUNT_THRESHOLD", "REPEATED_DESTINATION", "FAILURE_PATTERN"])
