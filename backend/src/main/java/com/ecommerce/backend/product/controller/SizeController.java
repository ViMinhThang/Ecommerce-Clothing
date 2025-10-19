package com.ecommerce.backend.product.controller;

import com.ecommerce.backend.category.dtos.CategoryDTO;
import com.ecommerce.backend.category.dtos.CategoryResponse;
import com.ecommerce.backend.category.service.CategoryService;
import com.ecommerce.backend.config.AppConstants;
import com.ecommerce.backend.product.dtos.SizeDTO;
import com.ecommerce.backend.product.dtos.SizeResponse;
import com.ecommerce.backend.product.service.SizeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
@RequiredArgsConstructor
public class SizeController {

    private SizeService sizeService;

    @GetMapping("/public/sizes")
    public ResponseEntity<SizeResponse> getAllSizes(
            @RequestParam(name = "pageNumber", defaultValue = AppConstants.PAGE_NUMBER, required = false) Integer pageNumber,
            @RequestParam(name = "pageSize", defaultValue = AppConstants.PAGE_SIZE, required = false) Integer pageSize,
            @RequestParam(name = "sortBy", defaultValue = AppConstants.SORT_CATEGORIES_BY, required = false) String sortBy,
            @RequestParam(name = "sortOrder", defaultValue = AppConstants.SORT_DIR, required = false) String sortOrder) {
        SizeResponse sizeResponse = sizeService.getAllSizes(pageNumber, pageSize, sortBy, sortOrder);
        return new ResponseEntity<>(sizeResponse, HttpStatus.OK);
    }

    @PostMapping("/admin/sizes")
    public ResponseEntity<SizeDTO> createSize(@Valid @RequestBody SizeDTO sizeDTO){
        SizeDTO size = sizeService.createSize(sizeDTO);
        return new ResponseEntity<>(size, HttpStatus.CREATED);
    }

    @DeleteMapping("/admin/sizes/{sizeId}")
    public ResponseEntity<SizeDTO> deleteSizes(@PathVariable Long sizeId){
        SizeDTO deletedSize = sizeService.deleteSize(sizeId);
        return new ResponseEntity<>(deletedSize, HttpStatus.OK);
    }


    @PutMapping("/admin/sizes/{sizeId}")
    public ResponseEntity<SizeDTO> updateSizes(@Valid @RequestBody SizeDTO sizeDTO,
                                                      @PathVariable Long sizeId){
        SizeDTO savedSized = sizeService.updateSize(sizeDTO, sizeId);
        return new ResponseEntity<>(savedSized, HttpStatus.OK);
    }
}