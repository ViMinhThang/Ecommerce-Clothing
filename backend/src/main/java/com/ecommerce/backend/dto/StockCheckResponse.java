package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class StockCheckResponse {
    private Long variantId;
    private int availableStock;
    private boolean inStock;
    private boolean isLowStock; // less than 10
    private String stockStatus; // "IN_STOCK", "LOW_STOCK", "OUT_OF_STOCK"
}
