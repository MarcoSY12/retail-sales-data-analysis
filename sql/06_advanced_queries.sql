
-- ============================================
-- 1. COMMON TABLE EXPRESSION (CTE)
-- ============================================

-- Identify loss-making sub-categories using CTE

WITH subcategory_summary AS (

    SELECT
        category,
        sub_category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        COUNT(*) AS total_records

    FROM public.superstore

    GROUP BY
        category,
        sub_category
)

SELECT
    category,
    sub_category,
    total_sales,
    total_profit,

    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin,

    total_records

FROM subcategory_summary

WHERE total_profit < 0

ORDER BY total_profit ASC;

-- ============================================
-- 2. CTE: CENTRAL FURNITURE ANALYSIS
-- ============================================

WITH central_furniture AS (

    SELECT
        sub_category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit,
        SUM(quantity) AS total_quantity,
        COUNT(*) AS total_records

    FROM public.superstore

    WHERE region = 'Central'
      AND category = 'Furniture'

    GROUP BY sub_category
)

SELECT
    sub_category,
    total_sales,
    total_profit,

    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin,

    total_quantity,
    total_records

FROM central_furniture

ORDER BY total_profit ASC;


-- ============================================
-- 3. MULTIPLE CTEs
-- CENTRAL FURNISHINGS DISCOUNT ANALYSIS
-- ============================================

WITH central_furnishings AS (

    -- CTE 1: Filter Central Furnishings transactions
    SELECT
        row_id,
        discount,
        sales,
        profit

    FROM public.superstore

    WHERE region = 'Central'
      AND category = 'Furniture'
      AND sub_category = 'Furnishings'
),

discount_summary AS (

    -- CTE 2: Aggregate performance by discount
    SELECT
        discount,
        COUNT(*) AS total_records,
        ROUND(AVG(profit), 2) AS average_profit,
        ROUND(SUM(profit), 2) AS total_profit,

        SUM(
            CASE
                WHEN profit < 0 THEN 1
                ELSE 0
            END
        ) AS loss_records

    FROM central_furnishings

    GROUP BY discount
)

-- Final Query
SELECT
    discount,
    total_records,
    average_profit,
    total_profit,
    loss_records,

    ROUND(
        loss_records::NUMERIC
        / NULLIF(total_records, 0) * 100,
        2
    ) AS loss_percentage

FROM discount_summary

ORDER BY discount;

-- ============================================
-- 4. SUBQUERY
-- Find transactions with above-average sales
-- ============================================

SELECT
    order_id,
    product_name,
    category,
    sales,
    profit

FROM public.superstore

WHERE sales > (
    SELECT AVG(sales)
    FROM public.superstore
)

ORDER BY sales DESC

LIMIT 10;


-- ============================================
-- 5. SUBQUERY IN FROM (DERIVED TABLE)
-- Identify loss-making sub-categories
-- ============================================

SELECT
    category,
    sub_category,
    total_sales,
    total_profit,

    ROUND(
        total_profit / NULLIF(total_sales, 0) * 100,
        2
    ) AS profit_margin

FROM (

    SELECT
        category,
        sub_category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit

    FROM public.superstore

    GROUP BY
        category,
        sub_category

) AS subcategory_summary

WHERE total_profit < 0

ORDER BY total_profit ASC;

-- ============================================
-- 6. CORRELATED SUBQUERY
-- Find transactions above category average sales
-- ============================================

SELECT
    s.order_id,
    s.product_name,
    s.category,
    s.sales,
    s.profit

FROM public.superstore AS s

WHERE s.sales > (
    SELECT AVG(sub.sales)
    FROM public.superstore AS sub
    WHERE sub.category = s.category
)

ORDER BY
    s.category,
    s.sales DESC

LIMIT 20;

-- Count above-average sales transactions by category

SELECT
    s.category,
    COUNT(*) AS above_average_transactions

FROM public.superstore AS s

WHERE s.sales > (
    SELECT AVG(sub.sales)
    FROM public.superstore AS sub
    WHERE sub.category = s.category
)

GROUP BY s.category
ORDER BY above_average_transactions DESC;

-- ============================================
-- 7. WINDOW FUNCTIONS
-- Rank sub-categories by total profit
-- ============================================

