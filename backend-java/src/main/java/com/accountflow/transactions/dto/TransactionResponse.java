package com.accountflow.transactions.dto;

import java.math.BigDecimal;

public record TransactionResponse(Long id, String reference, String status, BigDecimal amount, String currency,
                                  String destinationAccountNumber, String beneficiaryName, boolean riskFlag) {}
