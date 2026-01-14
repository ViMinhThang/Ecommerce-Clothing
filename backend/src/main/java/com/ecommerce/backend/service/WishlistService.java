package com.ecommerce.backend.service;
import com.ecommerce.backend.dto.view.WishlistItemView;

import java.util.List;

public interface WishlistService {

    List<WishlistItemView> getWishlistByUserId(Long userId);

    WishlistItemView addToWishlist(Long userId, Long productId);

    void removeFromWishlist(Long userId, Long productId);

    boolean isProductInWishlist(Long userId, Long productId);
}
