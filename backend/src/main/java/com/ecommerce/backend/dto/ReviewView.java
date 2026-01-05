package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ReviewView {
    private Long id;
    private Long userId;
    private String userName;
    private Long productId;
    private String productName;
    private String productImageUrl;
    private Long orderId;
    private Long orderItemId;
    private int rating;
    private String comment;
    private String status;
    private LocalDateTime createdDate;
}
