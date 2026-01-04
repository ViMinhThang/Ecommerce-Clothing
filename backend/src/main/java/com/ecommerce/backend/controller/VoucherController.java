package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.ValidateVoucherRequest;
import com.ecommerce.backend.dto.ValidateVoucherResponse;
import com.ecommerce.backend.dto.VoucherDTO;
import com.ecommerce.backend.dto.view.VoucherView;
import com.ecommerce.backend.service.VoucherService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/vouchers")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class VoucherController {

    private final VoucherService voucherService;

    @GetMapping
    public ResponseEntity<List<VoucherView>> getAllVouchers() {
        return ResponseEntity.ok(voucherService.getAllVouchers());
    }

    @GetMapping("/{id}")
    public ResponseEntity<VoucherView> getVoucherById(@PathVariable Long id) {
        return ResponseEntity.ok(voucherService.getVoucherById(id));
    }

    @GetMapping("/code/{code}")
    public ResponseEntity<VoucherView> getVoucherByCode(@PathVariable String code) {
        return ResponseEntity.ok(voucherService.getVoucherByCode(code));
    }

    @PostMapping
    public ResponseEntity<VoucherView> createVoucher(@RequestBody VoucherDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(voucherService.createVoucher(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<VoucherView> updateVoucher(
            @PathVariable Long id,
            @RequestBody VoucherDTO dto) {
        return ResponseEntity.ok(voucherService.updateVoucher(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteVoucher(@PathVariable Long id) {
        voucherService.deleteVoucher(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/validate")
    public ResponseEntity<ValidateVoucherResponse> validateVoucher(
            @RequestBody ValidateVoucherRequest request) {
        return ResponseEntity.ok(voucherService.validateVoucher(request));
    }

    @GetMapping("/active")
    public ResponseEntity<List<VoucherView>> getActiveVouchers() {
        return ResponseEntity.ok(voucherService.getActiveVouchers());
    }
}
