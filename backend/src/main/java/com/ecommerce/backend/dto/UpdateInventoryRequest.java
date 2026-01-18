package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateInventoryRequest {
    private Long storeId;
    private Long productVariantId;
    private int amount;
    private String operation; // "set", "add", "subtract"
}
