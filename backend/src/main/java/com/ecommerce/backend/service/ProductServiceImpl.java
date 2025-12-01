package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.PriceRequest;
import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.ProductVariantRequest;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import com.ecommerce.backend.repository.filter.ProductFilter;
import com.ecommerce.backend.repository.filter.ProductSpecifications;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Service implementation for Product operations.
 * Handles CRUD operations, filtering, and image upload for products.
 */
@Service
@RequiredArgsConstructor
@Transactional
public class ProductServiceImpl implements ProductService {

    private static final String UPLOAD_DIR = "./uploads/";
    private static final String IMAGE_BASE_URL = "http://10.0.2.2:8080/uploads/products/";

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductVariantRepository productVariantRepository;
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final PriceRepository priceRepository;

    @Override
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Override
    public Product getProductById(Long id) {
        return findProductOrThrow(id);
    }

    @Override
    public Product createProduct(ProductRequest request, MultipartFile image) throws IOException {
        Product product = buildProductFromRequest(new Product(), request, image);
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductRequest request, MultipartFile image) throws IOException {
        Product existingProduct = findProductOrThrow(id);
        clearExistingVariants(existingProduct);
        Product updatedProduct = buildProductFromRequest(existingProduct, request, image);
        return productRepository.save(updatedProduct);
    }

    @Override
    public void deleteProduct(Long id) {
        productRepository.deleteById(id);
    }

    @Override
    public Page<ProductView> getProductsByCategory(long categoryId, String status, Pageable pageable) {
        return productRepository.findByCategoryIdAndStatus(categoryId, status, pageable)
                .map(this::mapToProductView);
    }

    @Override
    public Page<ProductView> filterProduct(ProductFilter filter, Pageable pageable) {
        return productRepository.findAll(ProductSpecifications.build(filter), pageable)
                .map(this::mapToProductView);
    }

    @Override
    public Long filterProductCount(ProductFilter filter) {
        return productRepository.count(ProductSpecifications.build(filter));
    }

    @Override
    public Page<Product> searchProducts(String name, Pageable pageable) {
        return productRepository.findByNameContainingIgnoreCase(name, pageable);
    }

    @Override
    public FilterView getFilterAttributes(long categoryId) {
        return productVariantRepository.findFilterAttributesByCategory(categoryId);
    }

    // ==================== Private Helper Methods ====================

