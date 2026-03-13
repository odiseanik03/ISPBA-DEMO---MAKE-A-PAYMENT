package com.accountflow.reports.dto;

public record SuspiciousFlagResponse(Long id, Long transactionId, String ruleCode, String ruleDescription,
                                     String severity, String createdAt) {}
