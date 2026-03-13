package com.accountflow.payments;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import com.accountflow.accounts.entity.Account;
import com.accountflow.accounts.service.AccountService;
import com.accountflow.audit.service.AuditService;
import com.accountflow.payments.dto.CreatePaymentRequest;
import com.accountflow.payments.repository.PaymentRepository;
import com.accountflow.payments.service.PaymentService;
import com.accountflow.transactions.repository.TransactionRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

public class PaymentServiceTest {
  @Test
  void shouldRejectInsufficientBalance() {
    PaymentRepository paymentRepository = Mockito.mock(PaymentRepository.class);
    TransactionRepository transactionRepository = Mockito.mock(TransactionRepository.class);
    AccountService accountService = Mockito.mock(AccountService.class);
    AuditService auditService = Mockito.mock(AuditService.class);

    Account account = new Account();
    account.setUserId(1L);
    account.setCurrency("EUR");
    account.setAvailableBalance(new BigDecimal("10.00"));

    when(accountService.requireOwnedAccount(1L, 1L)).thenReturn(account);
    when(paymentRepository.save(any())).thenAnswer(i -> i.getArgument(0));

    PaymentService service = new PaymentService(paymentRepository, transactionRepository, accountService, auditService);

    CreatePaymentRequest req = new CreatePaymentRequest(1L, "DE1234567890", "Test", new BigDecimal("11.00"), "EUR", "x", LocalDate.now());

    assertThrows(IllegalArgumentException.class, () -> service.create(1L, req));
  }
}
