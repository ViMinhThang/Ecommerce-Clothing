package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.AddToCartRequest;
import com.ecommerce.backend.dto.view.CartView;
import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class CartServiceImpl implements CartService {

    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final ProductVariantsRepository productVariantsRepository;
    private final UserRepository userRepository;
    private final InventoryService inventoryService;

    @Override
    @SuppressWarnings("null")
    public CartView addToCart(AddToCartRequest request) {
        //  VALIDATION 1: Check quantity is valid
        if (request.getQuantity() <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }

        // Find or create cart for user
        Cart cart = cartRepository.findByUserId(request.getUserId());
        if (cart == null) {
            cart = new Cart();
            if (request.getUserId() == null) {
                throw new IllegalArgumentException("User ID cannot be null");
            }
            User user = userRepository.findById(request.getUserId())
                    .orElseThrow(() -> new EntityNotFoundException("User not found"));
            cart.setUser(user);
            cart.setCartItems(new ArrayList<>());
            cart = cartRepository.save(cart);
        }

        // Find product variant
        if (request.getVariantId() == null) {
            throw new IllegalArgumentException("Variant ID cannot be null");
        }
        ProductVariants variant = productVariantsRepository.findById(request.getVariantId())
                .orElseThrow(() -> new EntityNotFoundException("Product variant not found"));

        //  VALIDATION 2: Check variant status is active
        if (variant.getStatus() == null || !variant.getStatus().equalsIgnoreCase("active")) {
            throw new IllegalArgumentException("Product variant is not available for purchase");
        }

        // Check if item already exists in cart
        CartItem existingItem = cart.getCartItems().stream()
                .filter(item -> item.getProductVariants().getId() == request.getVariantId())
                .findFirst()
                .orElse(null);

        int requestedQuantity = request.getQuantity();
        if (existingItem != null) {
            requestedQuantity += existingItem.getQuantity();
        }

        // VALIDATION 3: Check stock availability
        if (!inventoryService.hasSufficientStock(request.getVariantId(), requestedQuantity)) {
            throw new IllegalStateException("Insufficient stock available for this product");
        }

        if (existingItem != null) {
            // Update quantity
            existingItem.setQuantity(existingItem.getQuantity() + request.getQuantity());
        } else {
            // Create new cart item
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProductVariants(variant);
            newItem.setQuantity(request.getQuantity());
            cart.getCartItems().add(newItem);
        }

        cart = cartRepository.save(cart);
        return mapToCartView(cart);
    }

    @Override
    public CartView getCartByUserId(Long userId) {
        Cart cart = cartRepository.findByUserId(userId);
        if (cart == null) {
            // Return empty cart
            CartView emptyCart = new CartView();
            emptyCart.setUserId(userId);
            emptyCart.setItems(new ArrayList<>());
            emptyCart.setTotalPrice(0.0);
            return emptyCart;
        }
        return mapToCartView(cart);
    }

    @Override
    public void removeFromCart(Long cartItemId) {
        if (cartItemId == null) {
            throw new IllegalArgumentException("Cart item ID cannot be null");
        }
        cartItemRepository.deleteById(cartItemId);
    }

    @Override
    public void updateCartItemQuantity(Long cartItemId, int quantity) {
        if (cartItemId == null) {
            throw new IllegalArgumentException("Cart item ID cannot be null");
        }
        if (quantity <= 0) {
            throw new IllegalArgumentException("Quantity must be greater than 0");
        }
        
        CartItem cartItem = cartItemRepository.findById(cartItemId)
                .orElseThrow(() -> new EntityNotFoundException("Cart item not found"));
        
        // Check stock availability for new quantity
        if (!inventoryService.hasSufficientStock(cartItem.getProductVariants().getId(), quantity)) {
            throw new IllegalStateException("Insufficient stock available for requested quantity");
        }
        
        cartItem.setQuantity(quantity);
        cartItemRepository.save(cartItem);
    }

    @Override
    public void clearCart(Long userId) {
        Cart cart = cartRepository.findByUserId(userId);
        if (cart != null) {
            cart.getCartItems().clear();
            cartRepository.save(cart);
        }
    }

    private CartView mapToCartView(Cart cart) {
        CartView view = new CartView();
        view.setId(cart.getId());
        view.setUserId(cart.getUser().getId());

        List<CartView.CartItemView> itemViews = cart.getCartItems().stream()
                .map(this::mapToCartItemView)
                .collect(Collectors.toList());

        view.setItems(itemViews);

        double totalPrice = itemViews.stream()
                .mapToDouble(CartView.CartItemView::getSubtotal)
                .sum();
        view.setTotalPrice(totalPrice);

        return view;
    }

    private CartView.CartItemView mapToCartItemView(CartItem item) {
        CartView.CartItemView view = new CartView.CartItemView();
        view.setId(item.getId());
        view.setVariantId(item.getProductVariants().getId());
        view.setProductName(item.getProductVariants().getProduct().getName());
        view.setProductImage(item.getProductVariants().getProduct().getPrimaryImageUrl());
        view.setColorName(item.getProductVariants().getColor() != null
                ? item.getProductVariants().getColor().getColorName()
                : "");
        view.setSizeName(item.getProductVariants().getSize() != null
                ? item.getProductVariants().getSize().getSizeName()
                : "");
        view.setQuantity(item.getQuantity());

        double price = item.getProductVariants().getPrice() != null
                ? item.getProductVariants().getPrice().getSalePrice()
                : 0.0;
        view.setPrice(price);
        view.setSubtotal(price * item.getQuantity());

        return view;
    }
}
