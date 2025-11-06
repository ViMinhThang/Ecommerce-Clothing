package com.ecommerce.backend.dto;

import com.ecommerce.backend.model.Category;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductRequest {
    private Long id;
    private String name;
    private String description;
    private double price;
    private Long categoryId;
}
