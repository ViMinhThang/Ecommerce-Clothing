package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Review;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    Optional<Review> findByOrderItemId(Long orderItemId);

    boolean existsByOrderItemId(Long orderItemId);

    Page<Review> findByProductIdAndStatus(Long productId, String status, Pageable pageable);

    Page<Review> findByUserIdAndStatus(Long userId, String status, Pageable pageable);

    List<Review> findByProductIdAndStatus(Long productId, String status);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.product.id = :productId AND r.status = 'active'")
    Double getAverageRatingByProductId(@Param("productId") Long productId);

    @Query("SELECT COUNT(r) FROM Review r WHERE r.product.id = :productId AND r.status = 'active'")
    Long countByProductId(@Param("productId") Long productId);

    @Query("SELECT r.orderItem.id FROM Review r WHERE r.order.id = :orderId")
    List<Long> findReviewedOrderItemIdsByOrderId(@Param("orderId") Long orderId);
}
