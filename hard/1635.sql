/* 1635. Hopper Company Queries I
Table: Drivers

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| driver_id   | int     |
| join_date   | date    |
+-------------+---------+
driver_id is the primary key for this table.
Each row of this table contains the driver's ID and the date they joined the Hopper company.
 

Table: Rides
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| ride_id      | int     |
| user_id      | int     |
| requested_at | date    |
+--------------+---------+
ride_id is the primary key for this table.
Each row of this table contains the ID of a ride, the user's ID that requested it, and the day they requested it.
There may be some ride requests in this table that were not accepted.
 

Table: AcceptedRides
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| ride_id       | int     |
| driver_id     | int     |
| ride_distance | int     |
| ride_duration | int     |
+---------------+---------+
ride_id is the primary key for this table.
Each row of this table contains some information about an accepted ride.
It is guaranteed that each accepted ride exists in the Rides table.
 

Write an SQL query to report the following statistics for each month of 2020:

The number of drivers currently with the Hopper company by the end of the month (active_drivers).
The number of accepted rides in that month (accepted_rides).
Return the result table ordered by month in ascending order, where month is the month's number (January is 1, February is 2, etc.).

The query result format is in the following example.

 

Drivers table:
+-----------+------------+
| driver_id | join_date  |
+-----------+------------+
| 10        | 2019-12-10 |
| 8         | 2020-1-13  |
| 5         | 2020-2-16  |
| 7         | 2020-3-8   |
| 4         | 2020-5-17  |
| 1         | 2020-10-24 |
| 6         | 2021-1-5   |
+-----------+------------+

Rides table:
+---------+---------+--------------+
| ride_id | user_id | requested_at |
+---------+---------+--------------+
| 6       | 75      | 2019-12-9    |
| 1       | 54      | 2020-2-9     |
| 10      | 63      | 2020-3-4     |
| 19      | 39      | 2020-4-6     |
| 3       | 41      | 2020-6-3     |
| 13      | 52      | 2020-6-22    |
| 7       | 69      | 2020-7-16    |
| 17      | 70      | 2020-8-25    |
| 20      | 81      | 2020-11-2    |
| 5       | 57      | 2020-11-9    |
| 2       | 42      | 2020-12-9    |
| 11      | 68      | 2021-1-11    |
| 15      | 32      | 2021-1-17    |
| 12      | 11      | 2021-1-19    |
| 14      | 18      | 2021-1-27    |
+---------+---------+--------------+

AcceptedRides table:
+---------+-----------+---------------+---------------+
| ride_id | driver_id | ride_distance | ride_duration |
+---------+-----------+---------------+---------------+
| 10      | 10        | 63            | 38            |
| 13      | 10        | 73            | 96            |
| 7       | 8         | 100           | 28            |
| 17      | 7         | 119           | 68            |
| 20      | 1         | 121           | 92            |
| 5       | 7         | 42            | 101           |
| 2       | 4         | 6             | 38            |
| 11      | 8         | 37            | 43            |
| 15      | 8         | 108           | 82            |
| 12      | 8         | 38            | 34            |
| 14      | 1         | 90            | 74            |
+---------+-----------+---------------+---------------+

Result table:
+-------+----------------+----------------+
| month | active_drivers | accepted_rides |
+-------+----------------+----------------+
| 1     | 2              | 0              |
| 2     | 3              | 0              |
| 3     | 4              | 1              |
| 4     | 4              | 0              |
| 5     | 5              | 0              |
| 6     | 5              | 1              |
| 7     | 5              | 1              |
| 8     | 5              | 1              |
| 9     | 5              | 0              |
| 10    | 6              | 0              |
| 11    | 6              | 2              |
| 12    | 6              | 1              |
+-------+----------------+----------------+

By the end of January --> two active drivers (10, 8) and no accepted rides.
By the end of February --> three active drivers (10, 8, 5) and no accepted rides.
By the end of March --> four active drivers (10, 8, 5, 7) and one accepted ride (10).
By the end of April --> four active drivers (10, 8, 5, 7) and no accepted rides.
By the end of May --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of June --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (13).
By the end of July --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (7).
By the end of August --> five active drivers (10, 8, 5, 7, 4) and one accepted ride (17).
By the end of Septemeber --> five active drivers (10, 8, 5, 7, 4) and no accepted rides.
By the end of October --> six active drivers (10, 8, 5, 7, 4, 1) and no accepted rides.
By the end of November --> six active drivers (10, 8, 5, 7, 4, 1) and two accepted rides (20, 5).
By the end of December --> six active drivers (10, 8, 5, 7, 4, 1) and one accepted ride (2).
*/

--Solution 
WITH RECURSIVE row_table as (
    select 
        1 as month 
    UNION ALL
    select month + 1 as month 
    from row_table
    where month <12
),
    active_driver as (
        select 
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 1 then 1
                  else 0 end)) as month1,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 2 then 1
                  else 0 end)) as month2,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 3 then 1
                  else 0 end)) as month3,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 4 then 1
                  else 0 end)) as month4,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 5 then 1
                  else 0 end)) as month5,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 6 then 1
                  else 0 end)) as month6,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 7 then 1
                  else 0 end)) as month7,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 8 then 1
                  else 0 end)) as month8,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 9 then 1
                  else 0 end)) as month9,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 10 then 1
                  else 0 end)) as month10,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 11 then 1
                  else 0 end)) as month11,
            sum((case when year(join_date)<2020 then 1 
                  when year(join_date)=2020 and month(join_date) <= 12 then 1
                  else 0 end)) as month12
        from drivers
        where year(join_date)<=2020
    ),
    
    active_drivers as (
        select 
        r.month,
        (case when r.month = 1 then month1
              when r.month = 2 then month2
              when r.month = 3 then month3
              when r.month = 4 then month4
              when r.month = 5 then month5
              when r.month = 6 then month6
              when r.month = 7 then month7
              when r.month = 8 then month8
              when r.month = 9 then month9
              when r.month = 10 then month10
              when r.month = 11 then month11
              when r.month = 12 then month12 end) as active_drivers
    from row_table r, active_driver
    ),
    
    accept_ride as (
        select 
            month(r.requested_at) as month,
            count(r.ride_id) as accepted_rides
            
        from Rides r
        join AcceptedRides a 
        on r.ride_id = a.ride_id
        where year(r.requested_at) = 2020
        group by month(r.requested_at)
        order by month(r.requested_at)
    )

select 
    a.month,
    a.active_drivers,
    ifnull(r.accepted_rides,0) as accepted_rides

from active_drivers a
left join accept_ride r
on a.month = r.month