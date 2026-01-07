package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class OrderDetailView {
    private Long id;
    private String buyerEmail;
    private double totalPrice;
    private double discountAmount;
    private double finalPrice;
    private String status;
    private LocalDateTime createdDate;
    private String voucherCode;
    private List<OrderItemView> items;
}
