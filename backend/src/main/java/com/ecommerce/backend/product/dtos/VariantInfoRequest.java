package com.ecommerce.backend.product.dtos;

import lombok.Data;

@Data
public class VariantInfoRequest {
    private Long variantId;
    private Double price;
    private String color;
    private String size;
    private String description;
    private String SKU;
}
