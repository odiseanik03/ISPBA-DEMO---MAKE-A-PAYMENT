package com.accountflow.payments.dto;

import java.math.BigDecimal;

public record PaymentResponse(Long paymentId, String transactionReference, String status, BigDecimal remainingBalance) {}
