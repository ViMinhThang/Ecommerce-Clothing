package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.ProductView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.repository.FilterView;
import com.ecommerce.backend.repository.filter.ProductFilter;
import com.ecommerce.backend.service.ProductService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/filter")
@RequiredArgsConstructor
public class FilterController {
    private final ProductService productService;
    @PostMapping()
    public ResponseEntity<Page<ProductView>> filter(@RequestBody @Valid ProductFilter filter, Pageable pageable) {
        Page<ProductView> res = productService.filterProduct(filter,pageable);
        return response(res);
    }
    @PostMapping("/count")
    public ResponseEntity<Long> filterCount(@RequestBody ProductFilter filter) {
        return ResponseEntity.ok(productService.filterProductCount(filter));
    }
    @GetMapping("/{categoryId}")
    public ResponseEntity<FilterView> getFilterAttributes(@PathVariable Long categoryId) {
        var res = productService.getFilterAttributes(categoryId);
        return ResponseEntity.ok(res);
    }
    private ResponseEntity<Page<ProductView>> response(Page<ProductView> res){
        if(res.isEmpty()){
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(res);
    }
}
