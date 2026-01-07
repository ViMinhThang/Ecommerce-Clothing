package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.WishlistDTO;
import com.ecommerce.backend.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/wishlists")
@RequiredArgsConstructor
public class WishlistController {
    private final WishlistService wishlistService;

    @GetMapping("/{userId}")
    public ResponseEntity<WishlistDTO> getWishlist(@PathVariable Long userId) {
        return ResponseEntity.ok(wishlistService.getWishlist(userId));
    }

    @PostMapping("/{userId}/items/{productId}")
    public ResponseEntity<WishlistDTO> addToWishlist(@PathVariable Long userId, @PathVariable Long productId) {
        return new ResponseEntity<>(wishlistService.addToWishlist(userId, productId), HttpStatus.CREATED);
    }

    @DeleteMapping("/{userId}/items/{productId}")
    public ResponseEntity<WishlistDTO> removeFromWishlist(@PathVariable Long userId, @PathVariable Long productId) {
        return ResponseEntity.ok(wishlistService.removeFromWishlist(userId, productId));
    }

    @DeleteMapping("/{userId}/clear")
    public ResponseEntity<Void> clearWishlist(@PathVariable Long userId) {
        wishlistService.clearWishlist(userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/{userId}/check/{productId}")
    public ResponseEntity<Boolean> isFavorite(@PathVariable Long userId, @PathVariable Long productId) {
        return ResponseEntity.ok(wishlistService.isFavorite(userId, productId));
    }
}
