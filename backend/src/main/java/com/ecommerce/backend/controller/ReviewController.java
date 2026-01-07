package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.CreateReviewRequest;
import com.ecommerce.backend.dto.ProductReviewSummary;
import com.ecommerce.backend.dto.ReviewView;
import com.ecommerce.backend.service.ReviewService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/reviews")
@RequiredArgsConstructor
public class ReviewController {

    private final ReviewService reviewService;

    @PostMapping
    public ResponseEntity<ReviewView> createReview(
            @RequestParam Long userId,
            @Valid @RequestBody CreateReviewRequest request) {
        ReviewView review = reviewService.createReview(userId, request);
        return ResponseEntity.ok(review);
    }

    @GetMapping("/can-review/{orderItemId}")
    public ResponseEntity<Map<String, Boolean>> canReview(
            @RequestParam Long userId,
            @PathVariable Long orderItemId) {
        boolean canReview = reviewService.canReview(userId, orderItemId);
        return ResponseEntity.ok(Map.of("canReview", canReview));
    }

    @GetMapping("/product/{productId}")
    public ResponseEntity<Page<ReviewView>> getProductReviews(
            @PathVariable Long productId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdDate"));
        return ResponseEntity.ok(reviewService.getProductReviews(productId, pageRequest));
    }

    @GetMapping("/product/{productId}/summary")
    public ResponseEntity<ProductReviewSummary> getProductReviewSummary(@PathVariable Long productId) {
        return ResponseEntity.ok(reviewService.getProductReviewSummary(productId));
    }

    @GetMapping("/user")
    public ResponseEntity<Page<ReviewView>> getUserReviews(
            @RequestParam Long userId,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        PageRequest pageRequest = PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdDate"));
        return ResponseEntity.ok(reviewService.getUserReviews(userId, pageRequest));
    }

    @GetMapping("/order/{orderId}/reviewed-items")
    public ResponseEntity<List<Long>> getReviewedOrderItemIds(@PathVariable Long orderId) {
        return ResponseEntity.ok(reviewService.getReviewedOrderItemIds(orderId));
    }
}
