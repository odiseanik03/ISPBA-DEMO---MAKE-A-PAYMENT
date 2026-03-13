from sqlalchemy.orm import declarative_base
from sqlalchemy import Column, BigInteger, String, Numeric, Date, Boolean, DateTime

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


class Transaction(Base):
    __tablename__ = "transactions"
    id = Column(BigInteger, primary_key=True)
    transaction_reference = Column(String)
    destination_account_number = Column(String)
    amount = Column(Numeric)
    status = Column(String)
    risk_flag = Column(Boolean)
    created_at = Column(DateTime(timezone=True))


class SuspiciousFlag(Base):
    __tablename__ = "suspicious_flags"
    id = Column(BigInteger, primary_key=True)
    transaction_id = Column(BigInteger)
    rule_code = Column(String)
    rule_description = Column(String)
    severity = Column(String)
