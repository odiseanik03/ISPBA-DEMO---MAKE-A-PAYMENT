package com.accountflow.payments.controller;

import com.accountflow.payments.dto.CreatePaymentRequest;
import com.accountflow.payments.dto.PaymentResponse;
import com.accountflow.payments.service.PaymentService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {
  private final PaymentService paymentService;

  public PaymentController(PaymentService paymentService) { this.paymentService = paymentService; }

  @PostMapping
  public PaymentResponse create(@RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId,
                                @Valid @RequestBody CreatePaymentRequest request) {
    return paymentService.create(userId, request);
  }
}
