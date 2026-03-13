package com.accountflow.payments.service;

import com.accountflow.payments.entity.Payment;
import com.accountflow.payments.repository.PaymentRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class PaymentQueryService {
  private final PaymentRepository paymentRepository;

  public PaymentQueryService(PaymentRepository paymentRepository) {
    this.paymentRepository = paymentRepository;
  }

  public List<Payment> listByUser(Long userId) {
    return paymentRepository.findByCreatedByOrderByIdDesc(userId);
  }

  public Payment getOwned(Long userId, Long paymentId) {
    return paymentRepository.findById(paymentId)
        .filter(p -> p.getCreatedBy().equals(userId))
        .orElseThrow(() -> new IllegalArgumentException("Payment not found"));
  }
}
