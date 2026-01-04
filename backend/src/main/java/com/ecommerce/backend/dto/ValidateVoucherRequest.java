package com.ecommerce.backend.dto;

import lombok.Data;

@Data
public class ValidateVoucherRequest {
    private String code;
    private double orderAmount;
}
