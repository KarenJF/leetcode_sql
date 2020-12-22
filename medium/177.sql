/* 177. Nth Highest Salary
Write a SQL query to get the nth highest salary from the Employee table.

+----+--------+
| Id | Salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+

For example, given the above Employee table, the nth highest salary where n = 2 is 200. If there is no nth highest salary, then the query should return null.

+------------------------+
| getNthHighestSalary(2) |
+------------------------+
| 200                    |
+------------------------+
*/
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      select a.Salary
      from Employee a
      join Employee b
      on b.Salary >= a.Salary
      group by a.Salary
      having count(distinct b.Salary) = N);
END

-- Solution 2
CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
RETURN (
    select Salary 
    from (select 
              Salary, 
              dense_rank () over (order by Salary desc) rnk from Employee) t 
    where t.rnk = N 
    group by 1
);
END

