/* 1384. Total Sales Amount by Year
Table: Product
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| product_name  | varchar |
+---------------+---------+
product_id is the primary key for this table.
product_name is the name of the product.
 

Table: Sales
+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| product_id          | int     |
| period_start        | date    |
| period_end          | date    |
| average_daily_sales | int     |
+---------------------+---------+
product_id is the primary key for this table. 
period_start and period_end indicates the start and end date for sales period, both dates are inclusive.
The average_daily_sales column holds the average daily sales amount of the items for the period.

Write an SQL query to report the Total sales amount of each item for each year, with corresponding product name, product_id, product_name and report_year.

Dates of the sales years are between 2018 to 2020. Return the result table ordered by product_id and report_year.

The query result format is in the following example:

Product table:
+------------+--------------+
| product_id | product_name |
+------------+--------------+
| 1          | LC Phone     |
| 2          | LC T-Shirt   |
| 3          | LC Keychain  |
+------------+--------------+

Sales table:
+------------+--------------+-------------+---------------------+
| product_id | period_start | period_end  | average_daily_sales |
+------------+--------------+-------------+---------------------+
| 1          | 2019-01-25   | 2019-02-28  | 100                 |
| 2          | 2018-12-01   | 2020-01-01  | 10                  |
| 3          | 2019-12-01   | 2020-01-31  | 1                   |
+------------+--------------+-------------+---------------------+

Result table:
+------------+--------------+-------------+--------------+
| product_id | product_name | report_year | total_amount |
+------------+--------------+-------------+--------------+
| 1          | LC Phone     |    2019     | 3500         |
| 2          | LC T-Shirt   |    2018     | 310          |
| 2          | LC T-Shirt   |    2019     | 3650         |
| 2          | LC T-Shirt   |    2020     | 10           |
| 3          | LC Keychain  |    2019     | 31           |
| 3          | LC Keychain  |    2020     | 31           |
+------------+--------------+-------------+--------------+
LC Phone was sold for the period of 2019-01-25 to 2019-02-28, and there are 35 days for this period. Total amount 35*100 = 3500. 
LC T-shirt was sold for the period of 2018-12-01 to 2020-01-01, and there are 31, 365, 1 days for years 2018, 2019 and 2020 respectively.
LC Keychain was sold for the period of 2019-12-01 to 2020-01-31, and there are 31, 31 days for years 2019 and 2020 respectively.
*/

-- Solution 
WITH recursive year_tb as(
    select 
        product_id,
        period_start,
        (case when year(period_start) = year(period_end) then period_end
              else date(concat(year(period_start),"-12-31")) end) as period_end,
        period_end as period_end_final,
        average_daily_sales
    from Sales

    UNION
    
    select 
        product_id,
        date(concat(year(period_end)+1,"-01-01")) as period_start,
        (case when (year(period_end)+1) = year(period_end_final) then period_end_final
              else date(concat((year(period_end)+1),"-12-31")) end) as period_end,
        period_end_final,
        average_daily_sales
    from year_tb
    where year(period_end)<year(period_end_final)
)

select 
    y.product_id,
    p.product_name,
    concat(year(period_start)) as report_year,
    (datediff(period_end,period_start)+1) *average_daily_sales as total_amount
from year_tb y
join product p
on y.product_id = p.product_id
order by y.product_id, report_year

