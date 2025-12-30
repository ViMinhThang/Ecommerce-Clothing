-- ========================================
-- ECOMMERCE SAMPLE DATA - PostgreSQL
-- Chạy file này trong pgAdmin hoặc psql
-- ========================================

-- ========================================
-- 1. ROLES
-- ========================================
INSERT INTO role (id, name, status, created_date) VALUES
(1, 'ROLE_ADMIN', 'active', NOW()),
(2, 'ROLE_USER', 'active', NOW()),
(3, 'ROLE_MANAGER', 'active', NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('role_id_seq', (SELECT MAX(id) FROM role));

-- ========================================
-- 2. USERS (password = 'password123' encoded BCrypt)
-- ========================================
INSERT INTO users (id, username, password, email, full_name, status, birth_day, is_account_non_expired, is_account_non_locked, is_credentials_non_expired, is_enabled, created_date) VALUES
(1, 'admin', '$2a$10$N.zmdr9cz25t/wT4f5rk.eL8tnYzKPfZxgpXjxhX5KjKHZV/7Dqxu', 'admin@example.com', 'Admin User', 'active', '1990-01-01', true, true, true, true, NOW()),
(2, 'user1', '$2a$10$N.zmdr9cz25t/wT4f5rk.eL8tnYzKPfZxgpXjxhX5KjKHZV/7Dqxu', 'user1@example.com', 'John Doe', 'active', '1995-05-15', true, true, true, true, NOW()),
(3, 'user2', '$2a$10$N.zmdr9cz25t/wT4f5rk.eL8tnYzKPfZxgpXjxhX5KjKHZV/7Dqxu', 'user2@example.com', 'Jane Smith', 'active', '1992-08-20', true, true, true, true, NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('users_id_seq', (SELECT MAX(id) FROM users));

-- ========================================
-- 3. USER_ROLE
-- ========================================
INSERT INTO user_role (id, user_id, role_id, status, created_date) VALUES
(1, 1, 1, 'active', NOW()),
(2, 2, 2, 'active', NOW()),
(3, 3, 2, 'active', NOW())
ON CONFLICT (id) DO NOTHING;

SELECT setval('user_role_id_seq', (SELECT MAX(id) FROM user_role));

-- ========================================
-- 4. CATEGORIES
-- ========================================
INSERT INTO category (id, name, description, image_url, status, created_date, created_by) VALUES
(1, 'Áo', 'Các loại áo thời trang', 'uploads/categories/ao.jpg', 'active', NOW(), 1),
(2, 'Quần', 'Các loại quần thời trang', 'uploads/categories/quan.jpg', 'active', NOW(), 1),
(3, 'Váy', 'Các loại váy thời trang', 'uploads/categories/vay.jpg', 'active', NOW(), 1),
(4, 'Phụ kiện', 'Túi xách, mũ, kính...', 'uploads/categories/phukien.jpg', 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('category_id_seq', (SELECT MAX(id) FROM category));

-- ========================================
-- 5. COLORS
-- ========================================
INSERT INTO color (id, color_name, color_code, status, created_date, created_by) VALUES
(1, 'Đen', '#000000', 'active', NOW(), 1),
(2, 'Trắng', '#FFFFFF', 'active', NOW(), 1),
(3, 'Đỏ', '#FF0000', 'active', NOW(), 1),
(4, 'Xanh dương', '#0000FF', 'active', NOW(), 1),
(5, 'Xanh lá', '#00FF00', 'active', NOW(), 1),
(6, 'Vàng', '#FFFF00', 'active', NOW(), 1),
(7, 'Hồng', '#FFC0CB', 'active', NOW(), 1),
(8, 'Xám', '#808080', 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('color_id_seq', (SELECT MAX(id) FROM color));

-- ========================================
-- 6. SIZES
-- ========================================
INSERT INTO size (id, size_name, status, created_date, created_by) VALUES
(1, 'XS', 'active', NOW(), 1),
(2, 'S', 'active', NOW(), 1),
(3, 'M', 'active', NOW(), 1),
(4, 'L', 'active', NOW(), 1),
(5, 'XL', 'active', NOW(), 1),
(6, 'XXL', 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('size_id_seq', (SELECT MAX(id) FROM size));

-- ========================================
-- 7. SEASONS
-- ========================================
INSERT INTO season (id, season_name, status, created_date, created_by) VALUES
(1, 'Xuân', 'active', NOW(), 1),
(2, 'Hạ', 'active', NOW(), 1),
(3, 'Thu', 'active', NOW(), 1),
(4, 'Đông', 'active', NOW(), 1),
(5, 'Quanh năm', 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('season_id_seq', (SELECT MAX(id) FROM season));

-- ========================================
-- 8. MATERIALS
-- ========================================
INSERT INTO material (id, material_name, status, created_date, created_by) VALUES
(1, 'Cotton', 'active', NOW(), 1),
(2, 'Polyester', 'active', NOW(), 1),
(3, 'Linen', 'active', NOW(), 1),
(4, 'Silk', 'active', NOW(), 1),
(5, 'Denim', 'active', NOW(), 1),
(6, 'Wool', 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('material_id_seq', (SELECT MAX(id) FROM material));

-- ========================================
-- 9. PRICES (1 price per variant - vì @OneToOne)
-- ========================================
INSERT INTO price (id, base_price, sale_price, status, created_date, created_by) VALUES
-- Product 1: Áo Thun Basic (6 variants)
(1, 299000, 249000, 'active', NOW(), 1),
(2, 299000, 249000, 'active', NOW(), 1),
(3, 299000, 249000, 'active', NOW(), 1),
(4, 299000, 249000, 'active', NOW(), 1),
(5, 299000, 249000, 'active', NOW(), 1),
(6, 299000, 249000, 'active', NOW(), 1),
-- Product 2: Áo Sơ Mi Công Sở (4 variants)
(7, 499000, 399000, 'active', NOW(), 1),
(8, 499000, 399000, 'active', NOW(), 1),
(9, 499000, 399000, 'active', NOW(), 1),
(10, 499000, 399000, 'active', NOW(), 1),
-- Product 3: Áo Hoodie Oversize (4 variants)
(11, 799000, 699000, 'active', NOW(), 1),
(12, 799000, 699000, 'active', NOW(), 1),
(13, 799000, 699000, 'active', NOW(), 1),
(14, 799000, 699000, 'active', NOW(), 1),
-- Product 4: Quần Jean Skinny (6 variants)
(15, 999000, 899000, 'active', NOW(), 1),
(16, 999000, 899000, 'active', NOW(), 1),
(17, 999000, 899000, 'active', NOW(), 1),
(18, 999000, 899000, 'active', NOW(), 1),
(19, 999000, 899000, 'active', NOW(), 1),
(20, 999000, 899000, 'active', NOW(), 1),
-- Product 5: Quần Kaki Công Sở (4 variants)
(21, 599000, 499000, 'active', NOW(), 1),
(22, 599000, 499000, 'active', NOW(), 1),
(23, 599000, 499000, 'active', NOW(), 1),
(24, 599000, 499000, 'active', NOW(), 1),
-- Product 6: Váy Midi Hoa (4 variants)
(25, 1299000, 1099000, 'active', NOW(), 1),
(26, 1299000, 1099000, 'active', NOW(), 1),
(27, 1299000, 1099000, 'active', NOW(), 1),
(28, 1299000, 1099000, 'active', NOW(), 1),
-- Product 7: Váy Liền Công Sở (4 variants)
(29, 1499000, 1299000, 'active', NOW(), 1),
(30, 1499000, 1299000, 'active', NOW(), 1),
(31, 1499000, 1299000, 'active', NOW(), 1),
(32, 1499000, 1299000, 'active', NOW(), 1),
-- Product 8: Túi Xách Tote (3 variants)
(33, 1299000, 1099000, 'active', NOW(), 1),
(34, 1299000, 1099000, 'active', NOW(), 1),
(35, 1299000, 1099000, 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('price_id_seq', (SELECT MAX(id) FROM price));

-- ========================================
-- 10. PRODUCTS
-- ========================================
INSERT INTO product (id, name, image_url, category_id, status, created_date, created_by) VALUES
(1, 'Áo Thun Basic', 'uploads/products/ao-thun-basic.jpg', 1, 'active', NOW(), 1),
(2, 'Áo Sơ Mi Công Sở', 'uploads/products/ao-so-mi.jpg', 1, 'active', NOW(), 1),
(3, 'Áo Hoodie Oversize', 'uploads/products/ao-hoodie.jpg', 1, 'active', NOW(), 1),
(4, 'Quần Jean Skinny', 'uploads/products/quan-jean.jpg', 2, 'active', NOW(), 1),
(5, 'Quần Kaki Công Sở', 'uploads/products/quan-kaki.jpg', 2, 'active', NOW(), 1),
(6, 'Váy Midi Hoa', 'uploads/products/vay-hoa.jpg', 3, 'active', NOW(), 1),
(7, 'Váy Liền Công Sở', 'uploads/products/vay-cong-so.jpg', 3, 'active', NOW(), 1),
(8, 'Túi Xách Tote', 'uploads/products/tui-tote.jpg', 4, 'active', NOW(), 1)
ON CONFLICT (id) DO NOTHING;

SELECT setval('product_id_seq', (SELECT MAX(id) FROM product));

-- ========================================
-- 11. PRODUCT_VARIANTS (mỗi variant có price_id riêng)
-- ========================================
-- Product 1: Áo Thun Basic
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(1, 1, 1, 2, 1, 5, 1, 'active', NOW(), 1),   -- Đen, S
(2, 1, 1, 3, 2, 5, 1, 'active', NOW(), 1),   -- Đen, M
(3, 1, 2, 2, 3, 5, 1, 'active', NOW(), 1),   -- Trắng, S
(4, 1, 2, 3, 4, 5, 1, 'active', NOW(), 1),   -- Trắng, M
(5, 1, 8, 3, 5, 5, 1, 'active', NOW(), 1),   -- Xám, M
(6, 1, 8, 4, 6, 5, 1, 'active', NOW(), 1)    -- Xám, L
ON CONFLICT (id) DO NOTHING;

-- Product 2: Áo Sơ Mi Công Sở
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(7, 2, 2, 2, 7, 5, 1, 'active', NOW(), 1),   -- Trắng, S
(8, 2, 2, 3, 8, 5, 1, 'active', NOW(), 1),   -- Trắng, M
(9, 2, 4, 3, 9, 5, 1, 'active', NOW(), 1),   -- Xanh dương, M
(10, 2, 4, 4, 10, 5, 1, 'active', NOW(), 1)  -- Xanh dương, L
ON CONFLICT (id) DO NOTHING;

-- Product 3: Áo Hoodie Oversize
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(11, 3, 1, 4, 11, 4, 1, 'active', NOW(), 1), -- Đen, L
(12, 3, 1, 5, 12, 4, 1, 'active', NOW(), 1), -- Đen, XL
(13, 3, 8, 4, 13, 4, 1, 'active', NOW(), 1), -- Xám, L
(14, 3, 7, 3, 14, 4, 1, 'active', NOW(), 1)  -- Hồng, M
ON CONFLICT (id) DO NOTHING;

-- Product 4: Quần Jean Skinny
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(15, 4, 4, 2, 15, 5, 5, 'active', NOW(), 1), -- Xanh dương, S
(16, 4, 4, 3, 16, 5, 5, 'active', NOW(), 1), -- Xanh dương, M
(17, 4, 4, 4, 17, 5, 5, 'active', NOW(), 1), -- Xanh dương, L
(18, 4, 1, 3, 18, 5, 5, 'active', NOW(), 1), -- Đen, M
(19, 4, 1, 4, 19, 5, 5, 'active', NOW(), 1), -- Đen, L
(20, 4, 8, 3, 20, 5, 5, 'active', NOW(), 1)  -- Xám, M
ON CONFLICT (id) DO NOTHING;

-- Product 5: Quần Kaki Công Sở
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(21, 5, 1, 3, 21, 5, 1, 'active', NOW(), 1), -- Đen, M
(22, 5, 1, 4, 22, 5, 1, 'active', NOW(), 1), -- Đen, L
(23, 5, 8, 3, 23, 5, 1, 'active', NOW(), 1), -- Xám, M
(24, 5, 8, 4, 24, 5, 1, 'active', NOW(), 1)  -- Xám, L
ON CONFLICT (id) DO NOTHING;

-- Product 6: Váy Midi Hoa
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(25, 6, 7, 1, 25, 2, 4, 'active', NOW(), 1), -- Hồng, XS
(26, 6, 7, 2, 26, 2, 4, 'active', NOW(), 1), -- Hồng, S
(27, 6, 2, 2, 27, 2, 4, 'active', NOW(), 1), -- Trắng, S
(28, 6, 2, 3, 28, 2, 4, 'active', NOW(), 1)  -- Trắng, M
ON CONFLICT (id) DO NOTHING;

-- Product 7: Váy Liền Công Sở
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(29, 7, 1, 2, 29, 5, 2, 'active', NOW(), 1), -- Đen, S
(30, 7, 1, 3, 30, 5, 2, 'active', NOW(), 1), -- Đen, M
(31, 7, 3, 2, 31, 5, 2, 'active', NOW(), 1), -- Đỏ, S
(32, 7, 3, 3, 32, 5, 2, 'active', NOW(), 1)  -- Đỏ, M
ON CONFLICT (id) DO NOTHING;

-- Product 8: Túi Xách Tote
INSERT INTO product_variants (id, product_id, color_id, size_id, price_id, season_id, material_id, status, created_date, created_by) VALUES
(33, 8, 1, 3, 33, 5, 3, 'active', NOW(), 1), -- Đen, M
(34, 8, 2, 3, 34, 5, 3, 'active', NOW(), 1), -- Trắng, M
(35, 8, 6, 3, 35, 5, 3, 'active', NOW(), 1)  -- Vàng, M
ON CONFLICT (id) DO NOTHING;

SELECT setval('product_variants_id_seq', (SELECT MAX(id) FROM product_variants));

-- ========================================
-- 12. CARTS
-- ========================================
INSERT INTO cart (id, user_id) VALUES
(1, 1),
(2, 2),
(3, 3)
ON CONFLICT (id) DO NOTHING;

SELECT setval('cart_id_seq', (SELECT MAX(id) FROM cart));

-- ========================================
-- SUMMARY
-- ========================================
-- Users: 3 (admin, user1, user2) - password: password123
-- Products: 8 với 35 variants đầy đủ

DO $$
BEGIN
    RAISE NOTICE 'Sample data imported successfully!';
END $$;
