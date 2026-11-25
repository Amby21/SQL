-- INNER JOIN

SELECT c.name, o.order_id, o.amount
FROM customers c
INNER JOIN orders o
ON c.id = o.cust_id;

-- LEFT JOIN

SELECT c.name, o.order_id, o.amount
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id;

-- CUSTOMERS WITH NO ORDERS
SELECT c.name, o.order_id, o.amount
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id
WHERE o.order_id ISNULL;

-- EVERY ORDER WITH CUSTOMER NAME WITH AMOUNT 30 OR MORE
SELECT c.name, o.order_id, o.amount
FROM orders o
LEFT JOIN customers c
ON o.cust_id = c.id
WHERE o.amount >= 30;

--ORDERS FOR WHICH CUSTOMER DOESNT EXIST

SELECT o.order_id
FROM orders o
LEFT JOIN customers c
ON o.cust_id = c.id
WHERE c.id IS NULL AND o.cust_id IS NOT NULL;

