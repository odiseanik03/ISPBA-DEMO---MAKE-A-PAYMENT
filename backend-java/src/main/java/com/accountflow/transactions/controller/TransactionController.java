package com.accountflow.transactions.controller;

import com.accountflow.transactions.dto.TransactionsPageResponse;
import com.accountflow.transactions.service.TransactionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {
  private final TransactionService transactionService;

  public TransactionController(TransactionService transactionService) { this.transactionService = transactionService; }

  @GetMapping
  public TransactionsPageResponse list(
      @RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId,
      @RequestParam(name = "status", required = false) String status,
      @RequestParam(name = "page", required = false) Integer page,
      @RequestParam(name = "size", required = false) Integer size) {
    return transactionService.list(userId, status, page, size);
  }
}
