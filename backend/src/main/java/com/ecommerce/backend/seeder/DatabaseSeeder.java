package com.ecommerce.backend.seeder;

import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.List;

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

    @Override
    public void run(String... args) throws Exception {
        // Create users
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

        // Create categories
        Category category1 = new Category();
        category1.setName("Electronics");
        category1.setDescription("Electronic gadgets and devices");
        category1.setImageUrl("http://10.0.2.2:8080/uploads/categories/65982f16-7bea-4230-b5b0-ea2f63e41d70_1000000020.jpg");
        category1.setStatus("active");

        Category category2 = new Category();
        category2.setName("Books");
        category2.setDescription("Various genres of books");
        category2.setImageUrl("http://10.0.2.2:8080/uploads/categories/f8802a77-6b55-4b4e-9fa8-c85d31e2a75c_1000000020.jpg");
        category2.setStatus("active");

        List<Category> categories = categoryRepository.saveAll(List.of(category1, category2));
        category1 = categories.get(0);
        category2 = categories.get(1);

        // Create colors
        Color color1 = new Color();
        color1.setColorName("Black");
        color1.setStatus("active");

        Color color2 = new Color();
        color2.setColorName("White");
        color2.setStatus("active");
        List<Color> colors = colorRepository.saveAll(List.of(color1, color2));
        color1 = colors.get(0);
        color2 = colors.get(1);

        // Create sizes
        Size size1 = new Size();
        size1.setSizeName("M");
        size1.setStatus("active");
        Size size2 = new Size();
        size2.setSizeName("L");
        size2.setStatus("active");
        List<Size> sizes = sizeRepository.saveAll(List.of(size1, size2));
        size1 = sizes.get(0);
        size2 = sizes.get(1);

        // Create prices
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

        // Create products
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

        // Create product variants
        ProductVariants variant1 = new ProductVariants();
        variant1.setProduct(product1);
        variant1.setColor(color1);
        variant1.setSize(size1);
        variant1.setPrice(price1);
        variant1.setStatus("active");

        ProductVariants variant2 = new ProductVariants();
        variant2.setProduct(product2);
        variant2.setColor(color2);
        variant2.setSize(size2);
        variant2.setPrice(price2);
        variant2.setStatus("active");

        productVariantsRepository.saveAll(List.of(variant1, variant2));

        // Generate 50 dummy products
        if (productRepository.count() < 50) {
            java.util.Random random = new java.util.Random();
            List<Category> allCategories = categoryRepository.findAll();
            List<Color> allColors = colorRepository.findAll();
            List<Size> allSizes = sizeRepository.findAll();

            for (int i = 1; i <= 50; i++) {
                Product product = new Product();
                product.setName("Dummy Product " + i);
                product.setDescription("Description for dummy product " + i);
                product.setCategory(allCategories.get(random.nextInt(allCategories.size())));
                product.setImageUrl("http://10.0.2.2:8080/uploads/products/placeholder.jpg");
                product.setStatus("active");
                
                product = productRepository.save(product);

                // Create 1-3 variants for each product
                int variantCount = random.nextInt(3) + 1;
                for (int j = 0; j < variantCount; j++) {
                    ProductVariants variant = new ProductVariants();
                    variant.setProduct(product);
                    variant.setColor(allColors.get(random.nextInt(allColors.size())));
                    variant.setSize(allSizes.get(random.nextInt(allSizes.size())));
                    
                    Price price = new Price();
                    double basePrice = 10.0 + random.nextDouble() * 100.0;
                    price.setBasePrice(basePrice);
                    price.setSalePrice(basePrice * 0.9);
                    price.setStatus("active");
                    price = priceRepository.save(price);
                    
                    variant.setPrice(price);
                    variant.setStatus("active");
                    productVariantsRepository.save(variant);
                }
            }
        }
    }
}