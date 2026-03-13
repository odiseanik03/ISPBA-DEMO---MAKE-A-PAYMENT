package com.accountflow.reports.entity;

import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "suspicious_flags")
public class SuspiciousFlag {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "transaction_id", nullable = false)
  private Long transactionId;
  @Column(name = "rule_code", nullable = false)
  private String ruleCode;
  @Column(name = "rule_description", nullable = false)
  private String ruleDescription;
  @Column(nullable = false)
  private String severity;
  @Column(name = "created_at")
  private OffsetDateTime createdAt;

  public Long getId() { return id; }
  public Long getTransactionId() { return transactionId; }
  public String getRuleCode() { return ruleCode; }
  public String getRuleDescription() { return ruleDescription; }
  public String getSeverity() { return severity; }
  public OffsetDateTime getCreatedAt() { return createdAt; }
}
