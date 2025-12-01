package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.SizeDTO; // Import SizeDTO
import com.ecommerce.backend.model.Size;
import com.ecommerce.backend.service.SizeService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/sizes")
@RequiredArgsConstructor
public class SizeController {

    private final SizeService sizeService;

    @GetMapping
    public ResponseEntity<Page<Size>> getAllSizes(
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Size> sizes;
        
        if (name != null && !name.isEmpty()) {
            sizes = sizeService.searchSizes(name, pageable);
        } else {
            sizes = sizeService.getAllSizes().stream()
                    .collect(Collectors.collectingAndThen(
                            Collectors.toList(),
                            list -> new PageImpl<>(list, pageable, list.size())
                    ));
        }
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
