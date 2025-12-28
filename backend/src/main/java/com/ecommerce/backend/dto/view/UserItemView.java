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

public class UserItemView {
    private long id;
    private String name;
    private String status;
    private List<String> role;
    private int totalOrder;
    private double totalPrice;
}
