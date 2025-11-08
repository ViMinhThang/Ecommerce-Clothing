package com.ecommerce.backend.controller;

import com.ecommerce.backend.model.Color;
import com.ecommerce.backend.repository.ColorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/colors")
@RequiredArgsConstructor
public class ColorController {

    private final ColorRepository colorRepository;

    @GetMapping
    public List<Color> getAllColors() {
        return colorRepository.findAll();
    }
}
