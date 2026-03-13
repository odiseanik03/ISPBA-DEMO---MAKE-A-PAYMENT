package com.accountflow.transactions.dto;

import java.util.List;

public record TransactionsPageResponse(List<TransactionResponse> items, int page, int size, long total) {}
