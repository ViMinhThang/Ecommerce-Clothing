package com.ecommerce.backend.product.repositories;

import com.ecommerce.backend.product.entity.Product;
import com.ecommerce.backend.product.entity.Variant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface VariantRepository  extends JpaRepository<Variant, Long> {
    @Modifying
    @Query("delete from Variant v where v.variantId = ?1")
    void delete(Long entityId);

    List<Variant> findByProductAndVariantIdNot(Product product, Long variantId);
}
