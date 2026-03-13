package com.accountflow.audit.dto;

import java.util.List;

public record AuditLogsPageResponse(List<AuditLogResponse> items, int page, int size, long total) {}
