package com.ecommerce.backend.product.service;

import com.ecommerce.backend.category.dtos.CategoryDTO;
import com.ecommerce.backend.product.dtos.SizeDTO;
import com.ecommerce.backend.product.dtos.SizeResponse;
import jakarta.validation.Valid;

public interface SizeService {
    SizeResponse getAllSizes(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder);

    SizeDTO createSize(@Valid SizeDTO sizeDTO);

    SizeDTO deleteSize(Long sizeId);

    SizeDTO updateSize(@Valid SizeDTO sizeDTO, Long sizeId);
}
