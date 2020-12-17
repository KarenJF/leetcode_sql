/* 1270. All People Report to the Given Manager
Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the primary key for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.
 

Write an SQL query to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed 3 managers as the company is small.

Return result table in any order without duplicates.

The query result format is in the following example:

Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |  1  1
| 3           | Alice         | 3          |  3  3
| 2           | Bob           | 1          |  1  1
| 4           | Daniel        | 2          |  1  1 
| 7           | Luis          | 4          |  2  1
| 8           | Jhon          | 3          |  3  3
| 9           | Angela        | 8          |  3  3
| 77          | Robert        | 1          |  1  1 
+-------------+---------------+------------+

Result table:
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+

The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 report his work indirectly to the head of the company 4 --> 2 --> 1. 
The employee with employee_id 7 report his work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8 and 9 don't report their work to head of company directly or indirectly. 
*/

-- Solution 
WITH l2_manager as (
    select 
        a.employee_id, 
        a.manager_id, 
        b.manager_id as l2_manager
    from Employees a
    join Employees b 
    on a.manager_id = b.employee_id),
    
    l3_manager as (
    select 
        a.employee_id,
        a.manager_id,
        a.l2_manager, 
        b.manager_id as l3_manager
    from l2_manager a
    join Employees b
    on a.l2_manager = b.employee_id)
    
select distinct employee_id
from l3_manager
where employee_id != 1 and l3_manager = 1

-- Solution 2 all self join 
select e.employee_id
from Employees e
join Employees e2
on e.manager_id = e2.employee_id
join Employees e3
on e2.manager_id=e3.employee_id
where e3.manager_id = 1 and e.employee_id != 1
