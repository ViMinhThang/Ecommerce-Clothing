package com.ecommerce.backend.service;

import com.ecommerce.backend.dto.view.WishlistItemView;

import java.util.List;

public interface FavoriteService {
    List<WishlistItemView> getFavoritesByUserId(Long userId);
    WishlistItemView addToFavorites(Long userId, Long productId);
    void removeFromFavorites(Long userId, Long productId);
    boolean isProductInFavorites(Long userId, Long productId);
}
