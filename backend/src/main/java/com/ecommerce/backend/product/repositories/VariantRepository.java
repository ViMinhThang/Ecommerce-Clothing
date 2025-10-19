package com.ecommerce.backend.product.repositories;

import com.ecommerce.backend.product.entity.Variant;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VariantRepository  extends JpaRepository<Variant, Long> {
}
