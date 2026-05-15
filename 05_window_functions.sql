WITH monthly_sales AS (
    SELECT 
        -- Truncate date to the month level
        DATE_TRUNC('month', order_date::date) AS sales_month,
        SUM(revenue) AS current_month_revenue
    FROM chocolate_sales
    GROUP BY 1
)
SELECT 
    TO_CHAR(sales_month, 'YYYY-MM') AS month,
    ROUND(current_month_revenue::numeric, 2) AS current_month_revenue,
    -- LAG pulls the previous month's revenue down to the current row
    ROUND(LAG(current_month_revenue) OVER (ORDER BY sales_month)::numeric, 2) AS previous_month_revenue,
    -- Calculate absolute difference
    ROUND((current_month_revenue - LAG(current_month_revenue) OVER (ORDER BY sales_month))::numeric, 2) AS mom_absolute_growth,
    -- Calculate percentage change
    ROUND(
        ((current_month_revenue - LAG(current_month_revenue) OVER (ORDER BY sales_month)) / 
        LAG(current_month_revenue) OVER (ORDER BY sales_month) * 100)::numeric, 
        2
    ) AS mom_growth_pct
FROM monthly_sales
ORDER BY sales_month ASC;

WITH store_sales AS (
    SELECT 
        st.country,
        s.store_id,
        SUM(s.revenue) AS total_store_revenue
    FROM chocolate_sales s
    JOIN chocolate_stores st ON s.store_id = st.store_id
    GROUP BY st.country, s.store_id
)
SELECT 
    country,
    DENSE_RANK() OVER (PARTITION BY country ORDER BY total_store_revenue DESC) AS store_rank,
    store_id,
    ROUND(total_store_revenue::numeric, 2) AS total_store_revenue
FROM store_sales
ORDER BY country ASC, store_rank ASC;

WITH daily_sales AS (
    SELECT 
        order_date::date AS sales_date,
        SUM(revenue) AS daily_revenue
    FROM chocolate_sales
    GROUP BY 1
)
SELECT 
    sales_date,
    ROUND(daily_revenue::numeric, 2) AS daily_revenue,
    -- An empty OVER() with an ORDER BY creates an unbounded cumulative sum
    ROUND(
        SUM(daily_revenue) OVER (ORDER BY sales_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::numeric, 
        2
    ) AS running_total_revenue
FROM daily_sales
ORDER BY sales_date ASC;
