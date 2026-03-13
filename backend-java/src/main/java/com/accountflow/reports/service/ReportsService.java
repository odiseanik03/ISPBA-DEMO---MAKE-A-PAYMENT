package com.accountflow.reports.service;

import com.accountflow.reports.dto.DailyReportResponse;
import com.accountflow.reports.dto.ReportsSummaryResponse;
import com.accountflow.reports.dto.SuspiciousFlagResponse;
import com.accountflow.reports.entity.Report;
import com.accountflow.reports.repository.ReportRepository;
import com.accountflow.reports.repository.SuspiciousFlagRepository;
import java.math.BigDecimal;
import java.time.LocalDate;
import org.springframework.stereotype.Service;

@Service
public class ReportsService {
  private final ReportRepository reportRepository;
  private final SuspiciousFlagRepository suspiciousFlagRepository;

  public ReportsService(ReportRepository reportRepository, SuspiciousFlagRepository suspiciousFlagRepository) {
    this.reportRepository = reportRepository;
    this.suspiciousFlagRepository = suspiciousFlagRepository;
  }

  public DailyReportResponse latestDaily() {
    Report r = reportRepository.findTopByOrderByReportDateDesc().orElseGet(this::defaultReport);
    return new DailyReportResponse(r.getReportDate(), r.getTotalTransactions(), r.getSuccessfulTransactions(),
        r.getFailedTransactions(), r.getTotalAmount(), r.getAvgAmount(), r.getSuspiciousCount());
  }

  public ReportsSummaryResponse summary() {
    DailyReportResponse d = latestDaily();
    return new ReportsSummaryResponse(d.totalTransactions(), d.failedTransactions(), d.suspiciousCount());
  }



  public java.util.List<SuspiciousFlagResponse> suspiciousFlags() {
    return suspiciousFlagRepository.findTop50ByOrderByIdDesc().stream()
        .map(f -> new SuspiciousFlagResponse(f.getId(), f.getTransactionId(), f.getRuleCode(), f.getRuleDescription(),
            f.getSeverity(), f.getCreatedAt() == null ? null : f.getCreatedAt().toString()))
        .toList();
  }

  private Report defaultReport() {
    Report d = new Report();
    d.setReportDate(LocalDate.now());
    d.setTotalTransactions(0L);
    d.setSuccessfulTransactions(0L);
    d.setFailedTransactions(0L);
    d.setTotalAmount(BigDecimal.ZERO);
    d.setAvgAmount(BigDecimal.ZERO);
    d.setSuspiciousCount(0L);
    return d;
  }
}
