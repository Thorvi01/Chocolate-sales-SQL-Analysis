SELECT 
    p.category,
    SUM(s.revenue) AS category_revenue,
    -- Cast the entire percentage calculation to numeric before rounding
    ROUND(
        ((SUM(s.revenue) / (SELECT SUM(revenue) FROM chocolate_sales)) * 100)::numeric, 
        2
    ) AS revenue_contribution_pct
FROM chocolate_sales s
JOIN chocolate_products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue_contribution_pct DESC;

WITH customer_age_segments AS (
    SELECT 
        customer_id,
        CASE 
            WHEN age < 25 THEN 'Gen Z (< 25)'
            WHEN age BETWEEN 25 AND 40 THEN 'Millennials (25-40)'
            WHEN age BETWEEN 41 AND 56 THEN 'Gen X (41-56)'
            ELSE 'Boomers+ (57+)'
        END AS age_group
    FROM chocolate_customers
)
SELECT 
    seg.age_group,
    COUNT(DISTINCT s.customer_id) AS unique_customers,
    COUNT(s.order_id) AS total_orders,
    SUM(s.revenue) AS total_revenue,
    ROUND(AVG(s.revenue)::numeric, 2) AS avg_order_value
FROM chocolate_sales s
JOIN customer_age_segments seg ON s.customer_id = seg.customer_id
GROUP BY seg.age_group
ORDER BY total_revenue DESC;

WITH ranked_products AS (
    SELECT 
        p.brand,
        s.product_id, -- Explicitly specified 's.' to remove ambiguity
        SUM(s.revenue) AS total_product_revenue,
        -- Explicitly specified 's.' inside the window function as well
        DENSE_RANK() OVER(PARTITION BY p.brand ORDER BY SUM(s.revenue) DESC) AS revenue_rank
    FROM chocolate_sales s
    JOIN chocolate_products p ON s.product_id = p.product_id
    GROUP BY p.brand, s.product_id -- Explicitly specified 's.' here
)
SELECT 
    brand,
    revenue_rank,
    product_id, -- In the outer query, this is fine because the CTE output only carries one product_id
    ROUND(total_product_revenue::numeric, 2) AS total_product_revenue
FROM ranked_products
WHERE revenue_rank <= 5
ORDER BY brand ASC, revenue_rank ASC;
