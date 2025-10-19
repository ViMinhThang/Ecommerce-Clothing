package com.ecommerce.backend.product.service;

import com.ecommerce.backend.helper.PaginationHelper;
import com.ecommerce.backend.product.dtos.VariantDTO;
import com.ecommerce.backend.product.dtos.VariantResponse;
import com.ecommerce.backend.product.repositories.VariantRepository;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class VariantServiceImpl implements VariantService {

    private final VariantRepository variantRepository;
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

    @Override
    public VariantDTO deleteVariant(Long variantId) {
        return null;
    }

    @Override
    public VariantDTO updateVariant(VariantDTO variantDTO, Long variantId) {
        return null;
    }
}
