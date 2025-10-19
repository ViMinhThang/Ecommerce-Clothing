package com.ecommerce.backend.product.service;

import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.helper.PaginationHelper;
import com.ecommerce.backend.product.dtos.VariantDTO;
import com.ecommerce.backend.product.dtos.VariantImageDTO;
import com.ecommerce.backend.product.dtos.VariantResponse;
import com.ecommerce.backend.product.entity.Variant;
import com.ecommerce.backend.product.entity.VariantImage;
import com.ecommerce.backend.product.repositories.VariantImageRepository;
import com.ecommerce.backend.product.repositories.VariantRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class VariantServiceImpl implements VariantService {

    private final VariantRepository variantRepository;
    private final VariantImageService variantImageService;
    private final ModelMapper modelMapper;
    private final PaginationHelper paginationHelper;

    @Override
    public VariantResponse getAllVariants(Long productId, Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        return null;
    }

    @Override
    public VariantDTO createVariant(VariantDTO variantDTO) {
        return null;
    }

    @Transactional
    @Override
    public void deleteVariant(Long variantId) {
        Variant variant = variantRepository.findById(variantId)
                .orElseThrow(() -> new ResourceNotFoundException("Variant", "variantId", variantId));
        variant.getImages().forEach(image->variantImageService.deletImage(modelMapper.map(image, VariantImageDTO.class)));
        variantRepository.delete(variantId);
    }

    @Override
    public VariantDTO updateVariant(VariantDTO variantDTO, Long variantId) {
        return null;
    }
}
