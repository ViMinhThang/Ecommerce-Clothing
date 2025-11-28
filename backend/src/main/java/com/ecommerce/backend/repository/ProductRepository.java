package com.ecommerce.backend.repository;

import com.ecommerce.backend.dto.ProductView;
import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.model.ProductVariants;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    Page<Product> findByNameContainingIgnoreCase(String search, Pageable pageable);
    // SELECT * FROM product WHERE category_id = ? AND status = ?
    Page<Product> findByCategoryIdAndStatus(long categoryId, String status, Pageable pageable);
}