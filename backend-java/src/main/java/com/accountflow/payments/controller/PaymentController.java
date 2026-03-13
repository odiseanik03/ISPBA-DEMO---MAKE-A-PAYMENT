package com.accountflow.payments.controller;

import com.accountflow.payments.dto.CreatePaymentRequest;
import com.accountflow.payments.dto.PaymentDetailsResponse;
import com.accountflow.payments.dto.PaymentResponse;
import com.accountflow.payments.service.PaymentQueryService;
import com.accountflow.payments.service.PaymentService;
import jakarta.validation.Valid;
import java.util.List;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/payments")
public class PaymentController {
  private final PaymentService paymentService;
  private final PaymentQueryService paymentQueryService;

  public PaymentController(PaymentService paymentService, PaymentQueryService paymentQueryService) {
    this.paymentService = paymentService;
    this.paymentQueryService = paymentQueryService;
  }

  @PostMapping
  public PaymentResponse create(@RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId,
                                @Valid @RequestBody CreatePaymentRequest request) {
    return paymentService.create(userId, request);
  }

  @GetMapping
  public List<PaymentDetailsResponse> list(@RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId) {
    return paymentQueryService.listByUser(userId).stream()
        .map(p -> new PaymentDetailsResponse(p.getId(), p.getSourceAccountId(), p.getDestinationAccountNumber(),
            p.getBeneficiaryName(), p.getAmount(), p.getCurrency(), p.getDescription(), p.getExecutionDate(),
            p.getStatus()))
        .toList();
  }

  @GetMapping("/{id}")
  public PaymentDetailsResponse get(@RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId,
                                    @PathVariable("id") Long id) {
    var p = paymentQueryService.getOwned(userId, id);
    return new PaymentDetailsResponse(p.getId(), p.getSourceAccountId(), p.getDestinationAccountNumber(),
        p.getBeneficiaryName(), p.getAmount(), p.getCurrency(), p.getDescription(), p.getExecutionDate(), p.getStatus());
  }
}
