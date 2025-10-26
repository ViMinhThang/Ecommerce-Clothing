package com.ecommerce.backend.product.controller;
import com.ecommerce.backend.config.AppConstants;
import com.ecommerce.backend.product.dtos.*;
import com.ecommerce.backend.product.entity.VariantImage;
import com.ecommerce.backend.product.service.VariantService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
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
    @GetMapping("/admin/variants/details")
    public ResponseEntity<VariantDetailResponse> getVariantDetails(@RequestParam Long productId,@RequestParam Long variantId){
        VariantDetailResponse variantDetailResponse = variantService.getVariantDetails(productId,variantId);
        return new ResponseEntity<>(variantDetailResponse, HttpStatus.OK);
    }

    @PutMapping("/admin/variants/update-variant-info")
    public ResponseEntity<VariantDTO> updateVariantInfo(@Valid @RequestBody VariantInfoRequest variantInfoRequest){
        VariantDTO variant = variantService.updateVariantInfo(variantInfoRequest);

        return new ResponseEntity<>(variant, HttpStatus.OK);
    }
    @PutMapping("/admin/variants/update-variant-stock")
    public ResponseEntity<String> updateVariantStock(@Valid @RequestBody QuantityRequest quantityRequest){
        String status= variantService.updateVariantStock(quantityRequest.getQuantity(),quantityRequest.getVariantId());

        return new ResponseEntity<>(status, HttpStatus.OK);
    }
    @PostMapping("/admin/variants/variant-images/upload")
    public ResponseEntity<VariantImageDTO> uploadVariantImage(@RequestParam("file") MultipartFile file, @RequestParam("variantId") Long variantId) throws IOException {

        VariantImageDTO image = variantService.uploadImages(file,variantId);
        return new ResponseEntity<>(image, HttpStatus.OK);
    }
    @DeleteMapping("/admin/variants/variant-images/{id}")
    public ResponseEntity<String> deleteImage(@PathVariable String id) throws IOException {

        String status = variantService.deleteImage(id);
        return new ResponseEntity<>(status, HttpStatus.OK);
    }
}