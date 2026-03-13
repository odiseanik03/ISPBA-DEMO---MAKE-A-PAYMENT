package com.accountflow.common.dto;

import java.time.OffsetDateTime;

public record ErrorResponse(String error, String message, int status, String path, OffsetDateTime timestamp) {}
