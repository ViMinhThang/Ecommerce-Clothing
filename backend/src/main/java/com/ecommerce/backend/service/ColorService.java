package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ColorDTO;
import com.ecommerce.backend.model.Color;
import org.springframework.data.domain.Page;

import java.util.List;

public interface ColorService {

    Page<Color> getAllColors(int page, int size);

    Color getColorById(Long id);

    Color createColor(ColorDTO colorDTO);

    Color updateColor(Long id, ColorDTO colorDTO);

    void deleteColor(Long id);
}