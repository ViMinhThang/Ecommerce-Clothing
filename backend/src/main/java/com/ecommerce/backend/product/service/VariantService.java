package com.ecommerce.backend.product.service;

import com.ecommerce.backend.product.dtos.VariantDTO;
import com.ecommerce.backend.product.dtos.VariantResponse;
import jakarta.validation.Valid;
import org.springframework.transaction.annotation.Transactional;

public interface VariantService {
    VariantResponse getAllVariants(Long productId, Integer pageNumber, Integer pageSize, String sortBy, String sortOrder);

    VariantDTO createVariant(@Valid VariantDTO variantDTO);

    @Transactional
    void deleteVariant(Long variantId);

    VariantDTO updateVariant(@Valid VariantDTO variantDTO, Long variantId);
}
