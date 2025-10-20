package com.ecommerce.backend.product.dtos;

import lombok.Data;

@Data
public class QuantityRequest {
    private int quantity;
    private String variantId;
}
