package com.ecommerce.backend.seeder;

import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Random;

@Component
@RequiredArgsConstructor
public class DatabaseSeeder implements CommandLineRunner {

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final PriceRepository priceRepository;
    private final ProductVariantsRepository productVariantsRepository;

    // thêm 2 repository mới
    private final MaterialRepository materialRepository;
    private final SeasonRepository seasonRepository;

    @Override
    public void run(String... args) throws Exception {
        // ===== Users =====
        User user1 = new User();
        user1.setUsername("john.doe");
        user1.setPassword("password");
        user1.setEmail("john.doe@example.com");

        User user2 = new User();
        user2.setUsername("jane.doe");
        user2.setPassword("password");
        user2.setEmail("jane.doe@example.com");

        List<User> users = userRepository.saveAll(List.of(user1, user2));
        user1 = users.get(0);
        user2 = users.get(1);

        // ===== Categories =====
        Category category1 = new Category();
        category1.setName("Dresses");
        category1.setDescription("Various genres of Dresses");
        category1.setImageUrl("http://10.0.2.2:8080/uploads/categories/Dresses.png");
        category1.setStatus("active");

        Category category2 = new Category();
        category2.setName("Jackets");
        category2.setDescription("Various genres of Jackets");
        category2.setImageUrl("http://10.0.2.2:8080/uploads/categories/Jacket.png");
        category2.setStatus("active");

        Category category3 = new Category();
        category3.setName("Coats");
        category3.setDescription("Various genres of Coats");
        category3.setImageUrl("http://10.0.2.2:8080/uploads/categories/Coats.png");
        category3.setStatus("active");

        Category category4 = new Category();
        category4.setName("Lingerie");
        category4.setDescription("Various genres of Lingerie");
        category4.setImageUrl("http://10.0.2.2:8080/uploads/categories/Lingerie.png");
        category4.setStatus("active");

        Category category5 = new Category();
        category5.setName("New Products");
        category5.setDescription("Various genres of new products");
        category5.setImageUrl("http://10.0.2.2:8080/uploads/categories/newProducts.png");
        category5.setStatus("active");

        Category category6 = new Category();
        category6.setName("Shirts");
        category6.setDescription("Various genres of Shirts");
        category6.setImageUrl("http://10.0.2.2:8080/uploads/categories/Shirts.png");
        category6.setStatus("active");

        Category category7 = new Category();
        category7.setName("Collections");
        category7.setDescription("Various genres of Collections");
        category7.setImageUrl("http://10.0.2.2:8080/uploads/categories/Collections.png");
        category7.setStatus("active");

        List<Category> categories = categoryRepository.saveAll(
                List.of(category1, category2, category3, category4, category5, category6, category7)
        );
        category1 = categories.get(0);
        category2 = categories.get(1);

        // ===== Colors =====
        Color color1 = new Color();
        color1.setColorName("Black");
        color1.setStatus("active");

        Color color2 = new Color();
        color2.setColorName("White");
        color2.setStatus("active");

        List<Color> colors = colorRepository.saveAll(List.of(color1, color2));
        color1 = colors.get(0);
        color2 = colors.get(1);

        // ===== Sizes =====
        Size size1 = new Size();
        size1.setSizeName("M");
        size1.setStatus("active");

        Size size2 = new Size();
        size2.setSizeName("L");
        size2.setStatus("active");

        List<Size> sizes = sizeRepository.saveAll(List.of(size1, size2));
        size1 = sizes.get(0);
        size2 = sizes.get(1);

        // ===== Materials =====
        Material material1 = new Material();
        material1.setMaterialName("Cotton");
        material1.setStatus("active");

        Material material2 = new Material();
        material2.setMaterialName("Wool");
        material2.setStatus("active");

        Material material3 = new Material();
        material3.setMaterialName("Leather");
        material3.setStatus("active");

        List<Material> materials = materialRepository.saveAll(
                List.of(material1, material2, material3)
        );
        material1 = materials.get(0);
        material2 = materials.get(1);
        material3 = materials.get(2);

        // ===== Seasons =====
        Season season1 = new Season();
        season1.setSeasonName("Spring");
        season1.setStatus("active");

        Season season2 = new Season();
        season2.setSeasonName("Summer");
        season2.setStatus("active");

        Season season3 = new Season();
        season3.setSeasonName("Autumn");
        season3.setStatus("active");

        Season season4 = new Season();
        season4.setSeasonName("Winter");
        season4.setStatus("active");

        List<Season> seasons = seasonRepository.saveAll(
                List.of(season1, season2, season3, season4)
        );
        season1 = seasons.get(0);
        season2 = seasons.get(1);
        season3 = seasons.get(2);
        season4 = seasons.get(3);

        // ===== Prices (ví dụ sản phẩm mẫu) =====
        Price price1 = new Price();
        price1.setBasePrice(100.0);
        price1.setSalePrice(80.0);
        price1.setStatus("active");

        Price price2 = new Price();
        price2.setBasePrice(200.0);
        price2.setSalePrice(150.0);
        price2.setStatus("active");

        List<Price> prices = priceRepository.saveAll(List.of(price1, price2));
        price1 = prices.get(0);
        price2 = prices.get(1);

        // ===== Products mẫu =====
        Product product1 = new Product();
        product1.setName("Laptop");
        product1.setDescription("A powerful laptop");
        product1.setCategory(category1);
        product1.setImageUrl("http://10.0.2.2:8080/uploads/products/3a3df57f-af6a-45c2-93c1-c4d3924616b6.jpg");
        product1.setStatus("active");

        Product product2 = new Product();
        product2.setName("The Lord of the Rings");
        product2.setDescription("A classic fantasy novel");
        product2.setCategory(category2);
        product2.setImageUrl("http://10.0.2.2:8080/uploads/products/5f1cd65a-196a-40c8-aa44-1d36eb0c9263.jpg");
        product2.setStatus("active");

        List<Product> products = productRepository.saveAll(List.of(product1, product2));
        product1 = products.get(0);
        product2 = products.get(1);

        // ===== Product variants mẫu =====
        ProductVariants variant1 = new ProductVariants();
        variant1.setProduct(product1);
        variant1.setColor(color1);
        variant1.setSize(size1);
        variant1.setPrice(price1);
        variant1.setStatus("active");
        // nếu ProductVariants có field material/season (tuỳ model):
        variant1.setMaterial(material1);
        variant1.setSeason(season1);

        ProductVariants variant2 = new ProductVariants();
        variant2.setProduct(product2);
        variant2.setColor(color2);
        variant2.setSize(size2);
        variant2.setPrice(price2);
        variant2.setStatus("active");
        variant2.setMaterial(material2);
        variant2.setSeason(season2);

        productVariantsRepository.saveAll(List.of(variant1, variant2));

        // ===== Dummy products =====
        if (productRepository.count() < 50) {
            Random random = new Random();
            List<Category> allCategories = categoryRepository.findAll();
            List<Color> allColors = colorRepository.findAll();
            List<Size> allSizes = sizeRepository.findAll();
            List<Material> allMaterials = materialRepository.findAll();
            List<Season> allSeasons = seasonRepository.findAll();

            for (int i = 1; i <= 25; i++) {
                Product product = new Product();
                product.setName("Dummy Product " + i);
                product.setDescription("Description for dummy product " + i);
                product.setCategory(
                        allCategories.get(random.nextInt(allCategories.size()))
                );
                product.setImageUrl(
                        "http://10.0.2.2:8080/uploads/products/placeholder.jpg"
                );
                product.setStatus("active");
                product = productRepository.save(product);

                // 1–3 variants cho mỗi product
                int variantCount = random.nextInt(3) + 1;
                for (int j = 0; j < variantCount; j++) {
                    ProductVariants variant = new ProductVariants();
                    variant.setProduct(product);
                    variant.setColor(
                            allColors.get(random.nextInt(allColors.size()))
                    );
                    variant.setSize(
                            allSizes.get(random.nextInt(allSizes.size()))
                    );

                    // Giá ít số lẻ: chia cho 10 và nhân lại để làm tròn chục
                    double rawBase = 10.0 + random.nextDouble() * 90.0; // 10–100
                    double basePrice = Math.round(rawBase / 10.0) * 10.0;       // 10,20,...,100
                    double salePrice = basePrice * 0.9;
                    salePrice = Math.round(salePrice / 10.0) * 10.0;           // cũng làm tròn chục

                    Price price = new Price();
                    price.setBasePrice(basePrice);
                    price.setSalePrice(salePrice);
                    price.setStatus("active");
                    price = priceRepository.save(price);

                    variant.setPrice(price);
                    variant.setStatus("active");

                    // gán material/season cho variant (nếu model có)
                    if (!allMaterials.isEmpty()) {
                        variant.setMaterial(
                                allMaterials.get(random.nextInt(allMaterials.size()))
                        );
                    }
                    if (!allSeasons.isEmpty()) {
                        variant.setSeason(
                                allSeasons.get(random.nextInt(allSeasons.size()))
                        );
                    }

                    productVariantsRepository.save(variant);
                }
            }
        }
    }
}