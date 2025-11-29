package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    Page<Product> findByNameContainingIgnoreCase(String search, Pageable pageable);
    // SELECT * FROM product WHERE category_id = ? AND status = ?
    Page<Product> findByCategoryIdAndStatus(long categoryId, String status, Pageable pageable);
}