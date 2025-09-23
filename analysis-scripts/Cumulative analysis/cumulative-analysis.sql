/*

Cummulative Analysis.

Why?

    - Calculates running totals or moving averages for key metrics.
    - Tracks performance over time cumulatively. 
    - Useful for growth analysis or identifying long-term trends.

Aggregate the data progressively over time. 

Helps to understand whether our business is growing or declining.

Summation [Cumulative Measure] by [Date Dimension]

    - Running Total Sales By Year

    - Moving average of Sales By Month

Calcualte the total sales per month and the running total of sales over time. 

*/

SELECT
    order_date, 
    total_sales, 
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales, 
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
    SELECT
        DATETRUNC(year, order_date) AS order_date, 
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(year, order_date)
) t