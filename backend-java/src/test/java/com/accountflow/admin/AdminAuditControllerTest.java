package com.accountflow.admin;

import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.doThrow;
import static org.mockito.Mockito.mock;

import com.accountflow.admin.controller.AdminAuditController;
import com.accountflow.audit.service.AuditService;
import com.accountflow.common.exception.ApiException;
import com.accountflow.common.security.DemoSecurity;
import org.junit.jupiter.api.Test;

public class AdminAuditControllerTest {
  @Test
  void shouldRejectNonAdminRole() {
    AuditService auditService = mock(AuditService.class);
    DemoSecurity demoSecurity = mock(DemoSecurity.class);
    doThrow(new ApiException(403, "Admin role required")).when(demoSecurity).requireAdmin("CUSTOMER");

    AdminAuditController controller = new AdminAuditController(auditService, demoSecurity);
    assertThrows(ApiException.class, () -> controller.auditLogs("CUSTOMER", 1L, 0, 20));
  }
}
