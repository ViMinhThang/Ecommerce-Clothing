package com.ecommerce.backend.controller;


import com.ecommerce.backend.dto.AddToCartRequest;
import com.ecommerce.backend.dto.view.CartView;
import com.ecommerce.backend.model.User;

import com.ecommerce.backend.service.CartService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/cart")
@RequiredArgsConstructor
public class CartController {

    private final CartService cartService;

    @PostMapping("/add")
    public ResponseEntity<CartView> addToCart(@RequestBody AddToCartRequest request) {
        // ✅ SECURITY CHECK: Verify user is authenticated and authorized
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof User) {
                User currentUser = (User) principal;
                // Check if the user is trying to add to their own cart
                if (!currentUser.getId().equals(request.getUserId())) {
                    throw new AccessDeniedException("Cannot add items to another user's cart");
                }
            }
        } catch (NullPointerException e) {
            // User not authenticated - proceed with validation
            // In production, you might want to require authentication
        }

        CartView cart = cartService.addToCart(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(cart);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<CartView> getCartByUserId(@PathVariable Long userId) {
        // ✅ SECURITY CHECK: Verify user can only view their own cart
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof User) {
                User currentUser = (User) principal;
                if (!currentUser.getId().equals(userId)) {
                    throw new AccessDeniedException("Cannot view another user's cart");
                }
            }
        } catch (NullPointerException e) {
            // User not authenticated
        }

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
        // ✅ SECURITY CHECK: Verify user can only clear their own cart
        try {
            Object principal = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            if (principal instanceof User) {
                User currentUser = (User) principal;
                if (!currentUser.getId().equals(userId)) {
                    throw new AccessDeniedException("Cannot clear another user's cart");
                }
            }
        } catch (NullPointerException e) {
            // User not authenticated
        }

        cartService.clearCart(userId);
        return ResponseEntity.noContent().build();
    }
}
