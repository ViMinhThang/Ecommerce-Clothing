package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ValidateVoucherRequest;
import com.ecommerce.backend.dto.ValidateVoucherResponse;
import com.ecommerce.backend.dto.VoucherDTO;
import com.ecommerce.backend.dto.view.VoucherView;
import com.ecommerce.backend.model.Voucher;

import java.util.List;

public interface VoucherService {

    List<VoucherView> getAllVouchers();

    VoucherView getVoucherById(Long id);

    VoucherView getVoucherByCode(String code);

    VoucherView createVoucher(VoucherDTO dto);

    VoucherView updateVoucher(Long id, VoucherDTO dto);

    void deleteVoucher(Long id);

    ValidateVoucherResponse validateVoucher(ValidateVoucherRequest request);

    List<VoucherView> getActiveVouchers();

    Voucher applyVoucher(String code, double orderAmount);

    void incrementUsedCount(Long voucherId);
}
