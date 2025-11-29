package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderItemView {

    private Long id;

    // tên sản phẩm / biến thể – tuỳ bạn muốn hiển thị thế nào
    private String productName;

    private String size;
    private String color;
    private String material;

    private String imageUrl;

    private double priceAtPurchase;
    private int quantity;
}