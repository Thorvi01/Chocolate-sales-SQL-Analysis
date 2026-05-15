SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

SELECT COUNT(*) FROM chocolate_calender;
SELECT COUNT(*) FROM chocolate_customers;
SELECT COUNT(*) FROM chocolate_products;
SELECT COUNT(*) FROM chocolate_sales;
SELECT COUNT(*) FROM chocolate_stores;

select * FROM chocolate_sales LIMIT 5;
SELECT * FROM chocolate_products LIMIT 5;
SELECT * FROM chocolate_customers LIMIT 5;
SELECT * FROM chocolate_stores LIMIT 5;


SELECT COUNT(*)
FROM chocolate_sales
WHERE order_id IS NULL 
or product_id IS NULL
or order_date IS NULL;

SELECT COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(DISTINCT order_date) AS unique_dates
FROM chocolate_sales

SELECT chocolate_sales.product_id
FROM chocolate_sales
LEFT JOIN chocolate_products 
ON chocolate_sales.product_id = chocolate_products.product_id
WHERE chocolate_products.product_id IS NULL;

SELECT chocolate_sales.product_id
FROM chocolate_sales
LEFT JOIN chocolate_products 
ON chocolate_sales.product_id = chocolate_products.product_id
WHERE chocolate_products.product_id IS NULL;

SELECT COUNT(*) 
FROM chocolate_sales
WHERE product_id NOT IN ('P0000','P0201')
