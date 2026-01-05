package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.CreateReviewRequest;
import com.ecommerce.backend.dto.ProductReviewSummary;
import com.ecommerce.backend.dto.ReviewView;
import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {

    private final ReviewRepository reviewRepository;
    private final OrderItemRepository orderItemRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public ReviewView createReview(Long userId, CreateReviewRequest request) {
        if (reviewRepository.existsByOrderItemId(request.getOrderItemId())) {
            throw new IllegalStateException("This item has already been reviewed");
        }

        OrderItem orderItem = orderItemRepository.findByIdWithOrderAndUser(request.getOrderItemId())
                .orElseThrow(() -> new IllegalArgumentException("Order item not found"));

        Order order = orderItem.getOrder();
        if (!order.getUser().getId().equals(userId)) {
            throw new IllegalStateException("You can only review items from your own orders");
        }

        if (!"DELIVERED".equalsIgnoreCase(order.getStatus())) {
            throw new IllegalStateException("You can only review items from delivered orders");
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        Product product = orderItem.getProductVariants().getProduct();

        Review review = Review.builder()
                .user(user)
                .product(product)
                .order(order)
                .orderItem(orderItem)
                .rating(request.getRating())
                .comment(request.getComment())
                .status("active")
                .build();

        review = reviewRepository.save(review);

        return mapToView(review);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean canReview(Long userId, Long orderItemId) {
        if (reviewRepository.existsByOrderItemId(orderItemId)) {
            return false;
        }

        OrderItem orderItem = orderItemRepository.findByIdWithOrderAndUser(orderItemId).orElse(null);
        if (orderItem == null) {
            return false;
        }

        Order order = orderItem.getOrder();
        if (!order.getUser().getId().equals(userId)) {
            return false;
        }

        return "DELIVERED".equalsIgnoreCase(order.getStatus());
    }

    @Override
    public Page<ReviewView> getProductReviews(Long productId, Pageable pageable) {
        return reviewRepository.findByProductIdAndStatus(productId, "active", pageable)
                .map(this::mapToView);
    }

    @Override
    public Page<ReviewView> getUserReviews(Long userId, Pageable pageable) {
        return reviewRepository.findByUserIdAndStatus(userId, "active", pageable)
                .map(this::mapToView);
    }

    @Override
    public ProductReviewSummary getProductReviewSummary(Long productId) {
        Double avgRating = reviewRepository.getAverageRatingByProductId(productId);
        Long totalReviews = reviewRepository.countByProductId(productId);

        return ProductReviewSummary.builder()
                .productId(productId)
                .averageRating(avgRating != null ? avgRating : 0.0)
                .totalReviews(totalReviews != null ? totalReviews : 0L)
                .build();
    }

    @Override
    public List<Long> getReviewedOrderItemIds(Long orderId) {
        return reviewRepository.findReviewedOrderItemIdsByOrderId(orderId);
    }

    private ReviewView mapToView(Review review) {
        String productImageUrl = null;
        if (review.getProduct().getImages() != null && !review.getProduct().getImages().isEmpty()) {
            productImageUrl = review.getProduct().getImages().stream()
                    .filter(img -> img.getIsPrimary() != null && img.getIsPrimary())
                    .findFirst()
                    .map(ProductImage::getImageUrl)
                    .orElse(review.getProduct().getImages().get(0).getImageUrl());
        }

        return ReviewView.builder()
                .id(review.getId())
                .userId(review.getUser().getId())
                .userName(review.getUser().getFullName())
                .productId(review.getProduct().getId())
                .productName(review.getProduct().getName())
                .productImageUrl(productImageUrl)
                .orderId(review.getOrder().getId())
                .orderItemId(review.getOrderItem().getId())
                .rating(review.getRating())
                .comment(review.getComment())
                .status(review.getStatus())
                .createdDate(review.getCreatedDate())
                .build();
    }
}
