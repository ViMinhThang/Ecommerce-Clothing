package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.SizeDTO;
import com.ecommerce.backend.model.Size;
import org.springframework.data.domain.Page;

import java.util.List;

public interface SizeService {

    Page<Size> getAllSizes(int page, int size);

    Size getSizeById(Long id);

    Size createSize(SizeDTO sizeDTO);

    Size updateSize(Long id, SizeDTO sizeDTO);

    void deleteSize(Long id);
}