WITH subcategory_profit AS (

    SELECT
        category,
        sub_category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit

    FROM public.superstore

    GROUP BY
        category,
        sub_category
)

SELECT
    category,
    sub_category,
    total_sales,
    total_profit,

    RANK() OVER (
        PARTITION BY category
        ORDER BY total_profit DESC
    ) AS profit_rank

FROM subcategory_profit

ORDER BY
    category,
    profit_rank;

-- ============================================
-- 8. ROW_NUMBER vs RANK vs DENSE_RANK
-- ============================================

WITH subcategory_profit AS (

    SELECT
        category,
        sub_category,
        SUM(profit) AS total_profit

    FROM public.superstore

    GROUP BY
        category,
        sub_category
)

SELECT
    category,
    sub_category,
    total_profit,

    ROW_NUMBER() OVER (
        PARTITION BY category
        ORDER BY total_profit DESC
    ) AS row_number_rank,

    RANK() OVER (
        PARTITION BY category
        ORDER BY total_profit DESC
    ) AS profit_rank,

    DENSE_RANK() OVER (
        PARTITION BY category
        ORDER BY total_profit DESC
    ) AS dense_rank

FROM subcategory_profit

ORDER BY
    category,
    total_profit DESC;

-- ============================================
-- 9. WINDOW FUNCTIONS: RUNNING TOTAL
-- Monthly cumulative sales and profit
-- ============================================

WITH monthly_summary AS (

    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales,
        SUM(profit) AS monthly_profit

    FROM public.superstore

    GROUP BY
        DATE_TRUNC('month', order_date)

)

SELECT
    month,
    monthly_sales,
    monthly_profit,

    SUM(monthly_sales) OVER (
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_sales,

    SUM(monthly_profit) OVER (
        ORDER BY month
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_profit

FROM monthly_summary

ORDER BY month;

-- ============================================
-- 10. WINDOW FUNCTIONS: LAG AND LEAD
-- Monthly Sales Comparison
-- ============================================

WITH monthly_summary AS (

    SELECT
        DATE_TRUNC('month', order_date)::DATE AS month,
        SUM(sales) AS monthly_sales,
        SUM(profit) AS monthly_profit

    FROM public.superstore

    GROUP BY DATE_TRUNC('month', order_date)

),

monthly_comparison AS (

    SELECT
        month,
        monthly_sales,
        monthly_profit,

        LAG(monthly_sales) OVER (
            ORDER BY month
        ) AS previous_month_sales,

        LEAD(monthly_sales) OVER (
            ORDER BY month
        ) AS next_month_sales

    FROM monthly_summary
)

SELECT
    month,
    monthly_sales,
    previous_month_sales,
    next_month_sales,

    monthly_sales - previous_month_sales
        AS sales_change,

    ROUND(
        (
            monthly_sales - previous_month_sales
        ) / NULLIF(previous_month_sales, 0) * 100,
        2
    ) AS sales_growth_percentage

FROM monthly_comparison

ORDER BY month

LIMIT 15;

-- ============================================
-- 11. FINAL SQL BUSINESS ANALYSIS
-- Top 3 Sub-Categories by Profit in Each Region
-- ============================================

WITH regional_subcategory AS (

    SELECT
        region,
        category,
        sub_category,
        SUM(sales) AS total_sales,
        SUM(profit) AS total_profit

    FROM public.superstore

    GROUP BY
        region,
        category,
        sub_category
),

ranked_subcategory AS (

    SELECT
        region,
        category,
        sub_category,
        total_sales,
        total_profit,

        RANK() OVER (
            PARTITION BY region
            ORDER BY total_profit DESC
        ) AS profit_rank,

        ROUND(
            total_profit /
            NULLIF(
                SUM(total_profit) OVER (
                    PARTITION BY region
                ),
                0
            ) * 100,
            2
        ) AS regional_profit_contribution

    FROM regional_subcategory
)

SELECT
    region,
    category,
    sub_category,
    total_sales,
    total_profit,
    profit_rank,
    regional_profit_contribution

FROM ranked_subcategory

WHERE profit_rank <= 3

ORDER BY
    region,
    profit_rank;
