package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.ProductVariants;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductVariantsRepository extends JpaRepository<ProductVariants, Long> {
    List<ProductVariants> findByProductId(Long productId);
}
