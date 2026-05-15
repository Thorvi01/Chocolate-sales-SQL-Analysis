SELECT 
    ROUND(SUM(revenue)::numeric, 2) AS total_revenue,
    ROUND(SUM(profit)::numeric, 2) AS total_profit,
    ROUND(SUM(cost)::numeric, 2) AS total_cost
FROM chocolate_sales
WHERE product_id NOT IN ('P0000','P0201');

SELECT p.category,
      ROUND(SUM(s.cost)::numeric, 2) AS total_cost,
      ROUND(SUM(s.revenue)::numeric, 2) AS total_revenue,
      ROUND(SUM(s.profit)::numeric, 2) AS total_profit,
      ROUND((SUM(s.profit) / SUM(s.revenue) * 100)::numeric, 2) AS profit_margin_pct
FROM "chocolate_sales" s
LEFT JOIN "chocolate_products" p
ON s.product_id = p.product_id
WHERE s.product_id NOT IN ('P0000', 'P0201')
GROUP BY p.category
ORDER BY total_revenue DESC;

SELECT p.brand,
      ROUND(SUM(s.cost)::numeric, 2) AS total_cost,
      ROUND(SUM(s.revenue)::numeric, 2) AS total_revenue,
      ROUND(SUM(s.profit)::numeric, 2) AS total_profit,
      ROUND((SUM(s.profit) / SUM(s.revenue) * 100)::numeric, 2) AS profit_margin_pct
FROM "chocolate_sales" s
LEFT JOIN "chocolate_products" p
ON s.product_id = p.product_id
WHERE s.product_id NOT IN ('P0000', 'P0201')
GROUP BY p.brand
ORDER BY total_revenue DESC;

SELECT st.store_name,
      ROUND(SUM(s.cost)::numeric, 2) AS total_cost,
      ROUND(SUM(s.revenue)::numeric, 2) AS total_revenue,
      ROUND(SUM(s.profit)::numeric, 2) AS total_profit,
      ROUND((SUM(s.profit) / SUM(s.revenue) * 100)::numeric, 2) AS profit_margin_pct
FROM "chocolate_sales" s
LEFT JOIN "chocolate_stores" st
ON s.store_id = st.store_id
WHERE s.product_id NOT IN ('P0000', 'P0201')
GROUP BY st.store_name
ORDER BY total_revenue DESC;

SELECT ROUND(AVG(discount)::numeric, 2) AS avg_discount
FROM chocolate_sales
WHERE product_id NOT IN ('P0000','P0201');

SELECT p.product_name,
      ROUND(SUM(s.cost)::numeric, 2) AS total_cost,
      ROUND(SUM(s.revenue)::numeric, 2) AS total_revenue,
      ROUND(SUM(s.profit)::numeric, 2) AS total_profit,
      ROUND((SUM(s.profit) / SUM(s.revenue) * 100)::numeric, 2) AS profit_margin_pct
FROM "chocolate_sales" s
LEFT JOIN "chocolate_products" p
ON s.product_id = p.product_id
WHERE s.product_id NOT IN ('P0000', 'P0201')
GROUP BY p.product_name
ORDER BY total_revenue DESC;

SELECT ROUND(AVG(discount)::numeric, 2) AS avg_discount,
FROM chocolate_sales,
WHERE product_id NOT IN ('P0000','P0201');
