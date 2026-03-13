package com.accountflow.payments.repository;

import com.accountflow.payments.entity.Payment;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentRepository extends JpaRepository<Payment, Long> {
  List<Payment> findByCreatedByOrderByIdDesc(Long createdBy);
}
