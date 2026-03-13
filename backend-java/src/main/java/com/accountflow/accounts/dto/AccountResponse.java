package com.accountflow.accounts.dto;

import java.math.BigDecimal;

public record AccountResponse(Long id, String maskedAccountNumber, String accountType, BigDecimal availableBalance,
                              String currency, String status) {}
