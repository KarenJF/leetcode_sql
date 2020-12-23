/* 1045. Customers Who Bought All Products
Table: Customer

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| product_key | int     |
+-------------+---------+
product_key is a foreign key to Product table.
 

Table: Product

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_key | int     |
+-------------+---------+
product_key is the primary key column for this table.
 

Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

Return the result table in any order.

The query result format is in the following example:

 

Customer table:
+-------------+-------------+
| customer_id | product_key |
+-------------+-------------+
| 1           | 5           |
| 2           | 6           |
| 3           | 5           |
| 3           | 6           |
| 1           | 6           |
+-------------+-------------+

Product table:
+-------------+
| product_key |
+-------------+
| 5           |
| 6           |
+-------------+

Result table:
+-------------+
| customer_id |
+-------------+
| 1           |
| 3           |
+-------------+
The customers who bought all the products (5 and 6) are customers with id 1 and 3.
*/

-- Solution 
WITH cust_product_cnt as (
    select 
        c.customer_id, 
        count(distinct c.product_key) as p_keys
    from Customer c
    where c.product_key in (select distinct product_key from Product)
    group by c.customer_id)
    
    
select 
    customer_id
from cust_product_cnt
where 
    p_keys = (select count(distinct product_key) from Product)

-- Solution 2 
select 
    p.product_key,
    c.*
from Product p 
left join Customer c
on p.product_key = c.product_key
UNION 
select 
    p.product_key,
    c.*
from Product p 
right join Customer c
on p.product_key = c.product_key