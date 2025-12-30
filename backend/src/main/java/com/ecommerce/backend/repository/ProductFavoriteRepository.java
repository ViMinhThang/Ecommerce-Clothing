package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.ProductFavorite;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProductFavoriteRepository extends JpaRepository<ProductFavorite, Long> {

    List<ProductFavorite> findByUserId(Long userId);

    List<ProductFavorite> findByUserIdAndStatus(Long userId, String status);

    Optional<ProductFavorite> findByUserAndProduct(User user, Product product);

    Optional<ProductFavorite> findByUserIdAndProductId(Long userId, Long productId);

    boolean existsByUserIdAndProductId(Long userId, Long productId);

    void deleteByUserIdAndProductId(Long userId, Long productId);
}
