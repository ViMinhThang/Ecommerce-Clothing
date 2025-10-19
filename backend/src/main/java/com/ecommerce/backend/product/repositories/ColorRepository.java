package com.ecommerce.backend.product.repositories;

import com.ecommerce.backend.product.entity.Color;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ColorRepository extends JpaRepository<Color, Long> {
    Color findByName(String name);
}
