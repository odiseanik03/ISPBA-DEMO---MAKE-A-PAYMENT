package com.accountflow.audit.dto;

public record AuditLogResponse(Long id, Long actorUserId, String actionType, String entityType, String entityId,
                               String detailsJson, String createdAt) {}
