package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.view.WishlistItemView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.model.ProductFavorite;
import com.ecommerce.backend.model.User;
import com.ecommerce.backend.repository.ProductFavoriteRepository;
import com.ecommerce.backend.repository.ProductRepository;
import com.ecommerce.backend.repository.UserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class WishlistServiceImpl implements WishlistService {

    private final ProductFavoriteRepository productFavoriteRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    @Override
    public List<WishlistItemView> getWishlistByUserId(Long userId) {
        List<ProductFavorite> favorites = productFavoriteRepository.findByUserIdAndStatus(userId, "active");
        return favorites.stream()
                .map(this::mapToWishlistItemView)
                .collect(Collectors.toList());
    }

    @Override
    public WishlistItemView addToWishlist(Long userId, Long productId) {
        // Check if already exists
        if (productFavoriteRepository.existsByUserIdAndProductId(userId, productId)) {
            // Return existing item
            ProductFavorite existing = productFavoriteRepository
                    .findByUserIdAndProductId(userId, productId)
                    .orElseThrow();
            return mapToWishlistItemView(existing);
        }

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new EntityNotFoundException("Product not found"));

        ProductFavorite favorite = new ProductFavorite();
        favorite.setUser(user);
        favorite.setProduct(product);
        favorite.setStatus("active");

        ProductFavorite saved = productFavoriteRepository.save(favorite);
        return mapToWishlistItemView(saved);
    }

    @Override
    public void removeFromWishlist(Long userId, Long productId) {
        productFavoriteRepository.deleteByUserIdAndProductId(userId, productId);
    }

    @Override
    public boolean isProductInWishlist(Long userId, Long productId) {
        return productFavoriteRepository.existsByUserIdAndProductId(userId, productId);
    }

    private WishlistItemView mapToWishlistItemView(ProductFavorite favorite) {
        Product product = favorite.getProduct();

        // Get first image URL if available
        String imageUrl = null;
        if (product.getImages() != null && !product.getImages().isEmpty()) {
            imageUrl = product.getImages().get(0).getImageUrl();
        }

        // Get price from first variant if available
        Double basePrice = null;
        Double salePrice = null;
        if (product.getVariants() != null && !product.getVariants().isEmpty()) {
            var firstVariant = product.getVariants().get(0);
            if (firstVariant.getPrice() != null) {
                basePrice = firstVariant.getPrice().getBasePrice();
                salePrice = firstVariant.getPrice().getSalePrice();
            }
        }

        return WishlistItemView.builder()
                .id(favorite.getId())
                .productId(product.getId())
                .productName(product.getName())
                .productDescription(product.getDescription())
                .imageUrl(imageUrl)
                .basePrice(basePrice)
                .salePrice(salePrice)
                .categoryName(product.getCategory() != null ? product.getCategory().getName() : null)
                .addedAt(favorite.getCreatedDate())
                .build();
    }
}
