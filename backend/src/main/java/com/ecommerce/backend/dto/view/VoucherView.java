package com.ecommerce.backend.dto.view;

import com.ecommerce.backend.model.DiscountType;
import com.ecommerce.backend.model.VoucherStatus;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@Builder
public class VoucherView {
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
    private int usedCount;
    private VoucherStatus status;
    private LocalDateTime createdDate;
}
