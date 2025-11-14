package com.ecommerce.backend.repository.filter;

import com.ecommerce.backend.model.Product;
import com.ecommerce.backend.model.ProductVariants;
import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.Path;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class ProductSpecifications {
    private ProductSpecifications() {}
    public static Specification<ProductVariants> build(ProductFilter f) {
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            Join<ProductVariants, Product> productJoin = root.join("product"); // join 2 bảng với nhau
            if (f.getStatus() != null && !f.getStatus().isEmpty()) {
                // Tạo điều kiện "bằng" (equal)
                predicates.add(cb.equal(productJoin.get("status"), f.getStatus()));
            }
            // Lấy đường dẫn (Path) tới cột giá
            Path<Double> pricePath;
            // Lấy giá theo trường hợp người dùng muốn tìm kiếm sản phẩm đang sale hay không
            if(f.isSale())
                pricePath= root.get("price").get("salePrice");
            else
                pricePath= root.get("price").get("basePrice");

            if (f.getMinPrice() > 0) {
                // Dùng "greaterThanOrEqualTo" (>=)
                predicates.add(cb.greaterThanOrEqualTo(pricePath, f.getMinPrice()));
            }

            // Lọc giá ĐẾN (maxPrice)
            if (f.getMaxPrice() > 0  && f.getMaxPrice() > f.getMinPrice()) {
                // Dùng "lessThanOrEqualTo" (<=)
                predicates.add(cb.lessThanOrEqualTo(pricePath, f.getMaxPrice()));
            }
            // Lọc với các Size được chọn
            if(f.getSizes() != null && !f.getSizes().isEmpty()){
                Path<String> sizeNamePath = root.join("size").get("sizeName");
                predicates.add(sizeNamePath.in(f.getSizes()));
            }

            // Lọc với các Season được chọn

            if(f.getSeasons() != null && !f.getSeasons().isEmpty()){
                Path<String> seasonNamePath = root.join("season").get("seasonName");
                predicates.add(seasonNamePath.in(f.getSeasons()));
            }

            // Lọc với các Color được chọn

            if(f.getColors() != null && !f.getColors().isEmpty()){
                Path<String> colorNamePath = root.join("color").get("colorName");
                predicates.add(colorNamePath.in(f.getColors()));
            }

            // Lọc với các Material được chọn

            if(f.getMaterials() != null && !f.getMaterials().isEmpty()){
                Path<String> materialNamePath = root.join("material").get("materialName");
                predicates.add(materialNamePath.in(f.getMaterials()));
            }


            Objects.requireNonNull(query).distinct(true);
            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
