
-- ============================================
-- RETAIL SALES DATA ANALYSIS
-- 04. AGGREGATION ANALYSIS
-- ============================================

-- 1. Sales and profit by category
SELECT
    category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(*) AS total_records,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM public.superstore
GROUP BY category
ORDER BY total_sales DESC;


-- 2. Sales and profit by sub-category
SELECT
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(*) AS total_records,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM public.superstore
GROUP BY category, sub_category
ORDER BY total_profit ASC;


-- 3. Find loss-making sub-categories
SELECT
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin,
    COUNT(*) AS total_records
FROM public.superstore
GROUP BY category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;


-- 4. Analyze sales and profit by region
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    COUNT(*) AS total_records,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM public.superstore
GROUP BY region
ORDER BY total_sales DESC;


-- 5. Analyze sales and profit by customer segment
SELECT
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT customer_id) AS total_customers,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(
        SUM(profit) / NULLIF(SUM(sales), 0) * 100,
        2
    ) AS profit_margin
FROM public.superstore
GROUP BY segment
ORDER BY total_sales DESC;
