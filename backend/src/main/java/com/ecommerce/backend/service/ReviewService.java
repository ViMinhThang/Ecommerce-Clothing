package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.CreateReviewRequest;
import com.ecommerce.backend.dto.ProductReviewSummary;
import com.ecommerce.backend.dto.ReviewView;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ReviewService {

    ReviewView createReview(Long userId, CreateReviewRequest request);

    boolean canReview(Long userId, Long orderItemId);

    Page<ReviewView> getProductReviews(Long productId, Pageable pageable);

    Page<ReviewView> getUserReviews(Long userId, Pageable pageable);

    ProductReviewSummary getProductReviewSummary(Long productId);

    List<Long> getReviewedOrderItemIds(Long orderId);
}
