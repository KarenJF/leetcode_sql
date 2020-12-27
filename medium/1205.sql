/* 1205. Monthly Transactions II
Table: Transactions
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| country        | varchar |
| state          | enum    |
| amount         | int     |
| trans_date     | date    |
+----------------+---------+
id is the primary key of this table.
The table has information about incoming transactions.
The state column is an enum of type ["approved", "declined"].

Table: Chargebacks
+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| trans_id       | int     |
| charge_date    | date    |
+----------------+---------+
Chargebacks contains basic information regarding incoming chargebacks from some transactions placed in Transactions table.
trans_id is a foreign key to the id column of Transactions table.
Each chargeback corresponds to a transaction made previously even if they were not approved.
 

Write an SQL query to find for each month and country, the number of approved transactions and their total amount, the number of chargebacks and their total amount.

Note: In your query, given the month and country, ignore rows with all zeros.

The query result format is in the following example:

Transactions table:
+------+---------+----------+--------+------------+
| id   | country | state    | amount | trans_date |
+------+---------+----------+--------+------------+
| 101  | US      | approved | 1000   | 2019-05-18 |
| 102  | US      | declined | 2000   | 2019-05-19 |
| 103  | US      | approved | 3000   | 2019-06-10 |
| 104  | US      | approved | 4000   | 2019-06-13 |
| 105  | US      | approved | 5000   | 2019-06-15 |
+------+---------+----------+--------+------------+

Chargebacks table:
+------------+------------+
| trans_id   | trans_date |
+------------+------------+
| 102        | 2019-05-29 |
| 101        | 2019-06-30 |
| 105        | 2019-09-18 |
+------------+------------+

Result table:
+----------+---------+----------------+-----------------+-------------------+--------------------+
| month    | country | approved_count | approved_amount | chargeback_count  | chargeback_amount  |
+----------+---------+----------------+-----------------+-------------------+--------------------+
| 2019-05  | US      | 1              | 1000            | 1                 | 2000               |
| 2019-06  | US      | 3              | 12000           | 1                 | 1000               |
| 2019-09  | US      | 0              | 0               | 1                 | 5000               |
+----------+---------+----------------+-----------------+-------------------+--------------------+
*/

-- Solution 
WITH tran_summary as (
    select 
        substr(trans_date,1,7) as month,
        country,
        sum(case when state = 'approved' then 1 else 0 end) as approved_count,
        sum(case when state = 'approved' then amount else 0 end) as approved_amount
    from Transactions
    group by 1,2
),

charge_summary as (
    select 
        substr(c.trans_date,1,7) as month,
        t.country,
        count(c.trans_id) as chargeback_count,
        sum(t.amount) as chargeback_amount
    from Chargebacks c
    join Transactions t
    on c.trans_id = t.id
    group by 1,2
    ),

event_month as (
    select 
        t.month,
        t.country
    from tran_summary t
    where t.approved_count >0
    UNION 
    select 
        c.month,
        c.country
    from charge_summary c

)

select 
    e.month,
    e.country,
    ifnull(t.approved_count,0) as approved_count,
    ifnull(t.approved_amount,0) as approved_amount,
    ifnull(c.chargeback_count,0) as chargeback_count,
    ifnull(c.chargeback_amount,0) as chargeback_amount
        
from event_month e
left join tran_summary t on e.month = t.month and e.country = t.country
left join charge_summary c on e.month = c.month and e.country = c.country
order by 1,2