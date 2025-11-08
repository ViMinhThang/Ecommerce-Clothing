package com.ecommerce.backend.controller;

import com.ecommerce.backend.model.Size;
import com.ecommerce.backend.repository.SizeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/sizes")
@RequiredArgsConstructor
public class SizeController {

    private final SizeRepository sizeRepository;

    @GetMapping
    public List<Size> getAllSizes() {
        return sizeRepository.findAll();
    }
}
