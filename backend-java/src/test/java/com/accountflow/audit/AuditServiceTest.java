package com.accountflow.audit;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

import com.accountflow.audit.entity.AuditLog;
import com.accountflow.audit.repository.AuditLogRepository;
import com.accountflow.audit.service.AuditService;
import java.time.OffsetDateTime;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

public class AuditServiceTest {
  @Test
  void shouldReturnPagedAuditLogs() {
    AuditLogRepository repo = Mockito.mock(AuditLogRepository.class);
    AuditService service = new AuditService(repo);

    AuditLog a1 = new AuditLog();
    a1.setActorUserId(1L);
    a1.setActionType("A");
    a1.setEntityType("E");
    a1.setEntityId("1");
    a1.setDetailsJson("{}");
    a1.setCreatedAt(OffsetDateTime.now());

    AuditLog a2 = new AuditLog();
    a2.setActorUserId(1L);
    a2.setActionType("B");
    a2.setEntityType("E");
    a2.setEntityId("2");
    a2.setDetailsJson("{}");
    a2.setCreatedAt(OffsetDateTime.now());

    when(repo.findAll()).thenReturn(List.of(a1, a2));

    var page = service.page(0, 1);
    assertEquals(1, page.items().size());
    assertEquals(2, page.total());
  }
}
