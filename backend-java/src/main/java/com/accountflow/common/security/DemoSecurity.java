package com.accountflow.common.security;

import com.accountflow.common.exception.ApiException;
import org.springframework.stereotype.Component;

@Component
public class DemoSecurity {
  public void requireAdmin(String role) {
    if (!"ADMIN".equalsIgnoreCase(role)) {
      throw new ApiException(403, "Admin role required");
    }
  }
}
