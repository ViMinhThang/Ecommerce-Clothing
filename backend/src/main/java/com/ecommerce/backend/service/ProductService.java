package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.model.Product;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface ProductService {

    List<Product> getAllProducts();

    Product getProductById(Long id);

    Product createProduct(ProductRequest productRequest, MultipartFile image) throws IOException;

    Product updateProduct(Long id, ProductRequest productRequest, MultipartFile image) throws IOException;

    void deleteProduct(Long id);
}
