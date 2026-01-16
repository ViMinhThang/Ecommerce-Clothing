package com.ecommerce.backend.seeder;

import com.ecommerce.backend.model.*;
import com.ecommerce.backend.repository.*;
import com.ecommerce.backend.service.AiRecommentService;
import com.fasterxml.jackson.core.JsonProcessingException;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.*;

@Component
@RequiredArgsConstructor
public class DatabaseSeeder implements CommandLineRunner {

        private final UserRepository userRepository;
        private final RoleRepository roleRepository;
        private final UserRoleRepository userRoleRepository;
        private final CategoryRepository categoryRepository;
        private final ProductRepository productRepository;
        private final ColorRepository colorRepository;
        private final SizeRepository sizeRepository;
        private final PriceRepository priceRepository;
        private final ProductVariantsRepository productVariantsRepository;
        private final MaterialRepository materialRepository;
        private final SeasonRepository seasonRepository;
        private final VoucherRepository voucherRepository;
        private final OrderRepository orderRepository;
        private final OrderItemRepository orderItemRepository;
        private final PasswordEncoder passwordEncoder;
        private final AiRecommentService aiRecommentService;
        @Override
        @Transactional
        public void run(String... args) throws JsonProcessingException {
                if (productRepository.count() > 0) {
                        System.out.println("Data already exists. Skipping seed.");
                        return;
                }

                System.out.println("Starting seeding...");

                User admin = initUsers();
                Map<String, Category> categoryMap = initCategories();
                Map<String, Color> colorMap = initColors();
                Map<String, Size> sizeMap = initSizes();
                Map<String, Material> materialMap = initMaterials();
                Map<String, Season> seasonMap = initSeasons();
                initVouchers();

                seedProducts(admin, categoryMap, colorMap, sizeMap, materialMap, seasonMap);
                // Nó không chạy thì comment lại đừng xóa dùm cái
                 aiRecommentService.buildCache();
                // Create a delivered order for john.doe to enable review feature testing
                initDeliveredOrderForJohnDoe();

                System.out.println("Seeding completed.");
        }

        private void initDeliveredOrderForJohnDoe() {
                Optional<User> johnDoeOpt = userRepository.findByUsername("john_doe");
                if (johnDoeOpt.isEmpty()) {
                        System.out.println("john_doe user not found, skipping delivered order creation.");
                        return;
                }

                User johnDoe = johnDoeOpt.get();

                // Check if john_doe already has a delivered order
                if (orderRepository.findByUserIdAndStatus(johnDoe.getId(), "DELIVERED").size() > 0) {
                        System.out.println("Delivered order for john_doe already exists. Skipping.");
                        return;
                }

                // Get some product variants to add to the order
                List<ProductVariants> variants = productVariantsRepository.findAll();
                if (variants.isEmpty()) {
                        System.out.println("No product variants found, skipping delivered order creation.");
                        return;
                }

                // Create a delivered order
                Order order = new Order();
                order.setUser(johnDoe);
                order.setStatus("DELIVERED");
                order.setTotalPrice(0);
                order.setDiscountAmount(0);
                order.setFinalPrice(0);
                order = orderRepository.save(order);

                // Add 2 items to the order
                double totalPrice = 0;
                List<OrderItem> orderItems = new ArrayList<>();

                for (int i = 0; i < Math.min(2, variants.size()); i++) {
                        ProductVariants variant = variants.get(i);
                        double salePrice = variant.getPrice().getSalePrice();
                        double basePrice = variant.getPrice().getBasePrice();
                        double price = salePrice > 0 ? salePrice : basePrice;

                        OrderItem item = new OrderItem();
                        item.setOrder(order);
                        item.setProductVariants(variant);
                        item.setQuantity(1);
                        item.setPriceAtPurchase(price);
                        item.setStatus("DELIVERED");
                        orderItems.add(item);
                        totalPrice += price;
                }

                orderItemRepository.saveAll(orderItems);

                order.setTotalPrice(totalPrice);
                order.setFinalPrice(totalPrice);
                orderRepository.save(order);

                System.out.println("Created delivered order for john_doe with " + orderItems.size() + " items.");
        }

        private void initVouchers() {
                if (voucherRepository.count() > 0)
                        return;

                List<Voucher> vouchers = List.of(
                                Voucher.builder()
                                                .code("WELCOME10")
                                                .description("10% off for new customers")
                                                .discountType(DiscountType.PERCENTAGE)
                                                .discountValue(10)
                                                .minOrderAmount(50)
                                                .maxDiscountAmount(20)
                                                .startDate(LocalDateTime.now())
                                                .endDate(LocalDateTime.now().plusMonths(3))
                                                .usageLimit(100)
                                                .usedCount(0)
                                                .status(VoucherStatus.ACTIVE)
                                                .build(),
                                Voucher.builder()
                                                .code("SAVE20")
                                                .description("$20 off orders over $100")
                                                .discountType(DiscountType.FIXED_AMOUNT)
                                                .discountValue(20)
                                                .minOrderAmount(100)
                                                .maxDiscountAmount(20)
                                                .startDate(LocalDateTime.now())
                                                .endDate(LocalDateTime.now().plusMonths(1))
                                                .usageLimit(50)
                                                .usedCount(0)
                                                .status(VoucherStatus.ACTIVE)
                                                .build(),
                                Voucher.builder()
                                                .code("SUMMER25")
                                                .description("25% summer sale - max $50 off")
                                                .discountType(DiscountType.PERCENTAGE)
                                                .discountValue(25)
                                                .minOrderAmount(80)
                                                .maxDiscountAmount(50)
                                                .startDate(LocalDateTime.now())
                                                .endDate(LocalDateTime.now().plusMonths(2))
                                                .usageLimit(200)
                                                .usedCount(0)
                                                .status(VoucherStatus.ACTIVE)
                                                .build());

                voucherRepository.saveAll(vouchers);
                System.out.println("Vouchers seeded: " + vouchers.size());
        }

        // --- Helper Methods to Reduce Code Size ---

        private Product createProduct(User creator, Category category, String name, String description,
                        String primaryImageUrl, List<String> secondaryImageUrls) {
                Product p = new Product();
                p.setName(name);
                p.setDescription(description);
                p.setCategory(category);
                p.setStatus("active");
                p.setCreatedBy(creator);
                p.setUpdatedBy(creator);

                List<ProductImage> images = new ArrayList<>();

                // Primary
                if (primaryImageUrl != null && !primaryImageUrl.isEmpty()) {
                        ProductImage pi = new ProductImage();
                        pi.setImageUrl(primaryImageUrl);
                        pi.setIsPrimary(true);
                        pi.setDisplayOrder(0);
                        pi.setProduct(p);
                        images.add(pi);
                }

                // Secondary
                if (secondaryImageUrls != null) {
                        for (int i = 0; i < secondaryImageUrls.size(); i++) {
                                ProductImage pi = new ProductImage();
                                pi.setImageUrl(secondaryImageUrls.get(i));
                                pi.setIsPrimary(false);
                                pi.setDisplayOrder(i + 1);
                                pi.setProduct(p);
                                images.add(pi);
                        }
                }

                p.setImages(images);
                return productRepository.save(p);
        }

        // Simplification: We will not pass exact variant details from JSON because they
        // are complex (nested objects).
        // Instead, we will simulate variants based on the 'colors' list name available
        // in JSON
        // but pass them as simple strings to a helper.

        private void createVariants(Product product, List<String> colorNames, double basePrice, double salePrice,
                        Map<String, Color> colorMap, Map<String, Size> sizeMap,
                        Map<String, Material> materialMap, Map<String, Season> seasonMap) {

                if (colorNames == null || colorNames.isEmpty())
                        return;

                Random random = new Random();
                List<String> sizeKeys = new ArrayList<>(sizeMap.keySet());
                List<String> materialKeys = new ArrayList<>(materialMap.keySet());
                List<String> seasonKeys = new ArrayList<>(seasonMap.keySet());

                List<ProductVariants> variants = new ArrayList<>();

                for (String cName : colorNames) {
                        Color col = colorMap.get(cName);
                        if (col == null)
                                continue;

                        // Create 2 random variants per color
                        for (int k = 0; k < 2; k++) {
                                ProductVariants v = new ProductVariants();
                                v.setProduct(product);
                                v.setColor(col);
                                v.setSize(sizeMap.get(sizeKeys.get(random.nextInt(sizeKeys.size()))));

                                Price pr = new Price();
                                pr.setBasePrice(basePrice);
                                pr.setSalePrice(salePrice);
                                pr.setStatus("active");
                                pr = priceRepository.save(pr);
                                v.setPrice(pr);

                                v.setMaterial(materialMap.get(materialKeys.get(random.nextInt(materialKeys.size()))));
                                v.setSeason(seasonMap.get(seasonKeys.get(random.nextInt(seasonKeys.size()))));
                                v.setStatus("active");
                                variants.add(v);
                        }
                }
                productVariantsRepository.saveAll(variants);
        }

        // --- Init Data Methods ---

        private User initUsers() {
                Role adminRole = roleRepository.findByName("ROLE_ADMIN").orElseGet(() -> {
                        Role r = new Role();
                        r.setName("ROLE_ADMIN");
                        r.setStatus("active");
                        return roleRepository.save(r);
                });
                Role userRole = roleRepository.findByName("ROLE_USER").orElseGet(() -> {
                        Role r = new Role();
                        r.setName("ROLE_USER");
                        r.setStatus("active");
                        return roleRepository.save(r);
                });

                // Create john_doe user
                userRepository.findByUsername("john.doe").orElseGet(() -> {
                        User u = new User();
                        u.setUsername("john_doe");
                        u.setPassword(passwordEncoder.encode("password"));
                        u.setFullName("John Doe");
                        u.setEmail("john_doe@example.com");
                        u.setStatus("active");
                        u = userRepository.save(u);
                        UserRole ur = new UserRole();
                        ur.setUser(u);
                        ur.setRole(userRole);
                        ur.setStatus("active");
                        userRoleRepository.save(ur);
                        return u;
                });

                return userRepository.findByUsername("sys.admin").orElseGet(() -> {
                        User u = new User();
                        u.setUsername("sys.admin");
                        u.setPassword(passwordEncoder.encode("123456"));
                        u.setFullName("System Administrator");
                        u.setEmail("sys.admin@example.com");
                        u.setStatus("active");
                        u = userRepository.save(u);
                        UserRole ur = new UserRole();
                        ur.setUser(u);
                        ur.setRole(adminRole);
                        ur.setStatus("active");
                        userRoleRepository.save(ur);
                        return u;
                });
        }

        private Map<String, Size> initSizes() {
                Map<String, Size> map = new HashMap<>();
                String[] sizes = { "XXS", "XS", "S", "M", "L", "XL", "XXL", "3XL", "4XL", "5XL" };
                List<Size> list = new ArrayList<>();
                for (String s : sizes) {
                        Size size = new Size();
                        size.setSizeName(s);
                        size.setStatus("active");
                        list.add(size);
                }
                sizeRepository.saveAll(list).forEach(s -> map.put(s.getSizeName(), s));
                return map;
        }

        private Map<String, Material> initMaterials() {
                Map<String, Material> map = new HashMap<>();
                String[] materials = { "Cotton", "Wool", "Leather", "Polyester", "Silk", "Linen", "Denim" };
                List<Material> list = new ArrayList<>();
                for (String s : materials) {
                        Material m = new Material();
                        m.setMaterialName(s);
                        m.setStatus("active");
                        list.add(m);
                }
                materialRepository.saveAll(list).forEach(m -> map.put(m.getMaterialName(), m));
                return map;
        }

        private Map<String, Season> initSeasons() {
                Map<String, Season> map = new HashMap<>();
                String[] seasons = { "Spring", "Summer", "Autumn", "Winter" };
                List<Season> list = new ArrayList<>();
                for (String s : seasons) {
                        Season season = new Season();
                        season.setSeasonName(s);
                        season.setStatus("active");
                        list.add(season);
                }
                seasonRepository.saveAll(list).forEach(s -> map.put(s.getSeasonName(), s));
                return map;
        }

        private Map<String, Color> initColors() {
                Map<String, Color> map = new HashMap<>();
                List<Color> list = new ArrayList<>();

                // 1. Các màu cơ bản
                {
                        Color c = new Color();
                        c.setColorName("White");
                        c.setColorCode("#FFFFFF");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Black");
                        c.setColorCode("#000000");
                        c.setStatus("active");
                        list.add(c);
                }

                // 2. Các màu Material Design & Phổ biến
                {
                        Color c = new Color();
                        c.setColorName("Blue");
                        c.setColorCode("#2196F3");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Brown");
                        c.setColorCode("#795548");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Red");
                        c.setColorCode("#F44336");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Yellow");
                        c.setColorCode("#FFEB3B");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Indigo");
                        c.setColorCode("#3F51B5");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Grey");
                        c.setColorCode("#9E9E9E");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Pink");
                        c.setColorCode("#E91E63");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Green");
                        c.setColorCode("#4CAF50");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Orange");
                        c.setColorCode("#FF9800");
                        c.setStatus("active");
                        list.add(c);
                }

                // 3. Các màu đặc biệt (Tone trầm/nhạt)
                {
                        Color c = new Color();
                        c.setColorName("Navy");
                        c.setColorCode("#000080");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Burgundy");
                        c.setColorCode("#800020");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Beige");
                        c.setColorCode("#F5F5DC");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Tan");
                        c.setColorCode("#D2B48C");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Khaki");
                        c.setColorCode("#F0E68C");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Silver");
                        c.setColorCode("#C0C0C0");
                        c.setStatus("active");
                        list.add(c);
                }
                {
                        Color c = new Color();
                        c.setColorName("Olive");
                        c.setColorCode("#808000");
                        c.setStatus("active");
                        list.add(c);
                }

                // 4. Màu tùy chọn (Thường để mặc định hoặc null tùy logic frontend)
                {
                        Color c = new Color();
                        c.setColorName("Custom");
                        c.setColorCode("#000000");
                        c.setStatus("active");
                        list.add(c);
                }

                colorRepository.saveAll(list).forEach(c -> map.put(c.getColorName(), c));
                return map;
        }

