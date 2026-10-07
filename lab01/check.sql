#кол-во строк
SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM olist.customers

UNION ALL
SELECT 'orders', COUNT(*)
FROM olist.orders

UNION ALL
SELECT 'order_items', COUNT(*)
FROM olist.order_items

UNION ALL
SELECT 'order_payments', COUNT(*)
FROM olist.order_payments

UNION ALL
SELECT 'order_reviews', COUNT(*)
FROM olist.order_reviews

UNION ALL
SELECT 'products', COUNT(*)
FROM olist.products

UNION ALL
SELECT 'sellers', COUNT(*)
FROM olist.sellers

UNION ALL
SELECT 'geolocation', COUNT(*)
FROM olist.geolocation

UNION ALL
SELECT 'product_category_name_translation', COUNT(*)
FROM olist.product_category_name_translation;


#пропуски 
SELECT 'customers.customer_id' AS field_name, COUNT(*) AS null_count
FROM olist.customers
WHERE customer_id IS NULL

UNION ALL
SELECT 'orders.order_id', COUNT(*)
FROM olist.orders
WHERE order_id IS NULL

UNION ALL
SELECT 'orders.customer_id', COUNT(*)
FROM olist.orders
WHERE customer_id IS NULL

UNION ALL
SELECT 'order_items.order_id', COUNT(*)
FROM olist.order_items
WHERE order_id IS NULL

UNION ALL
SELECT 'order_items.product_id', COUNT(*)
FROM olist.order_items
WHERE product_id IS NULL

UNION ALL
SELECT 'order_items.seller_id', COUNT(*)
FROM olist.order_items
WHERE seller_id IS NULL

UNION ALL
SELECT 'order_payments.order_id', COUNT(*)
FROM olist.order_payments
WHERE order_id IS NULL

UNION ALL
SELECT 'order_reviews.review_id', COUNT(*)
FROM olist.order_reviews
WHERE review_id IS NULL

UNION ALL
SELECT 'order_reviews.order_id', COUNT(*)
FROM olist.order_reviews
WHERE order_id IS NULL

UNION ALL
SELECT 'products.product_id', COUNT(*)
FROM olist.products
WHERE product_id IS NULL

UNION ALL
SELECT 'sellers.seller_id', COUNT(*)
FROM olist.sellers
WHERE seller_id IS NULL

UNION ALL
SELECT 'product_category_name_translation.product_category_name', COUNT(*)
FROM olist.product_category_name_translation
WHERE product_category_name IS NULL;



#осиротевшие строки
SELECT 'orders -> customers' AS check_name, COUNT(*) AS orphan_count
FROM olist.orders o
LEFT JOIN olist.customers c
    ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL

UNION ALL
SELECT 'order_items -> orders', COUNT(*)
FROM olist.order_items oi
LEFT JOIN olist.orders o
    ON o.order_id = oi.order_id
WHERE o.order_id IS NULL

UNION ALL
SELECT 'order_items -> products', COUNT(*)
FROM olist.order_items oi
LEFT JOIN olist.products p
    ON p.product_id = oi.product_id
WHERE p.product_id IS NULL

UNION ALL
SELECT 'order_items -> sellers', COUNT(*)
FROM olist.order_items oi
LEFT JOIN olist.sellers s
    ON s.seller_id = oi.seller_id
WHERE s.seller_id IS NULL

UNION ALL
SELECT 'order_payments -> orders', COUNT(*)
FROM olist.order_payments op
LEFT JOIN olist.orders o
    ON o.order_id = op.order_id
WHERE o.order_id IS NULL

UNION ALL
SELECT 'order_reviews -> orders', COUNT(*)
FROM olist.order_reviews r
LEFT JOIN olist.orders o
    ON o.order_id = r.order_id
WHERE o.order_id IS NULL;


ANALYZE olist.customers;
ANALYZE olist.geolocation;
ANALYZE olist.orders;
ANALYZE olist.order_items;
ANALYZE olist.order_payments;
ANALYZE olist.order_reviews;
ANALYZE olist.products;
ANALYZE olist.sellers;
ANALYZE olist.product_category_name_translation;