    /**
     * Finds a product by ID or throws EntityNotFoundException
     */
    private Product findProductOrThrow(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));
    }

    /**
     * Builds a Product entity from the request, handling all related entities
     */
    private Product buildProductFromRequest(Product product, ProductRequest request, MultipartFile image)
            throws IOException {
        updateBasicFields(product, request);
        handleImageUpload(product, image);
        assignCategory(product, request.getCategoryId());
        createVariants(product, request.getParsedVariants());
        return product;
    }

    /**
     * Updates product's basic fields (name, description)
     */
    private void updateBasicFields(Product product, ProductRequest request) {
        product.setName(request.getName());
        product.setDescription(request.getDescription());
    }

    /**
     * Handles image upload and updates product's imageUrl
     */
    private void handleImageUpload(Product product, MultipartFile image) throws IOException {
        if (isValidImage(image)) {
            String imageUrl = saveImage(image);
            product.setImageUrl(imageUrl);
        }
    }

    /**
     * Checks if the provided image is valid for upload
     */
    private boolean isValidImage(MultipartFile image) {
        return image != null && !image.isEmpty();
    }

    /**
     * Assigns a category to the product if categoryId is provided
     */
    private void assignCategory(Product product, Long categoryId) {
        if (categoryId != null) {
            Category category = findCategoryOrThrow(categoryId);
            product.setCategory(category);
        }
    }

    /**
     * Finds a category by ID or throws EntityNotFoundException
     */
    private Category findCategoryOrThrow(Long categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + categoryId));
    }

    /**
     * Creates and adds variants to the product
     */
    private void createVariants(Product product, List<ProductVariantRequest> variantRequests) {
        if (variantRequests == null || variantRequests.isEmpty()) {
            return;
        }

        for (ProductVariantRequest variantRequest : variantRequests) {
            ProductVariants variant = buildVariantFromRequest(product, variantRequest);
            product.getVariants().add(variant);
        }
    }

    /**
     * Builds a single ProductVariant from the request
     */
    private ProductVariants buildVariantFromRequest(Product product, ProductVariantRequest request) {
        ProductVariants variant = new ProductVariants();
        variant.setProduct(product);
        assignColor(variant, request.getColorId());
        assignSize(variant, request.getSizeId());
        assignPrice(variant, request.getPrice());
        return variant;
    }

    /**
     * Assigns a color to the variant if colorId is provided
     */
    private void assignColor(ProductVariants variant, Long colorId) {
        if (colorId != null) {
            Color color = findColorOrThrow(colorId);
            variant.setColor(color);
        }
    }

    /**
     * Finds a color by ID or throws EntityNotFoundException
     */
    private Color findColorOrThrow(Long colorId) {
        return colorRepository.findById(colorId)
                .orElseThrow(() -> new EntityNotFoundException("Color not found with id: " + colorId));
    }

    /**
     * Assigns a size to the variant if sizeId is provided
     */
    private void assignSize(ProductVariants variant, Long sizeId) {
        if (sizeId != null) {
            Size size = findSizeOrThrow(sizeId);
            variant.setSize(size);
        }
    }

    /**
     * Finds a size by ID or throws EntityNotFoundException
     */
    private Size findSizeOrThrow(Long sizeId) {
        return sizeRepository.findById(sizeId)
                .orElseThrow(() -> new EntityNotFoundException("Size not found with id: " + sizeId));
    }

    /**
     * Creates and assigns a price to the variant
     */
    private void assignPrice(ProductVariants variant, PriceRequest priceRequest) {
        if (priceRequest == null) {
            return;
        }

        Price price = buildPriceFromRequest(priceRequest);
        Price savedPrice = priceRepository.save(price);
        variant.setPrice(savedPrice);
    }

    /**
     * Builds a Price entity from the request
     */
    private Price buildPriceFromRequest(PriceRequest request) {
        Price price = new Price();
        price.setBasePrice(request.getBasePrice());
        price.setSalePrice(calculateSalePrice(request));
        return price;
    }

    /**
     * Calculates sale price, defaulting to base price if not provided
     */
    private Double calculateSalePrice(PriceRequest request) {
        return request.getSalePrice() != null
                ? request.getSalePrice()
                : request.getBasePrice();
    }

    /**
     * Clears existing variants before update
     */
    private void clearExistingVariants(Product product) {
        product.getVariants().clear();
    }

    /**
     * Maps a Product entity to ProductView DTO
     */
    private ProductView mapToProductView(Product product) {
        Optional<ProductVariants> firstVariant = product.getVariants().stream().findFirst();
        double basePrice = extractBasePrice(firstVariant);
        double salePrice = extractSalePrice(firstVariant);

        return new ProductView(
                product.getId(),
                product.getName(),
                product.getImageUrl(),
                basePrice,
                salePrice,
                product.getDescription());
    }

    /**
     * Extracts base price from variant, defaults to 0.0
     */
    private double extractBasePrice(Optional<ProductVariants> variant) {
        return variant
                .map(ProductVariants::getPrice)
                .map(Price::getBasePrice)
                .orElse(0.0);
    }

    /**
     * Extracts sale price from variant, defaults to 0.0
     */
    private double extractSalePrice(Optional<ProductVariants> variant) {
        return variant
                .map(ProductVariants::getPrice)
                .map(Price::getSalePrice)
                .orElse(0.0);
    }

    /**
     * Saves an image file and returns the URL
     */
    private String saveImage(MultipartFile image) throws IOException {
        String newFilename = generateUniqueFilename(image);
        Path filePath = Paths.get(UPLOAD_DIR + newFilename);
        Files.copy(image.getInputStream(), filePath);
        return IMAGE_BASE_URL + newFilename;
    }

    /**
     * Generates a unique filename for uploaded images
     */
    private String generateUniqueFilename(MultipartFile image) {
        String originalFilename = image.getOriginalFilename();
        String fileExtension = extractFileExtension(originalFilename);
        return UUID.randomUUID().toString() + fileExtension;
    }

    /**
     * Extracts file extension from filename
     */
    private String extractFileExtension(String filename) {
        return filename.substring(filename.lastIndexOf("."));
    }
}
