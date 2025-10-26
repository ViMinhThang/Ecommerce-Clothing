package com.ecommerce.backend.data;

import com.ecommerce.backend.category.entity.Category;
import com.ecommerce.backend.category.repositories.CategoryRepository;
import com.ecommerce.backend.product.entity.*;
import com.ecommerce.backend.product.repositories.*;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Propagation;

import java.util.List;

@Component
@RequiredArgsConstructor
public class MockDataLoader implements CommandLineRunner {

    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final SizeRepository sizeRepository;
    private final ColorRepository colorRepository;
    private final VariantRepository variantRepository;
    private final VariantImageRepository variantImageRepository;

    @Override
    @Transactional
    public void run(String... args) {

        // ⚙️ 1️⃣ Tạo Category
        Category category = new Category();
        category.setCategoryName("T-Shirt");
        categoryRepository.save(category);

        // ⚙️ 2️⃣ Tạo Color
        Color red = new Color(null, "Red");
        Color blue = new Color(null, "Blue");
        colorRepository.saveAll(List.of(red, blue));

        // ⚙️ 3️⃣ Tạo Size
        Size small = new Size(null, "S");
        Size large = new Size(null, "L");
        sizeRepository.saveAll(List.of(small, large));

        // ⚙️ 4️⃣ Tạo Product
        Product product = new Product();
        product.setProductName("Classic Cotton T-Shirt");
        product.setCategory(category);
        product.setAvailable(true);
        productRepository.save(product);

        // ⚙️ 5️⃣ Tạo Variants cho Product
        Variant variant1 = new Variant();
        variant1.setProduct(product);
        variant1.setColor(red);
        variant1.setSize(small);
        variant1.setPrice(199_000.0);
        variant1.setQuantity(50);
        variant1.setSKU("TSHIRT-RED-S");
        variant1.setDescription("Red Small Cotton T-Shirt");

        Variant variant2 = new Variant();
        variant2.setProduct(product);
        variant2.setColor(blue);
        variant2.setSize(large);
        variant2.setPrice(209_000.0);
        variant2.setQuantity(40);
        variant2.setSKU("TSHIRT-BLUE-L");
        variant2.setDescription("Blue Large Cotton T-Shirt");

        variantRepository.saveAll(List.of(variant1, variant2));

        // ⚙️ 6️⃣ Tạo Variant Images
        VariantImage img1 = new VariantImage(null,
                "https://example.com/images/tshirt-red-front.jpg", variant1);
        VariantImage img2 = new VariantImage(null,
                "https://example.com/images/tshirt-blue-front.jpg", variant2);

        variantImageRepository.saveAll(List.of(img1, img2));

        System.out.println("✅ Mock data initialized successfully!");
    }
}
