package com.accountflow.reports.controller;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.accountflow.reports.dto.ReportsSummaryResponse;
import com.accountflow.reports.dto.SuspiciousFlagResponse;
import com.accountflow.reports.service.ReportsService;
import java.util.List;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

@WebMvcTest(ReportsController.class)
class ReportsControllerTest {
  @Autowired
  MockMvc mockMvc;

  @MockBean
  ReportsService reportsService;

  @Test
  void shouldReturnSummary() throws Exception {
    when(reportsService.summary()).thenReturn(new ReportsSummaryResponse(10L, 1L, 0L));
    mockMvc.perform(get("/api/reports/summary")).andExpect(status().isOk());
  }

  @Test
  void shouldReturnSuspiciousFlags() throws Exception {
    when(reportsService.suspiciousFlags()).thenReturn(List.of(new SuspiciousFlagResponse(1L, "AMOUNT_THRESHOLD", "HIGH")));

    mockMvc.perform(get("/api/reports/suspicious-flags"))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$[0].transactionId").value(1))
        .andExpect(jsonPath("$[0].ruleCode").value("AMOUNT_THRESHOLD"));
  }
}
