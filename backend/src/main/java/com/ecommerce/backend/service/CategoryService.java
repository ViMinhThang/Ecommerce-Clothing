package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.CategoryDTO; // Import CategoryDTO
import com.ecommerce.backend.dto.CategoryView;
import com.ecommerce.backend.model.Category;
import org.springframework.data.domain.Page;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

public interface CategoryService {

    Page<Category> getAllCategories(int page, int size);

    Category getCategoryById(Long id);

    Category createCategory(CategoryDTO categoryDTO); // Changed parameter to CategoryDTO

    Category updateCategory(Long id, CategoryDTO categoryDTO); // Changed parameter to CategoryDTO

    void deleteCategory(Long id);

    String uploadCategoryImage(MultipartFile imageFile); // Added for image upload
}
