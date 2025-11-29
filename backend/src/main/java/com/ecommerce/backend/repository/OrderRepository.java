package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Order;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Long> {
    List<Order> findByCreatedDateBetween(LocalDateTime startOfMonth, LocalDateTime endOfMonth);
    Page<Order> findAllByStatus(String status, Pageable pageable);
}
