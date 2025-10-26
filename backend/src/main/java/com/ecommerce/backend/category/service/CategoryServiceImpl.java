package com.ecommerce.backend.category.service;

import com.ecommerce.backend.category.dtos.CategoryDTO;
import com.ecommerce.backend.category.dtos.CategoryResponse;
import com.ecommerce.backend.category.entity.Category;
import com.ecommerce.backend.category.repositories.CategoryRepository;
import com.ecommerce.backend.exception.APIException;
import com.ecommerce.backend.exception.ResourceNotFoundException;
import com.ecommerce.backend.helper.PaginationHelper;
import com.ecommerce.backend.product.dtos.ColorDTO;
import com.ecommerce.backend.product.dtos.ColorResponse;
import com.ecommerce.backend.product.entity.Color;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoryServiceImpl implements CategoryService{

    private final CategoryRepository categoryRepository;
    private final ModelMapper modelMapper;
    private  final PaginationHelper paginationHelper;
    @Override
    public CategoryResponse getAllCategories(Integer pageNumber, Integer pageSize, String sortBy, String sortOrder) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize,
                sortOrder.equalsIgnoreCase("asc") ? Sort.by(sortBy).ascending() : Sort.by(sortBy).descending()
        );
        Page<Category> page = categoryRepository.findAll(pageable);

        return paginationHelper.getPaginatedResponse(
                page,
                CategoryDTO.class,
                list -> {
                    CategoryResponse response = new CategoryResponse();
                    response.setContent(list);
                    return response;
                },
                "No color created till now."
        );
    }

    @Override
    public CategoryDTO createCategory(CategoryDTO categoryDTO) {
        Category category = modelMapper.map(categoryDTO, Category.class);
        Category categoryFromDb = categoryRepository.findByCategoryName(category.getCategoryName());
        if (categoryFromDb != null)
            throw new APIException("Category with the name " + category.getCategoryName() + " already exists !!!");
        Category savedCategory = categoryRepository.save(category);
        return modelMapper.map(savedCategory, CategoryDTO.class);
    }

    @Override
    public CategoryDTO deleteCategory(Long categoryId) {
        Category category = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("Category","categoryId",categoryId));

        categoryRepository.delete(category);
        return modelMapper.map(category, CategoryDTO.class);
    }

    @Override
    public CategoryDTO updateCategory(CategoryDTO categoryDTO, Long categoryId) {
        Category savedCategory = categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("Category","categoryId",categoryId));

        Category category = modelMapper.map(categoryDTO, Category.class);
        category.setCategoryId(categoryId);
        savedCategory = categoryRepository.save(category);
        return modelMapper.map(savedCategory, CategoryDTO.class);
    }
}