package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.view.ProductSearchView;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {

    private final ProductService productService;

    @GetMapping
    public Page<Product> getAllProducts(@RequestParam(required = false) String name, Pageable pageable) {
        if (name != null && !name.isEmpty()) {
            return productService.searchProducts(name, pageable);
        }
        return productService.getAllProducts(pageable);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id);
        return ResponseEntity.ok(product);
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Product> createProduct(
            @ModelAttribute ProductRequest productRequest,
            @RequestParam(value = "images", required = false) List<MultipartFile> images) throws IOException {
        System.out.println(productRequest.toString());
        Product createdProduct = productService.createProduct(productRequest, images);
        return new ResponseEntity<>(createdProduct, HttpStatus.CREATED);
    }

    @PutMapping(value = "/{id}", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Product> updateProduct(
            @PathVariable Long id,
            @ModelAttribute ProductRequest productRequest,
            @RequestParam(value = "images", required = false) List<MultipartFile> images,
            @RequestParam(value = "existingImageIds", required = false) List<Long> existingImageIds) {
        try {
            System.out.println("Received request for product: " + id);
            Product updatedProduct = productService.updateProduct(id, productRequest, images, existingImageIds);
            return ResponseEntity.ok(updatedProduct);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.badRequest().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{categoryId}/{pageIndex}/{pageSize}")
    public ResponseEntity<Page<ProductView>> getProductByCategory(@PathVariable Long categoryId,
            @PathVariable int pageIndex, @PathVariable int pageSize) {
        Pageable pageable = PageRequest.of(pageIndex, pageSize);
        Page<ProductView> res = productService.getProductsByCategory(categoryId, "active", pageable);
        return response(res);
    }

    @GetMapping("/searchByName")
    public ResponseEntity<List<ProductSearchView>> searchByName(@RequestParam("name") String name) {
        return ResponseEntity.ok(productService.searchByName(name));
    }

    @GetMapping("/searchByNameAndCategory")
    public ResponseEntity<List<ProductSearchView>> searchByNameAndCategory(@RequestParam("name") String name,
            @RequestParam("categoryId") long categoryId) {
        return ResponseEntity.ok(productService.searchByNameAndCategory(name, categoryId));
    }

    private ResponseEntity<Page<ProductView>> response(Page<ProductView> res) {
        if (res.isEmpty()) {
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(res);
    }
}
