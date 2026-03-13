package com.accountflow.payments.controller;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.accountflow.payments.dto.PaymentResponse;
import com.accountflow.payments.service.PaymentQueryService;
import com.accountflow.payments.service.PaymentService;
import java.math.BigDecimal;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(PaymentController.class)
class PaymentControllerTest {
  @Autowired
  MockMvc mockMvc;

  @MockBean
  PaymentService paymentService;

  @MockBean
  PaymentQueryService paymentQueryService;

  @Test
  void shouldCreatePayment() throws Exception {
    when(paymentService.create(any(), any())).thenReturn(new PaymentResponse(1L, "TXN-1", "PENDING", BigDecimal.TEN));

    mockMvc.perform(post("/api/payments")
            .contentType(MediaType.APPLICATION_JSON)
            .header("X-Demo-User-Id", "1")
            .content("""
                {"sourceAccountId":1,"destinationAccountNumber":"DE9999999999","beneficiaryName":"Acme","amount":10.0,"currency":"EUR","description":"x","executionDate":"2030-01-01"}
                """))
        .andExpect(status().isOk());
  }

  @Test
  void shouldReturnValidationEnvelopeForInvalidPayload() throws Exception {
    mockMvc.perform(post("/api/payments")
            .contentType(MediaType.APPLICATION_JSON)
            .header("X-Demo-User-Id", "1")
            .content("""
                {"sourceAccountId":1,"destinationAccountNumber":"BAD","beneficiaryName":"","amount":0,"currency":"EURO","description":"x","executionDate":"2030-01-01"}
                """))
        .andExpect(status().isBadRequest())
        .andExpect(jsonPath("$.error").value("VALIDATION_ERROR"))
        .andExpect(jsonPath("$.status").value(400))
        .andExpect(jsonPath("$.path").value("/api/payments"));
  }
}
