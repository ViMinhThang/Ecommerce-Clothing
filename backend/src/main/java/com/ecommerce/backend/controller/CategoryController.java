package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.CategoryDTO; // Import CategoryDTO
import com.ecommerce.backend.model.Category;
import com.ecommerce.backend.service.CategoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {

    private final CategoryService categoryService;

    @GetMapping
    public ResponseEntity<Page<Category>> getAllCategories(
            @RequestParam(required = false) String name,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<Category> categories;

        if (name != null && !name.isEmpty()) {
            categories = categoryService.searchCategories(name, pageable);
        } else {
            categories = categoryService.getAllCategories().stream()
                    .collect(Collectors.collectingAndThen(
                            Collectors.toList(),
                            list -> new PageImpl<>(list, pageable, list.size())));
        }
        return ResponseEntity.ok(categories);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Category> getCategoryById(@PathVariable Long id) {
        Category category = categoryService.getCategoryById(id);
        return ResponseEntity.ok(category);
    }

    @PostMapping
    public ResponseEntity<Category> createCategory(@RequestBody CategoryDTO categoryDTO) { // Changed parameter to
                                                                                           // CategoryDTO
        Category createdCategory = categoryService.createCategory(categoryDTO);
        return new ResponseEntity<>(createdCategory, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Category> updateCategory(@PathVariable Long id, @RequestBody CategoryDTO categoryDTO) { // Changed
                                                                                                                  // parameter
                                                                                                                  // to
                                                                                                                  // CategoryDTO
        Category updatedCategory = categoryService.updateCategory(id, categoryDTO);
        return ResponseEntity.ok(updatedCategory);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCategory(@PathVariable Long id) {
        categoryService.deleteCategory(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping("/upload/category-image")
    public ResponseEntity<String> uploadCategoryImage(@RequestParam("image") MultipartFile imageFile) {
        String imageUrl = categoryService.uploadCategoryImage(imageFile);
        return ResponseEntity.ok(imageUrl);
    }
}
