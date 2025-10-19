package com.ecommerce.backend.product.controller;
import com.ecommerce.backend.config.AppConstants;
import com.ecommerce.backend.product.dtos.*;
import com.ecommerce.backend.product.service.VariantService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;

import java.util.Set;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class VariantController {

    private final VariantService variantService;

    @GetMapping("/public/variants/{productId}")
    public ResponseEntity<VariantResponse> getAllVariants(
            @PathVariable Long productId,
            @RequestParam(name = "pageNumber", defaultValue = AppConstants.PAGE_NUMBER, required = false) Integer pageNumber,
            @RequestParam(name = "pageSize", defaultValue = AppConstants.PAGE_SIZE, required = false) Integer pageSize,
            @RequestParam(name = "sortBy", defaultValue = AppConstants.SORT_CATEGORIES_BY, required = false) String sortBy,
            @RequestParam(name = "sortOrder", defaultValue = AppConstants.SORT_DIR, required = false) String sortOrder) {
        VariantResponse variantResponse = variantService.getAllVariants(productId,pageNumber, pageSize, sortBy, sortOrder);
        return new ResponseEntity<>(variantResponse, HttpStatus.OK);
    }

    @PostMapping("/admin/variants")
    public ResponseEntity<VariantDTO> createVariant(@Valid @RequestBody VariantDTO variantDTO){
        VariantDTO variant = variantService.createVariant(variantDTO);
        return new ResponseEntity<>(variant, HttpStatus.CREATED);
    }

    @Transactional
    @DeleteMapping("/admin/variants/{variantId}")
    public ResponseEntity<String> deleteVariant(@PathVariable Long variantId){
         variantService.deleteVariant(variantId);
        return new ResponseEntity<>("Deleted", HttpStatus.OK);
    }


    @PutMapping("/admin/variants/{variantId}")
    public ResponseEntity<VariantDTO> updateVariant(@Valid @RequestBody VariantDTO variantDTO,
                                                @PathVariable Long variantId){
        VariantDTO variant = variantService.updateVariant(variantDTO, variantId);

        return new ResponseEntity<>(variant, HttpStatus.OK);
    }
}