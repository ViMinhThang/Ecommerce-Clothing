package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.WishlistDTO;
import com.ecommerce.backend.dto.WishlistItemDTO;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.model.User;
import com.ecommerce.backend.model.Wishlist;
import com.ecommerce.backend.model.WishlistItem;
import com.ecommerce.backend.repository.ProductRepository;
import com.ecommerce.backend.repository.UserRepository;
import com.ecommerce.backend.repository.WishlistItemRepository;
import com.ecommerce.backend.repository.WishlistRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class WishlistService {
    private final WishlistRepository wishlistRepository;
    private final WishlistItemRepository wishlistItemRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;

    public WishlistDTO getWishlist(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Wishlist wishlist = wishlistRepository.findByUserId(userId)
                .orElseGet(() -> createWishlistForUser(user));
        
        return convertToDTO(wishlist);
    }

    private Wishlist createWishlistForUser(User user) {
        Wishlist wishlist = new Wishlist();
        wishlist.setUser(user);
        wishlist.setCreatedDate(LocalDateTime.now());
        return wishlistRepository.save(wishlist);
    }

    public WishlistDTO addToWishlist(Long userId, Long productId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new RuntimeException("Product not found"));
        
        Wishlist wishlist = wishlistRepository.findByUserId(userId)
                .orElseGet(() -> createWishlistForUser(user));
        
        // Check if product already in wishlist
        boolean exists = wishlist.getItems().stream()
                .anyMatch(item -> item.getProduct().getId() == productId);
        
        if (!exists) {
            WishlistItem item = new WishlistItem();
            item.setWishlist(wishlist);
            item.setProduct(product);
            item.setProductName(product.getName());
            item.setProductImage(product.getImageUrl());
            item.setPrice(product.getVariants().isEmpty() ? 0.0 : 
                    product.getVariants().get(0).getPrice().getBasePrice());
            
            wishlist.getItems().add(item);
            wishlist.setUpdatedDate(LocalDateTime.now());
        }
        
        wishlistRepository.save(wishlist);
        return convertToDTO(wishlist);
    }

    public WishlistDTO removeFromWishlist(Long userId, Long productId) {
        Wishlist wishlist = wishlistRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Wishlist not found"));
        
        WishlistItem item = wishlistItemRepository.findByWishlistIdAndProductId(wishlist.getId(), productId)
                .orElseThrow(() -> new RuntimeException("Item not in wishlist"));
        
        wishlist.getItems().remove(item);
        wishlistItemRepository.delete(item);
        wishlist.setUpdatedDate(LocalDateTime.now());
        wishlistRepository.save(wishlist);
        
        return convertToDTO(wishlist);
    }

    public void clearWishlist(Long userId) {
        Wishlist wishlist = wishlistRepository.findByUserId(userId)
                .orElseThrow(() -> new RuntimeException("Wishlist not found"));
        
        wishlistItemRepository.deleteAll(wishlist.getItems());
        wishlist.getItems().clear();
        wishlist.setUpdatedDate(LocalDateTime.now());
        wishlistRepository.save(wishlist);
    }

    public boolean isFavorite(Long userId, Long productId) {
        Wishlist wishlist = wishlistRepository.findByUserId(userId)
                .orElse(null);
        
        if (wishlist == null) return false;
        
        return wishlist.getItems().stream()
                .anyMatch(item -> item.getProduct().getId() == productId);
    }

    private WishlistDTO convertToDTO(Wishlist wishlist) {
        List<WishlistItemDTO> itemDTOs = wishlist.getItems().stream()
                .map(item -> new WishlistItemDTO(
                        item.getId(),
                        item.getProduct().getId(),
                        item.getProductName(),
                        item.getProductImage(),
                        item.getPrice()
                ))
                .collect(Collectors.toList());
        
        return new WishlistDTO(
                wishlist.getId(),
                wishlist.getUser().getId(),
                itemDTOs,
                itemDTOs.size()
        );
    }
}
