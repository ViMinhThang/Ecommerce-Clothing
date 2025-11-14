package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.ProductView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.repository.filter.ProductFilter;
import com.ecommerce.backend.response.APIResponse;
import com.ecommerce.backend.service.ProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
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
    public List<Product> getAllProducts() {
        return productService.getAllProducts();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getProductById(@PathVariable Long id) {
        Product product = productService.getProductById(id);
        return ResponseEntity.ok(product);
    }


    @PostMapping
    public ResponseEntity<Product> createProduct(@ModelAttribute ProductRequest productRequest, @RequestParam(value = "image", required = false) MultipartFile image) throws IOException {
        Product createdProduct = productService.createProduct(productRequest, image);
        return new ResponseEntity<>(createdProduct, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> updateProduct(@PathVariable Long id, @ModelAttribute ProductRequest productRequest, @RequestParam(value = "image", required = false) MultipartFile image) throws IOException {
        Product updatedProduct = productService.updateProduct(id, productRequest, image);
        return ResponseEntity.ok(updatedProduct);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProduct(@PathVariable Long id) {
        productService.deleteProduct(id);
        return ResponseEntity.noContent().build();
    }
    @GetMapping("/{categoryId}/{pageIndex}/{pageSize}")
    public ResponseEntity<APIResponse<Page<ProductView>>> getProductByCategory(@PathVariable Long id, @PathVariable int pageIndex, @PathVariable int pageSize) {
        Pageable pageable =  PageRequest.of(pageIndex,pageSize);
        Page<ProductView> res = productService.getProductsByCategory(id,"active", pageable);
        return response(res);
    }
    // /api/products/filter?sizes=S&sizes=M&colors=RED&page=0&size=10
    @GetMapping("/filter")
    public ResponseEntity<APIResponse<Page<ProductView>>> filter(ProductFilter filter, Pageable pageable) {
        Page<ProductView> res = productService.filterProduct(filter,pageable );
        return response(res);
    }
    @GetMapping("/filter/count")
    public ResponseEntity<APIResponse<Long>> filterCount(ProductFilter filter) {
        return ResponseEntity.ok(new APIResponse<>("Success"
                , productService.filterProductCount(filter), true));
    }
    private ResponseEntity<APIResponse<Page<ProductView>>> response(Page<ProductView> res){
        if(res.isEmpty()){
            return ResponseEntity.badRequest().body(new APIResponse<>("List is empty", null, false));
        }
        return ResponseEntity.ok(new APIResponse<>("Success", res, true));
    }
}
