package com.accountflow.reports.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "reports")
public class Report {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "report_date", nullable = false)
  private LocalDate reportDate;
  @Column(name = "total_transactions", nullable = false)
  private Long totalTransactions;
  @Column(name = "successful_transactions", nullable = false)
  private Long successfulTransactions;
  @Column(name = "failed_transactions", nullable = false)
  private Long failedTransactions;
  @Column(name = "total_amount", nullable = false)
  private BigDecimal totalAmount;
  @Column(name = "avg_amount", nullable = false)
  private BigDecimal avgAmount;
  @Column(name = "suspicious_count", nullable = false)
  private Long suspiciousCount;

  public Long getId() { return id; }
  public LocalDate getReportDate() { return reportDate; }
  public void setReportDate(LocalDate reportDate) { this.reportDate = reportDate; }
  public Long getTotalTransactions() { return totalTransactions; }
  public void setTotalTransactions(Long totalTransactions) { this.totalTransactions = totalTransactions; }
  public Long getSuccessfulTransactions() { return successfulTransactions; }
  public void setSuccessfulTransactions(Long successfulTransactions) { this.successfulTransactions = successfulTransactions; }
  public Long getFailedTransactions() { return failedTransactions; }
  public void setFailedTransactions(Long failedTransactions) { this.failedTransactions = failedTransactions; }
  public BigDecimal getTotalAmount() { return totalAmount; }
  public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
  public BigDecimal getAvgAmount() { return avgAmount; }
  public void setAvgAmount(BigDecimal avgAmount) { this.avgAmount = avgAmount; }
  public Long getSuspiciousCount() { return suspiciousCount; }
  public void setSuspiciousCount(Long suspiciousCount) { this.suspiciousCount = suspiciousCount; }
}
