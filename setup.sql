DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (id INTEGER, name TEXT);
CREATE TABLE orders (order_id INTEGER, cust_id INTEGER, amount INTEGER);

INSERT INTO customers VALUES(1,'Asha'),(2,'Ben'),(3,'Chen');
INSERT INTO orders VALUES(101,1,50),(102,1,30),(103,3,20),(104,9,15);


INSERT INTO orders VALUES (105, 9, 99);