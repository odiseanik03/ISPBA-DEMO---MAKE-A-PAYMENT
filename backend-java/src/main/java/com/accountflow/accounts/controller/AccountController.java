package com.accountflow.accounts.controller;

import com.accountflow.accounts.dto.AccountResponse;
import com.accountflow.accounts.service.AccountService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/accounts")
public class AccountController {
  private final AccountService accountService;

  public AccountController(AccountService accountService) { this.accountService = accountService; }

  @GetMapping
  public List<AccountResponse> list(@RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId) {
    return accountService.listForUser(userId);
  }
}
