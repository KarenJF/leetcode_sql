/* 1164. Product Price at a Given Date
Table: Products
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| new_price     | int     |
| change_date   | date    |
+---------------+---------+
(product_id, change_date) is the primary key of this table.
Each row of this table indicates that the price of some product was changed to a new price at some date.
 

Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

The query result format is in the following example:

Products table:
+------------+-----------+-------------+
| product_id | new_price | change_date |
+------------+-----------+-------------+
| 1          | 20        | 2019-08-14  |
| 2          | 50        | 2019-08-14  |
| 1          | 30        | 2019-08-15  |
| 1          | 35        | 2019-08-16  |
| 2          | 65        | 2019-08-17  |
| 3          | 20        | 2019-08-18  |
+------------+-----------+-------------+

Result table:
+------------+-------+
| product_id | price |
+------------+-------+
| 2          | 50    |
| 1          | 35    |
| 3          | 10    |
+------------+-------+
*/

-- Solution 
-- Get most recent price before 2019-08-16
WITH summary as (
    select product_id, new_price, change_date
    from (
        select 
            *, 
            dense_rank() over (partition by product_id order by change_date desc) as rng
        from products
        where change_date <= '2019-08-16') a
    where rng = 1), 
    
    unique_user as (
    select distinct product_id from products
    )
    
select 
    u.product_id, 
    (case when s.new_price is null then 10 else s.new_price end) as price
from unique_user u
left join summary s
on u.product_id = s.product_id



    