package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WishlistItemView {
    private Long id;
    private Long productId;
    private String productName;
    private String productDescription;
    private String imageUrl;
    private Double basePrice;
    private Double salePrice;
    private String categoryName;
    private LocalDateTime addedAt;
}
