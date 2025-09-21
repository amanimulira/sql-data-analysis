/*

Performance Analysis.

Why?

    - Measures performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - Track yearly trends and growth.

Comparing the current value to a target value. 

Helps measure success and compare performance.

Current [Measure] - Target [Measure]

Analyze the yearly performance of products by comparing each product's 
sales to both its average sales perforamnce and the previous year's sales.

*/

WITH yearly_product_sales AS (
    SELECT 
        YEAR(f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY 
        YEAR(f.order_date),
        p.product_name
)
SELECT
    order_year,
    product_name,
    current_sales,
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales, 
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg, 
    CASE
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above AVG'
        WHEN current_sales - AVG(current_sales) over (PARTITION BY product_name) < 0 THEN 'Below AVG'
        ELSE 'AVG'
    END AS avg_change,
    -- Year-Over-Year Analysis
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales, 
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'INCREASE'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'DECREASE'
        ELSE 'NO CHANGE'
    END AS py_change
FROM yearly_product_sales
ORDER BY product_name, order_year;

