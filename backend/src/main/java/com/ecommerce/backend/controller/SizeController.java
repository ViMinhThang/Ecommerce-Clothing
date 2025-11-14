package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.SizeDTO; // Import SizeDTO
import com.ecommerce.backend.model.Size;
import com.ecommerce.backend.service.SizeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/sizes")
@RequiredArgsConstructor
public class SizeController {

    private final SizeService sizeService;

    @GetMapping
    public ResponseEntity<List<Size>> getAllSizes() {
        List<Size> sizes = sizeService.getAllSizes();
        return ResponseEntity.ok(sizes);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Size> getSizeById(@PathVariable Long id) {
        Size size = sizeService.getSizeById(id);
        return ResponseEntity.ok(size);
    }

    @PostMapping
    public ResponseEntity<Size> createSize(@RequestBody SizeDTO sizeDTO) { // Changed parameter to SizeDTO
        Size createdSize = sizeService.createSize(sizeDTO);
        return new ResponseEntity<>(createdSize, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Size> updateSize(@PathVariable Long id, @RequestBody SizeDTO sizeDTO) { // Changed parameter to SizeDTO
        Size updatedSize = sizeService.updateSize(id, sizeDTO);
        return ResponseEntity.ok(updatedSize);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSize(@PathVariable Long id) {
        sizeService.deleteSize(id);
        return ResponseEntity.noContent().build();
    }
}
