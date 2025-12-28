package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ColorDTO; // Import ColorDTO
import com.ecommerce.backend.model.Color;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ColorService {

    List<Color> getAllColors();

    Color getColorById(Long id);

    Color createColor(ColorDTO colorDTO);

    Color updateColor(Long id, ColorDTO colorDTO);

    void deleteColor(Long id);

    Page<Color> searchColors(String name, Pageable pageable);
}