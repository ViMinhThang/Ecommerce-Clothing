package com.ecommerce.backend.repository;

import com.ecommerce.backend.model.ProductVariants;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductVariantRepository
        extends JpaRepository<ProductVariants, Long>, JpaSpecificationExecutor<ProductVariants> {
    @Query(value = """
            SELECT
                string_agg(DISTINCT s.size_name, ',') as sizes,
                string_agg(DISTINCT m.material_name, ',') as materials,
                string_agg(DISTINCT c.color_name, ',') as colors,
            	string_agg(DISTINCT ss.season_name, ',') as seasons,
                MIN(p.base_price) as min_price,
                MAX(p.base_price) as max_price
            FROM product_variants as pv
            left join size as s ON pv.size_id = s.id
            left join material as m on m.id = pv.material_id
            left join color as c on c.id = pv.color_id
            left join price as p on p.id = pv.price_id
            left join season as ss on ss.id = pv.season_id
            left join product as pd on pd.id = pv.product_id
            left join category ON category.id = pd.category_id
            where pd.category_id = :categoryId
            """, nativeQuery = true)
    FilterView findFilterAttributesByCategory(@Param("categoryId") Long categoryId);
}
