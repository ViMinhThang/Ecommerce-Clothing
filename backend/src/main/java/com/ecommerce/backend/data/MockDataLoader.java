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
    public void run(String... args) throws Exception {

        Category electronics = new Category();
        electronics.setCategoryName("Electronics");
        categoryRepository.save(electronics);

        Category fashion = new Category();
        fashion.setCategoryName("Fashion");
        categoryRepository.save(fashion);
        // 2️⃣ Tạo Sizes
        Size sizeS = sizeRepository.save(new Size(null, "S"));
        Size sizeM = sizeRepository.save(new Size(null, "M"));
        Size sizeL = sizeRepository.save(new Size(null, "L"));

        // 3️⃣ Tạo Colors
        Color red = colorRepository.save(new Color(null, "Red"));
        Color blue = colorRepository.save(new Color(null, "Blue"));
        Color black = colorRepository.save(new Color(null, "Black"));

        // 4️⃣ Tạo Products
        Product phone = new Product();
        phone.setProductName("Smartphone XYZ");
        phone.setCategory(electronics);
        phone.setAvailable(true);

        Product tshirt = new Product();
        tshirt.setProductName("T-Shirt ABC");
        tshirt.setCategory(fashion);
        tshirt.setAvailable(true);

        productRepository.saveAll(List.of(phone, tshirt));

        // 5️⃣ Tạo Variants cho phone
        Variant phoneVariant1 = new Variant();
        phoneVariant1.setProduct(phone);
        phoneVariant1.setPrice(699.99);
        phoneVariant1.setQuantity(50);
        phoneVariant1.setSize(sizeM); // mặc định nếu muốn
        phoneVariant1.setColor(black);

        Variant phoneVariant2 = new Variant();
        phoneVariant2.setProduct(phone);
        phoneVariant2.setPrice(749.99);
        phoneVariant2.setQuantity(30);
        phoneVariant2.setSize(sizeL);
        phoneVariant2.setColor(blue);

        variantRepository.saveAll(List.of(phoneVariant1, phoneVariant2));

        // 6️⃣ Tạo Variants cho tshirt
        Variant tshirtVariant1 = new Variant();
        tshirtVariant1.setProduct(tshirt);
        tshirtVariant1.setPrice(19.99);
        tshirtVariant1.setQuantity(100);
        tshirtVariant1.setSize(sizeS);
        tshirtVariant1.setColor(red);

        Variant tshirtVariant2 = new Variant();
        tshirtVariant2.setProduct(tshirt);
        tshirtVariant2.setPrice(21.99);
        tshirtVariant2.setQuantity(80);
        tshirtVariant2.setSize(sizeM);
        tshirtVariant2.setColor(blue);

        variantRepository.saveAll(List.of(tshirtVariant1, tshirtVariant2));

        // 7️⃣ Thêm ảnh cho các variant
        VariantImage img1 = new VariantImage();
        img1.setVariant(phoneVariant1);
        img1.setImageUrl("https://example.com/phone_black_1.jpg");

        VariantImage img2 = new VariantImage();
        img2.setVariant(phoneVariant1);
        img2.setImageUrl("https://example.com/phone_black_2.jpg");

        VariantImage img3 = new VariantImage();
        img3.setVariant(tshirtVariant1);
        img3.setImageUrl("https://example.com/tshirt_red_1.jpg");

        variantImageRepository.saveAll(List.of(img1, img2, img3));

        System.out.println("✅ Mock data loaded successfully!");
    }
}
