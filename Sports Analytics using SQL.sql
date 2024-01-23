#Final Project - Sports Analytics using SQL

#In this project, you have to perform the job of a sports analyst. You are given two datasets related to 
#IPL (Indian Premier League) cricket matches. One dataset contains ball-by-ball data and the other 
#contains match-wise data. You have to import the datasets into an SQL database and perform the tasks
# given in this assignment to find important insights from this dataset.

#About the Data 

create database IPL;
use IPL;
show tables;
select count(*) from ipl_ball;
select * from ipl_ball;
-- The first CSV file is for ball-by-ball data and it has information of all the 238755 balls bowled 
-- between the years 2008 and 2020. It has 17 columns and below is the details of those 17 columns:
select * from ipl_matches;
select count(*) from ipl_matches;
-- The second file contains match-wise data and has data of 799 IPL matches. This table has 17 columns
-- and below is a short description of the columns in this table:

#Write queries for the following tasks:

-- 1)Create a table named ‘ipl_matches’ with appropriate data types for columns
select * from ipl_matches;

-- 2)Create a table named ‘ipl_ball’ with appropriate data types for columns
select * from ipl_ball;
-- Select the top 20 rows of the ipl_ball table after ordering them by id, inning, over, ball in
-- ascending order.
SELECT *
FROM ipl_ball
ORDER BY id, inning, "over", ball
LIMIT 20;

-- 3)Select the top 20 rows of the ipl_matches table.
select * from ipl_matches limit 20;

-- 4)Fetch data of all the matches played on 2nd May 2013 from the ipl_matches table..
SELECT *
FROM ipl_matches
WHERE date = '02-05-2013';

-- 5)Fetch data of all the ipl_matches where the result mode is ‘runs’ and margin of victory is more than 
-- 100 runs.
SELECT *
FROM ipl_matches
WHERE result = 'runs' AND result_margin > 100;

-- 6)Fetch data of all the ipl_matches where the final scores of both teams tied and order it in descending 
-- order of the date.
SELECT *
FROM ipl_matches
WHERE result = 'tie'
ORDER BY date DESC;

-- 7)Get the count of cities that have hosted an IPL match.
select city, count(*) from ipl_matches group by city;

SELECT COUNT(DISTINCT city) AS city_count
FROM ipl_matches;

-- 8)Create table ipl_ball02 with all the columns of the table ‘ipl_ball’ and an additional
-- column ball_result containing values boundary, dot or other depending on the total_run 
-- (boundary for >= 4, dot for 0 and other for any other number)
-- (Hint 1 : CASE WHEN statement is used to get condition based results)
-- (Hint 2: To convert the output data of select statement into a table, you can use a subquery. Create 
-- table table_name as [entire select statement].
SELECT * FROM ipl_ball;

CREATE TABLE ipl_ball02 AS
SELECT *, 
       CASE 
         WHEN total_runs >= 4 THEN 'boundary'
         WHEN total_runs = 0 THEN 'dot'
         ELSE 'other'
       END AS ball_result
FROM ipl_ball;

select ball_result from ipl_ball02;

-- 9)Write a query to fetch the total number of boundaries and dot balls from the ipl_ball02 table.
SELECT 
    COUNT(CASE WHEN ball_result = 'boundary' THEN 1 END) AS total_boundaries,
    COUNT(CASE WHEN ball_result = 'dot' THEN 1 END) AS total_dot_balls
FROM ipl_ball02;

-- 10)Write a query to fetch the total number of boundaries scored by each team from the ipl_ball02
-- table and order it in descending order of the number of boundaries scored.
SELECT
    batting_team,
    COUNT(CASE WHEN ball_result = 'boundary' THEN 1 END) AS total_boundaries
FROM ipl_ball02
GROUP BY batting_team
ORDER BY total_boundaries DESC;

-- 11)Write a query to fetch the total number of dot balls bowled by each team and order it in descending 
-- order of the total number of dot balls bowled.
SELECT
    bowling_team,
    COUNT(CASE WHEN ball_result = 'dot' THEN 1 END) AS total_dot_balls
FROM ipl_ball02
GROUP BY bowling_team
ORDER BY total_dot_balls DESC;

-- 12)Write a query to fetch the total number of dismissals by dismissal kinds where dismissal kind is not NA
SELECT
    dismissal_kind,
    COUNT(*) AS total_dismissals
FROM ipl_ball
WHERE dismissal_kind IS NOT NULL AND dismissal_kind <> 'NA' #In SQL, the <> is the "not equal"
GROUP BY dismissal_kind;

-- 13)Write a query to get the top 5 bowlers who conceded maximum extra runs from the deliveries table
SELECT
    bowler,
    SUM(extra_runs) AS total_extra_runs
FROM ipl_ball
GROUP BY bowler
ORDER BY total_extra_runs DESC
LIMIT 5;

