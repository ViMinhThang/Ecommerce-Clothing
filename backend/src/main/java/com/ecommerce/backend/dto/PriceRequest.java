package com.ecommerce.backend.dto;

import lombok.Data;

@Data
public class PriceRequest {
    private Long id;
    private double basePrice;
    private Double salePrice;
}