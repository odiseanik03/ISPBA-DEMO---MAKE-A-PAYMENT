package com.accountflow.payments;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.when;

import com.accountflow.payments.entity.Payment;
import com.accountflow.payments.repository.PaymentRepository;
import com.accountflow.payments.service.PaymentQueryService;
import java.util.Optional;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

public class PaymentQueryServiceTest {
  @Test
  void shouldRejectPaymentOfAnotherUser() {
    PaymentRepository repo = Mockito.mock(PaymentRepository.class);
    PaymentQueryService service = new PaymentQueryService(repo);

    Payment p = new Payment();
    p.setCreatedBy(2L);
    when(repo.findById(10L)).thenReturn(Optional.of(p));

    assertThrows(IllegalArgumentException.class, () -> service.getOwned(1L, 10L));
  }

  @Test
  void shouldReturnOwnedPayment() {
    PaymentRepository repo = Mockito.mock(PaymentRepository.class);
    PaymentQueryService service = new PaymentQueryService(repo);

    Payment p = new Payment();
    p.setCreatedBy(1L);
    when(repo.findById(11L)).thenReturn(Optional.of(p));

    assertEquals(p, service.getOwned(1L, 11L));
  }
}
