package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class InventoryDTO {
    private Long id;
    private Long storeId;
    private String storeName;
    private Long productVariantId;
    private String productName;
    private String variantInfo; // e.g., "Size: M, Color: Red"
    private int amount;
    private String status;
}
