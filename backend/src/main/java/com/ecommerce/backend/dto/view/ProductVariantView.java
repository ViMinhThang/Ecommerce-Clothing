package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ProductVariantView {
    private Long id;
    private ColorInfo color;
    private SizeInfo size;
    private PriceInfo price;
    private String status;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ColorInfo {
        private Long id;
        private String colorName;
        private String colorCode;
        private String status;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SizeInfo {
        private Long id;
        private String sizeName;
        private String status;
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class PriceInfo {
        private Long id;
        private Double basePrice;
        private Double salePrice;
    }
}
