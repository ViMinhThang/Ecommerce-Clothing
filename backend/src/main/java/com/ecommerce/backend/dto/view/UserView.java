package com.ecommerce.backend.dto.view;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserView {
    private String email;
    private String status;
    private String role;
    private double totalBuy;
    private int amountBuy;
}
