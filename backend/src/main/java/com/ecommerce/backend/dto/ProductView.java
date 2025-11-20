package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

@AllArgsConstructor
@Getter
@Setter
public class ProductView implements Serializable {
    private long Id;
    private String name;
    private String imageUrl;
    private double basePrice;
    private double salePrice;
    private String description;
}
