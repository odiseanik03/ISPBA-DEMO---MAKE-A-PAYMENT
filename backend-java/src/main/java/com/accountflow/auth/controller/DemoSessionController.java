package com.accountflow.auth.controller;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DemoSessionController {

  @PostMapping("/demo/session")
  public Map<String, Object> createDemoSession() {
    return Map.of("token", "demo-customer-token", "role", "CUSTOMER", "username", "demo.customer");
  }

  @GetMapping("/auth/me")
  public Map<String, Object> me() {
    return Map.of("id", 1, "username", "demo.customer", "role", "CUSTOMER", "displayName", "Olisea");
  }
}
