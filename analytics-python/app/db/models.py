from sqlalchemy.orm import declarative_base
from sqlalchemy import Column, BigInteger, String, Numeric, Date

Base = declarative_base()


class Report(Base):
    __tablename__ = "reports"
    id = Column(BigInteger, primary_key=True)
    report_date = Column(Date)
    total_transactions = Column(BigInteger)
    successful_transactions = Column(BigInteger)
    failed_transactions = Column(BigInteger)
    total_amount = Column(Numeric)
    avg_amount = Column(Numeric)
    suspicious_count = Column(BigInteger)


class DataQualityResult(Base):
    __tablename__ = "data_quality_results"
    id = Column(BigInteger, primary_key=True)
    check_name = Column(String)
    issue_count = Column(BigInteger)
    report_date = Column(Date)
