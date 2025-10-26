package com.ecommerce.backend.product.service;

import com.ecommerce.backend.product.dtos.*;
import jakarta.validation.Valid;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface VariantService {
    VariantResponse getAllVariants(Long productId, Integer pageNumber, Integer pageSize, String sortBy, String sortOrder);

    VariantDTO createVariant(@Valid VariantDTO variantDTO);

    @Transactional
    void deleteVariant(Long variantId);

    VariantDTO updateVariant(@Valid VariantDTO variantDTO, Long variantId);

    VariantDetailResponse getVariantDetails(Long productId, Long variantId);

    VariantDTO updateVariantInfo(@Valid VariantInfoRequest variantInfoRequest);

    String updateVariantStock(@Valid Integer quantity, @Valid String variantId);

    VariantImageDTO uploadImages(MultipartFile file, Long variantId) throws IOException;

    String deleteImage(String id);
}
