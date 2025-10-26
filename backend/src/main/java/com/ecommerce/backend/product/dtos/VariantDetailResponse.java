package com.ecommerce.backend.product.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class VariantDetailResponse {
    private Long productId;
    private String productName;
    private VariantDTO content;
    private List<VariantDTO> variants;
}
