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
    private long id;
    private String name;
    private String imageUrl; // Primary image URL
    private double basePrice;
    private double salePrice;
    private String description;
}