        private Map<String, Category> initCategories() {
                Map<String, Category> map = new HashMap<>();
                List<Category> list = new ArrayList<>();
                {
                        Category cat = new Category();
                        cat.setName("Dresses");
                        cat.setDescription("Various products for Dresses");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/Dresses.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                {
                        Category cat = new Category();
                        cat.setName("Jackets");
                        cat.setDescription("Various products for Jackets");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/Jacket.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                {
                        Category cat = new Category();
                        cat.setName("Coats");
                        cat.setDescription("Various products for Coats");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/Coats.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                {
                        Category cat = new Category();
                        cat.setName("Shoe");
                        cat.setDescription("Various products for Shoe");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/Lingerie.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                {
                        Category cat = new Category();
                        cat.setName("New Products");
                        cat.setDescription("Various products for New Products");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/newProducts.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                {
                        Category cat = new Category();
                        cat.setName("Shirts");
                        cat.setDescription("Various products for Shirts");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/Shirts.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                {
                        Category cat = new Category();
                        cat.setName("Collections");
                        cat.setDescription("Various products for Collections");
                        cat.setImageUrl("http://10.0.2.2:8080/uploads/categories/Collections.png");
                        cat.setStatus("active");
                        list.add(cat);
                }
                categoryRepository.saveAll(list).forEach(c -> map.put(c.getName(), c));
                return map;
        }

        // --- Main Seed Method ---
        private void seedProducts(User admin, Map<String, Category> categoryMap, Map<String, Color> colorMap,
                        Map<String, Size> sizeMap, Map<String, Material> materialMap, Map<String, Season> seasonMap) {

                Product p;
                p = createProduct(admin, categoryMap.get("Dresses"), "Gap × DÔEN Eyelet Midi Dress",
                                "Description for Gap × DÔEN Eyelet Midi Dress",
                                "https://www1.assets-gap.com/webcontent/0059/167/062/cn59167062.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/167/046/cn59167046.jpg",
                                                "https://www.gap.com/webcontent/0059/370/023/cn59370023.jpg",
                                                "https://www.gap.com/webcontent/0059/370/012/cn59370012.jpg",
                                                "https://www.gap.com/webcontent/0059/166/696/cn59166696.jpg",
                                                "https://www.gap.com/webcontent/0059/398/713/cn59398713.jpg",
                                                "https://www.gap.com/webcontent/0059/398/714/cn59398714.jpg",
                                                "https://www.gap.com/webcontent/0059/353/083/cn59353083.jpg",
                                                "https://www.gap.com/webcontent/0059/437/053/cn59437053.jpg"));
                createVariants(p, List.of("White", "Black"), 158, 64.97, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim V-Neck Crepe Maxi Dress",
                                "Description for Lace-Trim V-Neck Crepe Maxi Dress",
                                "https://www1.assets-gap.com/webcontent/0060/139/770/cn60139770.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/139/746/cn60139746.jpg",
                                                "https://www.gap.com/webcontent/0060/139/763/cn60139763.jpg",
                                                "https://www.gap.com/webcontent/0060/139/764/cn60139764.jpg",
                                                "https://www.gap.com/webcontent/0060/139/766/cn60139766.jpg",
                                                "https://www.gap.com/webcontent/0059/854/774/cn59854774.jpg",
                                                "https://www.gap.com/webcontent/0059/854/778/cn59854778.jpg",
                                                "https://www.gap.com/webcontent/0059/733/862/cn59733862.jpg",
                                                "https://www.gap.com/webcontent/0059/763/192/cn59763192.jpg"));
                createVariants(p, List.of("Blue", "Brown", "Custom"), 118, 59, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Linen-Blend Mini Shift Dress",
                                "Description for Linen-Blend Mini Shift Dress",
                                "https://www1.assets-gap.com/webcontent/0060/128/432/cn60128432.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/128/427/cn60128427.jpg",
                                                "https://www.gap.com/webcontent/0060/128/439/cn60128439.jpg",
                                                "https://www.gap.com/webcontent/0060/128/443/cn60128443.jpg",
                                                "https://www.gap.com/webcontent/0060/131/331/cn60131331.jpg",
                                                "https://www.gap.com/webcontent/0060/997/682/cn60997682.jpg"));
                createVariants(p, List.of("White", "Brown", "Blue", "Red", "Custom"), 79.95, 24.97, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Boatneck Mini Shift Dress",
                                "Description for Boatneck Mini Shift Dress",
                                "https://www1.assets-gap.com/webcontent/0060/592/556/cn60592556.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/592/539/cn60592539.jpg",
                                                "https://www.gap.com/webcontent/0060/592/155/cn60592155.jpg",
                                                "https://www.gap.com/webcontent/0060/592/168/cn60592168.jpg",
                                                "https://www.gap.com/webcontent/0060/592/175/cn60592175.jpg",
                                                "https://www.gap.com/webcontent/0060/573/150/cn60573150.jpg"));
                createVariants(p, List.of("Black", "Red", "Black", "Brown"), 89.95, 69.99, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim V-Neck Maxi Dress",
                                "Description for Lace-Trim V-Neck Maxi Dress",
                                "https://www1.assets-gap.com/webcontent/0060/664/306/cn60664306.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/664/275/cn60664275.jpg",
                                                "https://www.gap.com/webcontent/0060/626/704/cn60626704.jpg",
                                                "https://www.gap.com/webcontent/0060/626/715/cn60626715.jpg",
                                                "https://www.gap.com/webcontent/0060/626/727/cn60626727.jpg",
                                                "https://www.gap.com/webcontent/0060/503/422/cn60503422.jpg"));
                createVariants(p, List.of("Brown", "Black"), 118, 89.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim Mini Dress",
                                "Description for Lace-Trim Mini Dress",
                                "https://www1.assets-gap.com/webcontent/0057/424/601/cn57424601.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/424/555/cn57424555.jpg",
                                                "https://www.gap.com/webcontent/0057/424/574/cn57424574.jpg",
                                                "https://www.gap.com/webcontent/0057/424/576/cn57424576.jpg",
                                                "https://www.gap.com/webcontent/0057/424/295/cn57424295.jpg",
                                                "https://www.gap.com/webcontent/0057/393/055/cn57393055.jpg",
                                                "https://www.gap.com/webcontent/0057/393/043/cn57393043.jpg",
                                                "https://www.gap.com/webcontent/0061/052/569/cn61052569.jpg"));
                createVariants(p, List.of("White"), 98, 39.97, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Linen-Blend Seamed Corset Midi Dress",
                                "Description for Linen-Blend Seamed Corset Midi Dress",
                                "https://www1.assets-gap.com/webcontent/0060/062/118/cn60062118.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/062/089/cn60062089.jpg",
                                                "https://www.gap.com/webcontent/0060/063/253/cn60063253.jpg",
                                                "https://www.gap.com/webcontent/0060/062/114/cn60062114.jpg",
                                                "https://www.gap.com/webcontent/0060/063/861/cn60063861.jpg",
                                                "https://www.gap.com/webcontent/0059/986/005/cn59986005.jpg",
                                                "https://www.gap.com/webcontent/0060/063/874/cn60063874.jpg"));
                createVariants(p, List.of("Brown", "Yellow"), 128, 44.97, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim Midi Dress",
                                "Description for Lace-Trim Midi Dress",
                                "https://www1.assets-gap.com/webcontent/0060/020/243/cn60020243.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/020/208/cn60020208.jpg",
                                                "https://www.gap.com/webcontent/0060/020/232/cn60020232.jpg",
                                                "https://www.gap.com/webcontent/0060/020/247/cn60020247.jpg",
                                                "https://www.gap.com/webcontent/0059/807/945/cn59807945.jpg",
                                                "https://www.gap.com/webcontent/0059/807/956/cn59807956.jpg"));
                createVariants(p, List.of("Indigo"), 118, 70, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Adult VintageSoft Arch Logo Zip Hoodie",
                                "Description for Adult VintageSoft Arch Logo Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0056/583/088/cn56583088.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/583/062/cn56583062.jpg",
                                                "https://www.gap.com/webcontent/0059/203/469/cn59203469.jpg",
                                                "https://www.gap.com/webcontent/0059/203/462/cn59203462.jpg",
                                                "https://www.gap.com/webcontent/0060/799/583/cn60799583.jpg",
                                                "https://www.gap.com/webcontent/0056/593/346/cn56593346.jpg",
                                                "https://www.gap.com/webcontent/0060/801/384/cn60801384.jpg"));
                createVariants(p, List.of("Black", "Black", "Grey", "Navy", "White"), 69.95, 55, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Adult VintageSoft Arch Logo Zip Hoodie",
                                "Description for Adult VintageSoft Arch Logo Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0056/735/643/cn56735643.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/735/615/cn56735615.jpg",
                                                "https://www.gap.com/webcontent/0059/202/459/cn59202459.jpg",
                                                "https://www.gap.com/webcontent/0057/982/137/cn57982137.jpg",
                                                "https://www.gap.com/webcontent/0057/982/144/cn57982144.jpg",
                                                "https://www.gap.com/webcontent/0057/982/060/cn57982060.jpg",
                                                "https://www.gap.com/webcontent/0057/982/102/cn57982102.jpg",
                                                "https://www.gap.com/webcontent/0056/679/822/cn56679822.jpg",
                                                "https://www.gap.com/webcontent/0057/031/198/cn57031198.jpg"));
                createVariants(p, List.of("Black", "Black", "Grey", "Navy", "White"), 69.95, 55, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Adult VintageSoft Arch Logo Zip Hoodie",
                                "Description for Adult VintageSoft Arch Logo Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0056/100/507/cn56100507.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/100/489/cn56100489.jpg",
                                                "https://www.gap.com/webcontent/0059/203/455/cn59203455.jpg",
                                                "https://www.gap.com/webcontent/0059/203/990/cn59203990.jpg",
                                                "https://www.gap.com/webcontent/0059/204/020/cn59204020.jpg",
                                                "https://www.gap.com/webcontent/0055/934/696/cn55934696.jpg",
                                                "https://www.gap.com/webcontent/0060/427/412/cn60427412.jpg"));
                createVariants(p, List.of("Black", "Black", "Grey", "Navy", "White"), 69.95, 55, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Adult VintageSoft Arch Logo Zip Hoodie",
                                "Description for Adult VintageSoft Arch Logo Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0057/694/900/cn57694900.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/694/895/cn57694895.jpg",
                                                "https://www.gap.com/webcontent/0059/203/572/cn59203572.jpg",
                                                "https://www.gap.com/webcontent/0059/203/565/cn59203565.jpg",
                                                "https://www.gap.com/webcontent/0057/699/994/cn57699994.jpg",
                                                "https://www.gap.com/webcontent/0057/699/660/cn57699660.jpg",
                                                "https://www.gap.com/webcontent/0060/427/419/cn60427419.jpg"));
                createVariants(p, List.of("Black", "Black", "Grey", "Navy", "White"), 69.95, 55, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Adult VintageSoft Arch Logo Zip Hoodie",
                                "Description for Adult VintageSoft Arch Logo Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0056/747/419/cn56747419.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/747/398/cn56747398.jpg",
                                                "https://www.gap.com/webcontent/0057/981/661/cn57981661.jpg",
                                                "https://www.gap.com/webcontent/0057/981/629/cn57981629.jpg",
                                                "https://www.gap.com/webcontent/0057/981/675/cn57981675.jpg",
                                                "https://www.gap.com/webcontent/0057/982/045/cn57982045.jpg",
                                                "https://www.gap.com/webcontent/0057/982/095/cn57982095.jpg",
                                                "https://www.gap.com/webcontent/0056/656/706/cn56656706.jpg",
                                                "https://www.gap.com/webcontent/0057/031/121/cn57031121.jpg"));
                createVariants(p, List.of("Black", "Black", "Grey", "Navy", "White"), 69.95, 55, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Kids VintageSoft Gap Arch Logo Hoodie",
                                "Description for Kids VintageSoft Gap Arch Logo Hoodie",
                                "https://www1.assets-gap.com/webcontent/0061/016/467/cn61016467.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/016/462/cn61016462.jpg",
                                                "https://www.gap.com/webcontent/0061/015/645/cn61015645.jpg",
                                                "https://www.gap.com/webcontent/0060/979/386/cn60979386.jpg",
                                                "https://www.gap.com/webcontent/0061/015/682/cn61015682.jpg"));
                createVariants(p, List.of("Blue", "Pink"), 54.95, 32, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "VintageSoft Crop Logo Hoodie",
                                "Description for VintageSoft Crop Logo Hoodie",
                                "https://www1.assets-gap.com/webcontent/0059/846/500/cn59846500.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/411/288/cn57411288.jpg",
                                                "https://www.gap.com/webcontent/0057/411/290/cn57411290.jpg",
                                                "https://www.gap.com/webcontent/0057/411/293/cn57411293.jpg",
                                                "https://www.gap.com/webcontent/0057/475/895/cn57475895.jpg"));
                createVariants(p, List.of("Black", "Black"), 69.95, 55, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Jackets"), "Kids Vintage Soft  Logo Zip Hoodie",
                                "Description for Kids Vintage Soft  Logo Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0057/010/159/cn57010159.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/010/128/cn57010128.jpg",
                                                "https://www.gap.com/webcontent/0056/976/963/cn56976963.jpg",
                                                "https://www.gap.com/webcontent/0056/976/964/cn56976964.jpg",
                                                "https://www.gap.com/webcontent/0056/827/822/cn56827822.jpg",
                                                "https://www.gap.com/webcontent/0056/842/735/cn56842735.jpg"));
                createVariants(p, List.of("Grey", "Navy", "Black"), 54.95, 43, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Belted Long Puffer Coat",
                                "Description for Belted Long Puffer Coat",
                                "https://www1.assets-gap.com/webcontent/0060/586/666/cn60586666.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/586/627/cn60586627.jpg",
                                                "https://www.gap.com/webcontent/0060/586/435/cn60586435.jpg",
                                                "https://www.gap.com/webcontent/0060/586/443/cn60586443.jpg",
                                                "https://www.gap.com/webcontent/0060/165/937/cn60165937.jpg",
                                                "https://www.gap.com/webcontent/0060/168/731/cn60168731.jpg"));
                createVariants(p, List.of("Brown", "Black"), 268, 160, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Chesterfield Coat",
                                "Description for Wool-Blend Chesterfield Coat",
                                "https://www1.assets-gap.com/webcontent/0060/567/250/cn60567250.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/567/218/cn60567218.jpg",
                                                "https://www.gap.com/webcontent/0060/567/018/cn60567018.jpg",
                                                "https://www.gap.com/webcontent/0060/567/048/cn60567048.jpg",
                                                "https://www.gap.com/webcontent/0060/425/799/cn60425799.jpg",
                                                "https://www.gap.com/webcontent/0060/427/303/cn60427303.jpg"));
                createVariants(p, List.of("Black", "Grey"), 248, 124, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Wrap Coat",
                                "Description for Wool-Blend Wrap Coat",
                                "https://www1.assets-gap.com/webcontent/0060/264/674/cn60264674.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/264/654/cn60264654.jpg",
                                                "https://www.gap.com/webcontent/0060/213/636/cn60213636.jpg",
                                                "https://www.gap.com/webcontent/0060/213/638/cn60213638.jpg",
                                                "https://www.gap.com/webcontent/0059/830/908/cn59830908.jpg",
                                                "https://www.gap.com/webcontent/0059/830/893/cn59830893.jpg"));
                createVariants(p, List.of("Black", "Burgundy"), 248, 198, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Wrap Coat",
                                "Description for Wool-Blend Wrap Coat",
                                "https://www1.assets-gap.com/webcontent/0060/772/404/cn60772404.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/772/353/cn60772353.jpg",
                                                "https://www.gap.com/webcontent/0060/772/379/cn60772379.jpg",
                                                "https://www.gap.com/webcontent/0060/772/348/cn60772348.jpg",
                                                "https://www.gap.com/webcontent/0060/868/713/cn60868713.jpg",
                                                "https://www.gap.com/webcontent/0060/239/258/cn60239258.jpg"));
                createVariants(p, List.of("Black", "Burgundy"), 248, 99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Midi Puffer Jacket",
                                "Description for Faux Fur-Trim Midi Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/608/526/cn60608526.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/608/503/cn60608503.jpg",
                                                "https://www.gap.com/webcontent/0060/608/274/cn60608274.jpg",
                                                "https://www.gap.com/webcontent/0060/608/278/cn60608278.jpg",
                                                "https://www.gap.com/webcontent/0060/168/709/cn60168709.jpg",
                                                "https://www.gap.com/webcontent/0060/168/711/cn60168711.jpg"));
                createVariants(p, List.of("Green", "Black"), 248, 99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Midi Puffer Jacket",
                                "Description for Faux Fur-Trim Midi Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/567/260/cn60567260.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/567/240/cn60567240.jpg",
                                                "https://www.gap.com/webcontent/0060/582/045/cn60582045.jpg",
                                                "https://www.gap.com/webcontent/0060/567/068/cn60567068.jpg",
                                                "https://www.gap.com/webcontent/0060/567/093/cn60567093.jpg",
                                                "https://www.gap.com/webcontent/0060/168/729/cn60168729.jpg"));
                createVariants(p, List.of("Green", "Black"), 248, 124, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Puffer Jacket",
                                "Description for Faux Fur-Trim Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/592/523/cn60592523.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/592/514/cn60592514.jpg",
                                                "https://www.gap.com/webcontent/0060/592/017/cn60592017.jpg",
                                                "https://www.gap.com/webcontent/0060/592/038/cn60592038.jpg",
                                                "https://www.gap.com/webcontent/0060/592/041/cn60592041.jpg",
                                                "https://www.gap.com/webcontent/0060/172/758/cn60172758.jpg"));
                createVariants(p, List.of("Brown", "Beige", "Brown", "Black"), 228, 114, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Chesterfield Coat",
                                "Description for Wool-Blend Chesterfield Coat",
                                "https://www1.assets-gap.com/webcontent/0060/577/355/cn60577355.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/577/263/cn60577263.jpg",
                                                "https://www.gap.com/webcontent/0060/577/267/cn60577267.jpg",
                                                "https://www.gap.com/webcontent/0060/577/290/cn60577290.jpg",
                                                "https://www.gap.com/webcontent/0060/596/991/cn60596991.jpg",
                                                "https://www.gap.com/webcontent/0060/586/459/cn60586459.jpg",
                                                "https://www.gap.com/webcontent/0061/315/133/cn61315133.jpg"));
                createVariants(p, List.of("Black", "Grey"), 248, 124, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Recycled Heavyweight Puffer Jacket",
                                "Description for Recycled Heavyweight Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/463/993/cn60463993.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/463/974/cn60463974.jpg",
                                                "https://www.gap.com/webcontent/0060/448/738/cn60448738.jpg",
                                                "https://www.gap.com/webcontent/0060/448/756/cn60448756.jpg",
                                                "https://www.gap.com/webcontent/0061/092/239/cn61092239.jpg",
                                                "https://www.gap.com/webcontent/0060/138/098/cn60138098.jpg"));
                createVariants(p, List.of("Brown", "Black", "Red", "Navy", "Green", "Custom"), 168, 134, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur Relaxed Zip Hoodie",
                                "Description for Faux Fur Relaxed Zip Hoodie",
                                "https://www1.assets-gap.com/webcontent/0061/459/159/cn61459159.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/459/152/cn61459152.jpg",
                                                "https://www.gap.com/webcontent/0061/453/322/cn61453322.jpg",
                                                "https://www.gap.com/webcontent/0061/453/342/cn61453342.jpg",
                                                "https://www.gap.com/webcontent/0061/453/377/cn61453377.jpg",
                                                "https://www.gap.com/webcontent/0061/453/349/cn61453349.jpg",
                                                "https://www.gap.com/webcontent/0061/247/992/cn61247992.jpg"));
                createVariants(p, List.of("Tan"), 268, 107, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Recycled Sherpa & Vegan Leather-Trim Jacket",
                                "Description for Recycled Sherpa & Vegan Leather-Trim Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/762/477/cn60762477.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/762/461/cn60762461.jpg",
                                                "https://www.gap.com/webcontent/0060/750/857/cn60750857.jpg",
                                                "https://www.gap.com/webcontent/0060/750/880/cn60750880.jpg",
                                                "https://www.gap.com/webcontent/0060/750/852/cn60750852.jpg",
                                                "https://www.gap.com/webcontent/0060/750/860/cn60750860.jpg",
                                                "https://www.gap.com/webcontent/0061/314/999/cn61314999.jpg"));
                createVariants(p, List.of("Beige", "Black"), 268, 268, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Belted Long Puffer Coat",
                                "Description for Belted Long Puffer Coat",
                                "https://www1.assets-gap.com/webcontent/0060/567/324/cn60567324.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/567/313/cn60567313.jpg",
                                                "https://www.gap.com/webcontent/0060/567/033/cn60567033.jpg",
                                                "https://www.gap.com/webcontent/0060/567/069/cn60567069.jpg",
                                                "https://www.gap.com/webcontent/0060/567/101/cn60567101.jpg",
                                                "https://www.gap.com/webcontent/0060/251/412/cn60251412.jpg"));
                createVariants(p, List.of("Brown", "Black"), 268, 160, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Icon Trench Coat",
                                "Description for Icon Trench Coat",
                                "https://www1.assets-gap.com/webcontent/0059/564/240/cn59564240.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/564/235/cn59564235.jpg",
                                                "https://www.gap.com/webcontent/0059/564/096/cn59564096.jpg",
                                                "https://www.gap.com/webcontent/0059/564/089/cn59564089.jpg",
                                                "https://www.gap.com/webcontent/0057/936/094/cn57936094.jpg",
                                                "https://www.gap.com/webcontent/0053/613/595/cn53613595.jpg",
                                                "https://www.gap.com/webcontent/0053/670/874/cn53670874.jpg",
                                                "https://www.gap.com/webcontent/0058/044/824/cn58044824.jpg",
                                                "https://www.gap.com/webcontent/0060/013/833/cn60013833.jpg"));
                createVariants(p, List.of("Khaki", "Black"), 168, 168, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Puffer Jacket",
                                "Description for Faux Fur-Trim Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/567/252/cn60567252.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/567/222/cn60567222.jpg",
                                                "https://www.gap.com/webcontent/0060/567/032/cn60567032.jpg",
                                                "https://www.gap.com/webcontent/0060/567/054/cn60567054.jpg",
                                                "https://www.gap.com/webcontent/0060/567/080/cn60567080.jpg",
                                                "https://www.gap.com/webcontent/0060/172/573/cn60172573.jpg"));
                createVariants(p, List.of("Brown", "Beige", "Brown", "Black"), 228, 136, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Icon Trench Coat",
                                "Description for Icon Trench Coat",
                                "https://www1.assets-gap.com/webcontent/0059/989/478/cn59989478.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/989/467/cn59989467.jpg",
                                                "https://www.gap.com/webcontent/0060/015/389/cn60015389.jpg",
                                                "https://www.gap.com/webcontent/0059/987/954/cn59987954.jpg",
                                                "https://www.gap.com/webcontent/0059/987/956/cn59987956.jpg",
                                                "https://www.gap.com/webcontent/0059/647/943/cn59647943.jpg"));
                createVariants(p, List.of("Khaki", "Black"), 168, 134, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Puffer Jacket",
                                "Description for Faux Fur-Trim Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/577/271/cn60577271.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/577/260/cn60577260.jpg",
                                                "https://www.gap.com/webcontent/0060/577/289/cn60577289.jpg",
                                                "https://www.gap.com/webcontent/0060/577/305/cn60577305.jpg",
                                                "https://www.gap.com/webcontent/0060/173/149/cn60173149.jpg",
                                                "https://www.gap.com/webcontent/0060/172/568/cn60172568.jpg"));
                createVariants(p, List.of("Brown", "Beige", "Brown", "Black"), 228, 114, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Kids Quilted Puffer Coat",
                                "Description for Kids Quilted Puffer Coat",
                                "https://www1.assets-gap.com/webcontent/0060/781/571/cn60781571.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/781/545/cn60781545.jpg",
                                                "https://www.gap.com/webcontent/0059/971/430/cn59971430.jpg",
                                                "https://www.gap.com/webcontent/0060/781/578/cn60781578.jpg",
                                                "https://www.gap.com/webcontent/0060/781/651/cn60781651.jpg",
                                                "https://www.gap.com/webcontent/0059/971/406/cn59971406.jpg",
                                                "https://www.gap.com/webcontent/0060/781/683/cn60781683.jpg"));
                createVariants(p, List.of("Black", "Silver", "Pink"), 148, 59, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"),
                                "Recycled Lightweight Oversized Quilted Liner Jacket",
                                "Description for Recycled Lightweight Oversized Quilted Liner Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/221/914/cn60221914.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/221/884/cn60221884.jpg",
                                                "https://www.gap.com/webcontent/0060/221/893/cn60221893.jpg",
                                                "https://www.gap.com/webcontent/0060/221/905/cn60221905.jpg",
                                                "https://www.gap.com/webcontent/0060/221/919/cn60221919.jpg",
                                                "https://www.gap.com/webcontent/0060/771/997/cn60771997.jpg",
                                                "https://www.gap.com/webcontent/0060/772/018/cn60772018.jpg"));
                createVariants(p, List.of("Black", "Green"), 168, 54.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Recycled Sherpa & Vegan Leather-Trim Jacket",
                                "Description for Recycled Sherpa & Vegan Leather-Trim Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/844/948/cn60844948.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/844/929/cn60844929.jpg",
                                                "https://www.gap.com/webcontent/0060/845/109/cn60845109.jpg",
                                                "https://www.gap.com/webcontent/0060/845/119/cn60845119.jpg",
                                                "https://www.gap.com/webcontent/0060/881/851/cn60881851.jpg",
                                                "https://www.gap.com/webcontent/0060/636/919/cn60636919.jpg"));
                createVariants(p, List.of("Beige", "Black"), 268, 160, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Puffer Jacket",
                                "Description for Faux Fur-Trim Puffer Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/603/814/cn60603814.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/603/801/cn60603801.jpg",
                                                "https://www.gap.com/webcontent/0060/601/976/cn60601976.jpg",
                                                "https://www.gap.com/webcontent/0060/601/979/cn60601979.jpg",
                                                "https://www.gap.com/webcontent/0060/173/055/cn60173055.jpg",
                                                "https://www.gap.com/webcontent/0060/172/574/cn60172574.jpg"));
                createVariants(p, List.of("Brown", "Beige", "Brown", "Black"), 228, 114, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Cotton-Blend Cardigan Coat",
                                "Description for Cotton-Blend Cardigan Coat",
                                "https://www1.assets-gap.com/webcontent/0061/253/076/cn61253076.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/253/071/cn61253071.jpg",
                                                "https://www.gap.com/webcontent/0061/211/165/cn61211165.jpg",
                                                "https://www.gap.com/webcontent/0061/211/176/cn61211176.jpg",
                                                "https://www.gap.com/webcontent/0061/211/193/cn61211193.jpg",
                                                "https://www.gap.com/webcontent/0061/211/211/cn61211211.jpg"));
                createVariants(p, List.of("Blue", "Brown"), 168, 168, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Swing Jacket",
                                "Description for Wool-Blend Swing Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/432/123/cn60432123.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/432/100/cn60432100.jpg",
                                                "https://www.gap.com/webcontent/0060/431/001/cn60431001.jpg",
                                                "https://www.gap.com/webcontent/0060/432/442/cn60432442.jpg",
                                                "https://www.gap.com/webcontent/0060/432/466/cn60432466.jpg",
                                                "https://www.gap.com/webcontent/0060/431/016/cn60431016.jpg"));
                createVariants(p, List.of("Blue", "Tan"), 228, 114, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur Bomber Jacket",
                                "Description for Faux Fur Bomber Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/891/367/cn60891367.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/891/323/cn60891323.jpg",
                                                "https://www.gap.com/webcontent/0060/891/325/cn60891325.jpg",
                                                "https://www.gap.com/webcontent/0060/891/329/cn60891329.jpg",
                                                "https://www.gap.com/webcontent/0060/415/513/cn60415513.jpg",
                                                "https://www.gap.com/webcontent/0060/922/398/cn60922398.jpg",
                                                "https://www.gap.com/webcontent/0060/472/116/cn60472116.jpg"));
                createVariants(p, List.of("Brown"), 198, 198, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Vegan Leather Bomber Jacket",
                                "Description for Vegan Leather Bomber Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/264/759/cn60264759.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/264/725/cn60264725.jpg",
                                                "https://www.gap.com/webcontent/0060/264/735/cn60264735.jpg",
                                                "https://www.gap.com/webcontent/0060/264/738/cn60264738.jpg",
                                                "https://www.gap.com/webcontent/0060/264/752/cn60264752.jpg",
                                                "https://www.gap.com/webcontent/0059/831/071/cn59831071.jpg"));
                createVariants(p, List.of("Black"), 198, 79, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Cropped Floral Denim Icon Jacket",
                                "Description for Cropped Floral Denim Icon Jacket",
                                "https://www1.assets-gap.com/webcontent/0057/694/839/cn57694839.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/694/794/cn57694794.jpg",
                                                "https://www.gap.com/webcontent/0057/699/872/cn57699872.jpg",
                                                "https://www.gap.com/webcontent/0057/699/865/cn57699865.jpg",
                                                "https://www.gap.com/webcontent/0057/730/137/cn57730137.jpg",
                                                "https://www.gap.com/webcontent/0057/730/138/cn57730138.jpg"));
                createVariants(p, List.of("Custom", "Blue", "Indigo"), 98, 29.99, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Oversized Houndstooth Car Coat",
                                "Description for Wool-Blend Oversized Houndstooth Car Coat",
                                "https://www1.assets-gap.com/webcontent/0060/240/246/cn60240246.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/240/176/cn60240176.jpg",
                                                "https://www.gap.com/webcontent/0060/238/566/cn60238566.jpg",
                                                "https://www.gap.com/webcontent/0060/238/575/cn60238575.jpg",
                                                "https://www.gap.com/webcontent/0060/238/588/cn60238588.jpg",
                                                "https://www.gap.com/webcontent/0060/238/676/cn60238676.jpg"));
                createVariants(p, List.of("Tan"), 268, 199.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"), "UltraSoft Denim Stripe Cropped Icon Jacket",
                                "Description for UltraSoft Denim Stripe Cropped Icon Jacket",
                                "https://www1.assets-gap.com/webcontent/0057/299/740/cn57299740.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/299/729/cn57299729.jpg",
                                                "https://www.gap.com/webcontent/0057/298/994/cn57298994.jpg",
                                                "https://www.gap.com/webcontent/0057/298/985/cn57298985.jpg",
                                                "https://www.gap.com/webcontent/0057/512/440/cn57512440.jpg",
                                                "https://www.gap.com/webcontent/0057/512/834/cn57512834.jpg"));
                createVariants(p, List.of("Custom", "Blue", "Indigo"), 89.95, 29.99, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Coats"),
                                "Gap × Sandy Liang Reversible Vegan Leather Sherpa Jacket",
                                "Description for Gap × Sandy Liang Reversible Vegan Leather Sherpa Jacket",
                                "https://www1.assets-gap.com/webcontent/0060/514/334/cn60514334.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/514/312/cn60514312.jpg",
                                                "https://www.gap.com/webcontent/0060/769/667/cn60769667.jpg",
                                                "https://www.gap.com/webcontent/0060/769/660/cn60769660.jpg",
                                                "https://www.gap.com/webcontent/0060/660/995/cn60660995.jpg",
                                                "https://www.gap.com/webcontent/0060/659/758/cn60659758.jpg",
                                                "https://www.gap.com/webcontent/0060/671/244/cn60671244.jpg",
                                                "https://www.gap.com/webcontent/0060/674/641/cn60674641.jpg"));
                createVariants(p, List.of("Brown"), 268, 149.97, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Patent Leather Heels",
                                "Description for Vegan Patent Leather Heels",
                                "https://www1.assets-gap.com/webcontent/0060/139/423/cn60139423.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/139/404/cn60139404.jpg",
                                                "https://www.gap.com/webcontent/0060/137/897/cn60137897.jpg",
                                                "https://www.gap.com/webcontent/0060/137/905/cn60137905.jpg",
                                                "https://www.gap.com/webcontent/0060/137/907/cn60137907.jpg",
                                                "https://www.gap.com/webcontent/0060/137/919/cn60137919.jpg"));
                createVariants(p, List.of("Black"), 69.95, 27, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Loafers",
                                "Description for Vegan Suede Loafers",
                                "https://www1.assets-gap.com/webcontent/0059/680/145/cn59680145.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/680/110/cn59680110.jpg",
                                                "https://www.gap.com/webcontent/0059/679/382/cn59679382.jpg",
                                                "https://www.gap.com/webcontent/0059/679/391/cn59679391.jpg",
                                                "https://www.gap.com/webcontent/0059/679/392/cn59679392.jpg",
                                                "https://www.gap.com/webcontent/0059/679/426/cn59679426.jpg"));
                createVariants(p, List.of("Brown", "Black"), 59.95, 44.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Mary Jane Flats",
                                "Description for Mary Jane Flats",
                                "https://www1.assets-gap.com/webcontent/0060/021/611/cn60021611.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/021/605/cn60021605.jpg",
                                                "https://www.gap.com/webcontent/0060/049/917/cn60049917.jpg",
                                                "https://www.gap.com/webcontent/0060/024/265/cn60024265.jpg",
                                                "https://www.gap.com/webcontent/0060/024/278/cn60024278.jpg",
                                                "https://www.gap.com/webcontent/0060/029/502/cn60029502.jpg"));
                createVariants(p, List.of("Black", "Blue"), 54.95, 21, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Boots",
                                "Description for Kitten Heel Pointy Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/494/cn60427494.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/485/cn60427485.jpg",
                                                "https://www.gap.com/webcontent/0060/425/112/cn60425112.jpg",
                                                "https://www.gap.com/webcontent/0060/425/205/cn60425205.jpg",
                                                "https://www.gap.com/webcontent/0060/427/534/cn60427534.jpg",
                                                "https://www.gap.com/webcontent/0060/425/332/cn60425332.jpg"));
                createVariants(p, List.of("Black", "Brown", "Burgundy"), 98, 39, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Loafers",
                                "Description for Vegan Suede Loafers",
                                "https://www1.assets-gap.com/webcontent/0060/127/074/cn60127074.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/127/054/cn60127054.jpg",
                                                "https://www.gap.com/webcontent/0060/124/055/cn60124055.jpg",
                                                "https://www.gap.com/webcontent/0060/124/089/cn60124089.jpg",
                                                "https://www.gap.com/webcontent/0060/124/095/cn60124095.jpg",
                                                "https://www.gap.com/webcontent/0060/124/120/cn60124120.jpg"));
                createVariants(p, List.of("Brown", "Black"), 59.95, 44.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Ballet Flats",
                                "Description for Vegan Suede Ballet Flats",
                                "https://www1.assets-gap.com/webcontent/0060/234/428/cn60234428.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/234/416/cn60234416.jpg",
                                                "https://www.gap.com/webcontent/0060/233/085/cn60233085.jpg",
                                                "https://www.gap.com/webcontent/0060/233/106/cn60233106.jpg",
                                                "https://www.gap.com/webcontent/0060/233/112/cn60233112.jpg",
                                                "https://www.gap.com/webcontent/0060/233/129/cn60233129.jpg"));
                createVariants(p, List.of("Blue", "Brown", "Brown"), 59.95, 39.99, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Slingback Kitten Heels",
                                "Description for Slingback Kitten Heels",
                                "https://www1.assets-gap.com/webcontent/0059/662/302/cn59662302.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/662/293/cn59662293.jpg",
                                                "https://www.gap.com/webcontent/0059/662/021/cn59662021.jpg",
                                                "https://www.gap.com/webcontent/0059/662/048/cn59662048.jpg",
                                                "https://www.gap.com/webcontent/0059/662/062/cn59662062.jpg",
                                                "https://www.gap.com/webcontent/0059/662/098/cn59662098.jpg"));
                createVariants(p, List.of("Black", "Brown", "Custom"), 69.95, 34, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Mary Jane Flats",
                                "Description for Mary Jane Flats",
                                "https://www1.assets-gap.com/webcontent/0060/159/572/cn60159572.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/159/545/cn60159545.jpg",
                                                "https://www.gap.com/webcontent/0060/158/506/cn60158506.jpg",
                                                "https://www.gap.com/webcontent/0060/158/518/cn60158518.jpg",
                                                "https://www.gap.com/webcontent/0060/158/523/cn60158523.jpg",
                                                "https://www.gap.com/webcontent/0060/185/583/cn60185583.jpg"));
                createVariants(p, List.of("Black", "Blue"), 54.95, 21, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Leather Riding Boots",
                                "Description for Vegan Leather Riding Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/538/cn60427538.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/529/cn60427529.jpg",
                                                "https://www.gap.com/webcontent/0060/425/192/cn60425192.jpg",
                                                "https://www.gap.com/webcontent/0060/425/194/cn60425194.jpg",
                                                "https://www.gap.com/webcontent/0060/425/239/cn60425239.jpg",
                                                "https://www.gap.com/webcontent/0060/425/297/cn60425297.jpg"));
                createVariants(p, List.of("Black"), 110, 44, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Ballet Flats",
                                "Description for Vegan Suede Ballet Flats",
                                "https://www1.assets-gap.com/webcontent/0059/672/374/cn59672374.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/672/365/cn59672365.jpg",
                                                "https://www.gap.com/webcontent/0059/669/951/cn59669951.jpg",
                                                "https://www.gap.com/webcontent/0059/763/101/cn59763101.jpg",
                                                "https://www.gap.com/webcontent/0059/669/967/cn59669967.jpg",
                                                "https://www.gap.com/webcontent/0059/669/969/cn59669969.jpg"));
                createVariants(p, List.of("Blue", "Brown", "Brown"), 59.95, 19.99, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Knee High Boots",
                                "Description for Kitten Heel Pointy Knee High Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/467/cn60427467.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/460/cn60427460.jpg",
                                                "https://www.gap.com/webcontent/0060/425/101/cn60425101.jpg",
                                                "https://www.gap.com/webcontent/0060/425/154/cn60425154.jpg",
                                                "https://www.gap.com/webcontent/0060/425/252/cn60425252.jpg",
                                                "https://www.gap.com/webcontent/0060/425/347/cn60425347.jpg"));
                createVariants(p, List.of("Black", "Brown"), 118, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Sherpa Slippers",
                                "Description for Sherpa Slippers",
                                "https://www1.assets-gap.com/webcontent/0060/377/447/cn60377447.jpg?q=h&w=1152", null);
                createVariants(p, List.of("Brown"), 39.95, 15, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Leather Lug Sole Tall Boots",
                                "Description for Vegan Leather Lug Sole Tall Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/517/cn60427517.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/506/cn60427506.jpg",
                                                "https://www.gap.com/webcontent/0060/425/184/cn60425184.jpg",
                                                "https://www.gap.com/webcontent/0060/425/221/cn60425221.jpg",
                                                "https://www.gap.com/webcontent/0060/425/274/cn60425274.jpg",
                                                "https://www.gap.com/webcontent/0060/427/127/cn60427127.jpg"));
                createVariants(p, List.of("Brown", "Black"), 118, 59, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Faux Fur Slippers",
                                "Description for Faux Fur Slippers",
                                "https://www1.assets-gap.com/webcontent/0060/498/266/cn60498266.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/498/261/cn60498261.jpg",
                                                "https://www.gap.com/webcontent/0060/498/274/cn60498274.jpg",
                                                "https://www.gap.com/webcontent/0060/498/293/cn60498293.jpg",
                                                "https://www.gap.com/webcontent/0060/498/309/cn60498309.jpg",
                                                "https://www.gap.com/webcontent/0060/498/322/cn60498322.jpg"));
                createVariants(p, List.of("Black", "Brown"), 49.95, 19, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kids Moc Sneakers",
                                "Description for Kids Moc Sneakers",
                                "https://www1.assets-gap.com/webcontent/0057/143/685/cn57143685.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/143/680/cn57143680.jpg",
                                                "https://www.gap.com/webcontent/0057/143/025/cn57143025.jpg",
                                                "https://www.gap.com/webcontent/0057/143/074/cn57143074.jpg",
                                                "https://www.gap.com/webcontent/0057/143/065/cn57143065.jpg",
                                                "https://www.gap.com/webcontent/0057/143/075/cn57143075.jpg"));
                createVariants(p, List.of("Custom", "Custom"), 44.95, 19.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Slingback Kitten Heels",
                                "Description for Slingback Kitten Heels",
                                "https://www1.assets-gap.com/webcontent/0059/662/324/cn59662324.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/662/314/cn59662314.jpg",
                                                "https://www.gap.com/webcontent/0059/662/050/cn59662050.jpg",
                                                "https://www.gap.com/webcontent/0059/662/056/cn59662056.jpg",
                                                "https://www.gap.com/webcontent/0059/662/082/cn59662082.jpg",
                                                "https://www.gap.com/webcontent/0059/662/104/cn59662104.jpg"));
                createVariants(p, List.of("Black", "Brown", "Custom"), 69.95, 34, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Buckle Cork Sandals",
                                "Description for Toddler Buckle Cork Sandals",
                                "https://www1.assets-gap.com/webcontent/0057/324/034/cn57324034.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/324/025/cn57324025.jpg",
                                                "https://www.gap.com/webcontent/0057/324/048/cn57324048.jpg",
                                                "https://www.gap.com/webcontent/0057/322/798/cn57322798.jpg",
                                                "https://www.gap.com/webcontent/0057/324/051/cn57324051.jpg",
                                                "https://www.gap.com/webcontent/0057/324/059/cn57324059.jpg"));
                createVariants(p, List.of("Blue", "Green"), 34.95, 14.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Slingback Kitten Heels",
                                "Description for Slingback Kitten Heels",
                                "https://www1.assets-gap.com/webcontent/0059/662/315/cn59662315.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/662/305/cn59662305.jpg",
                                                "https://www.gap.com/webcontent/0059/662/029/cn59662029.jpg",
                                                "https://www.gap.com/webcontent/0059/662/053/cn59662053.jpg",
                                                "https://www.gap.com/webcontent/0059/662/057/cn59662057.jpg",
                                                "https://www.gap.com/webcontent/0059/662/094/cn59662094.jpg"));
                createVariants(p, List.of("Black", "Brown", "Custom"), 69.95, 27, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kids Canvas Strap Sandals",
                                "Description for Kids Canvas Strap Sandals",
                                "https://www1.assets-gap.com/webcontent/0057/611/558/cn57611558.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/611/551/cn57611551.jpg",
                                                "https://www.gap.com/webcontent/0057/609/778/cn57609778.jpg",
                                                "https://www.gap.com/webcontent/0057/609/787/cn57609787.jpg",
                                                "https://www.gap.com/webcontent/0057/609/790/cn57609790.jpg",
                                                "https://www.gap.com/webcontent/0057/609/789/cn57609789.jpg"));
                createVariants(p, List.of("Custom", "Custom"), 39.95, 12.97, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Denim Mary Jane Flats",
                                "Description for Denim Mary Jane Flats",
                                "https://www1.assets-gap.com/webcontent/0057/610/985/cn57610985.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/610/976/cn57610976.jpg",
                                                "https://www.gap.com/webcontent/0057/609/175/cn57609175.jpg",
                                                "https://www.gap.com/webcontent/0057/609/183/cn57609183.jpg",
                                                "https://www.gap.com/webcontent/0057/609/189/cn57609189.jpg",
                                                "https://www.gap.com/webcontent/0057/609/198/cn57609198.jpg"));
                createVariants(p, List.of("Blue"), 54.95, 32, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Ballet Flats",
                                "Description for Vegan Suede Ballet Flats",
                                "https://www1.assets-gap.com/webcontent/0060/234/438/cn60234438.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/234/424/cn60234424.jpg",
                                                "https://www.gap.com/webcontent/0060/233/093/cn60233093.jpg",
                                                "https://www.gap.com/webcontent/0060/233/108/cn60233108.jpg",
                                                "https://www.gap.com/webcontent/0060/233/128/cn60233128.jpg",
                                                "https://www.gap.com/webcontent/0060/233/133/cn60233133.jpg"));
                createVariants(p, List.of("Blue", "Brown", "Brown"), 59.95, 39.99, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kids T-Strap Loafers",
                                "Description for Kids T-Strap Loafers",
                                "https://www1.assets-gap.com/webcontent/0059/672/467/cn59672467.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/672/462/cn59672462.jpg",
                                                "https://www.gap.com/webcontent/0059/670/460/cn59670460.jpg",
                                                "https://www.gap.com/webcontent/0059/670/467/cn59670467.jpg",
                                                "https://www.gap.com/webcontent/0059/670/482/cn59670482.jpg",
                                                "https://www.gap.com/webcontent/0059/670/530/cn59670530.jpg"));
                createVariants(p, List.of("Burgundy", "Black"), 49.95, 49.95, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Leather Lug Sole Tall Boots",
                                "Description for Vegan Leather Lug Sole Tall Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/520/cn60427520.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/510/cn60427510.jpg",
                                                "https://www.gap.com/webcontent/0060/425/186/cn60425186.jpg",
                                                "https://www.gap.com/webcontent/0060/425/254/cn60425254.jpg",
                                                "https://www.gap.com/webcontent/0060/425/289/cn60425289.jpg",
                                                "https://www.gap.com/webcontent/0060/427/143/cn60427143.jpg"));
                createVariants(p, List.of("Brown", "Black"), 118, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Corduroy Mary Jane Flats",
                                "Description for Toddler Corduroy Mary Jane Flats",
                                "https://www1.assets-gap.com/webcontent/0059/961/171/cn59961171.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/961/151/cn59961151.jpg",
                                                "https://www.gap.com/webcontent/0059/959/519/cn59959519.jpg",
                                                "https://www.gap.com/webcontent/0059/959/518/cn59959518.jpg",
                                                "https://www.gap.com/webcontent/0059/959/556/cn59959556.jpg",
                                                "https://www.gap.com/webcontent/0059/959/568/cn59959568.jpg"));
                createVariants(p, List.of("Red", "Pink", "Custom"), 39.95, 19, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Boots",
                                "Description for Kitten Heel Pointy Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/479/cn60427479.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/474/cn60427474.jpg",
                                                "https://www.gap.com/webcontent/0060/425/156/cn60425156.jpg",
                                                "https://www.gap.com/webcontent/0060/425/167/cn60425167.jpg",
                                                "https://www.gap.com/webcontent/0060/425/268/cn60425268.jpg",
                                                "https://www.gap.com/webcontent/0060/425/331/cn60425331.jpg"));
                createVariants(p, List.of("Black", "Brown", "Burgundy"), 98, 39, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kids Studded Mary Jane Flats",
                                "Description for Kids Studded Mary Jane Flats",
                                "https://www1.assets-gap.com/webcontent/0059/672/498/cn59672498.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/672/488/cn59672488.jpg",
                                                "https://www.gap.com/webcontent/0059/679/736/cn59679736.jpg",
                                                "https://www.gap.com/webcontent/0059/670/480/cn59670480.jpg",
                                                "https://www.gap.com/webcontent/0059/670/528/cn59670528.jpg",
                                                "https://www.gap.com/webcontent/0059/670/541/cn59670541.jpg"));
                createVariants(p, List.of("Black"), 44.95, 22, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Jelly Ballet Flats",
                                "Description for Jelly Ballet Flats",
                                "https://www1.assets-gap.com/webcontent/0058/008/111/cn58008111.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0058/008/104/cn58008104.jpg",
                                                "https://www.gap.com/webcontent/0058/007/301/cn58007301.jpg",
                                                "https://www.gap.com/webcontent/0058/007/311/cn58007311.jpg",
                                                "https://www.gap.com/webcontent/0058/007/319/cn58007319.jpg",
                                                "https://www.gap.com/webcontent/0058/007/320/cn58007320.jpg"));
                createVariants(p, List.of("Custom", "Pink", "Blue"), 49.95, 16.97, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Knee High Boots",
                                "Description for Kitten Heel Pointy Knee High Boots",
                                "https://www1.assets-gap.com/webcontent/0060/427/456/cn60427456.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/427/451/cn60427451.jpg",
                                                "https://www.gap.com/webcontent/0060/425/070/cn60425070.jpg",
                                                "https://www.gap.com/webcontent/0060/425/147/cn60425147.jpg",
                                                "https://www.gap.com/webcontent/0060/425/253/cn60425253.jpg",
                                                "https://www.gap.com/webcontent/0060/425/246/cn60425246.jpg"));
                createVariants(p, List.of("Black", "Brown"), 118, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kids Corduroy Sneakers",
                                "Description for Kids Corduroy Sneakers",
                                "https://www1.assets-gap.com/webcontent/0059/698/921/cn59698921.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/698/911/cn59698911.jpg",
                                                "https://www.gap.com/webcontent/0059/697/790/cn59697790.jpg",
                                                "https://www.gap.com/webcontent/0059/697/800/cn59697800.jpg",
                                                "https://www.gap.com/webcontent/0059/697/803/cn59697803.jpg",
                                                "https://www.gap.com/webcontent/0059/697/831/cn59697831.jpg"));
                createVariants(p, List.of("Red", "Green"), 49.95, 19, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Denim Clogs",
                                "Description for Toddler Denim Clogs",
                                "https://www1.assets-gap.com/webcontent/0060/159/685/cn60159685.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/159/662/cn60159662.jpg",
                                                "https://www.gap.com/webcontent/0060/162/255/cn60162255.jpg",
                                                "https://www.gap.com/webcontent/0060/162/262/cn60162262.jpg",
                                                "https://www.gap.com/webcontent/0060/158/687/cn60158687.jpg",
                                                "https://www.gap.com/webcontent/0060/158/690/cn60158690.jpg"));
                createVariants(p, List.of("Custom"), 34.95, 13, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Kids Bow Ankle Boots",
                                "Description for Kids Bow Ankle Boots",
                                "https://www1.assets-gap.com/webcontent/0060/416/273/cn60416273.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/416/259/cn60416259.jpg",
                                                "https://www.gap.com/webcontent/0060/415/353/cn60415353.jpg",
                                                "https://www.gap.com/webcontent/0060/415/368/cn60415368.jpg",
                                                "https://www.gap.com/webcontent/0060/415/370/cn60415370.jpg",
                                                "https://www.gap.com/webcontent/0060/415/379/cn60415379.jpg"));
                createVariants(p, List.of("Red"), 59.95, 29, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Jelly Flower Sandals",
                                "Description for Toddler Jelly Flower Sandals",
                                "https://www1.assets-gap.com/webcontent/0057/333/304/cn57333304.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/333/298/cn57333298.jpg",
                                                "https://www.gap.com/webcontent/0057/333/306/cn57333306.jpg",
                                                "https://www.gap.com/webcontent/0057/333/317/cn57333317.jpg",
                                                "https://www.gap.com/webcontent/0057/333/344/cn57333344.jpg",
                                                "https://www.gap.com/webcontent/0057/333/348/cn57333348.jpg"));
                createVariants(p, List.of("Custom"), 29.95, 12.97, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0059/151/338/cn59151338.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/151/311/cn59151311.jpg",
                                                "https://www.gap.com/webcontent/0059/151/387/cn59151387.jpg",
                                                "https://www.gap.com/webcontent/0059/151/074/cn59151074.jpg",
                                                "https://www.gap.com/webcontent/0059/151/339/cn59151339.jpg",
                                                "https://www.gap.com/webcontent/0053/450/970/cn53450970.jpg",
                                                "https://www.gap.com/webcontent/0053/426/050/cn53426050.jpg",
                                                "https://www.gap.com/webcontent/0059/127/143/cn59127143.jpg",
                                                "https://www.gap.com/webcontent/0060/825/655/cn60825655.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0061/333/022/cn61333022.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/332/978/cn61332978.jpg",
                                                "https://www.gap.com/webcontent/0061/332/999/cn61332999.jpg",
                                                "https://www.gap.com/webcontent/0061/333/007/cn61333007.jpg",
                                                "https://www.gap.com/webcontent/0061/332/982/cn61332982.jpg",
                                                "https://www.gap.com/webcontent/0061/333/011/cn61333011.jpg",
                                                "https://www.gap.com/webcontent/0060/824/371/cn60824371.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0060/601/842/cn60601842.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/601/826/cn60601826.jpg",
                                                "https://www.gap.com/webcontent/0059/356/197/cn59356197.jpg",
                                                "https://www.gap.com/webcontent/0060/601/837/cn60601837.jpg",
                                                "https://www.gap.com/webcontent/0060/719/961/cn60719961.jpg",
                                                "https://www.gap.com/webcontent/0059/434/651/cn59434651.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                59.95, 29, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Joggers",
                                "Description for High Rise VintageSoft Joggers",
                                "https://www1.assets-gap.com/webcontent/0060/149/766/cn60149766.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/149/755/cn60149755.jpg",
                                                "https://www.gap.com/webcontent/0060/147/266/cn60147266.jpg",
                                                "https://www.gap.com/webcontent/0060/147/265/cn60147265.jpg",
                                                "https://www.gap.com/webcontent/0060/147/278/cn60147278.jpg",
                                                "https://www.gap.com/webcontent/0059/708/980/cn59708980.jpg",
                                                "https://www.gap.com/webcontent/0059/708/973/cn59708973.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                49.95, 24, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0060/135/414/cn60135414.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/135/409/cn60135409.jpg",
                                                "https://www.gap.com/webcontent/0060/135/422/cn60135422.jpg",
                                                "https://www.gap.com/webcontent/0060/135/428/cn60135428.jpg",
                                                "https://www.gap.com/webcontent/0059/583/948/cn59583948.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                49.95, 34.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0056/377/953/cn56377953.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/377/940/cn56377940.jpg",
                                                "https://www.gap.com/webcontent/0056/377/715/cn56377715.jpg",
                                                "https://www.gap.com/webcontent/0056/377/730/cn56377730.jpg",
                                                "https://www.gap.com/webcontent/0056/168/370/cn56168370.jpg",
                                                "https://www.gap.com/webcontent/0057/974/358/cn57974358.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                59.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "Pet CashSoft Sweater",
                                "Description for Pet CashSoft Sweater",
                                "https://www1.assets-gap.com/webcontent/0060/942/135/cn60942135.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/942/111/cn60942111.jpg",
                                                "https://www.gap.com/webcontent/0060/942/138/cn60942138.jpg",
                                                "https://www.gap.com/webcontent/0060/942/154/cn60942154.jpg",
                                                "https://www.gap.com/webcontent/0060/208/548/cn60208548.jpg"));
                createVariants(p, List.of("Custom"), 44.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0059/151/401/cn59151401.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/151/396/cn59151396.jpg",
                                                "https://www.gap.com/webcontent/0059/153/387/cn59153387.jpg",
                                                "https://www.gap.com/webcontent/0059/151/408/cn59151408.jpg",
                                                "https://www.gap.com/webcontent/0060/065/913/cn60065913.jpg",
                                                "https://www.gap.com/webcontent/0059/127/135/cn59127135.jpg",
                                                "https://www.gap.com/webcontent/0060/825/673/cn60825673.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0061/438/111/cn61438111.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/438/074/cn61438074.jpg",
                                                "https://www.gap.com/webcontent/0060/413/645/cn60413645.jpg",
                                                "https://www.gap.com/webcontent/0060/413/664/cn60413664.jpg",
                                                "https://www.gap.com/webcontent/0060/413/665/cn60413665.jpg",
                                                "https://www.gap.com/webcontent/0059/583/961/cn59583961.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Joggers",
                                "Description for High Rise VintageSoft Joggers",
                                "https://www1.assets-gap.com/webcontent/0060/117/907/cn60117907.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/332/978/cn61332978.jpg",
                                                "https://www.gap.com/webcontent/0061/332/999/cn61332999.jpg",
                                                "https://www.gap.com/webcontent/0061/333/007/cn61333007.jpg",
                                                "https://www.gap.com/webcontent/0061/332/982/cn61332982.jpg",
                                                "https://www.gap.com/webcontent/0061/333/011/cn61333011.jpg",
                                                "https://www.gap.com/webcontent/0060/824/371/cn60824371.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                49.95, 34.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0056/347/794/cn56347794.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/347/750/cn56347750.jpg",
                                                "https://www.gap.com/webcontent/0056/347/630/cn56347630.jpg",
                                                "https://www.gap.com/webcontent/0056/347/637/cn56347637.jpg",
                                                "https://www.gap.com/webcontent/0056/168/364/cn56168364.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                59.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0060/797/831/cn60797831.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/332/978/cn61332978.jpg",
                                                "https://www.gap.com/webcontent/0061/332/999/cn61332999.jpg",
                                                "https://www.gap.com/webcontent/0061/333/007/cn61333007.jpg",
                                                "https://www.gap.com/webcontent/0061/332/982/cn61332982.jpg",
                                                "https://www.gap.com/webcontent/0061/333/011/cn61333011.jpg",
                                                "https://www.gap.com/webcontent/0060/824/371/cn60824371.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                49.95, 39.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "Relaxed Straight Jeans",
                                "Description for Relaxed Straight Jeans",
                                "https://www1.assets-gap.com/webcontent/0060/078/075/cn60078075.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/078/026/cn60078026.jpg",
                                                "https://www.gap.com/webcontent/0060/078/051/cn60078051.jpg",
                                                "https://www.gap.com/webcontent/0060/078/046/cn60078046.jpg",
                                                "https://www.gap.com/webcontent/0060/078/086/cn60078086.jpg",
                                                "https://www.gap.com/webcontent/0059/565/741/cn59565741.jpg",
                                                "https://www.gap.com/webcontent/0059/565/744/cn59565744.jpg"));
                createVariants(p,
                                List.of("Custom", "Blue", "Custom", "Custom", "Custom", "Olive", "Brown", "Custom",
                                                "Custom", "White", "Custom"),
                                79.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0060/882/997/cn60882997.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/882/971/cn60882971.jpg",
                                                "https://www.gap.com/webcontent/0060/880/409/cn60880409.jpg",
                                                "https://www.gap.com/webcontent/0060/880/411/cn60880411.jpg",
                                                "https://www.gap.com/webcontent/0060/880/420/cn60880420.jpg",
                                                "https://www.gap.com/webcontent/0060/844/332/cn60844332.jpg",
                                                "https://www.gap.com/webcontent/0060/211/004/cn60211004.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 29, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0061/438/115/cn61438115.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/438/086/cn61438086.jpg",
                                                "https://www.gap.com/webcontent/0060/362/444/cn60362444.jpg",
                                                "https://www.gap.com/webcontent/0060/362/463/cn60362463.jpg",
                                                "https://www.gap.com/webcontent/0061/333/382/cn61333382.jpg",
                                                "https://www.gap.com/webcontent/0060/362/495/cn60362495.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                54.95, 43, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Joggers",
                                "Description for High Rise VintageSoft Joggers",
                                "https://www1.assets-gap.com/webcontent/0059/962/243/cn59962243.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/962/234/cn59962234.jpg",
                                                "https://www.gap.com/webcontent/0059/959/818/cn59959818.jpg",
                                                "https://www.gap.com/webcontent/0059/959/845/cn59959845.jpg",
                                                "https://www.gap.com/webcontent/0059/959/843/cn59959843.jpg",
                                                "https://www.gap.com/webcontent/0059/592/674/cn59592674.jpg",
                                                "https://www.gap.com/webcontent/0059/959/864/cn59959864.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Joggers",
                                "Description for High Rise VintageSoft Joggers",
                                "https://www1.assets-gap.com/webcontent/0060/140/015/cn60140015.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/140/010/cn60140010.jpg",
                                                "https://www.gap.com/webcontent/0060/140/022/cn60140022.jpg",
                                                "https://www.gap.com/webcontent/0060/140/026/cn60140026.jpg",
                                                "https://www.gap.com/webcontent/0060/140/034/cn60140034.jpg",
                                                "https://www.gap.com/webcontent/0060/140/039/cn60140039.jpg",
                                                "https://www.gap.com/webcontent/0060/140/051/cn60140051.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "Cotton-Blend Relaxed Crewneck Sweater",
                                "Description for Cotton-Blend Relaxed Crewneck Sweater",
                                "https://www1.assets-gap.com/webcontent/0060/633/052/cn60633052.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/633/042/cn60633042.jpg",
                                                "https://www.gap.com/webcontent/0060/630/003/cn60630003.jpg",
                                                "https://www.gap.com/webcontent/0060/630/080/cn60630080.jpg",
                                                "https://www.gap.com/webcontent/0060/630/119/cn60630119.jpg",
                                                "https://www.gap.com/webcontent/0060/630/166/cn60630166.jpg"));
                createVariants(p, List.of("Custom", "Black", "Blue", "Pink", "Beige"), 79.95, 63, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "Cotton-Blend Relaxed Crewneck Sweater",
                                "Description for Cotton-Blend Relaxed Crewneck Sweater",
                                "https://www1.assets-gap.com/webcontent/0060/617/785/cn60617785.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/617/756/cn60617756.jpg",
                                                "https://www.gap.com/webcontent/0060/617/614/cn60617614.jpg",
                                                "https://www.gap.com/webcontent/0060/617/632/cn60617632.jpg",
                                                "https://www.gap.com/webcontent/0060/653/236/cn60653236.jpg",
                                                "https://www.gap.com/webcontent/0060/377/595/cn60377595.jpg"));
                createVariants(p, List.of("Custom", "Black", "Blue", "Pink", "Beige"), 79.95, 63, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Logo Wedge Sweatshirt",
                                "Description for VintageSoft Logo Wedge Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0060/124/563/cn60124563.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/347/750/cn56347750.jpg",
                                                "https://www.gap.com/webcontent/0056/347/630/cn56347630.jpg",
                                                "https://www.gap.com/webcontent/0056/347/637/cn56347637.jpg",
                                                "https://www.gap.com/webcontent/0056/168/364/cn56168364.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                59.95, 29, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                                "Description for VintageSoft Wedge Crewneck Sweatshirt",
                                "https://www1.assets-gap.com/webcontent/0061/426/649/cn61426649.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/426/620/cn61426620.jpg",
                                                "https://www.gap.com/webcontent/0061/333/311/cn61333311.jpg",
                                                "https://www.gap.com/webcontent/0061/333/326/cn61333326.jpg",
                                                "https://www.gap.com/webcontent/0061/333/331/cn61333331.jpg",
                                                "https://www.gap.com/webcontent/0060/970/338/cn60970338.jpg",
                                                "https://www.gap.com/webcontent/0061/333/340/cn61333340.jpg"));
                createVariants(p,
                                List.of("Brown", "Pink", "Blue", "Blue", "Red", "Blue", "Blue", "Black", "Grey",
                                                "White", "Grey", "Blue", "Green", "Green", "Pink"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0060/969/246/cn60969246.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/969/241/cn60969241.jpg",
                                                "https://www.gap.com/webcontent/0061/333/352/cn61333352.jpg",
                                                "https://www.gap.com/webcontent/0061/333/351/cn61333351.jpg",
                                                "https://www.gap.com/webcontent/0061/333/350/cn61333350.jpg",
                                                "https://www.gap.com/webcontent/0061/333/353/cn61333353.jpg",
                                                "https://www.gap.com/webcontent/0061/333/375/cn61333375.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "Cotton-Blend Relaxed Crewneck Sweater",
                                "Description for Cotton-Blend Relaxed Crewneck Sweater",
                                "https://www1.assets-gap.com/webcontent/0060/619/933/cn60619933.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/619/925/cn60619925.jpg",
                                                "https://www.gap.com/webcontent/0060/619/942/cn60619942.jpg",
                                                "https://www.gap.com/webcontent/0060/619/953/cn60619953.jpg",
                                                "https://www.gap.com/webcontent/0060/472/252/cn60472252.jpg",
                                                "https://www.gap.com/webcontent/0060/472/278/cn60472278.jpg"));
                createVariants(p, List.of("Custom", "Black", "Blue", "Pink", "Beige"), 89.95, 71, colorMap, sizeMap,
                                materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0061/143/526/cn61143526.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/143/512/cn61143512.jpg",
                                                "https://www.gap.com/webcontent/0061/143/519/cn61143519.jpg",
                                                "https://www.gap.com/webcontent/0061/143/542/cn61143542.jpg",
                                                "https://www.gap.com/webcontent/0061/143/929/cn61143929.jpg",
                                                "https://www.gap.com/webcontent/0061/143/946/cn61143946.jpg",
                                                "https://www.gap.com/webcontent/0061/143/942/cn61143942.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/721/250/cn57721250.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/721/231/cn57721231.jpg",
                                                "https://www.gap.com/webcontent/0057/440/624/cn57440624.jpg",
                                                "https://www.gap.com/webcontent/0057/721/245/cn57721245.jpg",
                                                "https://www.gap.com/webcontent/0061/005/677/cn61005677.jpg"));
                createVariants(p, List.of("Blue", "Grey", "Black", "White"), 24.95, 9, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/429/403/cn60429403.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/429/395/cn60429395.jpg",
                                                "https://www.gap.com/webcontent/0060/429/400/cn60429400.jpg",
                                                "https://www.gap.com/webcontent/0060/429/414/cn60429414.jpg",
                                                "https://www.gap.com/webcontent/0060/295/649/cn60295649.jpg",
                                                "https://www.gap.com/webcontent/0060/295/665/cn60295665.jpg"));
                createVariants(p, List.of("Red", "Brown", "Green", "Red", "Grey", "White", "Black", "Blue"), 39.95, 23,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/491/300/cn57491300.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/491/260/cn57491260.jpg",
                                                "https://www.gap.com/webcontent/0057/491/276/cn57491276.jpg",
                                                "https://www.gap.com/webcontent/0057/491/279/cn57491279.jpg",
                                                "https://www.gap.com/webcontent/0057/510/741/cn57510741.jpg"));
                createVariants(p, List.of("Blue", "Grey", "Black", "White"), 24.95, 9, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/430/981/cn60430981.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/430/975/cn60430975.jpg",
                                                "https://www.gap.com/webcontent/0060/432/316/cn60432316.jpg",
                                                "https://www.gap.com/webcontent/0060/430/994/cn60430994.jpg",
                                                "https://www.gap.com/webcontent/0060/291/813/cn60291813.jpg",
                                                "https://www.gap.com/webcontent/0060/291/857/cn60291857.jpg"));
                createVariants(p, List.of("Red", "Brown", "Green", "Red", "Grey", "White", "Black", "Blue"), 39.95, 23,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/151/949/cn60151949.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/151/940/cn60151940.jpg",
                                                "https://www.gap.com/webcontent/0060/151/038/cn60151038.jpg",
                                                "https://www.gap.com/webcontent/0060/151/967/cn60151967.jpg",
                                                "https://www.gap.com/webcontent/0060/151/980/cn60151980.jpg"));
                createVariants(p, List.of("Red", "Brown", "Green", "Red", "Grey", "White", "Black", "Blue"), 39.95, 31,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Classic T-Shirt",
                                "Description for Classic T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0020/344/743/cn20344743.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0055/768/203/cn55768203.jpg",
                                                "https://www.gap.com/webcontent/0055/768/095/cn55768095.jpg",
                                                "https://www.gap.com/webcontent/0055/768/250/cn55768250.jpg",
                                                "https://www.gap.com/webcontent/0055/639/185/cn55639185.jpg",
                                                "https://www.gap.com/webcontent/0055/722/170/cn55722170.jpg"));
                createVariants(p, List.of("White", "Blue", "Black", "Grey"), 19.95, 13, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/413/582/cn60413582.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/413/547/cn60413547.jpg",
                                                "https://www.gap.com/webcontent/0060/771/856/cn60771856.jpg",
                                                "https://www.gap.com/webcontent/0060/413/620/cn60413620.jpg",
                                                "https://www.gap.com/webcontent/0060/771/756/cn60771756.jpg",
                                                "https://www.gap.com/webcontent/0060/771/833/cn60771833.jpg"));
                createVariants(p, List.of("Red", "Brown", "Green", "Red", "Grey", "White", "Black", "Blue"), 39.95, 23,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Classic T-Shirt",
                                "Description for Classic T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/821/457/cn57821457.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/821/449/cn57821449.jpg",
                                                "https://www.gap.com/webcontent/0057/821/485/cn57821485.jpg",
                                                "https://www.gap.com/webcontent/0057/821/450/cn57821450.jpg",
                                                "https://www.gap.com/webcontent/0061/016/825/cn61016825.jpg",
                                                "https://www.gap.com/webcontent/0061/017/647/cn61017647.jpg"));
                createVariants(p, List.of("White", "Blue", "Black", "Grey"), 19.95, 13, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "CloseKnit Jersey T-Shirt",
                                "Description for CloseKnit Jersey T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/791/130/cn57791130.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/791/120/cn57791120.jpg",
                                                "https://www.gap.com/webcontent/0057/790/938/cn57790938.jpg",
                                                "https://www.gap.com/webcontent/0057/791/137/cn57791137.jpg",
                                                "https://www.gap.com/webcontent/0057/860/160/cn57860160.jpg",
                                                "https://www.gap.com/webcontent/0058/028/015/cn58028015.jpg"));
                createVariants(p, List.of("Red", "Brown", "Black", "Blue", "Grey", "White"), 24.95, 14, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton VintageSoft T-Shirt",
                                "Description for Organic Cotton VintageSoft T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/796/475/cn57796475.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/796/433/cn57796433.jpg",
                                                "https://www.gap.com/webcontent/0057/796/468/cn57796468.jpg",
                                                "https://www.gap.com/webcontent/0057/796/474/cn57796474.jpg",
                                                "https://www.gap.com/webcontent/0057/860/144/cn57860144.jpg",
                                                "https://www.gap.com/webcontent/0057/860/130/cn57860130.jpg"));
                createVariants(p, List.of("White", "Brown", "Pink", "White", "Blue", "Grey", "Black", "Pink", "Red"),
                                24.95, 22, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton VintageSoft T-Shirt",
                                "Description for Organic Cotton VintageSoft T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0056/513/370/cn56513370.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/513/365/cn56513365.jpg",
                                                "https://www.gap.com/webcontent/0056/513/409/cn56513409.jpg",
                                                "https://www.gap.com/webcontent/0056/513/586/cn56513586.jpg",
                                                "https://www.gap.com/webcontent/0056/519/152/cn56519152.jpg"));
                createVariants(p, List.of("White", "Brown", "Pink", "White", "Blue", "Grey", "Black", "Pink", "Red"),
                                24.95, 22, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/413/587/cn60413587.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/413/553/cn60413553.jpg",
                                                "https://www.gap.com/webcontent/0060/413/598/cn60413598.jpg",
                                                "https://www.gap.com/webcontent/0060/413/663/cn60413663.jpg",
                                                "https://www.gap.com/webcontent/0060/295/678/cn60295678.jpg"));
                createVariants(p, List.of("Red", "Brown", "Green", "Red", "Grey", "White", "Black", "Blue"), 39.95, 23,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                                "Description for Organic Cotton Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/802/837/cn60802837.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/802/832/cn60802832.jpg",
                                                "https://www.gap.com/webcontent/0060/802/844/cn60802844.jpg",
                                                "https://www.gap.com/webcontent/0060/802/851/cn60802851.jpg",
                                                "https://www.gap.com/webcontent/0060/136/692/cn60136692.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 69.95,
                                34, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "CloseKnit Jersey T-Shirt",
                                "Description for CloseKnit Jersey T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/536/366/cn59536366.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/536/349/cn59536349.jpg",
                                                "https://www.gap.com/webcontent/0059/536/360/cn59536360.jpg",
                                                "https://www.gap.com/webcontent/0059/524/899/cn59524899.jpg",
                                                "https://www.gap.com/webcontent/0059/524/903/cn59524903.jpg",
                                                "https://www.gap.com/webcontent/0059/141/737/cn59141737.jpg"));
                createVariants(p, List.of("Red", "Brown", "Black", "Blue", "Grey", "White"), 24.95, 19.99, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Boatneck T-Shirt",
                                "Description for Modern Boatneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/852/790/cn59852790.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/852/779/cn59852779.jpg",
                                                "https://www.gap.com/webcontent/0059/851/127/cn59851127.jpg",
                                                "https://www.gap.com/webcontent/0059/851/148/cn59851148.jpg",
                                                "https://www.gap.com/webcontent/0059/592/218/cn59592218.jpg",
                                                "https://www.gap.com/webcontent/0059/851/156/cn59851156.jpg"));
                createVariants(p, List.of("Brown", "Grey", "Black", "White"), 39.95, 23, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "CloseKnit Jersey T-Shirt",
                                "Description for CloseKnit Jersey T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/391/905/cn57391905.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/391/892/cn57391892.jpg",
                                                "https://www.gap.com/webcontent/0057/827/816/cn57827816.jpg",
                                                "https://www.gap.com/webcontent/0057/827/809/cn57827809.jpg",
                                                "https://www.gap.com/webcontent/0059/335/406/cn59335406.jpg"));
                createVariants(p, List.of("Red", "Brown", "Black", "Blue", "Grey", "White"), 24.95, 14, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton VintageSoft T-Shirt",
                                "Description for Organic Cotton VintageSoft T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/220/031/cn57220031.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/219/992/cn57219992.jpg",
                                                "https://www.gap.com/webcontent/0057/830/072/cn57830072.jpg",
                                                "https://www.gap.com/webcontent/0057/830/065/cn57830065.jpg",
                                                "https://www.gap.com/webcontent/0057/179/443/cn57179443.jpg",
                                                "https://www.gap.com/webcontent/0057/184/016/cn57184016.jpg"));
                createVariants(p, List.of("White", "Brown", "Pink", "White", "Blue", "Grey", "Black", "Pink", "Red"),
                                29.95, 24.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton T-Shirt",
                                "Description for Organic Cotton T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/939/683/cn60939683.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/939/649/cn60939649.jpg",
                                                "https://www.gap.com/webcontent/0060/943/043/cn60943043.jpg",
                                                "https://www.gap.com/webcontent/0060/939/209/cn60939209.jpg"));
                createVariants(p, List.of("Beige", "Olive", "Navy", "Black", "White", "Grey"), 34.95, 17, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Boatneck T-Shirt",
                                "Description for Modern Boatneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/077/258/cn60077258.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/077/244/cn60077244.jpg",
                                                "https://www.gap.com/webcontent/0060/077/256/cn60077256.jpg",
                                                "https://www.gap.com/webcontent/0060/077/270/cn60077270.jpg",
                                                "https://www.gap.com/webcontent/0060/077/279/cn60077279.jpg",
                                                "https://www.gap.com/webcontent/0060/077/274/cn60077274.jpg"));
                createVariants(p, List.of("Brown", "Grey", "Black", "White"), 39.95, 23, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                                "Description for Organic Cotton Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/486/094/cn60486094.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/486/075/cn60486075.jpg",
                                                "https://www.gap.com/webcontent/0060/486/095/cn60486095.jpg",
                                                "https://www.gap.com/webcontent/0060/484/647/cn60484647.jpg",
                                                "https://www.gap.com/webcontent/0060/442/994/cn60442994.jpg",
                                                "https://www.gap.com/webcontent/0060/442/992/cn60442992.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 69.95,
                                34, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton VintageSoft T-Shirt",
                                "Description for Organic Cotton VintageSoft T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0056/248/013/cn56248013.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/248/003/cn56248003.jpg",
                                                "https://www.gap.com/webcontent/0056/248/054/cn56248054.jpg",
                                                "https://www.gap.com/webcontent/0056/248/055/cn56248055.jpg",
                                                "https://www.gap.com/webcontent/0056/132/214/cn56132214.jpg"));
                createVariants(p, List.of("White", "Brown", "Pink", "White", "Blue", "Grey", "Black", "Pink", "Red"),
                                24.95, 22, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                                "Description for Organic Cotton Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/763/241/cn59763241.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/763/206/cn59763206.jpg",
                                                "https://www.gap.com/webcontent/0059/763/219/cn59763219.jpg",
                                                "https://www.gap.com/webcontent/0059/763/019/cn59763019.jpg",
                                                "https://www.gap.com/webcontent/0059/783/375/cn59783375.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 69.95,
                                34, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Classic Shirt",
                                "Description for Organic Cotton Poplin Classic Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/577/691/cn59577691.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/577/674/cn59577674.jpg",
                                                "https://www.gap.com/webcontent/0059/577/689/cn59577689.jpg",
                                                "https://www.gap.com/webcontent/0059/577/683/cn59577683.jpg",
                                                "https://www.gap.com/webcontent/0058/006/974/cn58006974.jpg",
                                                "https://www.gap.com/webcontent/0058/072/345/cn58072345.jpg"));
                createVariants(p, List.of("Navy", "Black", "Green", "Navy", "Blue", "White", "Blue", "Pink"), 59.95, 35,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Big Shirt",
                                "Description for Organic Cotton Poplin Big Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/682/364/cn59682364.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/682/314/cn59682314.jpg",
                                                "https://www.gap.com/webcontent/0059/764/254/cn59764254.jpg",
                                                "https://www.gap.com/webcontent/0059/682/116/cn59682116.jpg",
                                                "https://www.gap.com/webcontent/0061/006/191/cn61006191.jpg"));
                createVariants(p, List.of("White", "Blue", "White", "Burgundy", "White", "White", "Black", "Blue"),
                                69.95, 69.95, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                                "Description for Organic Cotton Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/614/226/cn60614226.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/614/191/cn60614191.jpg",
                                                "https://www.gap.com/webcontent/0060/613/672/cn60613672.jpg",
                                                "https://www.gap.com/webcontent/0060/613/673/cn60613673.jpg",
                                                "https://www.gap.com/webcontent/0060/614/429/cn60614429.jpg",
                                                "https://www.gap.com/webcontent/0060/614/422/cn60614422.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 89.95,
                                44, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                                "Description for Organic Cotton Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/487/230/cn60487230.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/487/165/cn60487165.jpg",
                                                "https://www.gap.com/webcontent/0060/529/883/cn60529883.jpg",
                                                "https://www.gap.com/webcontent/0060/486/119/cn60486119.jpg",
                                                "https://www.gap.com/webcontent/0060/211/241/cn60211241.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 69.95,
                                27, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                                "Description for Organic Cotton Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/999/640/cn57999640.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/999/601/cn57999601.jpg",
                                                "https://www.gap.com/webcontent/0057/999/648/cn57999648.jpg",
                                                "https://www.gap.com/webcontent/0057/999/638/cn57999638.jpg",
                                                "https://www.gap.com/webcontent/0057/999/637/cn57999637.jpg",
                                                "https://www.gap.com/webcontent/0058/022/931/cn58022931.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 69.95,
                                34, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/440/552/cn57440552.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/440/512/cn57440512.jpg",
                                                "https://www.gap.com/webcontent/0057/440/546/cn57440546.jpg",
                                                "https://www.gap.com/webcontent/0057/440/560/cn57440560.jpg",
                                                "https://www.gap.com/webcontent/0057/481/855/cn57481855.jpg"));
                createVariants(p, List.of("Blue", "Grey", "Black", "White"), 24.95, 12, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Oxford Big Shirt",
                                "Description for Organic Cotton Oxford Big Shirt",
                                "https://www1.assets-gap.com/webcontent/0056/556/815/cn56556815.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/556/818/cn56556818.jpg",
                                                "https://www.gap.com/webcontent/0056/184/310/cn56184310.jpg",
                                                "https://www.gap.com/webcontent/0056/556/830/cn56556830.jpg",
                                                "https://www.gap.com/webcontent/0056/071/184/cn56071184.jpg"));
                createVariants(p, List.of("White", "Blue", "White", "Burgundy", "White", "White", "Black", "Blue"),
                                69.95, 69.95, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/477/093/cn57477093.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/477/064/cn57477064.jpg",
                                                "https://www.gap.com/webcontent/0057/477/025/cn57477025.jpg",
                                                "https://www.gap.com/webcontent/0057/477/046/cn57477046.jpg",
                                                "https://www.gap.com/webcontent/0057/510/753/cn57510753.jpg"));
                createVariants(p, List.of("Blue", "Grey", "Black", "White"), 24.95, 12, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Boatneck T-Shirt",
                                "Description for Modern Boatneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/941/846/cn59941846.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/941/821/cn59941821.jpg",
                                                "https://www.gap.com/webcontent/0059/941/879/cn59941879.jpg",
                                                "https://www.gap.com/webcontent/0059/941/921/cn59941921.jpg",
                                                "https://www.gap.com/webcontent/0059/958/544/cn59958544.jpg",
                                                "https://www.gap.com/webcontent/0059/958/561/cn59958561.jpg"));
                createVariants(p, List.of("Brown", "Grey", "Black", "White"), 39.95, 23, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "CloseKnit Jersey T-Shirt",
                                "Description for CloseKnit Jersey T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0056/387/465/cn56387465.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/387/447/cn56387447.jpg",
                                                "https://www.gap.com/webcontent/0056/386/812/cn56386812.jpg",
                                                "https://www.gap.com/webcontent/0056/386/837/cn56386837.jpg",
                                                "https://www.gap.com/webcontent/0059/335/399/cn59335399.jpg"));
                createVariants(p, List.of("Red", "Brown", "Black", "Blue", "Grey", "White"), 24.95, 14, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Oxford Big Shirt",
                                "Description for Organic Cotton Oxford Big Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/020/259/cn60020259.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/020/236/cn60020236.jpg",
                                                "https://www.gap.com/webcontent/0060/014/488/cn60014488.jpg",
                                                "https://www.gap.com/webcontent/0060/014/497/cn60014497.jpg",
                                                "https://www.gap.com/webcontent/0059/775/341/cn59775341.jpg",
                                                "https://www.gap.com/webcontent/0060/014/503/cn60014503.jpg",
                                                "https://www.gap.com/webcontent/0060/803/298/cn60803298.jpg"));
                createVariants(p, List.of("White", "Blue", "White", "Burgundy", "White", "White", "Black", "Blue"),
                                69.95, 69.95, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Denim Fitted Crop Shirt",
                                "Description for Denim Fitted Crop Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/772/334/cn59772334.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/772/280/cn59772280.jpg",
                                                "https://www.gap.com/webcontent/0059/772/283/cn59772283.jpg",
                                                "https://www.gap.com/webcontent/0059/772/297/cn59772297.jpg",
                                                "https://www.gap.com/webcontent/0059/784/217/cn59784217.jpg",
                                                "https://www.gap.com/webcontent/0060/803/340/cn60803340.jpg"));
                createVariants(p, List.of("White", "White", "Custom", "White", "White", "Red", "White", "Black"), 69.95,
                                41, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Classic T-Shirt",
                                "Description for Classic T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0020/344/733/cn20344733.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0055/691/994/cn55691994.jpg",
                                                "https://www.gap.com/webcontent/0055/691/933/cn55691933.jpg",
                                                "https://www.gap.com/webcontent/0055/691/979/cn55691979.jpg",
                                                "https://www.gap.com/webcontent/0055/632/554/cn55632554.jpg",
                                                "https://www.gap.com/webcontent/0055/722/163/cn55722163.jpg"));
                createVariants(p, List.of("White", "Blue", "Black", "Grey"), 19.95, 13, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                                "Description for Modern Crewneck T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/986/345/cn59986345.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/986/314/cn59986314.jpg",
                                                "https://www.gap.com/webcontent/0059/985/564/cn59985564.jpg",
                                                "https://www.gap.com/webcontent/0059/985/538/cn59985538.jpg",
                                                "https://www.gap.com/webcontent/0059/985/579/cn59985579.jpg"));
                createVariants(p, List.of("Red", "Brown", "Green", "Red", "Grey", "White", "Black", "Blue"), 39.95, 31,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton T-Shirt",
                                "Description for Organic Cotton T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0060/843/373/cn60843373.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/843/364/cn60843364.jpg",
                                                "https://www.gap.com/webcontent/0060/843/365/cn60843365.jpg",
                                                "https://www.gap.com/webcontent/0060/843/405/cn60843405.jpg"));
                createVariants(p, List.of("Beige", "Olive", "Navy", "Black", "White", "Grey"), 34.95, 17, colorMap,
                                sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Big Shirt",
                                "Description for Organic Cotton Poplin Big Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/180/006/cn57180006.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/180/001/cn57180001.jpg",
                                                "https://www.gap.com/webcontent/0057/180/015/cn57180015.jpg",
                                                "https://www.gap.com/webcontent/0057/180/014/cn57180014.jpg",
                                                "https://www.gap.com/webcontent/0057/177/475/cn57177475.jpg",
                                                "https://www.gap.com/webcontent/0057/180/027/cn57180027.jpg"));
                createVariants(p, List.of("White", "Blue", "White", "Burgundy", "White", "White", "Black", "Blue"),
                                69.95, 69.95, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Classic Shirt",
                                "Description for Organic Cotton Poplin Classic Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/601/406/cn57601406.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/601/390/cn57601390.jpg",
                                                "https://www.gap.com/webcontent/0057/620/848/cn57620848.jpg",
                                                "https://www.gap.com/webcontent/0057/601/400/cn57601400.jpg",
                                                "https://www.gap.com/webcontent/0057/481/267/cn57481267.jpg",
                                                "https://www.gap.com/webcontent/0057/620/858/cn57620858.jpg"));
                createVariants(p, List.of("Navy", "Black", "Green", "Navy", "Blue", "White", "Blue", "Pink"), 59.95, 35,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Classic Shirt",
                                "Description for Organic Cotton Poplin Classic Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/674/437/cn57674437.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/674/394/cn57674394.jpg",
                                                "https://www.gap.com/webcontent/0057/673/783/cn57673783.jpg",
                                                "https://www.gap.com/webcontent/0057/673/769/cn57673769.jpg",
                                                "https://www.gap.com/webcontent/0061/024/990/cn61024990.jpg",
                                                "https://www.gap.com/webcontent/0057/673/796/cn57673796.jpg"));
                createVariants(p, List.of("Navy", "Black", "Green", "Navy", "Blue", "White", "Blue", "Pink"), 59.95,
                                29.99, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Big Shirt",
                                "Description for Organic Cotton Poplin Big Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/461/820/cn59461820.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/461/775/cn59461775.jpg",
                                                "https://www.gap.com/webcontent/0059/461/059/cn59461059.jpg",
                                                "https://www.gap.com/webcontent/0059/461/060/cn59461060.jpg",
                                                "https://www.gap.com/webcontent/0052/349/036/cn52349036.jpg",
                                                "https://www.gap.com/webcontent/0052/349/065/cn52349065.jpg",
                                                "https://www.gap.com/webcontent/0059/467/447/cn59467447.jpg"));
                createVariants(p, List.of("White", "Blue", "White", "Burgundy", "White", "White", "Black", "Blue"),
                                59.95, 59.95, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Classic T-Shirt",
                                "Description for Classic T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/808/972/cn57808972.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/808/967/cn57808967.jpg",
                                                "https://www.gap.com/webcontent/0057/808/986/cn57808986.jpg",
                                                "https://www.gap.com/webcontent/0057/808/979/cn57808979.jpg",
                                                "https://www.gap.com/webcontent/0057/860/467/cn57860467.jpg",
                                                "https://www.gap.com/webcontent/0057/860/469/cn57860469.jpg"));
                createVariants(p, List.of("White", "Blue", "Black", "Grey"), 19.95, 13, colorMap, sizeMap, materialMap,
                                seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Oxford Button-Down Shirt",
                                "Description for Oxford Button-Down Shirt",
                                "https://www1.assets-gap.com/webcontent/0059/178/344/cn59178344.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/178/339/cn59178339.jpg",
                                                "https://www.gap.com/webcontent/0059/177/810/cn59177810.jpg",
                                                "https://www.gap.com/webcontent/0059/177/805/cn59177805.jpg",
                                                "https://www.gap.com/webcontent/0059/177/850/cn59177850.jpg",
                                                "https://www.gap.com/webcontent/0059/209/544/cn59209544.jpg"));
                createVariants(p, List.of("Blue", "White", "Navy", "Olive", "Pink", "Red", "Blue", "Custom", "Black"),
                                59.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Classic Shirt",
                                "Description for Organic Cotton Poplin Classic Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/729/463/cn57729463.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/729/436/cn57729436.jpg",
                                                "https://www.gap.com/webcontent/0057/729/168/cn57729168.jpg",
                                                "https://www.gap.com/webcontent/0057/729/158/cn57729158.jpg",
                                                "https://www.gap.com/webcontent/0057/447/862/cn57447862.jpg",
                                                "https://www.gap.com/webcontent/0057/447/017/cn57447017.jpg"));
                createVariants(p, List.of("Navy", "Black", "Green", "Navy", "Blue", "White", "Blue", "Pink"), 59.95, 35,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "VintageSoft Baggy Wide-Leg Sweatpants",
                                "Description for VintageSoft Baggy Wide-Leg Sweatpants",
                                "https://www1.assets-gap.com/webcontent/0056/601/381/cn56601381.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0056/601/367/cn56601367.jpg",
                                                "https://www.gap.com/webcontent/0056/600/701/cn56600701.jpg",
                                                "https://www.gap.com/webcontent/0056/600/686/cn56600686.jpg",
                                                "https://www.gap.com/webcontent/0056/600/685/cn56600685.jpg",
                                                "https://www.gap.com/webcontent/0056/548/138/cn56548138.jpg"));
                createVariants(p,
                                List.of("Pink", "Blue", "Black", "Blue", "Brown", "Black", "Grey", "Brown", "White",
                                                "Blue", "Grey", "Yellow"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "VintageSoft Baggy Wide-Leg Sweatpants",
                                "Description for VintageSoft Baggy Wide-Leg Sweatpants",
                                "https://www1.assets-gap.com/webcontent/0059/548/622/cn59548622.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/548/612/cn59548612.jpg",
                                                "https://www.gap.com/webcontent/0059/461/145/cn59461145.jpg",
                                                "https://www.gap.com/webcontent/0059/461/139/cn59461139.jpg",
                                                "https://www.gap.com/webcontent/0059/461/130/cn59461130.jpg",
                                                "https://www.gap.com/webcontent/0056/548/126/cn56548126.jpg"));
                createVariants(p,
                                List.of("Pink", "Blue", "Black", "Blue", "Brown", "Black", "Grey", "Brown", "White",
                                                "Blue", "Grey", "Yellow"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "High Rise VintageSoft Relaxed Joggers",
                                "Description for High Rise VintageSoft Relaxed Joggers",
                                "https://www1.assets-gap.com/webcontent/0059/151/338/cn59151338.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0059/151/311/cn59151311.jpg",
                                                "https://www.gap.com/webcontent/0059/151/387/cn59151387.jpg",
                                                "https://www.gap.com/webcontent/0059/151/074/cn59151074.jpg",
                                                "https://www.gap.com/webcontent/0059/151/339/cn59151339.jpg",
                                                "https://www.gap.com/webcontent/0053/450/970/cn53450970.jpg",
                                                "https://www.gap.com/webcontent/0053/426/050/cn53426050.jpg",
                                                "https://www.gap.com/webcontent/0059/127/143/cn59127143.jpg",
                                                "https://www.gap.com/webcontent/0060/825/655/cn60825655.jpg"));
                createVariants(p,
                                List.of("White", "Blue", "Grey", "Blue", "Pink", "Brown", "Brown", "Black", "Navy",
                                                "Blue", "Grey", "Black", "Blue", "Beige", "Pink", "Yellow", "Red"),
                                59.95, 35, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "VintageSoft Baggy Wide-Leg Sweatpants",
                                "Description for VintageSoft Baggy Wide-Leg Sweatpants",
                                "https://www1.assets-gap.com/webcontent/0060/362/537/cn60362537.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/362/491/cn60362491.jpg",
                                                "https://www.gap.com/webcontent/0060/362/517/cn60362517.jpg",
                                                "https://www.gap.com/webcontent/0060/362/509/cn60362509.jpg",
                                                "https://www.gap.com/webcontent/0060/362/515/cn60362515.jpg",
                                                "https://www.gap.com/webcontent/0060/362/521/cn60362521.jpg",
                                                "https://www.gap.com/webcontent/0060/362/519/cn60362519.jpg"));
                createVariants(p,
                                List.of("Pink", "Blue", "Black", "Blue", "Brown", "Black", "Grey", "Brown", "White",
                                                "Blue", "Grey", "Yellow"),
                                64.95, 51, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "Organic Cotton VintageSoft T-Shirt",
                                "Description for Organic Cotton VintageSoft T-Shirt",
                                "https://www1.assets-gap.com/webcontent/0057/796/475/cn57796475.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0057/796/433/cn57796433.jpg",
                                                "https://www.gap.com/webcontent/0057/796/468/cn57796468.jpg",
                                                "https://www.gap.com/webcontent/0057/796/474/cn57796474.jpg",
                                                "https://www.gap.com/webcontent/0057/860/144/cn57860144.jpg",
                                                "https://www.gap.com/webcontent/0057/860/130/cn57860130.jpg"));
                createVariants(p, List.of("White", "Brown", "Pink", "White", "Blue", "Grey", "Black", "Pink", "Red"),
                                24.95, 22, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "VintageSoft Baggy Wide-Leg Sweatpants",
                                "Description for VintageSoft Baggy Wide-Leg Sweatpants",
                                "https://www1.assets-gap.com/webcontent/0060/275/075/cn60275075.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/275/065/cn60275065.jpg",
                                                "https://www.gap.com/webcontent/0060/275/089/cn60275089.jpg",
                                                "https://www.gap.com/webcontent/0060/275/105/cn60275105.jpg",
                                                "https://www.gap.com/webcontent/0060/275/113/cn60275113.jpg",
                                                "https://www.gap.com/webcontent/0059/725/563/cn59725563.jpg",
                                                "https://www.gap.com/webcontent/0059/725/581/cn59725581.jpg"));
                createVariants(p,
                                List.of("Pink", "Blue", "Black", "Blue", "Red", "Brown", "Black", "Grey", "Brown",
                                                "White", "Blue", "Grey", "Orange", "Yellow"),
                                59.95, 47, colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "High Rise Stride Wide-Leg Jeans",
                                "Description for High Rise Stride Wide-Leg Jeans",
                                "https://www1.assets-gap.com/webcontent/0061/136/262/cn61136262.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0061/136/247/cn61136247.jpg",
                                                "https://www.gap.com/webcontent/0061/136/250/cn61136250.jpg",
                                                "https://www.gap.com/webcontent/0061/136/264/cn61136264.jpg",
                                                "https://www.gap.com/webcontent/0061/136/258/cn61136258.jpg",
                                                "https://www.gap.com/webcontent/0061/106/392/cn61106392.jpg",
                                                "https://www.gap.com/webcontent/0061/136/275/cn61136275.jpg",
                                                "https://www.gap.com/webcontent/0061/040/106/cn61040106.jpg",
                                                "https://www.gap.com/webcontent/0061/255/278/cn61255278.jpg"));
                createVariants(p, List.of("Custom", "Indigo", "Custom", "Brown", "Indigo", "Custom", "Black", "Custom",
                                "Brown", "Black", "Custom", "Indigo", "Red", "Indigo", "Custom", "Black"), 89.95, 71,
                                colorMap, sizeMap, materialMap, seasonMap);
                p = createProduct(admin, categoryMap.get("Collections"), "VintageSoft Baggy Wide-Leg Sweatpants",
                                "Description for VintageSoft Baggy Wide-Leg Sweatpants",
                                "https://www1.assets-gap.com/webcontent/0060/760/878/cn60760878.jpg?q=h&w=1152",
                                List.of("https://www.gap.com/webcontent/0060/760/864/cn60760864.jpg",
                                                "https://www.gap.com/webcontent/0060/760/882/cn60760882.jpg",
                                                "https://www.gap.com/webcontent/0060/760/896/cn60760896.jpg",
                                                "https://www.gap.com/webcontent/0060/760/908/cn60760908.jpg",
                                                "https://www.gap.com/webcontent/0060/760/947/cn60760947.jpg",
                                                "https://www.gap.com/webcontent/0060/760/928/cn60760928.jpg"));
                createVariants(p,
                                List.of("Pink", "Blue", "Black", "Blue", "Brown", "Black", "Grey", "Brown", "White",
                                                "Blue", "Grey", "Yellow"),
                                64.95, 51, colorMap, sizeMap, materialMap, seasonMap);
        }
}
