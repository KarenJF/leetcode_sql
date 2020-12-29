/* 1127. User Purchase Platform
Table: Spending
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| user_id     | int     |
| spend_date  | date    |
| platform    | enum    | 
| amount      | int     |
+-------------+---------+
The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
(user_id, spend_date, platform) is the primary key of this table.
The platform column is an ENUM type of ('desktop', 'mobile').

Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

The query result format is in the following example:

Spending table:
+---------+------------+----------+--------+
| user_id | spend_date | platform | amount |
+---------+------------+----------+--------+
| 1       | 2019-07-01 | mobile   | 100    |
| 1       | 2019-07-01 | desktop  | 100    |
| 2       | 2019-07-01 | mobile   | 100    |
| 2       | 2019-07-02 | mobile   | 100    |
| 3       | 2019-07-01 | desktop  | 100    |
| 3       | 2019-07-02 | desktop  | 100    |
+---------+------------+----------+--------+

Result table:
+------------+----------+--------------+-------------+
| spend_date | platform | total_amount | total_users |
+------------+----------+--------------+-------------+
| 2019-07-01 | desktop  | 100          | 1           |
| 2019-07-01 | mobile   | 100          | 1           |
| 2019-07-01 | both     | 200          | 1           |
| 2019-07-02 | desktop  | 100          | 1           |
| 2019-07-02 | mobile   | 100          | 1           |
| 2019-07-02 | both     | 0            | 0           |
+------------+----------+--------------+-------------+ 
On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.
*/

--Solution 
WITH platform_ind as (
        select 
            spend_date,
            user_id,
            sum((case when platform = 'mobile' then 1 else 0 end)) as mobile_ind,
            sum((case when platform = 'desktop' then 1 else 0 end)) as desktop_ind,
            sum(amount) as amount
        from Spending
        group by spend_date, user_id
        order by spend_date, user_id),
        
        
    user_amount as (
        select 
            spend_date,
            user_id,
            (case when mobile_ind > 0 and desktop_ind = 0 then 'mobile'
                  when desktop_ind > 0 and mobile_ind = 0 then 'desktop'
                  when mobile_ind > 0 and desktop_ind > 0 then 'both'
                  end) as platform,
            sum(amount) as total_amount
        from platform_ind
        group by spend_date, user_id, platform
        order by spend_date, user_id, platform
    ),

    table_row as (
        select distinct spend_date, 'desktop' as platform from Spending
        UNION ALL 
        select distinct spend_date, 'mobile' as platform from Spending
        UNION ALL
        select distinct spend_date, 'both' as platform from Spending
    )
    
    select
        t.spend_date, 
        t.platform,
        sum(ifnull(u.total_amount,0)) as total_amount,
        count(distinct u.user_id) as total_users
    from table_row t
    left join user_amount u 
    on t.spend_date = u.spend_date and 
       t.platform = u.platform
    group by t.spend_date, t.platform
    order by t.spend_date