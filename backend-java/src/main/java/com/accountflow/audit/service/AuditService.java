package com.accountflow.audit.service;

import com.accountflow.audit.dto.AuditLogResponse;
import com.accountflow.audit.dto.AuditLogsPageResponse;
import com.accountflow.audit.entity.AuditLog;
import com.accountflow.audit.repository.AuditLogRepository;
import java.time.OffsetDateTime;
import java.util.Comparator;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class AuditService {
  private final AuditLogRepository auditLogRepository;

  public AuditService(AuditLogRepository auditLogRepository) {
    this.auditLogRepository = auditLogRepository;
  }

  public void write(Long actor, String actionType, String entityType, String entityId, String detailsJson) {
    AuditLog l = new AuditLog();
    l.setActorUserId(actor);
    l.setActionType(actionType);
    l.setEntityType(entityType);
    l.setEntityId(entityId);
    l.setDetailsJson(detailsJson);
    l.setCreatedAt(OffsetDateTime.now());
    auditLogRepository.save(l);
  }

  public AuditLogsPageResponse page(int page, int size) {
    int p = Math.max(page, 0);
    int s = Math.max(1, Math.min(size, 200));
    List<AuditLogResponse> all = auditLogRepository.findAll().stream()
        .sorted(Comparator.comparingLong((AuditLog a) -> a.getId()).reversed())
        .map(a -> new AuditLogResponse(a.getId(), a.getActorUserId(), a.getActionType(), a.getEntityType(),
            a.getEntityId(), a.getDetailsJson(), a.getCreatedAt() == null ? null : a.getCreatedAt().toString()))
        .toList();
    int from = Math.min(p * s, all.size());
    int to = Math.min(from + s, all.size());
    return new AuditLogsPageResponse(all.subList(from, to), p, s, all.size());
  }
}
