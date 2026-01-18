package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.CategoryDTO;
import com.ecommerce.backend.dto.view.CategoryView;
import com.ecommerce.backend.model.Category;
import com.ecommerce.backend.repository.CategoryRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

/**
 * Service implementation for Category operations.
 * Handles CRUD operations and image upload for categories.
 */
@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private static final String UPLOAD_DIR = "uploads/categories/";
    private static final String IMAGE_URL_PREFIX = "/uploads/categories/";
    private static final String FILE_NAME_SEPARATOR = "_";

    private final CategoryRepository categoryRepository;

    @Override
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public Category getCategoryById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Category ID cannot be null");
        }
        return findCategoryOrThrow(id);
    }

    @Override
    public Category createCategory(CategoryDTO categoryDTO) {
        Category category = buildCategoryFromDTO(new Category(), categoryDTO);
        if (category != null) {
            return categoryRepository.save(category);
        }
        throw new IllegalStateException("Failed to create category");
    }

    @Override
    public Category updateCategory(Long id, CategoryDTO categoryDTO) {
        Category existingCategory = findCategoryOrThrow(id);
        Category updatedCategory = buildCategoryFromDTO(existingCategory, categoryDTO);
        if (updatedCategory != null) {
            return categoryRepository.save(updatedCategory);
        }
        throw new IllegalStateException("Failed to update category");
    }

    @Override
    public void deleteCategory(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Category ID cannot be null");
        }
        categoryRepository.deleteById(id);
    }

    @Override
    public String uploadCategoryImage(MultipartFile imageFile) {
        try {
            ensureUploadDirectoryExists();
            String fileName = generateUniqueFileName(imageFile);
            return buildImageUrl(fileName);
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload category image", e);
        }
    }

    @Override
    public Page<Category> searchCategories(String name, Pageable pageable) {
        return categoryRepository.findByNameContainingIgnoreCase(name, pageable);
    }

    @Override
    public List<CategoryView> searchByName(String name) {
        return categoryRepository.searchByNameFTS(name);
    }

    // ==================== Private Helper Methods ====================

    private Category findCategoryOrThrow(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Category ID cannot be null");
        }
        return categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + id));
    }

    private Category buildCategoryFromDTO(Category category, CategoryDTO dto) {
        category.setName(dto.getName());
        category.setDescription(dto.getDescription());
        category.setImageUrl(dto.getImageUrl());
        category.setStatus(dto.getStatus());
        return category;
    }

    private void ensureUploadDirectoryExists() throws IOException {
        Path uploadPath = Paths.get(UPLOAD_DIR);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
    }

    private String generateUniqueFileName(MultipartFile imageFile) {
        String originalFilename = imageFile.getOriginalFilename();
        return UUID.randomUUID().toString() + FILE_NAME_SEPARATOR + originalFilename;
    }

    private String buildImageUrl(String fileName) {
        return IMAGE_URL_PREFIX + fileName;
    }
}
