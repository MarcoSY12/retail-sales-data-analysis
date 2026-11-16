
-- ============================================
-- RETAIL SALES DATA ANALYSIS
-- 03. BASIC SQL ANALYSIS
-- ============================================

-- 1. Preview dataset
SELECT *
FROM public.superstore
LIMIT 10;


-- 2. Select specific columns
SELECT
    order_id,
    order_date,
    category,
    sub_category,
    sales,
    profit
FROM public.superstore
LIMIT 10;


-- 3. Find transactions with negative profit
SELECT
    order_id,
    product_name,
    category,
    sub_category,
    sales,
    discount,
    profit
FROM public.superstore
WHERE profit < 0
ORDER BY profit ASC
LIMIT 10;


-- 4. Find transactions with highest profit
SELECT
    order_id,
    product_name,
    category,
    sub_category,
    sales,
    profit
FROM public.superstore
ORDER BY profit DESC
LIMIT 10;


-- 5. Find transactions with lowest profit
SELECT
    order_id,
    product_name,
    category,
    sub_category,
    sales,
    profit
FROM public.superstore
ORDER BY profit ASC
LIMIT 10;


-- 6. Filter transactions with high discounts
SELECT
    product_name,
    category,
    sub_category,
    sales,
    discount,
    profit
FROM public.superstore
WHERE discount >= 0.5
ORDER BY profit ASC
LIMIT 10;
