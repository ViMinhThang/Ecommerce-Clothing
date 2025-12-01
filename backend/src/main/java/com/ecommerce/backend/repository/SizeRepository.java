package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Size;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SizeRepository extends JpaRepository<Size, Long> {
    Page<Size> findByNameContainingIgnoreCase(String name, Pageable pageable);
}
