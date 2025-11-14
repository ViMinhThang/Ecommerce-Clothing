package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.ProductView;
import com.ecommerce.backend.model.Category;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.model.ProductVariants;
import com.ecommerce.backend.repository.CategoryRepository;
import com.ecommerce.backend.repository.ProductRepository;
import com.ecommerce.backend.repository.ProductVariantRepository;
import com.ecommerce.backend.repository.filter.ProductFilter;
import com.ecommerce.backend.repository.filter.ProductSpecifications;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Example;
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

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductVariantRepository productVariantRepository;
    private final String UPLOAD_DIR = "./uploads/";

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));
    }

    @Override
    public Product createProduct(ProductRequest productRequest, MultipartFile image) throws IOException {
        Product product = new Product();
        product.setName(productRequest.getName());
        product.setDescription(productRequest.getDescription());
//        product.setBasePrice(productRequest.getPrice());

        if (image != null && !image.isEmpty()) {
            String imageUrl = saveImage(image);
            product.setImageUrl(imageUrl);
        }

        if (productRequest.getCategoryId() != null) {
            Category category = categoryRepository.findById(productRequest.getCategoryId())
                    .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + productRequest.getCategoryId()));
            product.setCategory(category);
        }

        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductRequest productRequest, MultipartFile image) throws IOException {
        Product existingProduct = productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));

        existingProduct.setName(productRequest.getName());
        existingProduct.setDescription(productRequest.getDescription());
//        existingProduct.setBasePrice(productRequest.getPrice());

        if (image != null && !image.isEmpty()) {
            String imageUrl = saveImage(image);
            existingProduct.setImageUrl(imageUrl);
        }

        if (productRequest.getCategoryId() != null) {
            Category category = categoryRepository.findById(productRequest.getCategoryId())
                    .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + productRequest.getCategoryId()));
            existingProduct.setCategory(category);
        }

        return productRepository.save(existingProduct);
    }

    @Override
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    @Override
    public Page<ProductView> getProductsByCategory(long categoryId, String status, Pageable pageable) {
        ProductVariants productVariants = new ProductVariants();
        // create product
        Product product = new Product();
        product.setStatus(status);          // set status "active" to avoid get product has deleted
        product.setCategory(new Category(categoryId,null, null)); // Search by category id

        productVariants.setProduct(product);
        Example<ProductVariants> example = Example.of(productVariants); // create Example

        return productVariantRepository.findBy(example
                , p -> p.page(pageable))
                .map(x ->
                        new ProductView(x.getProduct().getId(),x.getProduct().getName(),
                                x.getProduct().getImageUrl(), x.getPrice().getBasePrice(),
                                x.getPrice().getSalePrice(),x.getProduct().getDescription()));
    }

    @Override
    public Page<ProductView> filterProduct(ProductFilter filter, Pageable pageable) {
        return productVariantRepository.findAll(ProductSpecifications.build(filter), pageable)
                .map(x ->
                new ProductView(x.getProduct().getId(),x.getProduct().getName(),
                        x.getProduct().getImageUrl(), x.getPrice().getBasePrice(),
                        x.getPrice().getSalePrice(),x.getProduct().getDescription()));
    }

    @Override
    public Long filterProductCount(ProductFilter filter) {
        return productVariantRepository.count(ProductSpecifications.build(filter));

    }

    private String saveImage(MultipartFile image) throws IOException {
        String originalFilename = image.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String newFilename = UUID.randomUUID().toString() + fileExtension;
        Path filePath = Paths.get(UPLOAD_DIR + newFilename);
        Files.copy(image.getInputStream(), filePath);
        return "http://10.0.2.2:8080/uploads/" + newFilename;
    }
}
