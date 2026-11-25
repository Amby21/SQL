-------- TRIM

SELECT TRIM (name) , LOWER(email)
FROM leads
WHERE id = 1;

-------- COALESCE
SELECT COALESCE (country,'Unknown')
FROM leads
WHERE id = 2;

SELECT COALESCE (country,'Unknown')
FROM leads
WHERE id = 3;

-------- NULLIF/NULLIFS

SELECT id,
        COALESCE(NULLIF(TRIM (country), ''), 'Unknown') AS country_clean
FROM leads;

--------- CASE 

SELECT order_id , amount,CASE WHEN amount >= 40 THEN 'big' ELSE 'small' END AS size
FROM orders;

SELECT order_id, amount, CASE WHEN amount >=40 THEN 'big' WHEN amount >=20 THEN 'medium' ELSE 'small' END AS size
FROM orders;


------SUMMARIZING PER GROUP
SELECT cust_id, COUNT(*) AS n, SUM(amount) as total
FROM  orders
GROUP BY cust_id;

-----SUMMARIZING + JOIN
SELECT c.name, COUNT(o.order_id) AS n
FROM customers c
LEFT JOIN orders o 
ON c.id = o.cust_id
GROUP BY c.name;

------FILTERING GROUPS WITH HAVING
SELECT c.name, COALESCE(SUM(o.amount),0) AS total
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id
WHERE o.amount >=40
GROUP BY c.name
HAVING SUM(o.amount) >=30;

/* For every customer (Ben included), show name, number of orders, and total spend (0 for Ben, not NULL).
Show only customers whose total is under 100 (this is a HAVING job, and think about what it does to Ben’s row).
Sort the results from the biggest spender down. That’s new: add an ORDER BY clause at the end, with DESC for descending */

SELECT c.name, COUNT(o.order_id) AS total_orders, COALESCE(SUM(o.amount), 0) as total
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id
GROUP BY c.id
HAVING COALESCE(SUM(o.amount), 0) < 100
ORDER BY total DESC;

--Common Table Expression

WITH customer_totals AS (
SELECT c.id, c.name, COUNT(o.order_id) AS total_orders, COALESCE(SUM(o.amount), 0) as total
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id
GROUP BY c.id
)
SELECT name, total
FROM customer_totals
WHERE total < 100 AND total_orders >= 1
ORDER BY total DESC;

