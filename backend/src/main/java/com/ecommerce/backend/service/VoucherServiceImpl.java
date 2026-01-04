package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ValidateVoucherRequest;
import com.ecommerce.backend.dto.ValidateVoucherResponse;
import com.ecommerce.backend.dto.VoucherDTO;
import com.ecommerce.backend.dto.view.VoucherView;
import com.ecommerce.backend.model.DiscountType;
import com.ecommerce.backend.model.Voucher;
import com.ecommerce.backend.model.VoucherStatus;
import com.ecommerce.backend.repository.VoucherRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class VoucherServiceImpl implements VoucherService {

    private final VoucherRepository voucherRepository;

    @Override
    public List<VoucherView> getAllVouchers() {
        return voucherRepository.findAll().stream()
                .map(this::toView)
                .collect(Collectors.toList());
    }

    @Override
    public VoucherView getVoucherById(Long id) {
        Voucher voucher = voucherRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));
        return toView(voucher);
    }

    @Override
    public VoucherView getVoucherByCode(String code) {
        Voucher voucher = voucherRepository.findByCode(code.toUpperCase())
                .orElseThrow(() -> new RuntimeException("Voucher not found"));
        return toView(voucher);
    }

    @Override
    @Transactional
    public VoucherView createVoucher(VoucherDTO dto) {
        if (voucherRepository.existsByCode(dto.getCode().toUpperCase())) {
            throw new RuntimeException("Voucher code already exists");
        }

        Voucher voucher = Voucher.builder()
                .code(dto.getCode().toUpperCase())
                .description(dto.getDescription())
                .discountType(dto.getDiscountType())
                .discountValue(dto.getDiscountValue())
                .minOrderAmount(dto.getMinOrderAmount())
                .maxDiscountAmount(dto.getMaxDiscountAmount())
                .startDate(dto.getStartDate())
                .endDate(dto.getEndDate())
                .usageLimit(dto.getUsageLimit())
                .usedCount(0)
                .status(dto.getStatus() != null ? dto.getStatus() : VoucherStatus.ACTIVE)
                .build();

        return toView(voucherRepository.save(voucher));
    }

    @Override
    @Transactional
    public VoucherView updateVoucher(Long id, VoucherDTO dto) {
        Voucher voucher = voucherRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));

        if (!voucher.getCode().equals(dto.getCode().toUpperCase())
                && voucherRepository.existsByCode(dto.getCode().toUpperCase())) {
            throw new RuntimeException("Voucher code already exists");
        }

        voucher.setCode(dto.getCode().toUpperCase());
        voucher.setDescription(dto.getDescription());
        voucher.setDiscountType(dto.getDiscountType());
        voucher.setDiscountValue(dto.getDiscountValue());
        voucher.setMinOrderAmount(dto.getMinOrderAmount());
        voucher.setMaxDiscountAmount(dto.getMaxDiscountAmount());
        voucher.setStartDate(dto.getStartDate());
        voucher.setEndDate(dto.getEndDate());
        voucher.setUsageLimit(dto.getUsageLimit());
        voucher.setStatus(dto.getStatus());

        return toView(voucherRepository.save(voucher));
    }

    @Override
    @Transactional
    public void deleteVoucher(Long id) {
        if (!voucherRepository.existsById(id)) {
            throw new RuntimeException("Voucher not found");
        }
        voucherRepository.deleteById(id);
    }

    @Override
    public ValidateVoucherResponse validateVoucher(ValidateVoucherRequest request) {
        try {
            Voucher voucher = voucherRepository.findByCode(request.getCode().toUpperCase())
                    .orElseThrow(() -> new RuntimeException("Invalid voucher code"));

            String validationError = validateVoucherRules(voucher, request.getOrderAmount());
            if (validationError != null) {
                return ValidateVoucherResponse.builder()
                        .valid(false)
                        .message(validationError)
                        .build();
            }

            double discountAmount = calculateDiscount(voucher, request.getOrderAmount());
            double finalPrice = request.getOrderAmount() - discountAmount;

            return ValidateVoucherResponse.builder()
                    .valid(true)
                    .message("Voucher applied successfully")
                    .voucherId(voucher.getId())
                    .code(voucher.getCode())
                    .discountType(voucher.getDiscountType())
                    .discountValue(voucher.getDiscountValue())
                    .discountAmount(discountAmount)
                    .finalPrice(finalPrice)
                    .build();

        } catch (RuntimeException e) {
            return ValidateVoucherResponse.builder()
                    .valid(false)
                    .message(e.getMessage())
                    .build();
        }
    }

    @Override
    public List<VoucherView> getActiveVouchers() {
        LocalDateTime now = LocalDateTime.now();
        return voucherRepository.findByStatus(VoucherStatus.ACTIVE).stream()
                .filter(v -> isVoucherValid(v, now))
                .map(this::toView)
                .collect(Collectors.toList());
    }

    @Override
    public Voucher applyVoucher(String code, double orderAmount) {
        if (code == null || code.trim().isEmpty()) {
            return null;
        }

        Voucher voucher = voucherRepository.findByCode(code.toUpperCase())
                .orElseThrow(() -> new RuntimeException("Invalid voucher code"));

        String validationError = validateVoucherRules(voucher, orderAmount);
        if (validationError != null) {
            throw new RuntimeException(validationError);
        }

        return voucher;
    }

    @Override
    @Transactional
    public void incrementUsedCount(Long voucherId) {
        Voucher voucher = voucherRepository.findById(voucherId)
                .orElseThrow(() -> new RuntimeException("Voucher not found"));
        voucher.setUsedCount(voucher.getUsedCount() + 1);

        if (voucher.getUsageLimit() > 0 && voucher.getUsedCount() >= voucher.getUsageLimit()) {
            voucher.setStatus(VoucherStatus.INACTIVE);
        }

        voucherRepository.save(voucher);
    }

    private String validateVoucherRules(Voucher voucher, double orderAmount) {
        LocalDateTime now = LocalDateTime.now();

        if (voucher.getStatus() != VoucherStatus.ACTIVE) {
            return "Voucher is not active";
        }

        if (voucher.getStartDate() != null && now.isBefore(voucher.getStartDate())) {
            return "Voucher is not yet valid";
        }

        if (voucher.getEndDate() != null && now.isAfter(voucher.getEndDate())) {
            return "Voucher has expired";
        }

        if (voucher.getUsageLimit() > 0 && voucher.getUsedCount() >= voucher.getUsageLimit()) {
            return "Voucher usage limit reached";
        }

        if (voucher.getMinOrderAmount() > 0 && orderAmount < voucher.getMinOrderAmount()) {
            return "Minimum order amount is $" + voucher.getMinOrderAmount();
        }

        return null;
    }

    private boolean isVoucherValid(Voucher voucher, LocalDateTime now) {
        if (voucher.getStartDate() != null && now.isBefore(voucher.getStartDate())) {
            return false;
        }
        if (voucher.getEndDate() != null && now.isAfter(voucher.getEndDate())) {
            return false;
        }
        if (voucher.getUsageLimit() > 0 && voucher.getUsedCount() >= voucher.getUsageLimit()) {
            return false;
        }
        return true;
    }

    public double calculateDiscount(Voucher voucher, double orderAmount) {
        double discount;

        if (voucher.getDiscountType() == DiscountType.PERCENTAGE) {
            discount = orderAmount * (voucher.getDiscountValue() / 100);
            if (voucher.getMaxDiscountAmount() > 0 && discount > voucher.getMaxDiscountAmount()) {
                discount = voucher.getMaxDiscountAmount();
            }
        } else {
            discount = voucher.getDiscountValue();
        }

        if (discount > orderAmount) {
            discount = orderAmount;
        }

        return Math.round(discount * 100.0) / 100.0;
    }

    private VoucherView toView(Voucher voucher) {
        return VoucherView.builder()
                .id(voucher.getId())
                .code(voucher.getCode())
                .description(voucher.getDescription())
                .discountType(voucher.getDiscountType())
                .discountValue(voucher.getDiscountValue())
                .minOrderAmount(voucher.getMinOrderAmount())
                .maxDiscountAmount(voucher.getMaxDiscountAmount())
                .startDate(voucher.getStartDate())
                .endDate(voucher.getEndDate())
                .usageLimit(voucher.getUsageLimit())
                .usedCount(voucher.getUsedCount())
                .status(voucher.getStatus())
                .createdDate(voucher.getCreatedDate())
                .build();
    }
}
