package com.ecommerce.backend.product.service;

import com.ecommerce.backend.product.dtos.VariantImageDTO;

import java.util.List;

public interface VariantImageService {
    public VariantImageDTO addImageToVariant(Long variantId, String imageUrl);

    public List<VariantImageDTO> getImagesByVariant(Long variantId);
}
