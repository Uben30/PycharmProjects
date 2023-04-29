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

-- Find total sale by each POC and grade them excellent if their total_amt>Avg of total_amt, else poor
Select Sum(total_amt_usd), primary_poc, round(AVG(total_amt_usd),2),
Case
    When Sum(total_amt_usd)>
    (
        Select AVG(total_amt_usdd)
        FROM (
            Select primary_poc, Sum(total_amt_usd) as total_amt_usdd
            From orders
            Inner JOIN accounts on orders.account_id=accounts.id
            group by primary_poc
        ) as Total_Sum
    )
    then "Excelent"
    Else "POOR" 
    END as Avg_Performance
From orders
Inner JOIN accounts on orders.account_id=accounts.id
GROUP BY primary_poc;

--Provide a table for all web_events associated with account name of Walmart. There should be three columns. 
--Be sure to include the primary_poc, time of the event, and the channel for each event. Additionally, you might choose 
--to add a fourth column to assure only Walmart events were chosen.
Select acc.name,acc.primary_poc,wb.channel,Date(wb.occurred_at)
From accounts as acc
Inner Join web_events as wb ON acc.id=wb.account_id
Where name ="Walmart"

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--Your final table should include three columns: the region name, the sales rep name, and the account 
--name. Sort the accounts alphabetically (A-Z) according to account name.
Select acc.name as Account_name,
    sr.name as Sales_Rep_name,
    rg.name as Region_name
From accounts as acc
    Inner Join sales_reps as sr 
        on acc.sales_rep_id = sr.id
    Inner Join region as rg 
        on sr.region_id = rg.id
Order BY acc.name

--Provide the name for each region for every order, as well as the account name and the unit price 
--they paid (total_amt_usd/total) for the order. Your final table should have 3 columns: region name, 
--account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to 
--assure not dividing by zero.
Select rg.name as Region_name, 
    acc.name as Account_name, 
    round((o.total_amt_usd/(o.total+0.01)),2) as Unit_price
From accounts as acc
 Inner join orders as o 
   on acc.id=o.account_id
 Inner join sales_reps as sr
   on acc.sales_rep_id=sr.id
 Inner Join region as rg
   on sr.region_id=rg.id

--Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for the Midwest region. Your final table should include three columns: the region name, 
--the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
Select rg.name as Region,
       sr.name as Sales_Rep_name,
       acc.name as Account
From accounts as acc
Inner Join sales_reps as sr
      on acc.sales_rep_id=sr.id
Inner join region as rg
      on sr.region_id=rg.id
      AND rg.name ="Midwest"
Order by acc.name;                     

-- Q-> Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a first name starting with S and in the Midwest 
--region. Your final table should include three columns: the region name, the sales rep name, and the 
--account name. Sort the accounts alphabetically (A-Z) according to account name.
Select rg.name as Region,
       sr.name as Sales_Rep_name,
       acc.name as Account
From accounts as acc
Inner Join sales_reps as sr
      on acc.sales_rep_id=sr.id
Inner join region as rg
      on sr.region_id=rg.id
      AND rg.name ="Midwest" AND sr.name Like "S%"
ORDER BY acc.name;

-- Q-> Provide the name for each region for every order, as well as the account name and the unit price 
--they paid (total_amt_usd/total) for the order. However, you should only provide the results if the 
--standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, 
--and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is 
--helpful total_amt_usd/(total+0.01).
Select rg.name as Region,
       acc.name as Account,
       round((o.total_amt_usd/(total+0.01)),2) as Unit_price,
       o.standard_qty as Standard_QT
From accounts as acc
inner join orders as o
      on acc.id=o.account_id
Inner Join sales_reps as sr
      on acc.sales_rep_id=sr.id
Inner join region as rg
      on sr.region_id=rg.id
Where o.standard_qty>100                      

-- Q-> Provide the name for each region for every order, as well as the account name and the unit price they paid 
--(total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity 
--exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, 
--and unit price. Sort for the smallest unit price first.
Select rg.name as Region,
       acc.name as Account,
       round((o.total_amt_usd/(total+0.01)),2) as Unit_price,
       o.standard_qty as Standard_QT
From accounts as acc
inner join orders as o
      on acc.id=o.account_id
Inner Join sales_reps as sr
      on acc.sales_rep_id=sr.id
Inner join region as rg
      on sr.region_id=rg.id
Where o.standard_qty>100 AND o.poster_qty>50
Order by Unit_price ASC;

-- Q-> What are the different channels used by account id 1001? Your final table should have only 2 columns: 
--account name and the different channels.
Select Distinct acc.name as Account,
                web.channel as channel,
                acc.id as Account_ID
From accounts as acc
Inner Join web_events as web
      on  acc.id=web.account_id
      AND acc.id=1001 

--Find all the orders that occurred in 2015. Your final table should have 4 columns: 
--occurred_at, account name, order total, and order total_amt_usd.     

Select Year(web.occurred_at) as Years,
       acc.name as Account,
       o.total as Total_Orders,
       o.total_amt_usd as Total_Amt_Earned,
       o.id as Order_ID
From accounts as acc
Inner join orders as o
      on acc.id=o.account_id
Inner join web_events as web
      on acc.id=web.account_id
      AND Year(web.occurred_at)=2015
Limit 50;

                 

