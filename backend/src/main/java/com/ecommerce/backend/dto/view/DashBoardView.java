package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DashBoardView {
    private double totalRevenue;
    private long totalOrder;
    private long totalProduct;
    private long totalUser;
}
