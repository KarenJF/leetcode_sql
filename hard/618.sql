/* 618. Students Report By Geography
A U.S graduate school has students from Asia, Europe and America. The students' location information are stored in table student as below.
 

| name   | continent |
|--------|-----------|
| Jack   | America   |
| Pascal | Europe    |
| Xi     | Asia      |
| Jane   | America   |
 

Pivot the continent column in this table so that each name is sorted alphabetically and displayed underneath its corresponding continent. The output headers should be America, Asia and Europe respectively. It is guaranteed that the student number from America is no less than either Asia or Europe.
 

For the sample input, the output is:
 

| America | Asia | Europe |
|---------|------|--------|
| Jack    | Xi   | Pascal |
| Jane    |      |        |
 

Follow-up: If it is unknown which continent has the most students, can you write a query to generate the student report?
*/

--Solution 
WITH tb1 as (
    select 
        row_number() over (order by name) as row_num,
        name as America 
    from student
    where continent = 'America'
),

tb2 as (
    select 
        row_number() over (order by name) as row_num,
        name as Asia
    from student
    where continent = 'Asia'
),

tb3 as (
    select 
        row_number() over (order by name) as row_num,
        name as Europe
    from student 
    where continent = 'Europe'
)

select 
    tb1.America,
    tb2.Asia,
    tb3.Europe
from tb1 
left join tb2 
on tb1.row_num = tb2.row_num
left join tb3 
on tb1.row_num = tb3.row_num

