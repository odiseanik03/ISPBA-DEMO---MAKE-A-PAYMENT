package com.accountflow.accounts.entity;

import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "accounts")
public class Account {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;
  @Column(name = "user_id", nullable = false)
  private Long userId;
  @Column(name = "account_number", nullable = false, unique = true)
  private String accountNumber;
  @Column(nullable = false)
  private String currency;
  @Column(name = "account_type", nullable = false)
  private String accountType;
  @Column(name = "available_balance", nullable = false)
  private BigDecimal availableBalance;
  @Column(nullable = false)
  private String status;

  public Long getId() { return id; }
  public Long getUserId() { return userId; }
  public void setUserId(Long userId) { this.userId = userId; }
  public String getAccountNumber() { return accountNumber; }
  public void setAccountNumber(String accountNumber) { this.accountNumber = accountNumber; }
  public String getCurrency() { return currency; }
  public void setCurrency(String currency) { this.currency = currency; }
  public String getAccountType() { return accountType; }
  public void setAccountType(String accountType) { this.accountType = accountType; }
  public BigDecimal getAvailableBalance() { return availableBalance; }
  public void setAvailableBalance(BigDecimal availableBalance) { this.availableBalance = availableBalance; }
  public String getStatus() { return status; }
  public void setStatus(String status) { this.status = status; }
}
