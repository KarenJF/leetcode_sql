/* 1285. Find the Start and End Number of Continuous Ranges
Table: Logs
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
id is the primary key for this table.
Each row of this table contains the ID in a log Table.

Since some IDs have been removed from Logs. Write an SQL query to find the start and end number of continuous ranges in table Logs.

Order the result table by start_id.

The query result format is in the following example:

Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+

Result table:
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing in the table.
Number 10 is contained in the table.
*/

-- Solution 
WITH rank_tb as (
    select 
        log_id as id,
        log_id - rank() over (order by log_id) as rng
    from logs 
),

rank_min_max as (
    select 
        rng,
        min(id) as start_id,
        max(id) as end_id
    from rank_tb
    group by rng
)

select 
    start_id,
    end_id
from rank_min_max
order by start_id

-- Solution 2: use row_number()
WITH row_nm as (
    select 
        log_id as id,
        log_id  - row_number() over (order by log_id) as diff
    from logs
)

select 
    min(id) as start_id,
    max(id) as end_id
from row_nm
group by diff
