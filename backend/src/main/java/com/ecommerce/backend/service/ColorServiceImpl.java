package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ColorDTO; // Import ColorDTO
import com.ecommerce.backend.model.Color;
import com.ecommerce.backend.repository.ColorRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ColorServiceImpl implements ColorService {

    private final ColorRepository colorRepository;

    @Override
    public List<Color> getAllColors() {
        return colorRepository.findAll();
    }

    @Override
    public Color getColorById(Long id) {
        return colorRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Color not found with id: " + id));
    }

    @Override
    public Color createColor(ColorDTO colorDTO) {
        Color color = new Color();
        color.setColorName(colorDTO.getColorName());
        color.setStatus(colorDTO.getStatus());
        return colorRepository.save(color);
    }

    @Override
    public Color updateColor(Long id, ColorDTO colorDTO) {
        Color existingColor = colorRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Color not found with id: " + id));
        existingColor.setColorName(colorDTO.getColorName());
        existingColor.setStatus(colorDTO.getStatus());
        return colorRepository.save(existingColor);
    }

    @Override
    public void deleteColor(Long id) {
        colorRepository.deleteById(id);
    }
}