SELECT order_id , cust_id , amount, SUM(amount) OVER (PARTITION BY cust_id) AS cust_total
FROM orders;

---RANKING INSIDE PILE
SELECT order_id, cust_id, amount, ROW_NUMBER() OVER (PARTITION BY cust_id ORDER BY amount DESC) AS rank_in_cust
FROM orders;

WITH customer_ranks AS(
SELECT order_id, cust_id, amount, ROW_NUMBER() OVER( PARTITION BY cust_id ORDER BY amount DESC) AS rank_in_cust
FROM ORDERS
)
SELECT order_id, cust_id,amount
FROM customer_ranks
WHERE rank_in_cust = 1;

---INDEXES AND EXPLAIN
-- A database index ; a sorted lookup structure on a column, so the database can jump to matching rows instead of reading the whole table.

EXPLAIN QUERY PLAN
SELECT * FROM orders WHERE cust_id = 1;

CREATE INDEX idx_orders_cust_id ON orders(cust_id);


