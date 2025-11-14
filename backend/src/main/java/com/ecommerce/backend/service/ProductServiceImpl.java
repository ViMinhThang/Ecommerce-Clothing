package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.PriceRequest;
import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.ProductVariantRequest;
import com.ecommerce.backend.dto.ProductView;
import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
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
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final PriceRepository priceRepository;
    private final String UPLOAD_DIR = "./uploads/";

    @Override
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Override
    public Product getProductById(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));
    }

    @Override
    public Product createProduct(ProductRequest request, MultipartFile image) throws IOException {
        // 1. Create product with basic fields
        Product product = new Product();
        product.setName(request.getName());
        product.setDescription(request.getDescription());

        // 2. Handle image upload with null check
        if (image != null && !image.isEmpty()) {
            try {
                String imageUrl = saveImage(image);
                product.setImageUrl(imageUrl);
            } catch (IOException e) {
                throw new RuntimeException("Failed to save product image", e);
            }
        }

        if (request.getCategoryId() != null) {
            Category category = categoryRepository.findById(request.getCategoryId())
                    .orElseThrow(() -> new EntityNotFoundException(
                            "Category not found with id: " + request.getCategoryId()));
            product.setCategory(category);
        }

        List<ProductVariantRequest> variantRequests = request.getParsedVariants();
        if (variantRequests != null && !variantRequests.isEmpty()) {
            for (ProductVariantRequest variantRequest : variantRequests) {
                ProductVariants variant = new ProductVariants();
                variant.setProduct(product);

                // 5. Map color (with null check)
                if (variantRequest.getColorId() != null) {
                    Color color = colorRepository.findById(variantRequest.getColorId())
                            .orElseThrow(() -> new EntityNotFoundException(
                                    "Color not found with id: " + variantRequest.getColorId()));
                    variant.setColor(color);
                }

                if (variantRequest.getSizeId() != null) {
                    Size size = sizeRepository.findById(variantRequest.getSizeId())
                            .orElseThrow(() -> new EntityNotFoundException(
                                    "Size not found with id: " + variantRequest.getSizeId()));
                    variant.setSize(size);
                }

                if (variantRequest.getPrice() != null) {
                    PriceRequest priceReq = variantRequest.getPrice();
                    Price price = new Price();
                    price.setBasePrice(priceReq.getBasePrice());
                    price.setSalePrice(priceReq.getSalePrice() != null ?
                            priceReq.getSalePrice() : priceReq.getBasePrice());
                    price = priceRepository.save(price);
                    variant.setPrice(price);
                }

                product.getVariants().add(variant);
            }
        }

        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductRequest request, MultipartFile image) throws IOException {
        Product existingProduct = productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));

        existingProduct.setName(request.getName());
        existingProduct.setDescription(request.getDescription());

        if (image != null && !image.isEmpty()) {
            String imageUrl = saveImage(image);
            existingProduct.setImageUrl(imageUrl);
        }

        if (request.getCategoryId() != null) {
            Category category = categoryRepository.findById(request.getCategoryId())
                    .orElseThrow(() -> new EntityNotFoundException("Category not found"));
            existingProduct.setCategory(category);
        }

        existingProduct.getVariants().clear();
        List<ProductVariantRequest> variantRequests = request.getParsedVariants();

        if (variantRequests != null && !variantRequests.isEmpty()) {
            for (ProductVariantRequest variantRequest : variantRequests) {
                ProductVariants variant = new ProductVariants();
                variant.setProduct(existingProduct);

                if (variantRequest.getColorId() != null) {
                    Color color = colorRepository.findById(variantRequest.getColorId())
                            .orElseThrow(() -> new EntityNotFoundException("Color not found"));
                    variant.setColor(color);
                }

                if (variantRequest.getSizeId() != null) {
                    Size size = sizeRepository.findById(variantRequest.getSizeId())
                            .orElseThrow(() -> new EntityNotFoundException("Size not found"));
                    variant.setSize(size);
                }

                Price price = new Price();
                price.setBasePrice(variantRequest.getPrice().getBasePrice());
                price.setSalePrice(variantRequest.getPrice().getSalePrice());
                priceRepository.save(price);
                variant.setPrice(price);

                existingProduct.getVariants().add(variant);
            }
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
        Category category = new Category();
        category.setId(categoryId);
        product.setCategory(category); // Search by category id

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

    @Override
    public Page<Product> searchProducts(String name, Pageable pageable) {
        return productRepository.findByNameContaining(name, pageable);
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
