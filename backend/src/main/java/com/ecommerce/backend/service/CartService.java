package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.AddToCartRequest;
import com.ecommerce.backend.dto.view.CartView;

public interface CartService {
    CartView addToCart(AddToCartRequest request);

    CartView getCartByUserId(Long userId);

    void removeFromCart(Long cartItemId);

    void updateCartItemQuantity(Long cartItemId, int quantity);

    void clearCart(Long userId);
}
