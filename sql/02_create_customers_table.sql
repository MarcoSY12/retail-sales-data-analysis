
-- ============================================
-- RETAIL SALES DATA ANALYSIS
-- 02. CREATE CUSTOMERS TABLE
-- ============================================

-- Create customer table

CREATE TABLE public.customers (
    customer_id TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    segment TEXT
);


-- Insert unique customer records

INSERT INTO public.customers (
    customer_id,
    customer_name,
    segment
)

SELECT DISTINCT
    customer_id,
    customer_name,
    segment

FROM public.superstore;


-- Verify customer records

SELECT COUNT(*) AS total_customers
FROM public.customers;
