package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.util.List;

@AllArgsConstructor
@Getter
@Setter
public class ProductView implements Serializable {
    private long Id;
    private String name;
    private String imageUrl; // Primary image URL
    private List<String> imageUrls; // All image URLs
    private double basePrice;
    private double salePrice;
    private String description;
}
