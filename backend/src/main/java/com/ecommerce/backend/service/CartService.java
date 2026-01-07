package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.CartDTO;
import com.ecommerce.backend.dto.CartItemDTO;
import com.ecommerce.backend.model.Cart;
import com.ecommerce.backend.model.CartItem;
import com.ecommerce.backend.model.ProductVariants;
import com.ecommerce.backend.model.User;
import com.ecommerce.backend.repository.CartItemRepository;
import com.ecommerce.backend.repository.CartRepository;
import com.ecommerce.backend.repository.ProductVariantsRepository;
import com.ecommerce.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class CartService {
    private final CartRepository cartRepository;
    private final CartItemRepository cartItemRepository;
    private final UserRepository userRepository;
    private final ProductVariantsRepository productVariantsRepository;

    public CartDTO getCart(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Cart cart = cartRepository.findByUser(user)
                .orElseGet(() -> createCartForUser(user));
        
        return convertToDTO(cart);
    }

    private Cart createCartForUser(User user) {
        Cart cart = new Cart();
        cart.setUser(user);
        return cartRepository.save(cart);
    }

    public CartDTO addToCart(Long userId, Long productVariantId, int quantity) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        ProductVariants variant = productVariantsRepository.findById(productVariantId)
                .orElseThrow(() -> new RuntimeException("Product variant not found"));
        
        Cart cart = cartRepository.findByUser(user)
                .orElseGet(() -> createCartForUser(user));
        
        // Check if item already in cart
        CartItem existingItem = cart.getCartItems().stream()
                .filter(item -> item.getProductVariants().getId() == productVariantId)
                .findFirst()
                .orElse(null);
        
        if (existingItem != null) {
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem();
            newItem.setCart(cart);
            newItem.setProductVariants(variant);
            newItem.setQuantity(quantity);
            cart.getCartItems().add(newItem);
        }
        
        cartRepository.save(cart);
        return convertToDTO(cart);
    }

    public CartDTO updateCartItem(Long userId, Long productVariantId, int quantity) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        
        CartItem item = cart.getCartItems().stream()
                .filter(ci -> ci.getProductVariants().getId() == productVariantId)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Item not in cart"));
        
        if (quantity <= 0) {
            cart.getCartItems().remove(item);
            cartItemRepository.delete(item);
        } else {
            item.setQuantity(quantity);
        }
        
        cartRepository.save(cart);
        return convertToDTO(cart);
    }

    public CartDTO removeFromCart(Long userId, Long productVariantId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        
        CartItem item = cart.getCartItems().stream()
                .filter(ci -> ci.getProductVariants().getId() == productVariantId)
                .findFirst()
                .orElseThrow(() -> new RuntimeException("Item not in cart"));
        
        cart.getCartItems().remove(item);
        cartItemRepository.delete(item);
        cartRepository.save(cart);
        
        return convertToDTO(cart);
    }

    public void clearCart(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        Cart cart = cartRepository.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Cart not found"));
        
        cartItemRepository.deleteAll(cart.getCartItems());
        cart.getCartItems().clear();
        cartRepository.save(cart);
    }

    private CartDTO convertToDTO(Cart cart) {
        List<CartItemDTO> itemDTOs = cart.getCartItems().stream()
                .map(item -> new CartItemDTO(
                        item.getId(),
                        item.getProductVariants().getId(),
                        item.getQuantity(),
                        item.getProductVariants().getProduct().getName(),
                        item.getProductVariants().getProduct().getImageUrl(),
                        item.getProductVariants().getPrice().getBasePrice()
                ))
                .collect(Collectors.toList());
        
        Double totalPrice = itemDTOs.stream()
                .mapToDouble(item -> item.getPrice() * item.getQuantity())
                .sum();
        
        return new CartDTO(
                cart.getId(),
                cart.getUser().getId(),
                itemDTOs,
                totalPrice,
                itemDTOs.size()
        );
    }
}
