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
                userRepository.findByUsername("john_doe").orElseGet(() -> {
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

        
     private void seedProducts(User admin, Map<String, Category> categoryMap, Map<String, Color> colorMap,
                              Map<String, Size> sizeMap, Map<String, Material> materialMap, Map<String, Season> seasonMap) {

        Product p;
        p = createProduct(admin, categoryMap.get("Dresses"), "Gap × DÔEN Eyelet Midi Dress",
                "Description for Gap × DÔEN Eyelet Midi Dress", "https://www1.assets-gap.com/webcontent/0059/167/062/cn59167062.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/167/046/cn59167046.jpg", "https://www.gap.com/webcontent/0059/370/023/cn59370023.jpg", "https://www.gap.com/webcontent/0059/370/012/cn59370012.jpg", "https://www.gap.com/webcontent/0059/166/696/cn59166696.jpg", "https://www.gap.com/webcontent/0059/398/713/cn59398713.jpg", "https://www.gap.com/webcontent/0059/398/714/cn59398714.jpg", "https://www.gap.com/webcontent/0059/353/083/cn59353083.jpg", "https://www.gap.com/webcontent/0059/437/053/cn59437053.jpg"));
        createVariants(p, List.of("White", "Black"), 158, 64.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim V-Neck Crepe Maxi Dress",
                "Description for Lace-Trim V-Neck Crepe Maxi Dress", "https://www1.assets-gap.com/webcontent/0060/139/770/cn60139770.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/139/746/cn60139746.jpg", "https://www.gap.com/webcontent/0060/139/763/cn60139763.jpg", "https://www.gap.com/webcontent/0060/139/764/cn60139764.jpg", "https://www.gap.com/webcontent/0060/139/766/cn60139766.jpg", "https://www.gap.com/webcontent/0059/854/774/cn59854774.jpg", "https://www.gap.com/webcontent/0059/854/778/cn59854778.jpg", "https://www.gap.com/webcontent/0059/733/862/cn59733862.jpg", "https://www.gap.com/webcontent/0059/763/192/cn59763192.jpg"));
        createVariants(p, List.of("Blue", "Brown", "Custom"), 118, 59, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Linen-Blend Mini Shift Dress",
                "Description for Linen-Blend Mini Shift Dress", "https://www1.assets-gap.com/webcontent/0060/128/432/cn60128432.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/128/427/cn60128427.jpg", "https://www.gap.com/webcontent/0060/128/439/cn60128439.jpg", "https://www.gap.com/webcontent/0060/128/443/cn60128443.jpg", "https://www.gap.com/webcontent/0060/131/331/cn60131331.jpg", "https://www.gap.com/webcontent/0060/997/682/cn60997682.jpg"));
        createVariants(p, List.of("White", "Brown", "Blue", "Red", "Custom"), 79.95, 24.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Boatneck Mini Shift Dress",
                "Description for Boatneck Mini Shift Dress", "https://www1.assets-gap.com/webcontent/0060/592/556/cn60592556.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/592/539/cn60592539.jpg", "https://www.gap.com/webcontent/0060/592/155/cn60592155.jpg", "https://www.gap.com/webcontent/0060/592/168/cn60592168.jpg", "https://www.gap.com/webcontent/0060/592/175/cn60592175.jpg", "https://www.gap.com/webcontent/0060/573/150/cn60573150.jpg"));
        createVariants(p, List.of("Black", "Red", "Brown"), 89.95, 69.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim V-Neck Maxi Dress",
                "Description for Lace-Trim V-Neck Maxi Dress", "https://www1.assets-gap.com/webcontent/0060/664/306/cn60664306.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/664/275/cn60664275.jpg", "https://www.gap.com/webcontent/0060/626/704/cn60626704.jpg", "https://www.gap.com/webcontent/0060/626/715/cn60626715.jpg", "https://www.gap.com/webcontent/0060/626/727/cn60626727.jpg", "https://www.gap.com/webcontent/0060/503/422/cn60503422.jpg"));
        createVariants(p, List.of("Brown", "Black"), 118, 89.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim Mini Dress",
                "Description for Lace-Trim Mini Dress", "https://www1.assets-gap.com/webcontent/0057/424/601/cn57424601.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/424/555/cn57424555.jpg", "https://www.gap.com/webcontent/0057/424/574/cn57424574.jpg", "https://www.gap.com/webcontent/0057/424/576/cn57424576.jpg", "https://www.gap.com/webcontent/0057/424/295/cn57424295.jpg", "https://www.gap.com/webcontent/0057/393/055/cn57393055.jpg", "https://www.gap.com/webcontent/0057/393/043/cn57393043.jpg", "https://www.gap.com/webcontent/0061/052/569/cn61052569.jpg"));
        createVariants(p, List.of("White"), 98, 39.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Linen-Blend Seamed Corset Midi Dress",
                "Description for Linen-Blend Seamed Corset Midi Dress", "https://www1.assets-gap.com/webcontent/0060/062/118/cn60062118.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/062/089/cn60062089.jpg", "https://www.gap.com/webcontent/0060/063/253/cn60063253.jpg", "https://www.gap.com/webcontent/0060/062/114/cn60062114.jpg", "https://www.gap.com/webcontent/0060/063/861/cn60063861.jpg", "https://www.gap.com/webcontent/0059/986/005/cn59986005.jpg", "https://www.gap.com/webcontent/0060/063/874/cn60063874.jpg"));
        createVariants(p, List.of("Brown", "Yellow"), 128, 44.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Dresses"), "Lace-Trim Midi Dress",
                "Description for Lace-Trim Midi Dress", "https://www1.assets-gap.com/webcontent/0060/020/243/cn60020243.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/020/208/cn60020208.jpg", "https://www.gap.com/webcontent/0060/020/232/cn60020232.jpg", "https://www.gap.com/webcontent/0060/020/247/cn60020247.jpg", "https://www.gap.com/webcontent/0059/807/945/cn59807945.jpg", "https://www.gap.com/webcontent/0059/807/956/cn59807956.jpg"));
        createVariants(p, List.of("Indigo"), 118, 70, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Adult VintageSoft Arch Logo Zip Hoodie" */
        p = createProduct(admin, categoryMap.get("Jackets"), "Adult VintageSoft Arch Logo Zip Hoodie",
                "Description for Adult VintageSoft Arch Logo Zip Hoodie", "https://www1.assets-gap.com/webcontent/0056/583/088/cn56583088.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0056/583/062/cn56583062.jpg", "https://www.gap.com/webcontent/0059/203/469/cn59203469.jpg", "https://www.gap.com/webcontent/0059/203/462/cn59203462.jpg", "https://www.gap.com/webcontent/0060/799/583/cn60799583.jpg", "https://www.gap.com/webcontent/0056/593/346/cn56593346.jpg", "https://www.gap.com/webcontent/0060/801/384/cn60801384.jpg"));
        createVariants(p, List.of("Black", "Grey", "Navy", "White"), 69.95, 55, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Jackets"), "Kids VintageSoft Gap Arch Logo Hoodie",
                "Description for Kids VintageSoft Gap Arch Logo Hoodie", "https://www1.assets-gap.com/webcontent/0061/016/467/cn61016467.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0061/016/462/cn61016462.jpg", "https://www.gap.com/webcontent/0061/015/645/cn61015645.jpg", "https://www.gap.com/webcontent/0060/979/386/cn60979386.jpg", "https://www.gap.com/webcontent/0061/015/682/cn61015682.jpg"));
        createVariants(p, List.of("Blue", "Pink"), 54.95, 32, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Jackets"), "VintageSoft Crop Logo Hoodie",
                "Description for VintageSoft Crop Logo Hoodie", "https://www1.assets-gap.com/webcontent/0059/846/500/cn59846500.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/411/288/cn57411288.jpg", "https://www.gap.com/webcontent/0057/411/290/cn57411290.jpg", "https://www.gap.com/webcontent/0057/411/293/cn57411293.jpg", "https://www.gap.com/webcontent/0057/475/895/cn57475895.jpg"));
        createVariants(p, List.of("Black"), 69.95, 55, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Jackets"), "Kids Vintage Soft  Logo Zip Hoodie",
                "Description for Kids Vintage Soft  Logo Zip Hoodie", "https://www1.assets-gap.com/webcontent/0057/010/159/cn57010159.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/010/128/cn57010128.jpg", "https://www.gap.com/webcontent/0056/976/963/cn56976963.jpg", "https://www.gap.com/webcontent/0056/976/964/cn56976964.jpg", "https://www.gap.com/webcontent/0056/827/822/cn56827822.jpg", "https://www.gap.com/webcontent/0056/842/735/cn56842735.jpg"));
        createVariants(p, List.of("Grey", "Navy", "Black"), 54.95, 43, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Belted Long Puffer Coat" */
        p = createProduct(admin, categoryMap.get("Coats"), "Belted Long Puffer Coat",
                "Description for Belted Long Puffer Coat", "https://www1.assets-gap.com/webcontent/0060/586/666/cn60586666.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/586/627/cn60586627.jpg", "https://www.gap.com/webcontent/0060/586/435/cn60586435.jpg", "https://www.gap.com/webcontent/0060/586/443/cn60586443.jpg", "https://www.gap.com/webcontent/0060/165/937/cn60165937.jpg", "https://www.gap.com/webcontent/0060/168/731/cn60168731.jpg"));
        createVariants(p, List.of("Brown", "Black"), 268, 160, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Wool-Blend Chesterfield Coat" */
        p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Chesterfield Coat",
                "Description for Wool-Blend Chesterfield Coat", "https://www1.assets-gap.com/webcontent/0060/567/250/cn60567250.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/567/218/cn60567218.jpg", "https://www.gap.com/webcontent/0060/567/018/cn60567018.jpg", "https://www.gap.com/webcontent/0060/567/048/cn60567048.jpg", "https://www.gap.com/webcontent/0060/425/799/cn60425799.jpg", "https://www.gap.com/webcontent/0060/427/303/cn60427303.jpg"));
        createVariants(p, List.of("Black", "Grey"), 248, 124, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Wool-Blend Wrap Coat" */
        p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Wrap Coat",
                "Description for Wool-Blend Wrap Coat", "https://www1.assets-gap.com/webcontent/0060/264/674/cn60264674.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/264/654/cn60264654.jpg", "https://www.gap.com/webcontent/0060/213/636/cn60213636.jpg", "https://www.gap.com/webcontent/0060/213/638/cn60213638.jpg", "https://www.gap.com/webcontent/0059/830/908/cn59830908.jpg", "https://www.gap.com/webcontent/0059/830/893/cn59830893.jpg"));
        createVariants(p, List.of("Black", "Burgundy"), 248, 198, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Faux Fur-Trim Midi Puffer Jacket" */
        p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Midi Puffer Jacket",
                "Description for Faux Fur-Trim Midi Puffer Jacket", "https://www1.assets-gap.com/webcontent/0060/608/526/cn60608526.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/608/503/cn60608503.jpg", "https://www.gap.com/webcontent/0060/608/274/cn60608274.jpg", "https://www.gap.com/webcontent/0060/608/278/cn60608278.jpg", "https://www.gap.com/webcontent/0060/168/709/cn60168709.jpg", "https://www.gap.com/webcontent/0060/168/711/cn60168711.jpg"));
        createVariants(p, List.of("Green", "Black"), 248, 99, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Faux Fur-Trim Puffer Jacket" */
        p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur-Trim Puffer Jacket",
                "Description for Faux Fur-Trim Puffer Jacket", "https://www1.assets-gap.com/webcontent/0060/592/523/cn60592523.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/592/514/cn60592514.jpg", "https://www.gap.com/webcontent/0060/592/017/cn60592017.jpg", "https://www.gap.com/webcontent/0060/592/038/cn60592038.jpg", "https://www.gap.com/webcontent/0060/592/041/cn60592041.jpg", "https://www.gap.com/webcontent/0060/172/758/cn60172758.jpg"));
        createVariants(p, List.of("Brown", "Beige", "Black"), 228, 114, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Recycled Heavyweight Puffer Jacket",
                "Description for Recycled Heavyweight Puffer Jacket", "https://www1.assets-gap.com/webcontent/0060/463/993/cn60463993.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/463/974/cn60463974.jpg", "https://www.gap.com/webcontent/0060/448/738/cn60448738.jpg", "https://www.gap.com/webcontent/0060/448/756/cn60448756.jpg", "https://www.gap.com/webcontent/0061/092/239/cn61092239.jpg", "https://www.gap.com/webcontent/0060/138/098/cn60138098.jpg"));
        createVariants(p, List.of("Brown", "Black", "Red", "Navy", "Green", "Custom"), 168, 134, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur Relaxed Zip Hoodie",
                "Description for Faux Fur Relaxed Zip Hoodie", "https://www1.assets-gap.com/webcontent/0061/459/159/cn61459159.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0061/459/152/cn61459152.jpg", "https://www.gap.com/webcontent/0061/453/322/cn61453322.jpg", "https://www.gap.com/webcontent/0061/453/342/cn61453342.jpg", "https://www.gap.com/webcontent/0061/453/377/cn61453377.jpg", "https://www.gap.com/webcontent/0061/453/349/cn61453349.jpg", "https://www.gap.com/webcontent/0061/247/992/cn61247992.jpg"));
        createVariants(p, List.of("Tan"), 268, 107, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Recycled Sherpa & Vegan Leather-Trim Jacket" */
        p = createProduct(admin, categoryMap.get("Coats"), "Recycled Sherpa & Vegan Leather-Trim Jacket",
                "Description for Recycled Sherpa & Vegan Leather-Trim Jacket", "https://www1.assets-gap.com/webcontent/0060/762/477/cn60762477.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/762/461/cn60762461.jpg", "https://www.gap.com/webcontent/0060/750/857/cn60750857.jpg", "https://www.gap.com/webcontent/0060/750/880/cn60750880.jpg", "https://www.gap.com/webcontent/0060/750/852/cn60750852.jpg", "https://www.gap.com/webcontent/0060/750/860/cn60750860.jpg", "https://www.gap.com/webcontent/0061/314/999/cn61314999.jpg"));
        createVariants(p, List.of("Beige", "Black"), 268, 268, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Icon Trench Coat" */
        p = createProduct(admin, categoryMap.get("Coats"), "Icon Trench Coat",
                "Description for Icon Trench Coat", "https://www1.assets-gap.com/webcontent/0059/564/240/cn59564240.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/564/235/cn59564235.jpg", "https://www.gap.com/webcontent/0059/564/096/cn59564096.jpg", "https://www.gap.com/webcontent/0059/564/089/cn59564089.jpg", "https://www.gap.com/webcontent/0057/936/094/cn57936094.jpg", "https://www.gap.com/webcontent/0053/613/595/cn53613595.jpg", "https://www.gap.com/webcontent/0053/670/874/cn53670874.jpg", "https://www.gap.com/webcontent/0058/044/824/cn58044824.jpg", "https://www.gap.com/webcontent/0060/013/833/cn60013833.jpg"));
        createVariants(p, List.of("Khaki", "Black"), 168, 168, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Kids Quilted Puffer Coat",
                "Description for Kids Quilted Puffer Coat", "https://www1.assets-gap.com/webcontent/0060/781/571/cn60781571.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/781/545/cn60781545.jpg", "https://www.gap.com/webcontent/0059/971/430/cn59971430.jpg", "https://www.gap.com/webcontent/0060/781/578/cn60781578.jpg", "https://www.gap.com/webcontent/0060/781/651/cn60781651.jpg", "https://www.gap.com/webcontent/0059/971/406/cn59971406.jpg", "https://www.gap.com/webcontent/0060/781/683/cn60781683.jpg"));
        createVariants(p, List.of("Black", "Silver", "Pink"), 148, 59, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Recycled Lightweight Oversized Quilted Liner Jacket",
                "Description for Recycled Lightweight Oversized Quilted Liner Jacket", "https://www1.assets-gap.com/webcontent/0060/221/914/cn60221914.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/221/884/cn60221884.jpg", "https://www.gap.com/webcontent/0060/221/893/cn60221893.jpg", "https://www.gap.com/webcontent/0060/221/905/cn60221905.jpg", "https://www.gap.com/webcontent/0060/221/919/cn60221919.jpg", "https://www.gap.com/webcontent/0060/771/997/cn60771997.jpg", "https://www.gap.com/webcontent/0060/772/018/cn60772018.jpg"));
        createVariants(p, List.of("Black", "Green"), 168, 54.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Cotton-Blend Cardigan Coat",
                "Description for Cotton-Blend Cardigan Coat", "https://www1.assets-gap.com/webcontent/0061/253/076/cn61253076.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0061/253/071/cn61253071.jpg", "https://www.gap.com/webcontent/0061/211/165/cn61211165.jpg", "https://www.gap.com/webcontent/0061/211/176/cn61211176.jpg", "https://www.gap.com/webcontent/0061/211/193/cn61211193.jpg", "https://www.gap.com/webcontent/0061/211/211/cn61211211.jpg"));
        createVariants(p, List.of("Blue", "Brown"), 168, 168, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Swing Jacket",
                "Description for Wool-Blend Swing Jacket", "https://www1.assets-gap.com/webcontent/0060/432/123/cn60432123.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/432/100/cn60432100.jpg", "https://www.gap.com/webcontent/0060/431/001/cn60431001.jpg", "https://www.gap.com/webcontent/0060/432/442/cn60432442.jpg", "https://www.gap.com/webcontent/0060/432/466/cn60432466.jpg", "https://www.gap.com/webcontent/0060/431/016/cn60431016.jpg"));
        createVariants(p, List.of("Blue", "Tan"), 228, 114, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Faux Fur Bomber Jacket",
                "Description for Faux Fur Bomber Jacket", "https://www1.assets-gap.com/webcontent/0060/891/367/cn60891367.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/891/323/cn60891323.jpg", "https://www.gap.com/webcontent/0060/891/325/cn60891325.jpg", "https://www.gap.com/webcontent/0060/891/329/cn60891329.jpg", "https://www.gap.com/webcontent/0060/415/513/cn60415513.jpg", "https://www.gap.com/webcontent/0060/922/398/cn60922398.jpg", "https://www.gap.com/webcontent/0060/472/116/cn60472116.jpg"));
        createVariants(p, List.of("Brown"), 198, 198, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Vegan Leather Bomber Jacket",
                "Description for Vegan Leather Bomber Jacket", "https://www1.assets-gap.com/webcontent/0060/264/759/cn60264759.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/264/725/cn60264725.jpg", "https://www.gap.com/webcontent/0060/264/735/cn60264735.jpg", "https://www.gap.com/webcontent/0060/264/738/cn60264738.jpg", "https://www.gap.com/webcontent/0060/264/752/cn60264752.jpg", "https://www.gap.com/webcontent/0059/831/071/cn59831071.jpg"));
        createVariants(p, List.of("Black"), 198, 79, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Cropped Floral Denim Icon Jacket",
                "Description for Cropped Floral Denim Icon Jacket", "https://www1.assets-gap.com/webcontent/0057/694/839/cn57694839.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/694/794/cn57694794.jpg", "https://www.gap.com/webcontent/0057/699/872/cn57699872.jpg", "https://www.gap.com/webcontent/0057/699/865/cn57699865.jpg", "https://www.gap.com/webcontent/0057/730/137/cn57730137.jpg", "https://www.gap.com/webcontent/0057/730/138/cn57730138.jpg"));
        createVariants(p, List.of("Custom", "Blue", "Indigo"), 98, 29.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Wool-Blend Oversized Houndstooth Car Coat",
                "Description for Wool-Blend Oversized Houndstooth Car Coat", "https://www1.assets-gap.com/webcontent/0060/240/246/cn60240246.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/240/176/cn60240176.jpg", "https://www.gap.com/webcontent/0060/238/566/cn60238566.jpg", "https://www.gap.com/webcontent/0060/238/575/cn60238575.jpg", "https://www.gap.com/webcontent/0060/238/588/cn60238588.jpg", "https://www.gap.com/webcontent/0060/238/676/cn60238676.jpg"));
        createVariants(p, List.of("Tan"), 268, 199.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "UltraSoft Denim Stripe Cropped Icon Jacket",
                "Description for UltraSoft Denim Stripe Cropped Icon Jacket", "https://www1.assets-gap.com/webcontent/0057/299/740/cn57299740.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/299/729/cn57299729.jpg", "https://www.gap.com/webcontent/0057/298/994/cn57298994.jpg", "https://www.gap.com/webcontent/0057/298/985/cn57298985.jpg", "https://www.gap.com/webcontent/0057/512/440/cn57512440.jpg", "https://www.gap.com/webcontent/0057/512/834/cn57512834.jpg"));
        createVariants(p, List.of("Custom", "Blue", "Indigo"), 89.95, 29.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Coats"), "Gap × Sandy Liang Reversible Vegan Leather Sherpa Jacket",
                "Description for Gap × Sandy Liang Reversible Vegan Leather Sherpa Jacket", "https://www1.assets-gap.com/webcontent/0060/514/334/cn60514334.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/514/312/cn60514312.jpg", "https://www.gap.com/webcontent/0060/769/667/cn60769667.jpg", "https://www.gap.com/webcontent/0060/769/660/cn60769660.jpg", "https://www.gap.com/webcontent/0060/660/995/cn60660995.jpg", "https://www.gap.com/webcontent/0060/659/758/cn60659758.jpg", "https://www.gap.com/webcontent/0060/671/244/cn60671244.jpg", "https://www.gap.com/webcontent/0060/674/641/cn60674641.jpg"));
        createVariants(p, List.of("Brown"), 268, 149.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Patent Leather Heels",
                "Description for Vegan Patent Leather Heels", "https://www1.assets-gap.com/webcontent/0060/139/423/cn60139423.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/139/404/cn60139404.jpg", "https://www.gap.com/webcontent/0060/137/897/cn60137897.jpg", "https://www.gap.com/webcontent/0060/137/905/cn60137905.jpg", "https://www.gap.com/webcontent/0060/137/907/cn60137907.jpg", "https://www.gap.com/webcontent/0060/137/919/cn60137919.jpg"));
        createVariants(p, List.of("Black"), 69.95, 27, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Vegan Suede Loafers" */
        p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Loafers",
                "Description for Vegan Suede Loafers", "https://www1.assets-gap.com/webcontent/0059/680/145/cn59680145.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/680/110/cn59680110.jpg", "https://www.gap.com/webcontent/0059/679/382/cn59679382.jpg", "https://www.gap.com/webcontent/0059/679/391/cn59679391.jpg", "https://www.gap.com/webcontent/0059/679/392/cn59679392.jpg", "https://www.gap.com/webcontent/0059/679/426/cn59679426.jpg"));
        createVariants(p, List.of("Brown", "Black"), 59.95, 44.99, colorMap, sizeMap, materialMap, seasonMap);

        /* giữ 1 lần duy nhất theo name: "Mary Jane Flats" */
        p = createProduct(admin, categoryMap.get("Shoe"), "Mary Jane Flats",
                "Description for Mary Jane Flats", "https://www1.assets-gap.com/webcontent/0060/021/611/cn60021611.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/021/605/cn60021605.jpg", "https://www.gap.com/webcontent/0060/049/917/cn60049917.jpg", "https://www.gap.com/webcontent/0060/024/265/cn60024265.jpg", "https://www.gap.com/webcontent/0060/024/278/cn60024278.jpg", "https://www.gap.com/webcontent/0060/029/502/cn60029502.jpg"));
        createVariants(p, List.of("Black", "Blue"), 54.95, 21, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Boots",
                "Description for Kitten Heel Pointy Boots", "https://www1.assets-gap.com/webcontent/0060/427/494/cn60427494.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/427/485/cn60427485.jpg", "https://www.gap.com/webcontent/0060/425/112/cn60425112.jpg", "https://www.gap.com/webcontent/0060/425/205/cn60425205.jpg", "https://www.gap.com/webcontent/0060/427/534/cn60427534.jpg", "https://www.gap.com/webcontent/0060/425/332/cn60425332.jpg"));
        createVariants(p, List.of("Black", "Brown", "Burgundy"), 98, 39, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Ballet Flats",
                "Description for Vegan Suede Ballet Flats", "https://www1.assets-gap.com/webcontent/0060/234/428/cn60234428.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/234/416/cn60234416.jpg", "https://www.gap.com/webcontent/0060/233/085/cn60233085.jpg", "https://www.gap.com/webcontent/0060/233/106/cn60233106.jpg", "https://www.gap.com/webcontent/0060/233/112/cn60233112.jpg", "https://www.gap.com/webcontent/0060/233/129/cn60233129.jpg"));
        createVariants(p, List.of("Blue", "Brown"), 59.95, 39.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Slingback Kitten Heels",
                "Description for Slingback Kitten Heels", "https://www1.assets-gap.com/webcontent/0059/662/302/cn59662302.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/662/293/cn59662293.jpg", "https://www.gap.com/webcontent/0059/662/021/cn59662021.jpg", "https://www.gap.com/webcontent/0059/662/048/cn59662048.jpg", "https://www.gap.com/webcontent/0059/662/062/cn59662062.jpg", "https://www.gap.com/webcontent/0059/662/098/cn59662098.jpg"));
        createVariants(p, List.of("Black", "Brown", "Custom"), 69.95, 34, colorMap, sizeMap, materialMap, seasonMap);
        /*ádsa*/
        p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Leather Riding Boots",
                "Description for Vegan Leather Riding Boots", "https://www1.assets-gap.com/webcontent/0060/427/538/cn60427538.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/427/529/cn60427529.jpg", "https://www.gap.com/webcontent/0060/425/192/cn60425192.jpg", "https://www.gap.com/webcontent/0060/425/194/cn60425194.jpg", "https://www.gap.com/webcontent/0060/425/239/cn60425239.jpg", "https://www.gap.com/webcontent/0060/425/297/cn60425297.jpg"));
        createVariants(p, List.of("Black"), 110, 44, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Suede Ballet Flats",
                "Description for Vegan Suede Ballet Flats", "https://www1.assets-gap.com/webcontent/0059/672/374/cn59672374.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/672/365/cn59672365.jpg", "https://www.gap.com/webcontent/0059/669/951/cn59669951.jpg", "https://www.gap.com/webcontent/0059/763/101/cn59763101.jpg", "https://www.gap.com/webcontent/0059/669/967/cn59669967.jpg", "https://www.gap.com/webcontent/0059/669/969/cn59669969.jpg"));
        createVariants(p, List.of("Blue", "Brown"), 59.95, 19.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Knee High Boots",
                "Description for Kitten Heel Pointy Knee High Boots", "https://www1.assets-gap.com/webcontent/0060/427/467/cn60427467.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/427/460/cn60427460.jpg", "https://www.gap.com/webcontent/0060/425/101/cn60425101.jpg", "https://www.gap.com/webcontent/0060/425/154/cn60425154.jpg", "https://www.gap.com/webcontent/0060/425/252/cn60425252.jpg", "https://www.gap.com/webcontent/0060/425/347/cn60425347.jpg"));
        createVariants(p, List.of("Black", "Brown"), 118, 47, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Sherpa Slippers",
                "Description for Sherpa Slippers", "https://www1.assets-gap.com/webcontent/0060/377/447/cn60377447.jpg?q=h&w=1152", null);
        createVariants(p, List.of("Brown"), 39.95, 15, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Vegan Leather Lug Sole Tall Boots",
                "Description for Vegan Leather Lug Sole Tall Boots", "https://www1.assets-gap.com/webcontent/0060/427/517/cn60427517.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/427/506/cn60427506.jpg", "https://www.gap.com/webcontent/0060/425/184/cn60425184.jpg", "https://www.gap.com/webcontent/0060/425/221/cn60425221.jpg", "https://www.gap.com/webcontent/0060/425/274/cn60425274.jpg", "https://www.gap.com/webcontent/0060/427/127/cn60427127.jpg"));
        createVariants(p, List.of("Brown", "Black"), 118, 59, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Faux Fur Slippers",
                "Description for Faux Fur Slippers", "https://www1.assets-gap.com/webcontent/0060/498/266/cn60498266.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/498/261/cn60498261.jpg", "https://www.gap.com/webcontent/0060/498/274/cn60498274.jpg", "https://www.gap.com/webcontent/0060/498/293/cn60498293.jpg", "https://www.gap.com/webcontent/0060/498/309/cn60498309.jpg", "https://www.gap.com/webcontent/0060/498/322/cn60498322.jpg"));
        createVariants(p, List.of("Black", "Brown"), 49.95, 19, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kids Moc Sneakers",
                "Description for Kids Moc Sneakers", "https://www1.assets-gap.com/webcontent/0057/143/685/cn57143685.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/143/680/cn57143680.jpg", "https://www.gap.com/webcontent/0057/143/025/cn57143025.jpg", "https://www.gap.com/webcontent/0057/143/074/cn57143074.jpg", "https://www.gap.com/webcontent/0057/143/065/cn57143065.jpg", "https://www.gap.com/webcontent/0057/143/075/cn57143075.jpg"));
        createVariants(p, List.of("Custom"), 44.95, 19.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Slingback Kitten Heels",
                "Description for Slingback Kitten Heels", "https://www1.assets-gap.com/webcontent/0059/662/324/cn59662324.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/662/314/cn59662314.jpg", "https://www.gap.com/webcontent/0059/662/050/cn59662050.jpg", "https://www.gap.com/webcontent/0059/662/056/cn59662056.jpg", "https://www.gap.com/webcontent/0059/662/082/cn59662082.jpg", "https://www.gap.com/webcontent/0059/662/104/cn59662104.jpg"));
        createVariants(p, List.of("Black", "Brown", "Custom"), 69.95, 34, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Buckle Cork Sandals",
                "Description for Toddler Buckle Cork Sandals", "https://www1.assets-gap.com/webcontent/0057/324/034/cn57324034.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/324/025/cn57324025.jpg", "https://www.gap.com/webcontent/0057/324/048/cn57324048.jpg", "https://www.gap.com/webcontent/0057/322/798/cn57322798.jpg", "https://www.gap.com/webcontent/0057/324/051/cn57324051.jpg", "https://www.gap.com/webcontent/0057/324/059/cn57324059.jpg"));
        createVariants(p, List.of("Blue", "Green"), 34.95, 14.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kids Canvas Strap Sandals",
                "Description for Kids Canvas Strap Sandals", "https://www1.assets-gap.com/webcontent/0057/611/558/cn57611558.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/611/551/cn57611551.jpg", "https://www.gap.com/webcontent/0057/609/778/cn57609778.jpg", "https://www.gap.com/webcontent/0057/609/787/cn57609787.jpg", "https://www.gap.com/webcontent/0057/609/790/cn57609790.jpg", "https://www.gap.com/webcontent/0057/609/789/cn57609789.jpg"));
        createVariants(p, List.of("Custom"), 39.95, 12.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Denim Mary Jane Flats",
                "Description for Denim Mary Jane Flats", "https://www1.assets-gap.com/webcontent/0057/610/985/cn57610985.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/610/976/cn57610976.jpg", "https://www.gap.com/webcontent/0057/609/175/cn57609175.jpg", "https://www.gap.com/webcontent/0057/609/183/cn57609183.jpg", "https://www.gap.com/webcontent/0057/609/189/cn57609189.jpg", "https://www.gap.com/webcontent/0057/609/198/cn57609198.jpg"));
        createVariants(p, List.of("Blue"), 54.95, 32, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kids T-Strap Loafers",
                "Description for Kids T-Strap Loafers", "https://www1.assets-gap.com/webcontent/0059/672/467/cn59672467.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/672/462/cn59672462.jpg", "https://www.gap.com/webcontent/0059/670/460/cn59670460.jpg", "https://www.gap.com/webcontent/0059/670/467/cn59670467.jpg", "https://www.gap.com/webcontent/0059/670/482/cn59670482.jpg", "https://www.gap.com/webcontent/0059/670/530/cn59670530.jpg"));
        createVariants(p, List.of("Burgundy", "Black"), 49.95, 49.95, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Corduroy Mary Jane Flats",
                "Description for Toddler Corduroy Mary Jane Flats", "https://www1.assets-gap.com/webcontent/0059/961/171/cn59961171.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/961/151/cn59961151.jpg", "https://www.gap.com/webcontent/0059/959/519/cn59959519.jpg", "https://www.gap.com/webcontent/0059/959/518/cn59959518.jpg", "https://www.gap.com/webcontent/0059/959/556/cn59959556.jpg", "https://www.gap.com/webcontent/0059/959/568/cn59959568.jpg"));
        createVariants(p, List.of("Red", "Pink", "Custom"), 39.95, 19, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kitten Heel Pointy Boots",
                "Description for Kitten Heel Pointy Boots", "https://www1.assets-gap.com/webcontent/0060/427/479/cn60427479.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/427/474/cn60427474.jpg", "https://www.gap.com/webcontent/0060/425/156/cn60425156.jpg", "https://www.gap.com/webcontent/0060/425/167/cn60425167.jpg", "https://www.gap.com/webcontent/0060/425/268/cn60425268.jpg", "https://www.gap.com/webcontent/0060/425/331/cn60425331.jpg"));
        createVariants(p, List.of("Black", "Brown", "Burgundy"), 98, 39, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kids Studded Mary Jane Flats",
                "Description for Kids Studded Mary Jane Flats", "https://www1.assets-gap.com/webcontent/0059/672/498/cn59672498.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/672/488/cn59672488.jpg", "https://www.gap.com/webcontent/0059/679/736/cn59679736.jpg", "https://www.gap.com/webcontent/0059/670/480/cn59670480.jpg", "https://www.gap.com/webcontent/0059/670/528/cn59670528.jpg", "https://www.gap.com/webcontent/0059/670/541/cn59670541.jpg"));
        createVariants(p, List.of("Black"), 44.95, 22, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Jelly Ballet Flats",
                "Description for Jelly Ballet Flats", "https://www1.assets-gap.com/webcontent/0058/008/111/cn58008111.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0058/008/104/cn58008104.jpg", "https://www.gap.com/webcontent/0058/007/301/cn58007301.jpg", "https://www.gap.com/webcontent/0058/007/311/cn58007311.jpg", "https://www.gap.com/webcontent/0058/007/319/cn58007319.jpg", "https://www.gap.com/webcontent/0058/007/320/cn58007320.jpg"));
        createVariants(p, List.of("Custom", "Pink", "Blue"), 49.95, 16.97, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kids Corduroy Sneakers",
                "Description for Kids Corduroy Sneakers", "https://www1.assets-gap.com/webcontent/0059/698/921/cn59698921.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/698/911/cn59698911.jpg", "https://www.gap.com/webcontent/0059/697/790/cn59697790.jpg", "https://www.gap.com/webcontent/0059/697/800/cn59697800.jpg", "https://www.gap.com/webcontent/0059/697/803/cn59697803.jpg", "https://www.gap.com/webcontent/0059/697/831/cn59697831.jpg"));
        createVariants(p, List.of("Red", "Green"), 49.95, 19, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Denim Clogs",
                "Description for Toddler Denim Clogs", "https://www1.assets-gap.com/webcontent/0060/159/685/cn60159685.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/159/662/cn60159662.jpg", "https://www.gap.com/webcontent/0060/162/255/cn60162255.jpg", "https://www.gap.com/webcontent/0060/162/262/cn60162262.jpg", "https://www.gap.com/webcontent/0060/158/687/cn60158687.jpg", "https://www.gap.com/webcontent/0060/158/690/cn60158690.jpg"));
        createVariants(p, List.of("Custom"), 34.95, 13, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Kids Bow Ankle Boots",
                "Description for Kids Bow Ankle Boots", "https://www1.assets-gap.com/webcontent/0060/416/273/cn60416273.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/416/259/cn60416259.jpg", "https://www.gap.com/webcontent/0060/415/353/cn60415353.jpg", "https://www.gap.com/webcontent/0060/415/368/cn60415368.jpg", "https://www.gap.com/webcontent/0060/415/370/cn60415370.jpg", "https://www.gap.com/webcontent/0060/415/379/cn60415379.jpg"));
        createVariants(p, List.of("Red"), 59.95, 29, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shoe"), "Toddler Jelly Flower Sandals",
                "Description for Toddler Jelly Flower Sandals", "https://www1.assets-gap.com/webcontent/0057/333/304/cn57333304.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/333/298/cn57333298.jpg", "https://www.gap.com/webcontent/0057/333/306/cn57333306.jpg", "https://www.gap.com/webcontent/0057/333/317/cn57333317.jpg", "https://www.gap.com/webcontent/0057/333/344/cn57333344.jpg", "https://www.gap.com/webcontent/0057/333/348/cn57333348.jpg"));
        createVariants(p, List.of("Custom"), 29.95, 12.97, colorMap, sizeMap, materialMap, seasonMap);

        /* New Products: giữ 1 lần duy nhất theo name: "High Rise VintageSoft Relaxed Joggers" */
        p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                "Description for High Rise VintageSoft Relaxed Joggers", "https://www1.assets-gap.com/webcontent/0059/151/338/cn59151338.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/151/311/cn59151311.jpg", "https://www.gap.com/webcontent/0059/151/387/cn59151387.jpg", "https://www.gap.com/webcontent/0059/151/074/cn59151074.jpg", "https://www.gap.com/webcontent/0059/151/339/cn59151339.jpg", "https://www.gap.com/webcontent/0053/450/970/cn53450970.jpg", "https://www.gap.com/webcontent/0053/426/050/cn53426050.jpg", "https://www.gap.com/webcontent/0059/127/143/cn59127143.jpg", "https://www.gap.com/webcontent/0060/825/655/cn60825655.jpg"));
        createVariants(p, List.of("White", "Blue", "Grey", "Pink", "Brown", "Black", "Navy", "Beige", "Yellow", "Red"), 59.95, 35, colorMap, sizeMap, materialMap, seasonMap);

        /* New Products: giữ 1 lần duy nhất theo name: "VintageSoft Wedge Crewneck Sweatshirt" */
        p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                "Description for VintageSoft Wedge Crewneck Sweatshirt", "https://www1.assets-gap.com/webcontent/0060/601/842/cn60601842.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/601/826/cn60601826.jpg", "https://www.gap.com/webcontent/0059/356/197/cn59356197.jpg", "https://www.gap.com/webcontent/0060/601/837/cn60601837.jpg", "https://www.gap.com/webcontent/0060/719/961/cn60719961.jpg", "https://www.gap.com/webcontent/0059/434/651/cn59434651.jpg"));
        createVariants(p, List.of("Brown", "Pink", "Blue", "Red", "Black", "Grey", "White", "Green"), 59.95, 29, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Joggers",
                "Description for High Rise VintageSoft Joggers", "https://www1.assets-gap.com/webcontent/0060/149/766/cn60149766.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/149/755/cn60149755.jpg", "https://www.gap.com/webcontent/0060/147/266/cn60147266.jpg", "https://www.gap.com/webcontent/0060/147/265/cn60147265.jpg", "https://www.gap.com/webcontent/0060/147/278/cn60147278.jpg", "https://www.gap.com/webcontent/0059/708/980/cn59708980.jpg", "https://www.gap.com/webcontent/0059/708/973/cn59708973.jpg"));
        createVariants(p, List.of("White", "Blue", "Grey", "Pink", "Brown", "Black", "Navy", "Beige", "Yellow", "Red"), 49.95, 24, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "Pet CashSoft Sweater",
                "Description for Pet CashSoft Sweater", "https://www1.assets-gap.com/webcontent/0060/942/135/cn60942135.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/942/111/cn60942111.jpg", "https://www.gap.com/webcontent/0060/942/138/cn60942138.jpg", "https://www.gap.com/webcontent/0060/942/154/cn60942154.jpg", "https://www.gap.com/webcontent/0060/208/548/cn60208548.jpg"));
        createVariants(p, List.of("Custom"), 44.95, 35, colorMap, sizeMap, materialMap, seasonMap);
        /*sdada*/
        p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Wedge Crewneck Sweatshirt",
                "Description for VintageSoft Wedge Crewneck Sweatshirt", "https://www1.assets-gap.com/webcontent/0056/347/794/cn56347794.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0056/347/750/cn56347750.jpg", "https://www.gap.com/webcontent/0056/347/630/cn56347630.jpg", "https://www.gap.com/webcontent/0056/347/637/cn56347637.jpg", "https://www.gap.com/webcontent/0056/168/364/cn56168364.jpg"));
        createVariants(p, List.of("Brown", "Pink", "Blue", "Red", "Black", "Grey", "White", "Green"), 59.95, 35, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Relaxed Joggers",
                "Description for High Rise VintageSoft Relaxed Joggers", "https://www1.assets-gap.com/webcontent/0060/797/831/cn60797831.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0061/332/978/cn61332978.jpg", "https://www.gap.com/webcontent/0061/332/999/cn61332999.jpg", "https://www.gap.com/webcontent/0061/333/007/cn61333007.jpg", "https://www.gap.com/webcontent/0061/332/982/cn61332982.jpg", "https://www.gap.com/webcontent/0061/333/011/cn61333011.jpg", "https://www.gap.com/webcontent/0060/824/371/cn60824371.jpg"));
        createVariants(p, List.of("White", "Blue", "Grey", "Pink", "Brown", "Black", "Navy", "Beige", "Yellow", "Red"), 49.95, 39.99, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "Relaxed Straight Jeans",
                "Description for Relaxed Straight Jeans", "https://www1.assets-gap.com/webcontent/0060/078/075/cn60078075.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/078/026/cn60078026.jpg", "https://www.gap.com/webcontent/0060/078/051/cn60078051.jpg", "https://www.gap.com/webcontent/0060/078/046/cn60078046.jpg", "https://www.gap.com/webcontent/0060/078/086/cn60078086.jpg", "https://www.gap.com/webcontent/0059/565/741/cn59565741.jpg", "https://www.gap.com/webcontent/0059/565/744/cn59565744.jpg"));
        createVariants(p, List.of("Custom", "Blue", "Olive", "Brown", "White"), 79.95, 47, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "Cotton-Blend Relaxed Crewneck Sweater",
                "Description for Cotton-Blend Relaxed Crewneck Sweater", "https://www1.assets-gap.com/webcontent/0060/633/052/cn60633052.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/633/042/cn60633042.jpg", "https://www.gap.com/webcontent/0060/630/003/cn60630003.jpg", "https://www.gap.com/webcontent/0060/630/080/cn60630080.jpg", "https://www.gap.com/webcontent/0060/630/119/cn60630119.jpg", "https://www.gap.com/webcontent/0060/630/166/cn60630166.jpg"));
        createVariants(p, List.of("Custom", "Black", "Blue", "Pink", "Beige"), 79.95, 63, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "VintageSoft Logo Wedge Sweatshirt",
                "Description for VintageSoft Logo Wedge Sweatshirt", "https://www1.assets-gap.com/webcontent/0060/124/563/cn60124563.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0056/347/750/cn56347750.jpg", "https://www.gap.com/webcontent/0056/347/630/cn56347630.jpg", "https://www.gap.com/webcontent/0056/347/637/cn56347637.jpg", "https://www.gap.com/webcontent/0056/168/364/cn56168364.jpg"));
        createVariants(p, List.of("Brown", "Pink", "Blue", "Red", "Black", "Grey", "White", "Green"), 59.95, 29, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("New Products"), "High Rise VintageSoft Joggers",
                "Description for High Rise VintageSoft Joggers", "https://www1.assets-gap.com/webcontent/0059/962/243/cn59962243.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/962/234/cn59962234.jpg", "https://www.gap.com/webcontent/0059/959/818/cn59959818.jpg", "https://www.gap.com/webcontent/0059/959/845/cn59959845.jpg", "https://www.gap.com/webcontent/0059/959/843/cn59959843.jpg", "https://www.gap.com/webcontent/0059/592/674/cn59592674.jpg", "https://www.gap.com/webcontent/0059/959/864/cn59959864.jpg"));
        createVariants(p, List.of("White", "Blue", "Grey", "Pink", "Brown", "Black", "Navy", "Beige", "Yellow", "Red"), 59.95, 47, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Modern Crewneck T-Shirt",
                "Description for Modern Crewneck T-Shirt", "https://www1.assets-gap.com/webcontent/0057/721/250/cn57721250.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/721/231/cn57721231.jpg", "https://www.gap.com/webcontent/0057/440/624/cn57440624.jpg", "https://www.gap.com/webcontent/0057/721/245/cn57721245.jpg", "https://www.gap.com/webcontent/0061/005/677/cn61005677.jpg"));
        createVariants(p, List.of("Blue", "Grey", "Black", "White"), 24.95, 9, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Classic T-Shirt",
                "Description for Classic T-Shirt", "https://www1.assets-gap.com/webcontent/0020/344/743/cn20344743.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0055/768/203/cn55768203.jpg", "https://www.gap.com/webcontent/0055/768/095/cn55768095.jpg", "https://www.gap.com/webcontent/0055/768/250/cn55768250.jpg", "https://www.gap.com/webcontent/0055/639/185/cn55639185.jpg", "https://www.gap.com/webcontent/0055/722/170/cn55722170.jpg"));
        createVariants(p, List.of("White", "Blue", "Black", "Grey"), 19.95, 13, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "CloseKnit Jersey T-Shirt",
                "Description for CloseKnit Jersey T-Shirt", "https://www1.assets-gap.com/webcontent/0057/791/130/cn57791130.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/791/120/cn57791120.jpg", "https://www.gap.com/webcontent/0057/790/938/cn57790938.jpg", "https://www.gap.com/webcontent/0057/791/137/cn57791137.jpg", "https://www.gap.com/webcontent/0057/860/160/cn57860160.jpg", "https://www.gap.com/webcontent/0058/028/015/cn58028015.jpg"));
        createVariants(p, List.of("Red", "Brown", "Black", "Blue", "Grey", "White"), 24.95, 14, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton VintageSoft T-Shirt",
                "Description for Organic Cotton VintageSoft T-Shirt", "https://www1.assets-gap.com/webcontent/0057/796/475/cn57796475.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0057/796/433/cn57796433.jpg", "https://www.gap.com/webcontent/0057/796/468/cn57796468.jpg", "https://www.gap.com/webcontent/0057/796/474/cn57796474.jpg", "https://www.gap.com/webcontent/0057/860/144/cn57860144.jpg", "https://www.gap.com/webcontent/0057/860/130/cn57860130.jpg"));
        createVariants(p, List.of("White", "Brown", "Pink", "Blue", "Grey", "Black", "Red"), 24.95, 22, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Fitted Crop Shirt",
                "Description for Organic Cotton Fitted Crop Shirt", "https://www1.assets-gap.com/webcontent/0060/802/837/cn60802837.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/802/832/cn60802832.jpg", "https://www.gap.com/webcontent/0060/802/844/cn60802844.jpg", "https://www.gap.com/webcontent/0060/802/851/cn60802851.jpg", "https://www.gap.com/webcontent/0060/136/692/cn60136692.jpg"));
        createVariants(p, List.of("White", "Custom", "Red", "Black"), 69.95, 34, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Modern Boatneck T-Shirt",
                "Description for Modern Boatneck T-Shirt", "https://www1.assets-gap.com/webcontent/0059/852/790/cn59852790.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/852/779/cn59852779.jpg", "https://www.gap.com/webcontent/0059/851/127/cn59851127.jpg", "https://www.gap.com/webcontent/0059/851/148/cn59851148.jpg", "https://www.gap.com/webcontent/0059/592/218/cn59592218.jpg", "https://www.gap.com/webcontent/0059/851/156/cn59851156.jpg"));
        createVariants(p, List.of("Brown", "Grey", "Black", "White"), 39.95, 23, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton T-Shirt",
                "Description for Organic Cotton T-Shirt", "https://www1.assets-gap.com/webcontent/0060/939/683/cn60939683.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0060/939/649/cn60939649.jpg", "https://www.gap.com/webcontent/0060/943/043/cn60943043.jpg", "https://www.gap.com/webcontent/0060/939/209/cn60939209.jpg"));
        createVariants(p, List.of("Beige", "Olive", "Navy", "Black", "White", "Grey"), 34.95, 17, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Classic Shirt",
                "Description for Organic Cotton Poplin Classic Shirt", "https://www1.assets-gap.com/webcontent/0059/577/691/cn59577691.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/577/674/cn59577674.jpg", "https://www.gap.com/webcontent/0059/577/689/cn59577689.jpg", "https://www.gap.com/webcontent/0059/577/683/cn59577683.jpg", "https://www.gap.com/webcontent/0058/006/974/cn58006974.jpg", "https://www.gap.com/webcontent/0058/072/345/cn58072345.jpg"));
        createVariants(p, List.of("Navy", "Black", "Green", "Blue", "White", "Pink"), 59.95, 35, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Poplin Big Shirt",
                "Description for Organic Cotton Poplin Big Shirt", "https://www1.assets-gap.com/webcontent/0059/682/364/cn59682364.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/682/314/cn59682314.jpg", "https://www.gap.com/webcontent/0059/764/254/cn59764254.jpg", "https://www.gap.com/webcontent/0059/682/116/cn59682116.jpg", "https://www.gap.com/webcontent/0061/006/191/cn61006191.jpg"));
        createVariants(p, List.of("White", "Blue", "Burgundy", "Black"), 69.95, 69.95, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Organic Cotton Oxford Big Shirt",
                "Description for Organic Cotton Oxford Big Shirt", "https://www1.assets-gap.com/webcontent/0056/556/815/cn56556815.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0056/556/818/cn56556818.jpg", "https://www.gap.com/webcontent/0056/184/310/cn56184310.jpg", "https://www.gap.com/webcontent/0056/556/830/cn56556830.jpg", "https://www.gap.com/webcontent/0056/071/184/cn56071184.jpg"));
        createVariants(p, List.of("White", "Blue", "Burgundy", "Black"), 69.95, 69.95, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Shirts"), "Oxford Button-Down Shirt",
                "Description for Oxford Button-Down Shirt", "https://www1.assets-gap.com/webcontent/0059/178/344/cn59178344.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/178/339/cn59178339.jpg", "https://www.gap.com/webcontent/0059/177/810/cn59177810.jpg", "https://www.gap.com/webcontent/0059/177/805/cn59177805.jpg", "https://www.gap.com/webcontent/0059/177/850/cn59177850.jpg", "https://www.gap.com/webcontent/0059/209/544/cn59209544.jpg"));
        createVariants(p, List.of("Blue", "White", "Navy", "Olive", "Pink", "Red", "Custom", "Black"), 59.95, 35, colorMap, sizeMap, materialMap, seasonMap);

        /* Collections */
        p = createProduct(admin, categoryMap.get("Collections"), "VintageSoft Baggy Wide-Leg Sweatpants",
                "Description for VintageSoft Baggy Wide-Leg Sweatpants", "https://www1.assets-gap.com/webcontent/0056/601/381/cn56601381.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0056/601/367/cn56601367.jpg", "https://www.gap.com/webcontent/0056/600/701/cn56600701.jpg", "https://www.gap.com/webcontent/0056/600/686/cn56600686.jpg", "https://www.gap.com/webcontent/0056/600/685/cn56600685.jpg", "https://www.gap.com/webcontent/0056/548/138/cn56548138.jpg"));
        createVariants(p, List.of("Pink", "Blue", "Black", "Brown", "Grey", "White", "Yellow"), 59.95, 47, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Collections"), "High Rise VintageSoft Relaxed Joggers",
                "Description for High Rise VintageSoft Relaxed Joggers", "https://www1.assets-gap.com/webcontent/0059/151/338/cn59151338.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0059/151/311/cn59151311.jpg", "https://www.gap.com/webcontent/0059/151/387/cn59151387.jpg", "https://www.gap.com/webcontent/0059/151/074/cn59151074.jpg", "https://www.gap.com/webcontent/0059/151/339/cn59151339.jpg", "https://www.gap.com/webcontent/0053/450/970/cn53450970.jpg", "https://www.gap.com/webcontent/0053/426/050/cn53426050.jpg", "https://www.gap.com/webcontent/0059/127/143/cn59127143.jpg", "https://www.gap.com/webcontent/0060/825/655/cn60825655.jpg"));
        createVariants(p, List.of("White", "Blue", "Grey", "Pink", "Brown", "Black", "Navy", "Beige", "Yellow", "Red"), 59.95, 35, colorMap, sizeMap, materialMap, seasonMap);

        p = createProduct(admin, categoryMap.get("Collections"), "High Rise Stride Wide-Leg Jeans",
                "Description for High Rise Stride Wide-Leg Jeans", "https://www1.assets-gap.com/webcontent/0061/136/262/cn61136262.jpg?q=h&w=1152", List.of("https://www.gap.com/webcontent/0061/136/247/cn61136247.jpg", "https://www.gap.com/webcontent/0061/136/250/cn61136250.jpg", "https://www.gap.com/webcontent/0061/136/264/cn61136264.jpg", "https://www.gap.com/webcontent/0061/136/258/cn61136258.jpg", "https://www.gap.com/webcontent/0061/106/392/cn61106392.jpg", "https://www.gap.com/webcontent/0061/136/275/cn61136275.jpg", "https://www.gap.com/webcontent/0061/040/106/cn61040106.jpg", "https://www.gap.com/webcontent/0061/255/278/cn61255278.jpg"));
        createVariants(p, List.of("Custom", "Indigo", "Brown", "Black", "Red"), 89.95, 71, colorMap, sizeMap, materialMap, seasonMap);
    }
}
