package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.CategoryDTO; // Import CategoryDTO
import com.ecommerce.backend.dto.CategoryView;
import com.ecommerce.backend.dto.ProductView;
import com.ecommerce.backend.model.Category;
import com.ecommerce.backend.repository.CategoryRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService {

    private final CategoryRepository categoryRepository;

    // Define the upload directory
    private final String UPLOAD_DIR = "uploads/categories/"; // Corrected to be a local path

    @Override
    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    @Override
    public Category getCategoryById(Long id) {
        return categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + id));
    }

    @Override
    public Category createCategory(CategoryDTO categoryDTO) { // Changed parameter to CategoryDTO
        Category category = new Category();
        category.setName(categoryDTO.getName());
        category.setDescription(categoryDTO.getDescription());
        category.setImageUrl(categoryDTO.getImageUrl());
        category.setStatus(categoryDTO.getStatus());
        return categoryRepository.save(category);
    }

    @Override
    public Category updateCategory(Long id, CategoryDTO categoryDTO) { // Changed parameter to CategoryDTO
        Category existingCategory = categoryRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + id));
        existingCategory.setName(categoryDTO.getName());
        existingCategory.setDescription(categoryDTO.getDescription());
        existingCategory.setImageUrl(categoryDTO.getImageUrl());
        existingCategory.setStatus(categoryDTO.getStatus());
        return categoryRepository.save(existingCategory);
    }

    @Override
    public void deleteCategory(Long id) {
        categoryRepository.deleteById(id);
    }

    @Override
    public String uploadCategoryImage(MultipartFile imageFile) {
        try {
            // Create the upload directory if it doesn't exist
            Path uploadPath = Paths.get(UPLOAD_DIR);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Generate a unique file name
            String fileName = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
            Path filePath = uploadPath.resolve(fileName);

            // Save the file
            Files.copy(imageFile.getInputStream(), filePath);

            // Return the URL/path to the saved image
            // Assuming the images are served from /uploads endpoint
            return "/uploads/categories/" + fileName;
        } catch (IOException e) {
            throw new RuntimeException("Failed to upload image", e);
        }
    }
}
