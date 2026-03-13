package com.accountflow.transactions.controller;

import com.accountflow.transactions.dto.TransactionResponse;
import com.accountflow.transactions.service.TransactionService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/transactions")
public class TransactionController {
  private final TransactionService transactionService;

  public TransactionController(TransactionService transactionService) { this.transactionService = transactionService; }

  @GetMapping
  public List<TransactionResponse> list(@RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId) {
    return transactionService.list(userId);
  }
}
