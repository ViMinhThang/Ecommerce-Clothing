package com.ecommerce.backend.dto;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductRequest {
    private String name;
    private String description;
    private Long categoryId;
    private String variants;

    public List<ProductVariantRequest> getParsedVariants() {
        if (variants == null || variants.isEmpty()) {
            return new ArrayList<>();
        }
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readValue(variants, new TypeReference<List<ProductVariantRequest>>() {
            });
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse variants JSON: " + e.getMessage(), e);
        }
    }
}