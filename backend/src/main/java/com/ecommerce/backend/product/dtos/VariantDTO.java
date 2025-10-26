package com.ecommerce.backend.product.dtos;

import lombok.Data;

import java.util.List;

@Data
public class VariantDTO {
    private Long variantId;
    private Double price;
    private Integer quantity;
    private String description;
    private String SKU;
    private SizeDTO size;
    private ColorDTO color;

    private List<VariantImageDTO> images;
}