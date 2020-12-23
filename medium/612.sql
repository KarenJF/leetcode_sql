/* 612. Shortest Distance in a Plane
Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.
 
Write a query to find the shortest distance between these points rounded to 2 decimals.
 

| x  | y  |
|----|----|
| -1 | -1 |
| 0  | 0  |
| -1 | -2 |
 

The shortest distance is 1.00 from point (-1,-1) to (-1,2). So the output should be:
 

| shortest |
|----------|
| 1.00     |
 

Note: The longest distance among all the points are less than 10000.
*/

-- Solution 
WITH point_tb as (
        select
            p1.x as x1,
            p1.y as y1,
            p2.x as x2,
            p2.y as y2
        from point_2d p1, point_2d p2),
        
    calc_distance as (
        select 
            (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) as distance
        from point_tb
        where ((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))>0
    )

    
select 
    round(min(sqrt(distance)),2) as shortest
from calc_distance