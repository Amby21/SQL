SQL Practice: Joins

Small, hands-on exercises for learning SQL joins with SQLite. The focus is on reading a query, predicting its output before running it, and testing with edge cases.

Setup
Open this folder in VS Code and install the SQLite extension.
Create an empty file named shop.db (SQLite treats an empty file as a new database).
Open the Command Palette and run SQLite: Open Database, then choose shop.db.
Open setup.sql and run it. It drops and recreates the tables, so you can rerun it any time for a clean reset.
Open joins.sql, highlight one query at a time, and run the selection.

shop.db is not committed. It is rebuilt from setup.sql.

Data

customers

id	name
1	Asha
2	Ben
3	Chen

orders

order_id	cust_id	amount
101	1	50
102	1	30
103	3	20
104	9	15

Deliberate edge cases in the data:

Ben has no orders.
Order 104 belongs to customer 9, who does not exist in customers (an "orphan" order).
Optional: a second orphan order with a large amount (for example 105, 9, 99) to prove a join keeps orphans that survive a filter.
What the queries cover
Topic	Question it answers
INNER JOIN	Which customers and orders match on both sides?
LEFT JOIN	Keep every customer, even those with no orders
LEFT JOIN with tables swapped	Keep every order, even those with no matching customer
Anti-join (LEFT JOIN ... WHERE key IS NULL)	Which customers have never placed an order?
LEFT JOIN with a filter	Orders of 30 or more, keeping orphans that qualify
Key takeaways
INNER JOIN keeps only rows that match on both sides. LEFT JOIN keeps every row from the left table and fills the right side with NULL when nothing matches.
A left row that matches several right rows appears several times, so row counts can grow after a join.
NULL means "missing", not 0. Check for it with IS NULL, never with = or !=.
When looking for unmatched rows, test a column that is only NULL when there is no match (the key), not one that can legitimately be NULL (such as amount).
Test joins with edge cases. Happy-path data can make a wrong join look correct.