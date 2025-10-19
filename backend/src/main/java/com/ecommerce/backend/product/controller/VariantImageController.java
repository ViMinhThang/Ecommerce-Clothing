package com.ecommerce.backend.product.controller;

import com.ecommerce.backend.product.dtos.VariantImageDTO;
import com.ecommerce.backend.product.service.VariantImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/variants")
@RequiredArgsConstructor
public class VariantImageController {

    private final VariantImageService variantImageService;

    @PostMapping("/{variantId}/images")
    public VariantImageDTO addImage(@PathVariable Long variantId, @RequestParam String imageUrl) {
        return variantImageService.addImageToVariant(variantId, imageUrl);
    }

    @GetMapping("/{variantId}/images")
    public List<VariantImageDTO> getImages(@PathVariable Long variantId) {
        return variantImageService.getImagesByVariant(variantId);
    }
}