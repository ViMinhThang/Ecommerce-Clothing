package com.ecommerce.backend.seeder;

import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import org.springframework.security.crypto.password.PasswordEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class DatabaseSeeder implements CommandLineRunner {

    private static final int MIN_TOTAL_PRODUCTS = 50;
    private static final int DUMMY_PRODUCT_COUNT = 48;

    private final UserRepository userRepository;
    private final CategoryRepository categoryRepository;
    private final ProductRepository productRepository;
    private final ColorRepository colorRepository;
    private final SizeRepository sizeRepository;
    private final PriceRepository priceRepository;
    private final ProductVariantsRepository productVariantsRepository;
    private final OrderRepository orderRepository;
    private final OrderItemRepository orderItemRepository;
    private final MaterialRepository materialRepository;
    private final SeasonRepository seasonRepository;
    private final RoleRepository roleRepository;
    private final UserRoleRepository userRoleRepository;
    private final PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        // 1. Seed roles
        seedRolesIfNotExists();

        // 2. Seed admin user
        User adminUser = seedAdminUserIfNotExists();

        // 3. Seed 2 user thường (giữ nguyên data bạn đã có)
        List<User> normalUsers = seedUsers();
        User user1 = normalUsers.get(0);
        User user2 = normalUsers.get(1);

        // 4. Các seed khác
        Map<String, Category> categories = seedCategories();
        List<Color> colors = initColor();
        Map<String, Size> sizes = seedSizes10(); // 10 size
        Map<String, Material> materials = seedMaterials();
        Map<String, Season> seasons = seedSeasons();
        Map<String, Price> samplePrices = seedSamplePrices();
        Map<String, Product> sampleProducts = seedSampleProducts(categories);
        seedSampleProductVariants(sampleProducts, colors, sizes, materials, seasons, samplePrices);
        seedDummyProductsAndVariants(sizes); // dùng list size 10

        // 5. Tạo orders mẫu dùng 2 user thường (nếu muốn thêm admin thì truyền
        // adminUser vào)
        createSampleOrders(user1, user2);
    }

    // ================== SEED USERS & ROLES ==================

    private List<User> seedUsers() {
        User user1 = new User();
        user1.setUsername("john.doe");
        user1.setPassword(passwordEncoder.encode("password"));
        user1.setFullName("John Doe");
        user1.setBirthDay(LocalDate.of(2000, 6, 2));
        user1.setStatus("active");
        user1.setEmail("john.doe@example.com");

        User user2 = new User();
        user2.setUsername("jane.doe");
        user2.setPassword(passwordEncoder.encode("password"));
        user2.setFullName("Jane Doe");
        user2.setBirthDay(LocalDate.of(2003, 2, 20));
        user2.setStatus("active");
        user2.setEmail("jane.doe@example.com");

        return userRepository.saveAll(List.of(user1, user2));
    }

    // Tạo ROLE_ADMIN và ROLE_USER nếu chưa có
    private void seedRolesIfNotExists() {
        if (roleRepository.count() == 0) {
            Role adminRole = new Role();
            adminRole.setName("ROLE_ADMIN");
            adminRole.setStatus("active");

            Role userRole = new Role();
            userRole.setName("ROLE_USER");
            userRole.setStatus("active");

            roleRepository.saveAll(List.of(adminRole, userRole));
        }
    }

    // Tạo user admin + gán role nếu chưa có
    private User seedAdminUserIfNotExists() {
        // tìm user theo username
        Optional<User> existingAdminOpt = userRepository.findByUsername("admin");
        if (existingAdminOpt.isPresent()) {
            return existingAdminOpt.get();
        }

        // Nếu bạn có PasswordEncoder, hãy thay bằng passwordEncoder.encode("admin123")
        User admin = new User();
        admin.setUsername("admin");
        admin.setPassword(passwordEncoder.encode("admin123"));
        admin.setEmail("admin@example.com");
        admin.setFullName("System Administrator");
        admin.setBirthDay(LocalDate.of(1999, 12, 10));
        admin.setStatus("active");
        admin = userRepository.save(admin);

        // lấy roles
        Role adminRole = roleRepository.findByName("ROLE_ADMIN")
                .orElseThrow(() -> new RuntimeException("ROLE_ADMIN not found. Did you run seedRolesIfNotExists()?"));

        // Nếu muốn admin vừa là ADMIN vừa là USER thì lấy thêm ROLE_USER
        Role userRole = roleRepository.findByName("ROLE_USER").orElse(null);

        // tạo UserRole cho admin với ROLE_ADMIN
        UserRole urAdmin = new UserRole();
        urAdmin.setUser(admin);
        urAdmin.setRole(adminRole);
        urAdmin.setStatus("active");

        userRoleRepository.save(urAdmin);
        admin.getUserRoles().add(urAdmin);

        // Gán thêm ROLE_USER cho admin (tuỳ ý – hiện tại mình có gán)
        if (userRole != null) {
            UserRole urAdminUser = new UserRole();
            urAdminUser.setUser(admin);
            urAdminUser.setRole(userRole);
            urAdminUser.setStatus("active");
            userRoleRepository.save(urAdminUser);
            admin.getUserRoles().add(urAdminUser);
        }

        // cập nhật lại admin với list userRoles mới
        return userRepository.save(admin);
    }

    // ================== CATEGORIES / SIZES / MATERIALS / SEASONS / PRICES
    // ==================

    private Map<String, Category> seedCategories() {
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

        List<Category> saved = categoryRepository.saveAll(
                List.of(category1, category2, category3, category4, category5, category6, category7));

        return saved.stream().collect(Collectors.toMap(Category::getName, c -> c));
    }

    /**
     * Seed ít nhất 10 size (ví dụ: XXS, XS, S, M, L, XL, XXL, 3XL, 4XL, 5XL)
     */
    private Map<String, Size> seedSizes10() {
        Size s1 = new Size();
        s1.setSizeName("XXS");
        s1.setStatus("active");

        Size s2 = new Size();
        s2.setSizeName("XS");
        s2.setStatus("active");

        Size s3 = new Size();
        s3.setSizeName("S");
        s3.setStatus("active");

        Size s4 = new Size();
        s4.setSizeName("M");
        s4.setStatus("active");

        Size s5 = new Size();
        s5.setSizeName("L");
        s5.setStatus("active");

        Size s6 = new Size();
        s6.setSizeName("XL");
        s6.setStatus("active");

        Size s7 = new Size();
        s7.setSizeName("XXL");
        s7.setStatus("active");

        Size s8 = new Size();
        s8.setSizeName("3XL");
        s8.setStatus("active");

        Size s9 = new Size();
        s9.setSizeName("4XL");
        s9.setStatus("active");

        Size s10 = new Size();
        s10.setSizeName("5XL");
        s10.setStatus("active");

        List<Size> saved = sizeRepository.saveAll(
                List.of(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10));
        return saved.stream().collect(Collectors.toMap(Size::getSizeName, s -> s));
    }

    private Map<String, Material> seedMaterials() {
        Material material1 = new Material();
        material1.setMaterialName("Cotton");
        material1.setStatus("active");

        Material material2 = new Material();
        material2.setMaterialName("Wool");
        material2.setStatus("active");

        Material material3 = new Material();
        material3.setMaterialName("Leather");
        material3.setStatus("active");

        List<Material> saved = materialRepository.saveAll(
                List.of(material1, material2, material3));
        return saved.stream().collect(Collectors.toMap(Material::getMaterialName, m -> m));
    }

    private Map<String, Season> seedSeasons() {
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

        List<Season> saved = seasonRepository.saveAll(
                List.of(season1, season2, season3, season4));
        return saved.stream().collect(Collectors.toMap(Season::getSeasonName, s -> s));
    }

    private Map<String, Price> seedSamplePrices() {
        Price price1 = new Price();
        price1.setBasePrice(100.0);
        price1.setSalePrice(80.0);
        price1.setStatus("active");

        Price price2 = new Price();
        price2.setBasePrice(200.0);
        price2.setSalePrice(150.0);
        price2.setStatus("active");

        List<Price> saved = priceRepository.saveAll(List.of(price1, price2));

        Map<String, Price> map = new HashMap<>();
        map.put("P1", saved.get(0));
        map.put("P2", saved.get(1));
        return map;
    }

    private Map<String, Product> seedSampleProducts(Map<String, Category> categories) {
        Product product1 = new Product();
        product1.setName("Laptop");
        product1.setDescription("A powerful laptop");
        product1.setCategory(categories.get("Dresses")); // category1
        product1.setStatus("active");

        Product product2 = new Product();
        product2.setName("The Lord of the Rings");
        product2.setDescription("A classic fantasy novel");
        product2.setCategory(categories.get("Jackets")); // category2
        product2.setStatus("active");

        List<Product> saved = productRepository.saveAll(List.of(product1, product2));

        Map<String, Product> map = new HashMap<>();
        map.put("Laptop", saved.get(0));
        map.put("LotR", saved.get(1));
        return map;
    }

    private void seedSampleProductVariants(
            Map<String, Product> sampleProducts,
            List<Color> colors,
            Map<String, Size> sizes,
            Map<String, Material> materials,
            Map<String, Season> seasons,
            Map<String, Price> samplePrices) {
        Color colorBlack = colors.stream()
                .filter(c -> "Black".equalsIgnoreCase(c.getColorName()))
                .findFirst().orElse(colors.get(0));
        Color colorWhite = colors.stream()
                .filter(c -> "White".equalsIgnoreCase(c.getColorName()))
                .findFirst().orElse(colors.get(1));

        Product laptop = sampleProducts.get("Laptop");
        Product lotr = sampleProducts.get("LotR");

        // chọn 1–2 size phổ biến trong 10 size cho sample (ở đây dùng M và L)
        Size sizeM = sizes.get("M");
        Size sizeL = sizes.get("L");

        ProductVariants variant1 = new ProductVariants();
        variant1.setProduct(laptop);
        variant1.setColor(colorBlack);
        variant1.setSize(sizeM);
        variant1.setPrice(samplePrices.get("P1"));
        variant1.setStatus("active");
        variant1.setMaterial(materials.get("Cotton"));
        variant1.setSeason(seasons.get("Spring"));

        ProductVariants variant2 = new ProductVariants();
        variant2.setProduct(lotr);
        variant2.setColor(colorWhite);
        variant2.setSize(sizeL);
        variant2.setPrice(samplePrices.get("P2"));
        variant2.setStatus("active");
        variant2.setMaterial(materials.get("Wool"));
        variant2.setSeason(seasons.get("Summer"));

        productVariantsRepository.saveAll(List.of(variant1, variant2));
    }

    private void seedDummyProductsAndVariants(Map<String, Size> sizeMap) {
        long currentCount = productRepository.count();
        if (currentCount >= MIN_TOTAL_PRODUCTS)
            return;

        int needToCreate = (int) Math.max(MIN_TOTAL_PRODUCTS - currentCount, DUMMY_PRODUCT_COUNT);
        int productToCreate = DUMMY_PRODUCT_COUNT;

        Random random = new Random();
        List<Category> allCategories = categoryRepository.findAll();
        List<Color> allColors = colorRepository.findAll();
        List<Size> allSizes = new ArrayList<>(sizeMap.values()); // 10 size
        List<Material> allMaterials = materialRepository.findAll();
        List<Season> allSeasons = seasonRepository.findAll();

        // URL ảnh mẫu cho tất cả dummy products
        String DUMMY_IMAGE_URL = "https://patchwiki.biligame.com/images/lol/4/43/lvqxvolxskyaxgo4id1nqtv7u3v6rds.png";

        for (int i = 1; i <= productToCreate; i++) {
            Product product = new Product();
            product.setName("Dummy Product " + i);
            product.setDescription("This is a sample product for testing purposes. Product number " + i
                    + " with full details including images, variants, colors, sizes, and pricing information.");
            product.setCategory(
                    allCategories.get(random.nextInt(allCategories.size())));
            product.setStatus("active");

            // Tạo ProductImage (QUAN TRỌNG - thiếu cái này nên không hiển thị ảnh)
            ProductImage primaryImage = new ProductImage();
            primaryImage.setImageUrl(DUMMY_IMAGE_URL);
            primaryImage.setDisplayOrder(0);
            primaryImage.setIsPrimary(true);
            primaryImage.setProduct(product);

            // Thêm image vào product
            product.getImages().add(primaryImage);

            // Save product (cascade sẽ save image)
            product = productRepository.save(product);

            int variantCount = 2 + random.nextInt(3); // 2-4 variants
            for (int j = 0; j < variantCount; j++) {
                ProductVariants variant = new ProductVariants();
                variant.setProduct(product);

                if (!allColors.isEmpty()) {
                    variant.setColor(
                            allColors.get(random.nextInt(allColors.size())));
                }

                // chọn random trong 10 size
                if (!allSizes.isEmpty()) {
                    variant.setSize(
                            allSizes.get(random.nextInt(allSizes.size())));
                }

                // Tạo Price với giá hợp lý hơn (200-1500)
                double basePrice = 200.0 + (random.nextDouble() * 1300.0); // 200-1500
                basePrice = Math.round(basePrice / 10.0) * 10.0; // Làm tròn đến chục

                double discountPercent = 0.1 + (random.nextDouble() * 0.3); // Giảm 10-40%
                double salePrice = basePrice * (1 - discountPercent);
                salePrice = Math.round(salePrice / 10.0) * 10.0;

                Price price = new Price();
                price.setBasePrice(basePrice);
                price.setSalePrice(salePrice);
                price.setStatus("active");
                price = priceRepository.save(price);

                variant.setPrice(price);
                variant.setStatus("active");

                if (!allMaterials.isEmpty()) {
                    variant.setMaterial(
                            allMaterials.get(random.nextInt(allMaterials.size())));
                }
                if (!allSeasons.isEmpty()) {
                    variant.setSeason(
                            allSeasons.get(random.nextInt(allSeasons.size())));
                }

                productVariantsRepository.save(variant);
            }
        }

        System.out.println("✅ Created " + productToCreate + " dummy products with images and variants");
    }

    // ================== ORDERS & COLORS ==================

    private void createSampleOrders(User user1, User user2) {
        List<ProductVariants> allVariants = productVariantsRepository.findAll();
        if (allVariants.isEmpty())
            return;

        Random random = new Random();

        int totalOrders = 12 + random.nextInt(4); // 12–15

        for (int idx = 0; idx < totalOrders; idx++) {
            User owner = (idx % 2 == 0) ? user1 : user2;

            Order order = new Order();
            order.setUser(owner);

            if (idx % 3 == 0) {
                order.setStatus("completed");
            } else if (idx % 3 == 1) {
                order.setStatus("pending");
            } else {
                order.setStatus("cancelled");
            }

            order.setCreatedDate(LocalDateTime.now().minusDays(5 - (idx % 5)));
            order.setUpdatedDate(LocalDateTime.now().minusDays(4 - (idx % 4)));
            order.setUpdatedBy(owner);

            order.setOrderItems(new ArrayList<>());
            order = orderRepository.save(order);

            List<OrderItem> items = new ArrayList<>();
            double total = 0.0;

            int itemCount = 1 + random.nextInt(4);
            for (int i = 0; i < itemCount; i++) {
                ProductVariants pv = allVariants.get(random.nextInt(allVariants.size()));
                int qty = 1 + random.nextInt(5);

                OrderItem item = new OrderItem();
                item.setOrder(order);
                item.setProductVariants(pv);
                item.setQuantity(qty);
                item.setPriceAtPurchase(pv.getPrice().getSalePrice());
                item.setStatus("active");
                item.setCreatedDate(order.getCreatedDate());
                item.setUpdatedDate(order.getUpdatedDate());

                total += item.getPriceAtPurchase() * qty;
                items.add(item);
            }

            orderItemRepository.saveAll(items);
            order.setOrderItems(items);
            order.setTotalPrice(total);
            orderRepository.save(order);
        }
    }

    private List<Color> initColor() {
        Color c1 = new Color();
        c1.setColorName("Black");
        c1.setColorCode("#000000");
        c1.setStatus("active");

        Color c2 = new Color();
        c2.setColorName("Blue");
        c2.setColorCode("#1E88E5");
        c2.setStatus("active");

        Color c3 = new Color();
        c3.setColorName("Green");
        c3.setColorCode("#2E7D32");
        c3.setStatus("active");

        Color c4 = new Color();
        c4.setColorName("Red");
        c4.setColorCode("#D32F2F");
        c4.setStatus("active");

        Color c5 = new Color();
        c5.setColorName("Pink");
        c5.setColorCode("#F8BBD0");
        c5.setStatus("active");

        Color c6 = new Color();
        c6.setColorName("Orange");
        c6.setColorCode("#FFA000");
        c6.setStatus("active");

        Color c7 = new Color();
        c7.setColorName("Beige");
        c7.setColorCode("#F0E1C6");
        c7.setStatus("active");

        Color c8 = new Color();
        c8.setColorName("Grey");
        c8.setColorCode("#BDBDBD");
        c8.setStatus("active");

        Color c9 = new Color();
        c9.setColorName("White");
        c9.setColorCode("#FFFFFF");
        c9.setStatus("active");

        Color c10 = new Color();
        c10.setColorName("Purple");
        c10.setColorCode("#673AB7");
        c10.setStatus("active");

        return colorRepository.saveAll(
                List.of(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10));
    }
}