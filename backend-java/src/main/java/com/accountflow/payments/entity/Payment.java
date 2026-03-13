package com.accountflow.payments.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "payments")
public class Payment {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
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
  private String description;
  @Column(name = "execution_date", nullable = false)
  private LocalDate executionDate;
  @Column(nullable = false)
  private String status;
  @Column(name = "created_by", nullable = false)
  private Long createdBy;

  public Long getId() { return id; }
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
  public String getDescription() { return description; }
  public void setDescription(String description) { this.description = description; }
  public LocalDate getExecutionDate() { return executionDate; }
  public void setExecutionDate(LocalDate executionDate) { this.executionDate = executionDate; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
  public Long getCreatedBy() { return createdBy; }
  public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }
}
