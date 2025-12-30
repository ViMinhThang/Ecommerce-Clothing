package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.SizeDTO; // Import SizeDTO
import com.ecommerce.backend.model.Size;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface SizeService {

    List<Size> getAllSizes();

    Size getSizeById(Long id);

    Size createSize(SizeDTO sizeDTO);

    Size updateSize(Long id, SizeDTO sizeDTO);

    void deleteSize(Long id);

    Page<Size> searchSizes(String name, Pageable pageable);
}