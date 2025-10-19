package com.ecommerce.backend.product.repositories;

import com.ecommerce.backend.product.entity.VariantImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface VariantImageRepository extends JpaRepository<VariantImage, Long> {
    List<VariantImage> findByVariant_VariantId(Long variantId);

    @Modifying
    @Query("delete from VariantImage v where v.id = ?1")
    void delete(Long entityId);

}