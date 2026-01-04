package com.ecommerce.backend.repository;

import com.ecommerce.backend.dto.view.ProductSearchView;
import com.ecommerce.backend.dto.view.ProductView;
import com.ecommerce.backend.model.Product;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>, JpaSpecificationExecutor<Product> {
    Page<Product> findByNameContainingIgnoreCase(String search, Pageable pageable);

    // SELECT * FROM product WHERE category_id = ? AND status = ?
    Page<Product> findByCategoryIdAndStatus(long categoryId, String status, Pageable pageable);

    @Query(value = """
            SELECT DISTINCT ON (p.id) p.id, p.name, pi.image_url FROM product as p
            join product_image as pi on p.id = pi.product_id WHERE pi.is_primary = true and p.status = 'active' and
             search_vector @@ to_tsquery('simple', unaccent(:keyword) || ':*') LIMIT 5
            """, nativeQuery = true)
    List<ProductSearchView> searchByName(@Param("keyword") String keyword);

    @Query(value = """
            SELECT DISTINCT ON (p.id) p.id, p.name, pi.image_url
            FROM product p
            join product_image as pi on p.id = pi.product_id WHERE pi.is_primary = true and p.status = 'active' and
            p.category_id = :categoryId
            AND p.search_vector @@ to_tsquery('simple', unaccent(:keyword) || ':*')
            ORDER BY ts_rank(p.search_vector, to_tsquery('simple', unaccent(:keyword) || ':*')) DESC
            LIMIT 5
            """, nativeQuery = true)
    List<ProductSearchView> searchByNameAndCategory(
            @Param("keyword") String keyword,
            @Param("categoryId") long categoryId);
}