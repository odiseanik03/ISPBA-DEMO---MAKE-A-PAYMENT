package com.accountflow.reports.controller;

import com.accountflow.reports.dto.DailyReportResponse;
import com.accountflow.reports.dto.ReportsSummaryResponse;
import com.accountflow.reports.service.ReportsService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/reports")
public class ReportsController {
  private final ReportsService reportsService;

  public ReportsController(ReportsService reportsService) {
    this.reportsService = reportsService;
  }

  @GetMapping("/daily")
  public DailyReportResponse daily() { return reportsService.latestDaily(); }

  @GetMapping("/summary")
  public ReportsSummaryResponse summary() { return reportsService.summary(); }
}
