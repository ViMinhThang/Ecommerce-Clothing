package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.CartDTO;
import com.ecommerce.backend.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/carts")
@RequiredArgsConstructor
public class CartController {
    private final CartService cartService;

    @GetMapping("/{userId}")
    public ResponseEntity<CartDTO> getCart(@PathVariable Long userId) {
        return ResponseEntity.ok(cartService.getCart(userId));
    }

    @PostMapping("/{userId}/items")
    public ResponseEntity<CartDTO> addToCart(
            @PathVariable Long userId,
            @RequestParam Long productVariantId,
            @RequestParam(defaultValue = "1") int quantity) {
        return new ResponseEntity<>(cartService.addToCart(userId, productVariantId, quantity), HttpStatus.CREATED);
    }

    @PutMapping("/{userId}/items/{productVariantId}")
    public ResponseEntity<CartDTO> updateCartItem(
            @PathVariable Long userId,
            @PathVariable Long productVariantId,
            @RequestParam int quantity) {
        return ResponseEntity.ok(cartService.updateCartItem(userId, productVariantId, quantity));
    }

    @DeleteMapping("/{userId}/items/{productVariantId}")
    public ResponseEntity<CartDTO> removeFromCart(
            @PathVariable Long userId,
            @PathVariable Long productVariantId) {
        return ResponseEntity.ok(cartService.removeFromCart(userId, productVariantId));
    }

    @DeleteMapping("/{userId}/clear")
    public ResponseEntity<Void> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }
}
