package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.view.WishlistItemView;
import com.ecommerce.backend.service.FavoriteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/favorites")
@RequiredArgsConstructor
public class FavoriteController {

    private final FavoriteService favoriteService;

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<WishlistItemView>> getFavorites(@PathVariable Long userId) {
        List<WishlistItemView> favorites = favoriteService.getFavoritesByUserId(userId);
        return ResponseEntity.ok(favorites);
    }

    @PostMapping("/add")
    public ResponseEntity<WishlistItemView> addToFavorites(@RequestBody Map<String, Long> request) {
        Long userId = request.get("userId");
        Long productId = request.get("productId");

        if (userId == null || productId == null) {
            return ResponseEntity.badRequest().build();
        }

        WishlistItemView item = favoriteService.addToFavorites(userId, productId);
        return ResponseEntity.status(HttpStatus.CREATED).body(item);
    }

    @DeleteMapping("/user/{userId}/product/{productId}")
    public ResponseEntity<Void> removeFromFavorites(
            @PathVariable Long userId,
            @PathVariable Long productId) {
        favoriteService.removeFromFavorites(userId, productId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/user/{userId}/product/{productId}/check")
    public ResponseEntity<Map<String, Boolean>> isInFavorites(
            @PathVariable Long userId,
            @PathVariable Long productId) {
        boolean isInFavorites = favoriteService.isProductInFavorites(userId, productId);
        return ResponseEntity.ok(Map.of("isInFavorites", isInFavorites));
    }
}
