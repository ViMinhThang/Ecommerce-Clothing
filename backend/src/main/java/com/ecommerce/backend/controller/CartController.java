package com.ecommerce.backend.controller;

import com.ecommerce.backend.dto.AddToCartRequest;
import com.ecommerce.backend.dto.view.CartView;
import com.ecommerce.backend.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @PostMapping("/add")
    public ResponseEntity<CartView> addToCart(@RequestBody AddToCartRequest request) {
        CartView cart = cartService.addToCart(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(cart);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<CartView> getCartByUserId(@PathVariable Long userId) {
        CartView cart = cartService.getCartByUserId(userId);
        return ResponseEntity.ok(cart);
    }

    @DeleteMapping("/item/{cartItemId}")
    public ResponseEntity<Void> removeFromCart(@PathVariable Long cartItemId) {
        cartService.removeFromCart(cartItemId);
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/item/{cartItemId}/quantity")
    public ResponseEntity<Void> updateQuantity(
            @PathVariable Long cartItemId,
            @RequestParam int quantity) {
        cartService.updateCartItemQuantity(cartItemId, quantity);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/user/{userId}/clear")
    public ResponseEntity<Void> clearCart(@PathVariable Long userId) {
        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }
}
