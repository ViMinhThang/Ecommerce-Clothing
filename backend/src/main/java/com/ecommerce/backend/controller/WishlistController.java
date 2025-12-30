package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.view.WishlistItemView;
import com.ecommerce.backend.service.WishlistService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/wishlist")
@RequiredArgsConstructor
public class WishlistController {

    private final WishlistService wishlistService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<WishlistItemView>> getWishlist(@PathVariable Long userId) {
        List<WishlistItemView> wishlist = wishlistService.getWishlistByUserId(userId);
        return ResponseEntity.ok(wishlist);
    }

    @PostMapping("/add")
    public ResponseEntity<WishlistItemView> addToWishlist(@RequestBody Map<String, Long> request) {
        Long userId = request.get("userId");
        Long productId = request.get("productId");

        if (userId == null || productId == null) {
            return ResponseEntity.badRequest().build();
        }

        WishlistItemView item = wishlistService.addToWishlist(userId, productId);
        return ResponseEntity.status(HttpStatus.CREATED).body(item);
    }

    @DeleteMapping("/user/{userId}/product/{productId}")
    public ResponseEntity<Void> removeFromWishlist(
            @PathVariable Long userId,
            @PathVariable Long productId) {
        wishlistService.removeFromWishlist(userId, productId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}/product/{productId}/check")
    public ResponseEntity<Map<String, Boolean>> isInWishlist(
            @PathVariable Long userId,
            @PathVariable Long productId) {
        boolean isInWishlist = wishlistService.isProductInWishlist(userId, productId);
        return ResponseEntity.ok(Map.of("isInWishlist", isInWishlist));
    }
}
