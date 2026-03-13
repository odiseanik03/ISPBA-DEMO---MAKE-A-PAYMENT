package com.accountflow.common.exception;

import com.accountflow.common.dto.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import java.time.OffsetDateTime;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class GlobalExceptionHandler {

  @ExceptionHandler(ApiException.class)
  public ResponseEntity<ErrorResponse> api(ApiException ex, HttpServletRequest request) {
    return ResponseEntity.status(ex.getStatus()).body(
        new ErrorResponse("API_ERROR", ex.getMessage(), ex.getStatus(), request.getRequestURI(), OffsetDateTime.now()));
  }

  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<ErrorResponse> badRequest(IllegalArgumentException ex, HttpServletRequest request) {
    return ResponseEntity.badRequest().body(
        new ErrorResponse("VALIDATION_ERROR", ex.getMessage(), 400, request.getRequestURI(), OffsetDateTime.now()));
  }

  @ExceptionHandler(MethodArgumentNotValidException.class)
  public ResponseEntity<ErrorResponse> validation(MethodArgumentNotValidException ex, HttpServletRequest request) {
    return ResponseEntity.badRequest().body(
        new ErrorResponse("VALIDATION_ERROR", "Validation failed", 400, request.getRequestURI(), OffsetDateTime.now()));
  }
}
