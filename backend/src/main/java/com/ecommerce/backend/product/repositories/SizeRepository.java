package com.ecommerce.backend.product.repositories;

import com.ecommerce.backend.product.entity.Size;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SizeRepository extends JpaRepository<Size, Long> {
    Size findByName(String name);
}
