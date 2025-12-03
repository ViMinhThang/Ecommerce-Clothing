package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailView {
    private String name;
    private String email;
    private LocalDate birthDay;
    private String status;
    private List<String> role;
    private int totalOrder;
    private double totalPrice;
}
