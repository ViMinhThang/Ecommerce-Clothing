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

@Service
@RequiredArgsConstructor
@Transactional
public class ProductServiceImpl implements ProductService {

    private static final String UPLOAD_DIR = "./uploads/products/";
    private static final String IMAGE_BASE_URL = "http://10.0.2.2:8080/uploads/products";

    private final ProductRepository productRepository;
    private final CategoryRepository categoryRepository;
    private final ProductVariantRepository productVariantRepository;
    private final ProductVariantsRepository productVariantsRepository;
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final PriceRepository priceRepository;

    @Override
    public Page<Product> getAllProducts(Pageable pageable) {
        if (pageable == null) {
            throw new IllegalArgumentException("Pageable cannot be null");
        }
        return productRepository.findAll(pageable);
    }

    @Override
    public Product getProductById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        return findProductOrThrow(id);
    }

    @Override
    @SuppressWarnings("null")
    public Product createProduct(ProductRequest request, List<MultipartFile> images) throws IOException {
        Product product = buildProductFromRequest(new Product(), request, images);
        return productRepository.save(product);
    }

    @Override
    @SuppressWarnings("null")
    public Product updateProduct(Long id, ProductRequest request, List<MultipartFile> images,
            List<Long> existingImageIds) throws IOException {
        Product existingProduct = findProductOrThrow(id);

        if (existingImageIds == null) {
            existingProduct.getImages().clear();
        } else {
            existingProduct.getImages().removeIf(img -> !existingImageIds.contains(img.getId()));
        }

        Product updatedProduct = buildProductFromRequest(existingProduct, request, images);
        return productRepository.save(updatedProduct);
    }

    @Override
    public void deleteProduct(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        productRepository.deleteById(id);
    }

    @Override
    @SuppressWarnings("null")
    public Page<ProductView> getProductsByCategory(long categoryId, String status, Pageable pageable) {
        if (categoryId == 0) {
            return productRepository.findAll(pageable).map(this::mapToProductView);
        }
        return productRepository.findByCategoryIdAndStatus(categoryId, status, pageable)
                .map(this::mapToProductView);
    }

    @Override
    public Page<ProductView> filterProduct(ProductFilter filter, Pageable pageable) {
        if (pageable == null) {
            throw new IllegalArgumentException("Pageable cannot be null");
        }
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

    @Override
    public List<ProductView> getAll() {
        return productRepository.findAll().stream().map(this::mapToProductView).toList();
    }

    @Override
    @SuppressWarnings("null")
    public List<ProductView> getByListId(List<Long> ids) {
        return productRepository.findAllById(ids).stream().map(this::mapToProductView).toList();
    }

    // ==================== Private Helper Methods ====================

    private Product findProductOrThrow(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Product ID cannot be null");
        }
        return productRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Product not found with id: " + id));
    }

    private Product buildProductFromRequest(Product product, ProductRequest request, List<MultipartFile> images)
            throws IOException {
        updateBasicFields(product, request);
        handleImagesUpload(product, images);
        assignCategory(product, request.getCategoryId());
        syncVariants(product, request.getParsedVariants());
        return product;
    }

    private void updateBasicFields(Product product, ProductRequest request) {
        product.setName(request.getName());
        product.setDescription(request.getDescription());
    }

    private void handleImagesUpload(Product product, List<MultipartFile> images) throws IOException {
        if (images != null && !images.isEmpty()) {
            int currentImageCount = product.getImages().size();
            for (int i = 0; i < images.size(); i++) {
                MultipartFile image = images.get(i);
                if (isValidImage(image)) {
                    String imageUrl = saveImage(image);
                    boolean isPrimary = (currentImageCount == 0 && i == 0);
                    ProductImage productImage = new ProductImage(imageUrl, currentImageCount + i, isPrimary, product);
                    product.getImages().add(productImage);
                }
            }
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
        if (categoryId == null) {
            throw new IllegalArgumentException("Category ID cannot be null");
        }
        return categoryRepository.findById(categoryId)
                .orElseThrow(() -> new EntityNotFoundException("Category not found with id: " + categoryId));
    }

    private void syncVariants(Product product, List<ProductVariantRequest> variantRequests) {
        if (variantRequests == null) {
            return;
        }

        List<ProductVariants> currentVariants = product.getVariants();
        List<Long> incomingIds = variantRequests.stream()
                .map(ProductVariantRequest::getId)
                .filter(id -> id != null)
                .toList();


        for (ProductVariants variant : currentVariants) {
            if (!incomingIds.contains(variant.getId())) {
                variant.setStatus("INACTIVE");
            }
        }

        for (ProductVariantRequest variantRequest : variantRequests) {
            if (variantRequest.getId() != null) {
                currentVariants.stream()
                        .filter(v -> v.getId() == variantRequest.getId())
                        .findFirst()
                        .ifPresent(v -> updateVariantFromRequest(v, variantRequest));
            } else {
                ProductVariants variant = buildVariantFromRequest(product, variantRequest);
                variant.setStatus("ACTIVE");
                product.getVariants().add(variant);
            }
        }
    }

    private void updateVariantFromRequest(ProductVariants variant, ProductVariantRequest request) {
        assignColor(variant, request.getColorId());
        assignSize(variant, request.getSizeId());
        updatePrice(variant, request.getPrice());
        variant.setStatus("ACTIVE");
    }

    private void updatePrice(ProductVariants variant, PriceRequest priceRequest) {
        if (priceRequest == null) {
            return;
        }

        if (variant.getPrice() != null) {
            Price price = variant.getPrice();
            price.setBasePrice(priceRequest.getBasePrice());
            price.setSalePrice(calculateSalePrice(priceRequest));
            priceRepository.save(price);
        } else {
            assignPrice(variant, priceRequest);
        }
    }

    private ProductVariants buildVariantFromRequest(Product product, ProductVariantRequest request) {
        ProductVariants variant = new ProductVariants();
        variant.setProduct(product);
        variant.setStatus("ACTIVE");
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
        if (colorId == null) {
            throw new IllegalArgumentException("Color ID cannot be null");
        }
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
        if (sizeId == null) {
            throw new IllegalArgumentException("Size ID cannot be null");
        }
        return sizeRepository.findById(sizeId)
                .orElseThrow(() -> new EntityNotFoundException("Size not found with id: " + sizeId));
    }

    private void assignPrice(ProductVariants variant, PriceRequest priceRequest) {
        if (priceRequest == null) {
            return;
        }

        Price price = buildPriceFromRequest(priceRequest);
        if (price != null) {
            Price savedPrice = priceRepository.save(price);
            variant.setPrice(savedPrice);
        }
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

    private ProductView mapToProductView(Product product) {
        Optional<ProductVariants> firstVariant = product.getVariants().stream().findFirst();
        double basePrice = extractBasePrice(firstVariant);
        double salePrice = extractSalePrice(firstVariant);

        return new ProductView(
                product.getId(),
                product.getName(),
                product.getPrimaryImageUrl(),
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
            colorInfo.setColorName(variant.getColor().getColorName());
            colorInfo.setColorCode(variant.getColor().getColorCode());
            colorInfo.setStatus(variant.getColor().getStatus());
            view.setColor(colorInfo);
        }

        if (variant.getSize() != null) {
            ProductVariantView.SizeInfo sizeInfo = new ProductVariantView.SizeInfo();
            sizeInfo.setId(variant.getSize().getId());
            sizeInfo.setSizeName(variant.getSize().getSizeName());
            sizeInfo.setStatus(variant.getSize().getStatus());
            view.setSize(sizeInfo);
        }

        if (variant.getPrice() != null) {
            ProductVariantView.PriceInfo priceInfo = new ProductVariantView.PriceInfo();
            priceInfo.setId(variant.getPrice().getId());
            priceInfo.setBasePrice(variant.getPrice().getBasePrice());
            priceInfo.setSalePrice(variant.getPrice().getSalePrice());
            view.setPrice(priceInfo);
        }

        return view;
    }

    private String saveImage(MultipartFile image) throws IOException {
        // Validate file extension for security
        String originalFilename = image.getOriginalFilename();
        if (originalFilename == null || !isAllowedImageExtension(originalFilename)) {
            throw new IllegalArgumentException("Invalid image file format. Only JPG, JPEG, PNG, and GIF are allowed.");
        }
        
        String newFilename = generateUniqueFilename(image);
        Path filePath = Paths.get(UPLOAD_DIR + newFilename);
        Files.createDirectories(filePath.getParent());
        Files.copy(image.getInputStream(), filePath);
        return IMAGE_BASE_URL + newFilename;
    }

    private boolean isAllowedImageExtension(String filename) {
        if (filename == null) return false;
        String extension = extractFileExtension(filename).toLowerCase();
        return extension.equals(".jpg") || extension.equals(".jpeg") || 
               extension.equals(".png") || extension.equals(".gif");
    }

    private String generateUniqueFilename(MultipartFile image) {
        String originalFilename = image.getOriginalFilename();
        String fileExtension = extractFileExtension(originalFilename);
        return UUID.randomUUID().toString() + fileExtension;
    }

    private String extractFileExtension(String filename) {
        if (filename == null || !filename.contains(".")) {
            return "";
        }
        int lastDotIndex = filename.lastIndexOf(".");
        if (lastDotIndex == -1 || lastDotIndex == filename.length() - 1) {
            return "";
        }
        return filename.substring(lastDotIndex);
    }
}
