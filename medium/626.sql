/* 626. Exchange Seats
Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

The column id is continuous increment.

Mary wants to change seats for the adjacent students.

Can you write a SQL query to output the result for Mary?


+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Abbot   |
|    2    | Doris   |
|    3    | Emerson |
|    4    | Green   |
|    5    | Jeames  |
+---------+---------+
For the sample input, the output is:

+---------+---------+
|    id   | student |
+---------+---------+
|    1    | Doris   |
|    2    | Abbot   |
|    3    | Green   |
|    4    | Emerson |
|    5    | Jeames  |
+---------+---------+
Note:

If the number of students is odd, there is no need to change the last one's seat.
*/

-- Solution 
select 
    ifnull((case when a.id%2=0 then seat1 
          else seat2 end), a.id) as id,
    a.student
from (
select 
    id, 
    student,
    LAG(id, 1) over() as seat1,
    LEAD(id, 1) over() as seat2
from seat) a
order by 1

-- Solution 2
select 
    (case when id%2 != 0 and id != seats_sum then id + 1
          when id%2 != 0 and id = seats_sum then id
          else id-1 end) as id, 
    student
from seat,
    (select 
        count(*) as seats_sum
    from seat) a 
order by 1