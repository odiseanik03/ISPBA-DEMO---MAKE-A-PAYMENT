from dataclasses import dataclass


@dataclass
class DataQualityResult:
    issues: int
    checks: list[str]


class DataQualityService:
    def run(self) -> DataQualityResult:
        return DataQualityResult(
            issues=0,
            checks=[
                "MISSING_CRITICAL_FIELDS",
                "DUPLICATE_TRANSACTION_REFERENCE",
                "INVALID_CURRENCY",
                "IMPOSSIBLE_AMOUNT",
                "INCONSISTENT_STATUS",
            ],
        )
