package com.accountflow.reports.dto;

public record ReportsSummaryResponse(Long totalTransactions, Long failedTransactions, Long suspiciousCount) {}
