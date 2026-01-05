package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.OrderItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface OrderItemRepository extends JpaRepository<OrderItem, Long> {
    boolean existsByProductVariantsId(Long productVariantId);

    @Query("SELECT oi FROM OrderItem oi JOIN FETCH oi.order o JOIN FETCH o.user WHERE oi.id = :id")
    Optional<OrderItem> findByIdWithOrderAndUser(@Param("id") Long id);
}
