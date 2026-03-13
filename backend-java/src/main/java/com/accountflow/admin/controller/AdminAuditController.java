package com.accountflow.admin.controller;

import com.accountflow.audit.dto.AuditLogResponse;
import com.accountflow.audit.service.AuditService;
import java.util.List;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/admin")
public class AdminAuditController {
  private final AuditService auditService;

  public AdminAuditController(AuditService auditService) {
    this.auditService = auditService;
  }

  @GetMapping("/audit-logs")
  public List<AuditLogResponse> auditLogs(@RequestHeader(name = "X-Demo-Role", defaultValue = "CUSTOMER") String role,
                                          @RequestHeader(name = "X-Demo-User-Id", defaultValue = "1") Long userId) {
    if (!"ADMIN".equalsIgnoreCase(role)) {
      throw new IllegalArgumentException("Admin role required");
    }
    auditService.write(userId, "ADMIN_VIEW_AUDIT_LOGS", "AUDIT_LOG", null, "{}");
    return auditService.latest();
  }
}
