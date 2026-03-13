package com.accountflow.admin.controller;

import com.accountflow.audit.dto.AuditLogsPageResponse;
import com.accountflow.audit.service.AuditService;
import com.accountflow.common.security.DemoSecurity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin")
public class AdminAuditController {
  private final AuditService auditService;
  private final DemoSecurity demoSecurity;

  public AdminAuditController(AuditService auditService, DemoSecurity demoSecurity) {
    this.auditService = auditService;
    this.demoSecurity = demoSecurity;
  }

  @GetMapping("/audit-logs")
  public AuditLogsPageResponse auditLogs(
      @RequestHeader(name = "X-Demo-Role", defaultValue = "CUSTOMER") String role,
      @RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId,
      @RequestParam(name = "page", required = false, defaultValue = "0") int page,
      @RequestParam(name = "size", required = false, defaultValue = "20") int size) {
    demoSecurity.requireAdmin(role);
    auditService.write(userId, "ADMIN_VIEW_AUDIT_LOGS", "AUDIT_LOG", null, "{}");
    return auditService.page(page, size);
  }
}
