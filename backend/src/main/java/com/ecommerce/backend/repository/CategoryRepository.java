package com.ecommerce.backend.repository;

import com.ecommerce.backend.dto.view.CategoryView;
import com.ecommerce.backend.model.Category;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Long> {
    Page<Category> findByNameContainingIgnoreCase(String name, Pageable pageable);

    @Query(value = """
            SELECT id, name, image_url FROM category WHERE search_vector @@ to_tsquery('simple', unaccent(:keyword) || ':*') LIMIT 5
            """, nativeQuery = true)
    List<CategoryView> searchByNameFTS(@Param("keyword") String keyword);
}