package com.accountflow.payments.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record PaymentDetailsResponse(Long id, Long sourceAccountId, String destinationAccountNumber, String beneficiaryName,
                                     BigDecimal amount, String currency, String description, LocalDate executionDate,
                                     String status) {}
