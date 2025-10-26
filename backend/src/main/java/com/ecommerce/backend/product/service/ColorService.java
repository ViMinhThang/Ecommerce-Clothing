package com.ecommerce.backend.product.service;

import com.ecommerce.backend.product.dtos.ColorDTO;
import com.ecommerce.backend.product.dtos.ColorResponse;
import jakarta.validation.Valid;

public interface ColorService {
    ColorResponse getAllColors(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder);

    ColorDTO createColor(@Valid ColorDTO colorDTO);

    ColorDTO deleteColor(Long colorId);

    ColorDTO updateColor(@Valid ColorDTO colorDTO, Long colorId);
}
