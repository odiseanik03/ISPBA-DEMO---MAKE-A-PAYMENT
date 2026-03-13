package com.accountflow.transactions.repository;

import com.accountflow.transactions.entity.TransactionRecord;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransactionRepository extends JpaRepository<TransactionRecord, Long> {
  List<TransactionRecord> findBySourceAccountIdOrderByIdDesc(Long sourceAccountId);
}
