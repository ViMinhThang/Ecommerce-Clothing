package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetailView {

    private Long id;
    private String buyerEmail;
    private double totalPrice;
    private String status;

    private List<OrderItemView> items;
}
