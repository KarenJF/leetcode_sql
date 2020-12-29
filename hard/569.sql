/* 569. Median Employee Salary
The Employee table holds all employees. The employee table has three columns: Employee Id, Company Name, and Salary.
+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|1    | A          | 2341   |
|2    | A          | 341    |
|3    | A          | 15     |
|4    | A          | 15314  |
|5    | A          | 451    |
|6    | A          | 513    |
|7    | B          | 15     |
|8    | B          | 13     |
|9    | B          | 1154   |
|10   | B          | 1345   |
|11   | B          | 1221   |
|12   | B          | 234    |
|13   | C          | 2345   |
|14   | C          | 2645   |
|15   | C          | 2645   |
|16   | C          | 2652   |
|17   | C          | 65     |
+-----+------------+--------+

Write a SQL query to find the median salary of each company. Bonus points if you can solve it without using any built-in SQL functions.

+-----+------------+--------+
|Id   | Company    | Salary |
+-----+------------+--------+
|5    | A          | 451    |
|6    | A          | 513    |
|12   | B          | 234    |
|9    | B          | 1154   |
|14   | C          | 2645   |
+-----+------------+--------+
*/

-- Solution 
WITH salary_order as (
    select 
        Id,
        Company,
        Salary,
        row_number() over (partition by Company order by Salary) as rnk
    from Employee
    order by Company,Salary),
    
employee_cnt as (
    select 
        Company,
        count(*) as num
    from Employee
    group by Company
),

median_num as (
    select 
        Company,
        (case when num%2 == 0 then num/2 
              else (num+1)/2 end) as left_ind,
        (case when num%2 == 0 then num/2 + 1
              else (num+1)/2 end) as right_ind
    from employee_cnt
)

select 
    s.Id, 
    s.Company,
    s.Salary
from salary_order s
join median_num m 
on s.Company = m.Company 
where s.rnk >= m.left_ind and 
      s.rnk <= m.right_ind
order by s.Company, s.Salary

--Solution 2
WITH salary_rnk as (
    select 
        Id,
        Company,
        Salary,
        row_number() over (partition by Company order by Salary) as rnk,
        count(Id) over (partition by Company) as employee_cnt
    from Employee
),

median_ind as (
    select 
        Id,
        Company,
        Salary,
        (case when employee_cnt%2 = 0 and rnk = employee_cnt/2 then 1
              when employee_cnt%2 = 0 and rnk = employee_cnt/2 + 1 then 1
              when employee_cnt%2 != 0 and rnk = (employee_cnt + 1)/2 then 1
              else 0 end) as median_select
    from salary_rnk
)
  
select 
    Id,
    Company,
    Salary
from median_ind
where median_select = 1

