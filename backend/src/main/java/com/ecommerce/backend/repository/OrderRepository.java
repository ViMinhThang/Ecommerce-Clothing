package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCreatedDateBetween(LocalDateTime startOfMonth, LocalDateTime endOfMonth);

    @Query("SELECT o FROM Order o WHERE UPPER(o.status) = UPPER(:status)")
    Page<Order> findAllByStatus(@Param("status") String status, Pageable pageable);

    @Query("SELECT COALESCE(SUM(o.totalPrice), 0) FROM Order o WHERE o.status = :status")
    double sumTotalPriceByStatus(@Param("status") String status);

    List<Order> findByUserIdAndStatus(Long userId, String status);
}
