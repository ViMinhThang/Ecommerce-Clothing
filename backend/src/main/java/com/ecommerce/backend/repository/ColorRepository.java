package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Color;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ColorRepository extends JpaRepository<Color, Long> {
    Page<Color> findByNameContainingIgnoreCase(String name, Pageable pageable);
}