-- 14)Write a query to create a table named ipl_ball03 with all the columns of ipl_ball02 table and 
-- two additional column (named venue and match_date) of venue and date from table matches.
CREATE TABLE ipl_ball03 AS
SELECT ipl_ball02.*, ipl_matches.venue, ipl_matches.date
FROM ipl_ball02
JOIN ipl_matches ON ipl_ball02.id = ipl_matches.id;

Select * from ipl_ball03;

-- 15)Write a query to fetch the total runs scored for each venue and order it in the descending order of 
-- total runs scored.
SELECT
    venue,
    SUM(total_runs) AS total_runs_scored
FROM ipl_ball03
GROUP BY venue
ORDER BY total_runs_scored DESC;

-- 16)Write a query to fetch the year-wise total runs scored at Eden Gardens and order it in the descending 
-- order of total runs scored.
SELECT
    venue,
    SUM(total_runs) AS total_runs_scored
FROM ipl_ball03
GROUP BY venue
ORDER BY total_runs_scored DESC;

-- 17)Get unique team1 names from the matches table, you will notice that there are two entries for Rising
-- Pune Supergiant one with Rising Pune Supergiant and another one with Rising Pune Supergiants.  
-- Your task is to create a matches_corrected table with two additional columns team1_corr and team2_corr
-- containing team names with replacing Rising Pune Supergiants with Rising Pune Supergiant. 
-- Now analyse these newly created columns.
CREATE TABLE matches_corrected AS
SELECT
    *,
    CASE WHEN team1 = 'Rising Pune Supergiants' THEN 'Rising Pune Supergiant' ELSE team1 END AS team1_corr,
    CASE WHEN team2 = 'Rising Pune Supergiants' THEN 'Rising Pune Supergiant' ELSE team2 END AS team2_corr
FROM ipl_matches;

select * from matches_corrected;

SELECT DISTINCT team1_corr FROM matches_corrected;

-- 18)Create a new table ipl_ball04 with the first column as ball_id containing information of
-- match_id, inning, over and ball separated by ‘-’ (For ex. 335982-1-0-1 match_id-inning-over-ball)
-- and rest of the columns same as ipl_ball03)
CREATE TABLE ipl_ball04 AS
SELECT
    CONCAT(id, '-', inning, '-', 'over', '-', ball) AS ball_id,
    ipl_ball03.*
FROM ipl_ball03;

select * from ipl_ball04;

-- 19)Compare the total count of rows and total count of distinct ball_id in ipl_ball04;
-- Total count of rows
SELECT COUNT(*) AS total_rows FROM ipl_ball04;

-- Total count of distinct ball_id values
SELECT COUNT(DISTINCT ball_id) AS distinct_ball_id_count FROM ipl_ball04;

-- 20)SQL Row_Number() function is used to sort and assign row numbers to data rows in the presence of
-- multiple groups. For example, to identify the top 10 rows which have the highest order amount in each 
-- region, we can use row_number to assign row numbers in each group (region) with any particular order 
-- (decreasing order of order amount) and then we can use this new column to apply filters. Using this
-- knowledge, solve the following exercise. You can use hints to create an additional column of row 
-- number. Create a temporary table with row numbers partitioned by team and ordered by total_runs in
-- descending order
CREATE TEMPORARY TABLE temp_ranked_rows AS
SELECT
    ROW_NUMBER() OVER (PARTITION BY batting_team ORDER BY total_runs DESC) AS row_num,
    ipl_ball04.*
FROM ipl_ball04;

select * from temp_ranked_rows;

-- Select the top 5 rows for each team based on row_num
SELECT *
FROM temp_ranked_rows
WHERE row_num <= 5;

-- Drop the temporary table
DROP TEMPORARY TABLE IF EXISTS temp_ranked_rows;

-- 21)Create table ipl_ball05 with all columns of ipl_ball04 and an additional column for row 
-- number partition over ball_id. (HINT : Syntax to add along with other columns,  row_number() 
-- over (partition by ball_id) as r_num).
CREATE TABLE ipl_ball05 AS
SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY ball_id ORDER BY id, inning, 'over', ball) AS r_num
FROM ipl_ball04;

select * from ipl_ball05;

-- 22)Use the r_num created in deliveries_v05 to identify instances where ball_id is repeating.
-- (HINT : select * from ipl_ball05 WHERE r_num=2;)
SELECT *
FROM ipl_ball05
WHERE r_num > 1;

-- 23)Use subqueries to fetch data of all the ball_id which are repeating. 
-- (HINT: SELECT * FROM deliveries_v05 WHERE ball_id in (select BALL_ID from deliveries_v05 WHERE r_num=2);
SELECT *
FROM ipl_ball05
WHERE ball_id IN (SELECT ball_id FROM ipl_ball05 WHERE r_num > 1);
