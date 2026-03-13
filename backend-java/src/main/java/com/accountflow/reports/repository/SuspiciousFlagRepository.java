package com.accountflow.reports.repository;

import com.accountflow.reports.entity.SuspiciousFlag;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SuspiciousFlagRepository extends JpaRepository<SuspiciousFlag, Long> {
  List<SuspiciousFlag> findTop50ByOrderByIdDesc();
}
