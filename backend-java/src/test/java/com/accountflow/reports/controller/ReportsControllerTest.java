package com.accountflow.reports.controller;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import com.accountflow.reports.dto.ReportsSummaryResponse;
import com.accountflow.reports.service.ReportsService;
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
}
