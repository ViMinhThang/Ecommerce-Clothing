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
        category1.setName("Electronics"); // Changed from setTitle
        category1.setDescription("Electronic gadgets and devices"); // Added description
        category1.setImageUrl("http://10.0.2.2:8080/uploads/categories/electronics.jpg"); // Updated image URL
        category1.setStatus("active"); // Added status

        Category category2 = new Category();
        category2.setName("Books"); // Changed from setTitle
        category2.setDescription("Various genres of books"); // Added description
        category2.setImageUrl("http://10.0.2.2:8080/uploads/categories/books.jpg"); // Updated image URL
        category2.setStatus("active"); // Added status

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
        price1.setStatus("active"); // Added status

        Price price2 = new Price();
        price2.setBasePrice(200.0);
        price2.setSalePrice(150.0);
        price2.setStatus("active"); // Added status

        List<Price> prices = priceRepository.saveAll(List.of(price1, price2));
        price1 = prices.get(0);
        price2 = prices.get(1);

        // Create products
        Product product1 = new Product();
        product1.setName("Laptop");
        product1.setDescription("A powerful laptop");
        product1.setCategory(category1);
        product1.setImageUrl("http://10.0.2.2:8080/uploads/products/laptop.jpg"); // Updated image URL
        product1.setStatus("active"); // Added status
        Product product2 = new Product();
        product2.setName("The Lord of the Rings");
        product2.setDescription("A classic fantasy novel");
        product2.setCategory(category2);
        product2.setImageUrl("http://10.0.2.2:8080/uploads/products/lotr.jpg"); // Updated image URL
        product2.setStatus("active"); // Added status

        List<Product> products = productRepository.saveAll(List.of(product1, product2));
        product1 = products.get(0);
        product2 = products.get(1);

        // Create product variants
        ProductVariants variant1 = new ProductVariants();
        variant1.setProduct(product1);
        variant1.setColor(color1);
        variant1.setSize(size1);
        variant1.setPrice(price1);
        variant1.setStatus("active"); // Added status

        ProductVariants variant2 = new ProductVariants();
        variant2.setProduct(product2);
        variant2.setColor(color2);
        variant2.setSize(size2);
        variant2.setPrice(price2);
        variant2.setStatus("active"); // Added status

        productVariantsRepository.saveAll(List.of(variant1, variant2));
    }
}