package com.ecommerce.backend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductVariantRequest {
    private Long id;
    private Long colorId;
    private Long sizeId;
    private PriceRequest price;
}
