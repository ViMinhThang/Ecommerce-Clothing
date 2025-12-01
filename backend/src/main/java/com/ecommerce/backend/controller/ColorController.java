package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.ColorDTO;
import com.ecommerce.backend.model.Color;
import com.ecommerce.backend.service.ColorService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/colors")
@RequiredArgsConstructor
public class ColorController {

    private final ColorService colorService;

    @GetMapping
    public ResponseEntity<List<Color>> getAllColors(
            @RequestParam(required = false) String name) {
        List<Color> colors;

        if (name != null && !name.isEmpty()) {
            colors = colorService.searchColors(name, Pageable.unpaged()).getContent();
        } else {
            colors = colorService.getAllColors();
        }
        return ResponseEntity.ok(colors);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Color> getColorById(@PathVariable Long id) {
        Color color = colorService.getColorById(id);
        return ResponseEntity.ok(color);
    }

    @PostMapping
    public ResponseEntity<Color> createColor(@RequestBody ColorDTO colorDTO) {
        Color createdColor = colorService.createColor(colorDTO);
        return new ResponseEntity<>(createdColor, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Color> updateColor(@PathVariable Long id, @RequestBody ColorDTO colorDTO) {
        Color updatedColor = colorService.updateColor(id, colorDTO);
        return ResponseEntity.ok(updatedColor);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteColor(@PathVariable Long id) {
        colorService.deleteColor(id);
        return ResponseEntity.noContent().build();
    }
}
