/*

Part-to-Whole Analysis (Proportional Analysis)

Why?

    - Compares performance or metrics across dimensions or time periods.
    - Eveluate differences between categories.
    - Useful for A/B testing or regional comparison.

Analyze How an Individual Part is Performing Compared to the Overall.

(Allowing us to understand which categroy has the greatest impact on the business.)

([Measure] / Total[Measure]) * 100 By [Dimension]

- (Sales / Total Sales) * 100 By Category
- (Quantity/Total Quantity) * 100 By Country

*/

-- Which Categories Contribute the Most to Overall Sales?

WITH category_sales AS (
    SELECT
        p.category, 
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)
SELECT
    category, 
    total_sales, 
    SUM(total_sales) OVER () overall_sales,
    ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;