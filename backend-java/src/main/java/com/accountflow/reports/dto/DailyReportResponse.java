package com.accountflow.reports.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record DailyReportResponse(LocalDate reportDate, Long totalTransactions, Long successfulTransactions,
                                  Long failedTransactions, BigDecimal totalAmount, BigDecimal avgAmount,
                                  Long suspiciousCount) {}
