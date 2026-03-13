from pydantic import BaseModel


class JobAccepted(BaseModel):
    status: str
    job: str


class LatestReport(BaseModel):
    totalTransactions: int
    successfulTransactions: int
    failedTransactions: int
    suspiciousCount: int
