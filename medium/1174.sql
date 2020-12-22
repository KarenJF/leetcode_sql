/* 1174. Immediate Food Delivery II
Table: Delivery

+-----------------------------+---------+
| Column Name                 | Type    |
+-----------------------------+---------+
| delivery_id                 | int     |
| customer_id                 | int     |
| order_date                  | date    |
| customer_pref_delivery_date | date    |
+-----------------------------+---------+
delivery_id is the primary key of this table.
The table holds information about food delivery to customers that make orders at some date and specify a preferred delivery date (on the same order date or after it).
 

If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise it's called scheduled.

The first order of a customer is the order with the earliest order date that customer made. It is guaranteed that a customer has exactly one first order.

Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.

The query result format is in the following example:

Delivery table:
+-------------+-------------+------------+-----------------------------+
| delivery_id | customer_id | order_date | customer_pref_delivery_date |
+-------------+-------------+------------+-----------------------------+
| 1           | 1           | 2019-08-01 | 2019-08-02                  |
| 2           | 2           | 2019-08-02 | 2019-08-02                  |
| 3           | 1           | 2019-08-11 | 2019-08-12                  |
| 4           | 3           | 2019-08-24 | 2019-08-24                  |
| 5           | 3           | 2019-08-21 | 2019-08-22                  |
| 6           | 2           | 2019-08-11 | 2019-08-13                  |
| 7           | 4           | 2019-08-09 | 2019-08-09                  |
+-------------+-------------+------------+-----------------------------+

Result table:
+----------------------+
| immediate_percentage |
+----------------------+
| 50.00                |
+----------------------+
The customer id 1 has a first order with delivery id 1 and it is scheduled.
The customer id 2 has a first order with delivery id 2 and it is immediate.
The customer id 3 has a first order with delivery id 5 and it is scheduled.
The customer id 4 has a first order with delivery id 7 and it is immediate.
Hence, half the customers have immediate first orders.
*/

-- Solution 
select 
    round(sum(immediate_ind)/count(*)*100, 2) as immediate_percentage
from (
    select 
        d.delivery_id, 
        d.customer_id, 
        (case when d.order_date = d.customer_pref_delivery_date then 1
              else 0 end) as immedidate_ind
    from Delivery d
    join 
        (select
            customer_id, 
            min(order_date) as first_date
        from Delivery
        group by customer_id) a
        on 
       d.customer_id = a.customer_id and 
       d.order_date = a.first_date
    )
    
-- Solution 2
select 
    round(sum(immedidate_ind)/sum(first_order)*100,2) as immediate_percentage
from (
    select 
        (case when order_date=customer_pref_delivery_date then 1
              else 0 end ) as immediate_ind,
        (case when order_date = min(order_date) over (partition by customer_id order by order_date asc) then 1
               else 0 end ) as first_order
    from Delivery) a
where a.first_order = 1


WITH first AS (
    SELECT customer_id, MIN(order_date)
    FROM Delivery
    GROUP BY customer_id
)

SELECT ROUND(SUM(CASE WHEN order_date = customer_pref_delivery_date THEN 1 ELSE 0 END)/COUNT(*)*100, 2) as immediate_percentage
FROM Delivery
WHERE (customer_id, order_date) IN (SELECT * FROM first)