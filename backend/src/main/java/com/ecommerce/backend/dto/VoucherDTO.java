package com.ecommerce.backend.dto;

import com.ecommerce.backend.model.DiscountType;
import com.ecommerce.backend.model.VoucherStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class VoucherDTO {
    private Long id;
    private String code;
    private String description;
    private DiscountType discountType;
    private double discountValue;
    private double minOrderAmount;
    private double maxDiscountAmount;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private int usageLimit;
    private VoucherStatus status;
}
