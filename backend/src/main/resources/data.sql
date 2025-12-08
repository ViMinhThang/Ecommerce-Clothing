-- 1. Bật Extension (Chạy 1 lần dùng chung cho cả DB)
CREATE EXTENSION IF NOT EXISTS unaccent;;
ALTER FUNCTION unaccent(text) IMMUTABLE;;
-- ========================================================
-- PHẦN CẤU HÌNH CHO PRODUCT
-- ========================================================
DO $$
BEGIN
    -- Kiểm tra xem bảng product đã có cột search_vector chưa
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='product' AND column_name='search_vector') THEN
        ALTER TABLE product
        ADD COLUMN search_vector tsvector
        -- Tìm kiếm trên Name (và Description nếu có)
        -- Ví dụ nối chuỗi: unaccent(COALESCE(name, '')) || ' ' || unaccent(COALESCE(description, ''))
        GENERATED ALWAYS AS (
            to_tsvector('simple', unaccent(COALESCE(name, '')))
        ) STORED;
    END IF;
END $$;;

-- Tạo Index cho Product
CREATE INDEX IF NOT EXISTS idx_product_search_vector ON product USING GIN(search_vector);


-- ========================================================
-- PHẦN CẤU HÌNH CHO CATEGORY
-- ========================================================
DO $$
BEGIN
    -- Kiểm tra xem bảng category đã có cột search_vector chưa
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name='category' AND column_name='search_vector') THEN
        ALTER TABLE category
        ADD COLUMN search_vector tsvector
        GENERATED ALWAYS AS (
            to_tsvector('simple', unaccent(COALESCE(name, '')))
        ) STORED;
    END IF;
END $$;;

-- Tạo Index cho Category
CREATE INDEX IF NOT EXISTS idx_category_search_vector ON category USING GIN(search_vector);;