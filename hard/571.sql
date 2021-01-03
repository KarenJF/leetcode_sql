/* 571. Find Median Given Frequency of Numbers
The Numbers table keeps the value of number and its frequency.

+----------+-------------+
|  Number  |  Frequency  |
+----------+-------------|
|  0       |  7          |
|  1       |  1          |
|  2       |  3          |
|  3       |  1          |
+----------+-------------+
In this table, the numbers are 0, 0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 3, so the median is (0 + 0) / 2 = 0.

+--------+
| median |
+--------|
| 0.0000 |
+--------+
Write a query to find the median of all numbers and name the result as median.
*/

--Solution 
WITH position as (
    select 
        Number,
        Frequency,
        sum(Frequency) over (order by Number) - Frequency + 1 as start_pos,
        sum(Frequency) over (order by Number) as end_pos,
        sum(Frequency) over () as total_nums
    from Numbers
    ),

    median_ind as (
        select 
            total_nums,
            (case when total_nums%2 = 0 and start_pos <= total_nums/2 and end_pos >= total_nums/2 then Number
                  when total_nums%2 !=0 and start_pos <= (total_nums+1)/2 and end_pos >= (total_nums+1)/2 then Number
                  else 0 end) as left_num,
            (case when total_nums%2 = 0 and start_pos <= total_nums/2 + 1 and end_pos >= total_nums/2+ 1 then Number
                  else 0 end) as right_num
        from position)
        
    select 
        (case when total_nums%2 = 0 then sum(left_num + right_num)/2
              else sum(left_num) end) as median
    from median_ind
        
        
-- Final 
SELECT 
    CASE WHEN is_even THEN
        SUM(m1 + m2) / 2
    ELSE
        SUM(m2)
    END
    as median
FROM
(
    select 
    total_nos % 2 = 0 as is_even,
    IF(start_position <= FLOOR(total_nos/2) and FLOOR(total_nos/2) <= end_position, Number, 0) as m1,
    IF(start_position <= FLOOR(total_nos/2) + 1 and FLOOR(total_nos/2) + 1 <= end_position, Number, 0) as m2
    from (
        select 
        Number,
        frequency,
        sum(Frequency) over(order by Number) - Frequency + 1 as start_position,
        sum(Frequency) over(order by Number) as end_position,
        sum(Frequency) over() as total_nos 
        from Numbers
    ) as T1
    order by Number
) as T2