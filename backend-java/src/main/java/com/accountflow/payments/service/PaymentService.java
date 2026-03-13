package com.accountflow.payments.service;

import com.accountflow.accounts.entity.Account;
import com.accountflow.accounts.service.AccountService;
import com.accountflow.payments.dto.CreatePaymentRequest;
import com.accountflow.payments.dto.PaymentResponse;
import com.accountflow.payments.entity.Payment;
import com.accountflow.payments.repository.PaymentRepository;
import com.accountflow.audit.service.AuditService;
import com.accountflow.transactions.entity.TransactionRecord;
import com.accountflow.transactions.repository.TransactionRepository;
import java.math.BigDecimal;
import java.util.UUID;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class PaymentService {
  private final PaymentRepository paymentRepository;
  private final TransactionRepository transactionRepository;
  private final AccountService accountService;
  private final AuditService auditService;

  public PaymentService(PaymentRepository paymentRepository, TransactionRepository transactionRepository,
                        AccountService accountService, AuditService auditService) {
    this.paymentRepository = paymentRepository;
    this.transactionRepository = transactionRepository;
    this.accountService = accountService;
    this.auditService = auditService;
  }

  @Transactional
  public PaymentResponse create(Long userId, CreatePaymentRequest req) {
    Account account = accountService.requireOwnedAccount(req.sourceAccountId(), userId);
    validate(req, account);

    Payment payment = new Payment();
    payment.setSourceAccountId(req.sourceAccountId());
    payment.setDestinationAccountNumber(req.destinationAccountNumber());
    payment.setBeneficiaryName(req.beneficiaryName());
    payment.setAmount(req.amount());
    payment.setCurrency(req.currency());
    payment.setDescription(req.description());
    payment.setExecutionDate(req.executionDate());
    payment.setStatus("PENDING");
    payment.setCreatedBy(userId);
    payment = paymentRepository.save(payment);

    TransactionRecord txn = new TransactionRecord();
    txn.setPaymentId(payment.getId());
    txn.setSourceAccountId(req.sourceAccountId());
    txn.setDestinationAccountNumber(req.destinationAccountNumber());
    txn.setBeneficiaryName(req.beneficiaryName());
    txn.setAmount(req.amount());
    txn.setCurrency(req.currency());
    txn.setTransactionType("OUTBOUND_PAYMENT");
    txn.setStatus("PENDING");
    txn.setRiskFlag(false);
    txn.setTransactionReference("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
    transactionRepository.save(txn);

    account.setAvailableBalance(account.getAvailableBalance().subtract(req.amount()));
    accountService.save(account);

    auditService.write(userId, "PAYMENT_CREATED", "PAYMENT", String.valueOf(payment.getId()),
        "{\"reference\":\"" + txn.getTransactionReference() + "\"}");

    return new PaymentResponse(payment.getId(), txn.getTransactionReference(), payment.getStatus(), account.getAvailableBalance());
  }

  private void validate(CreatePaymentRequest req, Account account) {
    if (!req.currency().equals(account.getCurrency())) {
      throw new IllegalArgumentException("Currency must match source account currency");
    }
    if (req.executionDate().isBefore(java.time.LocalDate.now())) {
      throw new IllegalArgumentException("Execution date cannot be in the past");
    }
    if (req.amount().compareTo(account.getAvailableBalance()) > 0) {
      throw new IllegalArgumentException("Insufficient balance");
    }
  }
}
