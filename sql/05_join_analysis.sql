
-- ============================================
-- RETAIL SALES DATA ANALYSIS
-- 05. JOIN ANALYSIS
-- ============================================

-- 1. Preview customer table
SELECT *
FROM public.customers
LIMIT 10;


-- 2. Count unique customers
SELECT COUNT(*) AS total_customers
FROM public.customers;


-- 3. INNER JOIN: Transactions with customer information
SELECT
    s.order_id,
    s.order_date,
    c.customer_id,
    c.customer_name,
    c.segment,
    s.category,
    s.sales,
    s.profit
FROM public.superstore AS s
INNER JOIN public.customers AS c
    ON s.customer_id = c.customer_id
ORDER BY s.order_date ASC
LIMIT 10;


-- 4. Count records after INNER JOIN
SELECT
    COUNT(*) AS joined_records
FROM public.superstore AS s
INNER JOIN public.customers AS c
    ON s.customer_id = c.customer_id;


-- 5. LEFT JOIN: Keep all transactions
SELECT
    s.order_id,
    s.customer_id,
    c.customer_name,
    c.segment,
    s.sales,
    s.profit
FROM public.superstore AS s
LEFT JOIN public.customers AS c
    ON s.customer_id = c.customer_id
ORDER BY s.order_id
LIMIT 10;


-- 6. Find unmatched transactions
SELECT
    COUNT(*) AS unmatched_transactions
FROM public.superstore AS s
LEFT JOIN public.customers AS c
    ON s.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
