package com.accountflow.reports.repository;

import com.accountflow.reports.entity.Report;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, Long> {
  Optional<Report> findTopByOrderByReportDateDesc();
}
