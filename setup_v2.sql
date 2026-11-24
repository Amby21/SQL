PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(id INTEGER PRIMARY KEY, name TEXT);
CREATE TABLE orders(order_id INTEGER PRIMARY KEY, cust_id INTEGER NOT NULL, amount INTEGER, FOREIGN KEY (cust_id) REFERENCES customers(id) );

INSERT INTO customers VALUES (1,'Asha'),(2,'Ben'),(3,'Chen');
INSERT INTO orders VALUES(101,1,50),(102,1,30),(103,3,20);

/* INSERT INTO customers VALUES (1, 'Skandan');

INSERT INTO orders VALUES(104,9,10);
PRAGMA foreign_keys = ON;
DELETE FROM customers
WHERE name = 'Ben';

SELECT * FROM customers;
*/

DROP TABLE IF EXISTS leads;
CREATE TABLE leads(id INTEGER PRIMARY KEY, name TEXT, email TEXT, country TEXT);
INSERT INTO leads VALUES
 (1, '  asha ', 'ASHA@Mail.com', 'India'),
 (2, 'BEN', 'ben@mail.com', NULL),
 (3, 'chen', 'Chen@mail.com', '');