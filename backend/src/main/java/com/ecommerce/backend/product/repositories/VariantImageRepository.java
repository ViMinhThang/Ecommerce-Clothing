package com.ecommerce.backend.product.repositories;

import com.ecommerce.backend.product.entity.VariantImage;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface VariantImageRepository extends JpaRepository<VariantImage, Long> {
    List<VariantImage> findByVariant_VariantId(Long variantId);
}