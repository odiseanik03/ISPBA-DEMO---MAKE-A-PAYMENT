package com.accountflow.transactions.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "transactions")
public class TransactionRecord {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "payment_id", nullable = false)
  private Long paymentId;
  @Column(name = "transaction_reference", nullable = false)
  private String transactionReference;
  @Column(name = "source_account_id", nullable = false)
  private Long sourceAccountId;
  @Column(name = "destination_account_number", nullable = false)
  private String destinationAccountNumber;
  @Column(name = "beneficiary_name", nullable = false)
  private String beneficiaryName;
  @Column(nullable = false)
  private BigDecimal amount;
  @Column(nullable = false)
  private String currency;
  @Column(name = "transaction_type", nullable = false)
  private String transactionType;
  @Column(nullable = false)
  private String status;
  @Column(name = "risk_flag", nullable = false)
  private Boolean riskFlag = false;

  public Long getId() { return id; }
  public Long getPaymentId() { return paymentId; }
  public void setPaymentId(Long paymentId) { this.paymentId = paymentId; }
  public String getTransactionReference() { return transactionReference; }
  public void setTransactionReference(String transactionReference) { this.transactionReference = transactionReference; }
  public Long getSourceAccountId() { return sourceAccountId; }
  public void setSourceAccountId(Long sourceAccountId) { this.sourceAccountId = sourceAccountId; }
  public String getDestinationAccountNumber() { return destinationAccountNumber; }
  public void setDestinationAccountNumber(String destinationAccountNumber) { this.destinationAccountNumber = destinationAccountNumber; }
  public String getBeneficiaryName() { return beneficiaryName; }
  public void setBeneficiaryName(String beneficiaryName) { this.beneficiaryName = beneficiaryName; }
  public BigDecimal getAmount() { return amount; }
  public void setAmount(BigDecimal amount) { this.amount = amount; }
  public String getCurrency() { return currency; }
  public void setCurrency(String currency) { this.currency = currency; }
  public String getTransactionType() { return transactionType; }
  public void setTransactionType(String transactionType) { this.transactionType = transactionType; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public Boolean getRiskFlag() { return riskFlag; }
  public void setRiskFlag(Boolean riskFlag) { this.riskFlag = riskFlag; }
}
