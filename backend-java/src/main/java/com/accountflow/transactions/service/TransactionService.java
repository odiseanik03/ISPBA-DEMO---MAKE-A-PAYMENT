package com.accountflow.transactions.service;

import com.accountflow.accounts.repository.AccountRepository;
import com.accountflow.transactions.dto.TransactionResponse;
import com.accountflow.transactions.repository.TransactionRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class TransactionService {
  private final TransactionRepository transactionRepository;
  private final AccountRepository accountRepository;

  public TransactionService(TransactionRepository transactionRepository, AccountRepository accountRepository) {
    this.transactionRepository = transactionRepository;
    this.accountRepository = accountRepository;
  }

  public List<TransactionResponse> list(Long userId) {
    var accountIds = accountRepository.findByUserId(userId).stream().map(a -> a.getId()).toList();
    return accountIds.stream()
        .flatMap(id -> transactionRepository.findBySourceAccountIdOrderByIdDesc(id).stream())
        .map(t -> new TransactionResponse(t.getId(), t.getTransactionReference(), t.getStatus(), t.getAmount(), t.getCurrency(), t.getDestinationAccountNumber(), t.getBeneficiaryName()))
        .toList();
  }
}
