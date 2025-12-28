package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class CartView {
    private Long id;
    private Long userId;
    private List<CartItemView> items;
    private double totalPrice;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CartItemView {
        private Long id;
        private Long variantId;
        private String productName;
        private String productImage;
        private String colorName;
        private String sizeName;
        private int quantity;
        private double price;
        private double subtotal;
    }
}
