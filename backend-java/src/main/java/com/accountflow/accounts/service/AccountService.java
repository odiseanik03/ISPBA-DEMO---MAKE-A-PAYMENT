package com.accountflow.accounts.service;

import com.accountflow.accounts.dto.AccountResponse;
import com.accountflow.accounts.entity.Account;
import com.accountflow.accounts.repository.AccountRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class AccountService {
  private final AccountRepository accountRepository;

  public AccountService(AccountRepository accountRepository) {
    this.accountRepository = accountRepository;
  }

  public List<AccountResponse> listForUser(Long userId) {
    return accountRepository.findByUserId(userId).stream().map(this::toResponse).toList();
  }

  public Account requireOwnedAccount(Long accountId, Long userId) {
    return accountRepository.findByIdAndUserId(accountId, userId)
        .orElseThrow(() -> new IllegalArgumentException("Account not found for user"));
  }

  public Account save(Account account) { return accountRepository.save(account); }

  private AccountResponse toResponse(Account a) {
    return new AccountResponse(a.getId(), mask(a.getAccountNumber()), a.getAccountType(), a.getAvailableBalance(),
        a.getCurrency(), a.getStatus());
  }

  private String mask(String accountNumber) {
    if (accountNumber == null || accountNumber.length() < 4) return "****";
    return "**** **** **** " + accountNumber.substring(accountNumber.length() - 4);
  }
}
