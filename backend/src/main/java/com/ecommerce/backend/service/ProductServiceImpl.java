package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.PriceRequest;
import com.ecommerce.backend.dto.ProductRequest;
import com.ecommerce.backend.dto.ProductVariantRequest;
import com.ecommerce.backend.dto.view.ProductSearchView;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.dto.view.ProductVariantView;
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
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ProductServiceImpl implements ProductService {

    private static final String UPLOAD_DIR = "./uploads/";
    private static final String IMAGE_BASE_URL = "http://10.0.2.2:8080/uploads/";

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductVariantRepository productVariantRepository;
    private final ProductVariantsRepository productVariantsRepository;
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final PriceRepository priceRepository;
    private final OrderItemRepository orderItemRepository;

    @Override
    public Page<Product> getAllProducts(Pageable pageable) {
        return productRepository.findAll(pageable);
    }

    @Override
    public Product getProductById(Long id) {
        return findProductOrThrow(id);
    }

    @Override
    public Product createProduct(ProductRequest request, List<MultipartFile> images) throws IOException {
        Product product = new Product();
        updateBasicFields(product, request);
        assignCategory(product, request.getCategoryId());
        handleMultipleImageUpload(product, images);
        createVariants(product, request.getParsedVariants());
        return productRepository.save(product);
    }

    @Override
    public Product updateProduct(Long id, ProductRequest request, List<MultipartFile> images,
            List<Long> existingImageIds) throws IOException {
        Product existingProduct = findProductOrThrow(id);
        updateBasicFields(existingProduct, request);
        assignCategory(existingProduct, request.getCategoryId());
        clearExistingVariants(existingProduct);
        updateImages(existingProduct, images, existingImageIds);
        createVariants(existingProduct, request.getParsedVariants());
        return productRepository.save(existingProduct);
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

    @Override
    public List<ProductSearchView> searchByName(String name) {
        return productRepository.searchByName(name);
    }

    @Override
    public List<ProductSearchView> searchByNameAndCategory(String name, long categoryId) {
        return productRepository.searchByNameAndCategory(name, categoryId);
    }

    @Override
    public List<ProductVariantView> getProductVariants(Long productId) {
        List<ProductVariants> variants = productVariantsRepository.findByProductId(productId);
        return variants.stream()
                .map(this::mapToProductVariantView)
                .toList();
    }

    // ==================== Private Helper Methods ====================

    private Product findProductOrThrow(Long id) {
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));
    }

    private void updateBasicFields(Product product, ProductRequest request) {
        product.setName(request.getName());
        product.setDescription(request.getDescription());
    }

    private void handleMultipleImageUpload(Product product, List<MultipartFile> images) throws IOException {
        if (images == null || images.isEmpty()) {
            return;
        }

        int displayOrder = product.getImages().size();
        boolean isFirst = product.getImages().isEmpty();

        for (MultipartFile image : images) {
            if (isValidImage(image)) {
                String imageUrl = saveImage(image);

                ProductImage productImage = new ProductImage();
                productImage.setImageUrl(imageUrl);
                productImage.setDisplayOrder(displayOrder++);
                productImage.setIsPrimary(isFirst);
                productImage.setProduct(product);

                product.getImages().add(productImage);
                isFirst = false;
            }
        }
    }

    private void updateImages(Product product, List<MultipartFile> newImages, List<Long> existingImageIds)
            throws IOException {
        // Remove images not in existingImageIds (user deleted them)
        if (existingImageIds != null) {
            product.getImages().removeIf(img -> !existingImageIds.contains(img.getId()));
        } else {
            // If no existing IDs provided, keep all existing images
        }

        // Add new images
        handleMultipleImageUpload(product, newImages);

        // Ensure at least one image is primary
        ensurePrimaryImage(product);

        // Reorder display order
        reorderImages(product);
    }

    private void ensurePrimaryImage(Product product) {
        if (product.getImages().isEmpty())
            return;

        boolean hasPrimary = product.getImages().stream().anyMatch(ProductImage::getIsPrimary);
        if (!hasPrimary) {
            product.getImages().get(0).setIsPrimary(true);
        }
    }

    private void reorderImages(Product product) {
        List<ProductImage> images = product.getImages();
        for (int i = 0; i < images.size(); i++) {
            images.get(i).setDisplayOrder(i);
        }
    }

    private boolean isValidImage(MultipartFile image) {
        return image != null && !image.isEmpty();
    }

    private void assignCategory(Product product, Long categoryId) {
        if (categoryId != null) {
            Category category = findCategoryOrThrow(categoryId);
            product.setCategory(category);
        }
    }

    private Category findCategoryOrThrow(Long categoryId) {
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + categoryId));
    }

    private void createVariants(Product product, List<ProductVariantRequest> variantRequests) {
        if (variantRequests == null || variantRequests.isEmpty()) {
            return;
        }

        for (ProductVariantRequest variantRequest : variantRequests) {
            ProductVariants variant = buildVariantFromRequest(product, variantRequest);
            product.getVariants().add(variant);
        }
    }

    private ProductVariants buildVariantFromRequest(Product product, ProductVariantRequest request) {
        ProductVariants variant = new ProductVariants();
        variant.setProduct(product);
        assignColor(variant, request.getColorId());
        assignSize(variant, request.getSizeId());
        assignPrice(variant, request.getPrice());
        return variant;
    }

    private void assignColor(ProductVariants variant, Long colorId) {
        if (colorId != null) {
            Color color = findColorOrThrow(colorId);
            variant.setColor(color);
        }
    }

    private Color findColorOrThrow(Long colorId) {
        return colorRepository.findById(colorId)
                .orElseThrow(() -> new EntityNotFoundException("Color not found with id: " + colorId));
    }

    private void assignSize(ProductVariants variant, Long sizeId) {
        if (sizeId != null) {
            Size size = findSizeOrThrow(sizeId);
            variant.setSize(size);
        }
    }

    private Size findSizeOrThrow(Long sizeId) {
        return sizeRepository.findById(sizeId)
                .orElseThrow(() -> new EntityNotFoundException("Size not found with id: " + sizeId));
    }

    private void assignPrice(ProductVariants variant, PriceRequest priceRequest) {
        if (priceRequest == null) {
            return;
        }

        Price price = buildPriceFromRequest(priceRequest);
        Price savedPrice = priceRepository.save(price);
        variant.setPrice(savedPrice);
    }

    private Price buildPriceFromRequest(PriceRequest request) {
        Price price = new Price();
        price.setBasePrice(request.getBasePrice());
        price.setSalePrice(calculateSalePrice(request));
        return price;
    }

    private Double calculateSalePrice(PriceRequest request) {
        return request.getSalePrice() != null
                ? request.getSalePrice()
                : request.getBasePrice();
    }

    private void clearExistingVariants(Product product) {
        // Soft-delete variants that are referenced by orders (set status to INACTIVE)
        // and only remove variants that are not referenced
        List<ProductVariants> variantsToKeep = new java.util.ArrayList<>();
        List<ProductVariants> variantsToRemove = new java.util.ArrayList<>();

        for (ProductVariants variant : product.getVariants()) {
            if (variant.getId() > 0 && isVariantReferencedByOrders(variant.getId())) {
                // This variant has orders - soft delete instead of hard delete
                variant.setStatus("INACTIVE");
                variantsToKeep.add(variant);
            } else {
                variantsToRemove.add(variant);
            }
        }

        // Remove only variants not referenced by orders
        product.getVariants().removeAll(variantsToRemove);
    }

    private boolean isVariantReferencedByOrders(Long variantId) {
        // Check if any order items reference this variant
        return orderItemRepository.existsByProductVariantsId(variantId);
    }

    private ProductView mapToProductView(Product product) {
        Optional<ProductVariants> firstVariant = product.getVariants().stream().findFirst();
        double basePrice = extractBasePrice(firstVariant);
        double salePrice = extractSalePrice(firstVariant);

        // Get all image URLs
        List<String> imageUrls = product.getImages().stream()
                .map(ProductImage::getImageUrl)
                .collect(Collectors.toList());

        return new ProductView(
                product.getId(),
                product.getName(),
                product.getPrimaryImageUrl(),
                imageUrls,
                basePrice,
                salePrice,
                product.getDescription());
    }

    private double extractBasePrice(Optional<ProductVariants> variant) {
        return variant
                .map(ProductVariants::getPrice)
                .map(Price::getBasePrice)
                .orElse(0.0);
    }

    private double extractSalePrice(Optional<ProductVariants> variant) {
        return variant
                .map(ProductVariants::getPrice)
                .map(Price::getSalePrice)
                .orElse(0.0);
    }

    private ProductVariantView mapToProductVariantView(ProductVariants variant) {
        ProductVariantView view = new ProductVariantView();
        view.setId(variant.getId());
        view.setStatus(variant.getStatus());

        if (variant.getColor() != null) {
            ProductVariantView.ColorInfo colorInfo = new ProductVariantView.ColorInfo();
            colorInfo.setId(variant.getColor().getId());
            colorInfo.setName(variant.getColor().getColorName());
            colorInfo.setHexCode(variant.getColor().getColorCode());
            view.setColor(colorInfo);
        }

        if (variant.getSize() != null) {
            ProductVariantView.SizeInfo sizeInfo = new ProductVariantView.SizeInfo();
            sizeInfo.setId(variant.getSize().getId());
            sizeInfo.setName(variant.getSize().getSizeName());
            view.setSize(sizeInfo);
        }

        if (variant.getPrice() != null) {
            ProductVariantView.PriceInfo priceInfo = new ProductVariantView.PriceInfo();
            priceInfo.setId(variant.getPrice().getId());
            priceInfo.setOriginalPrice(variant.getPrice().getBasePrice());
            priceInfo.setDiscountPrice(variant.getPrice().getSalePrice());
            view.setPrice(priceInfo);
        }

        return view;
    }

    private String saveImage(MultipartFile image) throws IOException {
        String newFilename = generateUniqueFilename(image);
        Path uploadPath = Paths.get(UPLOAD_DIR);

        // Create uploads directory if it doesn't exist
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path filePath = uploadPath.resolve(newFilename);
        Files.copy(image.getInputStream(), filePath);
        return IMAGE_BASE_URL + newFilename;
    }

    private String generateUniqueFilename(MultipartFile image) {
        String originalFilename = image.getOriginalFilename();
        String fileExtension = extractFileExtension(originalFilename);
        return UUID.randomUUID().toString() + fileExtension;
    }

    private String extractFileExtension(String filename) {
        return filename.substring(filename.lastIndexOf("."));
    }
}
