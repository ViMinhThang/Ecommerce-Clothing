package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.ProductVariants;
import org.springframework.data.domain.Example;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.repository.query.FluentQuery;
import org.springframework.stereotype.Repository;

import java.util.function.Function;

@Repository
public interface ProductVariantRepository extends JpaRepository<ProductVariants,Long>, JpaSpecificationExecutor<ProductVariants> {
}
