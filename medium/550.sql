/* 550. Game Play Analysis IV
Table: Activity
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| player_id    | int     |
| device_id    | int     |
| event_date   | date    |
| games_played | int     |
+--------------+---------+
(player_id, event_date) is the primary key of this table.
This table shows the activity of players of some game.
Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out on some day using some device.
 

Write an SQL query that reports the fraction of players that logged in again on the day after the day they first logged in, rounded to 2 decimal places. In other words, you need to count the number of players that logged in for at least two consecutive days starting from their first login date, then divide that number by the total number of players.

The query result format is in the following example:

Activity table:
+-----------+-----------+------------+--------------+
| player_id | device_id | event_date | games_played |
+-----------+-----------+------------+--------------+
| 1         | 2         | 2016-03-01 | 5            |
| 1         | 2         | 2016-03-02 | 6            |
| 2         | 3         | 2017-06-25 | 1            |
| 3         | 1         | 2016-03-02 | 0            |
| 3         | 4         | 2018-07-03 | 5            |
+-----------+-----------+------------+--------------+

Result table:
+-----------+
| fraction  |
+-----------+
| 0.33      |
+-----------+
Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33
*/

-- Solution 
-- first date
-- next date
-- fraction
WITH first_date as 
    (select 
        player_id, 
        min(event_date) as frist_day
     from activity
     group by player_id),
     
    consecutive_table as 
    (select 
         first_date.player_id, 
         a.event_date,
         (case when a.event_date = first_day + 1 then 1 else 0 end) as consecutive_ind
     from first_date
     left join activity a
     on first_date.player_id = a.player_id
    )

select round(sum(consecutive_ind)/count(distinct player_id),2) as fraction 
from consecutive_table
    





WITH c1 AS
(
SELECT      player_id,
            MIN(event_date) AS first_day
FROM        Activity
GROUP BY    player_id
),

c2 AS
(
SELECT      
            c1.player_id, 
            a.event_date,
            case when a.event_date = c1.first_day + 1 then 1
                 else 0 end as consecutive_ind
from        c1
LEFT JOIN   activity a
ON          c1.player_id = a.player_id
)

SELECT      ROUND(SUM(consecutive_ind) / COUNT(DISTINCT player_id), 2) AS fraction
FROM        c2;