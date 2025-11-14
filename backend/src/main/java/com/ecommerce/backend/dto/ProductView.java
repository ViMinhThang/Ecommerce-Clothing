package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public class ProductView {
    private long Id;
    private String name;
    private String imageUrl;
    private double basePrice;
    private double salePrice;
    private String description;
}
