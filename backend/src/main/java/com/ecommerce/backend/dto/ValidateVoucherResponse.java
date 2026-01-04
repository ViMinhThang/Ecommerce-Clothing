package com.ecommerce.backend.dto;

import com.ecommerce.backend.model.DiscountType;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ValidateVoucherResponse {
    private boolean valid;
    private String message;
    private Long voucherId;
    private String code;
    private DiscountType discountType;
    private double discountValue;
    private double discountAmount;
    private double finalPrice;
}
