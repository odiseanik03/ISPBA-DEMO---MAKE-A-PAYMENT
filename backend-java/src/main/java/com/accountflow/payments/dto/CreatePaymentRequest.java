package com.accountflow.payments.dto;

import jakarta.validation.constraints.*;
import java.math.BigDecimal;
import java.time.LocalDate;

public record CreatePaymentRequest(
    @NotNull Long sourceAccountId,
    @NotBlank @Size(min = 10, max = 34) String destinationAccountNumber,
    @NotBlank String beneficiaryName,
    @NotNull @DecimalMin(value = "0.01") BigDecimal amount,
    @NotBlank @Pattern(regexp = "^[A-Z]{3}$") String currency,
    String description,
    @NotNull LocalDate executionDate
) {}
