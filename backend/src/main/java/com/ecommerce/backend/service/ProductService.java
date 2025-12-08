package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.view.ProductSearchView;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.repository.FilterView;
import com.ecommerce.backend.repository.filter.ProductFilter;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface ProductService {

    Page<Product> getAllProducts(Pageable pageable);

    Product getProductById(Long id);

    Product createProduct(ProductRequest productRequest, MultipartFile image) throws IOException;

    Product updateProduct(Long id, ProductRequest productRequest, MultipartFile image) throws IOException;

    void deleteProduct(Long id);
    // Get Product of specifying Category
    Page<ProductView> getProductsByCategory(long categoryId, String status, Pageable pageable);
    // Get Product when filter success
    Page<ProductView> filterProduct(ProductFilter filter, Pageable pageable);
    // Count amount product when user filter
    Long filterProductCount(ProductFilter filter);

    Page<Product> searchProducts(String name, Pageable pageable);

    FilterView getFilterAttributes(long categoryId);
    List<ProductSearchView> searchByName(String name);
    List<ProductSearchView> searchByNameAndCategory(String name, long categoryId);
}
