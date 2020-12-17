/* 180. Consecutive Numbers
Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example:

 

Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   | 
| 3  | 1   | 
| 4  | 2   | 
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
1 is the only number that appears consecutively for at least three times.
*/

-- Solution
select DISTINCT a.Num as ConsecutiveNums
from (
SELECT 
    Num, 
    LEAD(Num, 1) OVER() AS Num1, 
    LEAD(Num, 2) OVER() AS Num2
FROM Logs ) a
where a.Num = a.Num1 and a.Num = a.Num2 and a.Num1 = a.Num2
    
-- Solution 2
select DISTINCT a.Num as ConsecutiveNums
from (
SELECT 
    Num, 
    LAG(Num, 1) OVER() AS Num1, 
    LAG(Num, 2) OVER() AS Num2
FROM Logs ) a
where a.Num = a.Num1 and a.Num = a.Num2 and a.Num1 = a.Num2

-- Solution 3
WITH ORDER_LOGS as (
    select 
        Num, 
        ROW_NUMBER() over () as 'row_order'
    from Logs 
)

select distinct a.Num as ConsecutiveNums
from ORDER_LOGS a, ORDER_LOGS b, ORDER_LOGS c
where 
    a.row_order = b.row_order - 1 and 
    b.row_order = c.row_order - 1 and 
    a.Num = b.Num and b.Num = c.Num