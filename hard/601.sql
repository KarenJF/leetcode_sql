/*601. Human Traffic of Stadium

Table: Stadium
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| visit_date    | date    |
| people        | int     |
+---------------+---------+
visit_date is the primary key for this table.
Each row of this table contains the visit date and visit id to the stadium with the number of people during the visit.
No two rows will have the same visit_date, and as the id increases, the dates increase as well.
 
Write an SQL query to display the records with three or more rows with consecutive id's, and the number of people is greater than or equal to 100 for each.

Return the result table ordered by visit_date in ascending order.

The query result format is in the following example.

Stadium table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 1    | 2017-01-01 | 10        |
| 2    | 2017-01-02 | 109       |
| 3    | 2017-01-03 | 150       |
| 4    | 2017-01-04 | 99        |
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+

Result table:
+------+------------+-----------+
| id   | visit_date | people    |
+------+------------+-----------+
| 5    | 2017-01-05 | 145       |
| 6    | 2017-01-06 | 1455      |
| 7    | 2017-01-07 | 199       |
| 8    | 2017-01-09 | 188       |
+------+------------+-----------+
The four rows with ids 5, 6, 7, and 8 have consecutive ids and each of them has >= 100 people attended. Note that row 8 was included even though the visit_date was not the next day after row 7.
The rows with ids 2 and 3 are not included because we need at least three consecutive ids.
*/

--Solution 
WITH people_summary as (
    select 
        id, visit_date, people 
    from Stadium
    where people >= 100
    order by id
)

select distinct
    s.id, s.visit_date, s.people
from people_summary s,people_summary s2, people_summary s3
where 
    (s.id + 1 = s2.id and s.id + 2 = s3.id) or 
    (s.id - 1 = s2.id and s.id + 1 = s3.id) or
    (s.id - 1 = s2.id and s.id - 2 = s3.id)
order by s.id

-- Solution 2
select distinct 
    a.id, a.visit_date, a.people
from Stadium a, Stadium b, Stadium c
where 
    a.people >=100 and 
    b.people >= 100 and 
    c.people >= 100 and 
    ((a.id + 1 = b.id and a.id + 2 = c.id) or 
     (a.id - 1 = b.id and a.id + 1 = c.id) or
     (a.id - 1 = b.id and a.id - 2 = c.id))
order by a.id