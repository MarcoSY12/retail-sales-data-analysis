
-- ============================================
-- RETAIL SALES DATA ANALYSIS
-- 01. CREATE SUPERSTORE TABLE
-- ============================================

CREATE TABLE public.superstore (
    row_id BIGINT PRIMARY KEY,
    order_id TEXT,
    order_date TIMESTAMP,
    ship_date TIMESTAMP,
    ship_mode TEXT,
    customer_id TEXT,
    customer_name TEXT,
    segment TEXT,
    country TEXT,
    city TEXT,
    state TEXT,
    postal_code TEXT,
    region TEXT,
    product_id TEXT,
    category TEXT,
    sub_category TEXT,
    product_name TEXT,
    sales NUMERIC(14,4),
    quantity INTEGER,
    discount NUMERIC(8,4),
    profit NUMERIC(14,4)
);

-- Note:
-- Import superstore_cleaned.csv into this table
-- using pgAdmin Import/Export Data.
