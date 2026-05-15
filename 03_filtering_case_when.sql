SELECT 
    product_id,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date::date) = 2023 THEN revenue ELSE 0 END) AS revenue_2023,
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date::date) = 2024 THEN revenue ELSE 0 END) AS revenue_2024,
    -- Calculate absolute growth
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date::date) = 2024 THEN revenue ELSE 0 END) - 
    SUM(CASE WHEN EXTRACT(YEAR FROM order_date::date) = 2023 THEN revenue ELSE 0 END) AS YoY_growth
FROM chocolate_sales
-- Make sure the filter also handles the text comparison cleanly, or cast it here too
WHERE order_date::date BETWEEN '2023-01-01' AND '2024-12-31'
GROUP BY product_id
ORDER BY YoY_growth DESC;

SELECT 
    CASE 
        WHEN c.loyalty_member = 1 THEN 'Loyalty Member' 
        ELSE 'Regular Customer' 
    END AS customer_segment,
    COUNT(s.order_id) AS total_orders,
    SUM(s.revenue) AS total_revenue,
    ROUND(AVG(s.revenue)::numeric, 2) AS avg_order_value,
    ROUND((SUM(s.revenue) / SUM(s.quantity))::numeric, 2) AS avg_price_per_unit
FROM chocolate_sales s
JOIN chocolate_customers c ON s.customer_id = c.customer_id
GROUP BY c.loyalty_member;

SELECT 
    CASE 
        WHEN discount = 0 THEN '01. No Discount (0%)'
        WHEN discount > 0 AND discount <= 0.10 THEN '02. Low (1% - 10%)'
        WHEN discount > 0.10 AND discount <= 0.25 THEN '03. Medium (11% - 25%)'
        ELSE '04. High (> 25%)'
    END AS discount_tier,
    COUNT(order_id) AS sales_volume,
    SUM(quantity) AS total_units_sold,
    SUM(revenue) AS gross_revenue,
    ROUND(AVG(quantity)::numeric, 1) AS avg_units_per_order
FROM chocolate_sales
GROUP BY 1
ORDER BY discount_tier ASC;
