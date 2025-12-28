package com.ecommerce.backend.dto.view;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class OrderStatistics {
    private int totalOrderByDay;
    private double totalPriceByDay;
    private int totalOrderByWeek;
    private double totalPriceByWeek;
    private int totalOrderByMonth;
    private double totalPriceByMonth;
}
