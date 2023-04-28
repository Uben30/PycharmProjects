-- Select all the records from all the tables in the schema
SELECT * from accounts;
SELECT * from orders;
SELECT * from region;
SELECT * from sales_reps; 
select * from web_events;   

-- All the companies whose names start with 'C'
Select * From accounts where name like 'C%';

--All companies whose names contain the string 'one' 
--somewhere in the name.
Select * From accounts where name like '%one%'

--All companies whose names end with 's'.
SELECT * From accounts where name like '%s'

--Use the accounts table to find the account name, primary_poc, 
--and sales_rep_id for Walmart, Target, and Nordstrom.
select name, primary_poc, sales_rep_id
From accounts
Where name In ("Walmart","Target","Nordstrom");

--Use the web_events table to find all information regarding individuals 
--who were contacted via the channel of organic or adwords.
Select * 
From web_events
Where channel In("organic","adwords")

--Use the accounts table to find the account name, primary poc, and 
--sales rep id for all stores except Walmart, Target, and Nordstrom.
select name, primary_poc,sales_rep_id
from accounts 
where name NOT IN ("Walmart","Target","Nordstrom");

--All companies whose names do not contain the string 'one' 
--somewhere in the name.
Select * From accounts where name NOT Like "%one%";

--Write a query that returns all the orders where the standard_qty 
--is over 1000, the poster_qty is 0, and the gloss_qty is 0
Select *
From orders
where standard_qty>1000 And poster_qty=0 And gloss_qty=0;

--Using the accounts table, find all the companies 
--whose names do not start with 'C' and end with 's'.
select * From accounts
Where name Not like "C%" AND name NOT LIKE "%s";

--When you use the BETWEEN operator in SQL, do the results include 
--writing a query that displays the order date 
--and gloss_qty data for all orders where gloss_qty is between 24 and 29. 
--Then look at your output to see if the BETWEEN operator included the begin and end values or not.
Select *
From orders
Where gloss_qty BETWEEN 24 AND 29;

--Use the web_events table to find all information regarding 
--individuals who were contacted via the organic or adwords channels, 
--and started their account at any point in 2016, sorted from newest 
--to oldest
Select channel, Year(occurred_at) as Years,occurred_at
From web_events
where channel in ("adwords","organic") AND Year(occurred_at)=2016
Order by occurred_at DESC;
-- Checking database system for output
SELECT FROM_UNIXTIME(1445490167000 / 1000) AS event_date
-- Checking datatype of occurred_at column
SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'newschema' AND TABLE_NAME = 'web_events' AND COLUMN_NAME = 'occurred_at';
-- modifying column to bigint format to store unix timestamp properly
ALTER TABLE web_events MODIFY occurred_at bigint;

--Write a query that returns a list of orders where the standard_qty is 
--zero and either the gloss_qty or poster_qty is over 1000.
Select *
From orders
Where standard_qty=0 AND (gloss_qty>1000 OR poster_qty>1000);

--Find all the company names that start with a 'C' or 'W', and the primary 
--contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.
Select *
From accounts
Where (name like "C%" OR name like "W%") 
    AND (primary_poc like "%ANA%" AND primary_poc NOT LIKE "%eana%")

--Find all row from orders and accounts table where primary POC is 'Jodee Lupo'
Select *
From orders
Inner JOIN accounts on orders.account_id=accounts.id
Where primary_poc='Jodee Lupo'
Limit 10;

Select DISTinct primary_poc
from accounts;

--Find all the companies 'Jodee Lupo' is working as primary POC
Select Distinct name, primary_poc
From orders
Inner JOIN accounts on orders.account_id=accounts.id
Where primary_poc='Jodee Lupo'

-- 