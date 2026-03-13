package com.accountflow.transactions.service;

import com.accountflow.accounts.repository.AccountRepository;
import com.accountflow.transactions.dto.TransactionResponse;
import com.accountflow.transactions.dto.TransactionsPageResponse;
import com.accountflow.transactions.repository.TransactionRepository;
import java.util.Comparator;
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

  public TransactionsPageResponse list(Long userId, String status, Integer page, Integer size) {
    int p = page == null || page < 0 ? 0 : page;
    int s = size == null || size < 1 ? 10 : Math.min(size, 100);

    var accountIds = accountRepository.findByUserId(userId).stream().map(a -> a.getId()).toList();
    var all = accountIds.stream()
        .flatMap(id -> transactionRepository.findBySourceAccountIdOrderByIdDesc(id).stream())
        .filter(t -> status == null || status.isBlank() || t.getStatus().equalsIgnoreCase(status))
        .sorted(Comparator.comparingLong(t -> -t.getId()))
        .map(t -> new TransactionResponse(t.getId(), t.getTransactionReference(), t.getStatus(), t.getAmount(),
            t.getCurrency(), t.getDestinationAccountNumber(), t.getBeneficiaryName(), Boolean.TRUE.equals(t.getRiskFlag())))
        .toList();

    int from = Math.min(p * s, all.size());
    int to = Math.min(from + s, all.size());
    return new TransactionsPageResponse(all.subList(from, to), p, s, all.size());
  }
}
