from dataclasses import dataclass


@dataclass
class DailyReport:
    total_transactions: int
    successful_transactions: int
    failed_transactions: int
    suspicious_count: int


class DailyReportService:
    def generate(self) -> DailyReport:
        # placeholder implementation for next integration with DB
        return DailyReport(
            total_transactions=24,
            successful_transactions=23,
            failed_transactions=1,
            suspicious_count=0,
        )
