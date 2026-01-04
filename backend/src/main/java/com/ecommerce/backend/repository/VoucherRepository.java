package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Voucher;
import com.ecommerce.backend.model.VoucherStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface VoucherRepository extends JpaRepository<Voucher, Long> {

    Optional<Voucher> findByCode(String code);

    Optional<Voucher> findByCodeAndStatus(String code, VoucherStatus status);

    List<Voucher> findByStatus(VoucherStatus status);

    List<Voucher> findByStatusAndStartDateBeforeAndEndDateAfter(
            VoucherStatus status, LocalDateTime now1, LocalDateTime now2);

    boolean existsByCode(String code);
}
