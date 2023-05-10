-- Select all the records from all the tables in the schema
SELECT * from accounts lIMIT 10;
SELECT * from orders lIMIT 10;
SELECT * from region lIMIT 10;
SELECT * from sales_reps lIMIT 10; 
select * from web_events lIMIT 10; 

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

--Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper 
--type purchased per order. Your final answer should have 6 values - one for each paper type for the average number 
--of sales, as well as the average amount.
Select * From orders;

Select AVG(standard_qty) as Avg_STD_QTY,
       AVG(gloss_qty) as AVG_GLS_QTY,
       AVG(poster_qty) as AVG_PST_QTY,
       AVG(standard_amt_usd) as AVG_STD_AMT,
       AVG(poster_amt_usd) as AVG_PST_AMT,
       AVG(gloss_amt_usd) as AVG_GLS_AMT
FROM orders; 

-- what is the MEDIAN total_usd spent on all orders?  
WITH ordered_orders AS (
  SELECT total_amt_usd, 
         ROW_NUMBER() OVER (ORDER BY total_amt_usd) AS row_num,
         COUNT(*) OVER () AS row_count
  FROM orders
)
SELECT AVG(total_amt_usd) AS median_total_usd
FROM ordered_orders
WHERE row_num IN (FLOOR(row_count / 2), FLOOR(row_count / 2) + 1);

--Which account (by name) placed the earliest order? Your solution should have the 
--account name and the date of the order.
Select acc.name as Account,
       Min(Date(o.occurred_at)) as Datee
From accounts as acc
Inner Join orders as o on acc.id=o.account_id


--When was the earliest order placed by each account? Your solution should have the 
--account name and the date of the order.
Select acc.name as Account,
       Min(Date(o.occurred_at)) as Datee
From accounts as acc
Inner Join orders as o on acc.id=o.account_id
Group By acc.name;

--Find the total sales in usd for each account. You should include two columns - 
--the total sales for each company's orders in usd and the company name.
Select acc.name as Account,
       SUM(total_amt_usd) as Total_Sales
From accounts as acc
Inner Join orders as o on acc.id=o.account_id
Group By acc.name
order by acc.name;

--Via what channel did the most recent (latest) web_event occur, which account was 
--associated with this web_event? Your query should return only three values - the 
--date, channel, and account name
Select MIN(Date(web.occurred_at)) as Earliest_Date,
      web.channel,
      acc.name
From accounts as acc
Inner join web_events as web on acc.id=web.account_id;

--Find the total number of times each type of channel from the web_events was used. 
--Your final table should have two columns - the channel and the number of times the channel was used.
Select channel, Count(channel) as Channel_Count
From web_events
Group by channel;

--What was the smallest order placed by each account in terms of total usd. Provide only two columns - 
--the account name and the total usd. Order from smallest dollar amounts to largest.
Select acc.name as Account,
      Min(o.total_amt_usd) as Minimum_Sales
From accounts as acc
Inner join orders as o on acc.id=o.account_id
group by acc.name
Order by Minimum_Sales

--Find the number of sales reps in each region. Your final table should have two columns - 
--the region and the number of sales_reps. Order from fewest reps to most reps.
Select reg.name as Region_name,
       Count(sr.name) as Sales_Rep_Count
From sales_reps as sr
Inner join region as reg on sr.region_id=reg.id
Group by reg.name
order by Sales_Rep_Count ASC

--For each account, determine the average amount of each type of paper they purchased across their orders. 
--Your result should have four columns - one for the account name and one for the average quantity purchased 
--for each of the paper types for each account. 
Select acc.name as Account,
       Round(AVG(o.standard_qty),2) as Avg_Standard_Qty,
       Round(AVG(o.poster_qty),2) as Avg_poster_Qty,
       Round(AVG(o.gloss_qty),2) as Avg_Gloss_Qty
From accounts as acc
Inner Join orders as o on acc.id=o.account_id
Group by Account
Order by Avg_Standard_Qty Desc;

--Groupby and Sum Test Query
Select acc.name, (standard_qty),(poster_qty),(gloss_qty)
From accounts as acc
Inner Join orders as o on acc.id=o.account_id
Where acc.name ="State Farm Insurance Cos."
group by acc.name

--Determine the number of times a particular channel was used in the web_events table for each sales rep. 
--Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.
Select sr.name as Sales_Rep_name,
       web.channel as Channel_name,
       Count(web.channel) as Channel_Count
From accounts as acc
Inner join sales_reps as sr on acc.sales_rep_id=sr.id
Inner join web_events as web on acc.id=web.account_id
Group by Sales_Rep_name, Channel_name
Order by Channel_Count DESC;

--Determine the number of times a particular channel was used in the web_events table for each region. 
--Your final table should have three columns - the region name, the channel, and the number of occurrences. 
--Order your table with the highest number of occurrences first.
Select reg.name as Region_name,
       web.channel as Channel_name,
       Count(web.channel) as Channel_Count
From accounts as acc
Inner join sales_reps as sr on acc.sales_rep_id=sr.id
Inner join region as reg on sr.region_id=reg.id
Inner Join web_events as web on acc.id=web.account_id
Group by Region_name, Channel_name
Order by Channel_Count DESC; 

--Use DISTINCT to test if there are any accounts associated with more than one region.
Select Distinct acc.name as Account, reg.name as Region_name
From accounts as acc
Inner join sales_reps as sr on acc.sales_rep_id=sr.id
Inner join region as reg on sr.region_id=reg.id
Group By Account
Order by Account;

Select name From accounts;

--How many of the sales reps have more than 5 accounts that they manage?
Select sr.name as Rep_name, Count(acc.name) as Account_Count
From accounts as acc
Inner Join sales_reps as sr on acc.sales_rep_id=sr.id
Group by Rep_name
Having Account_Count > 5

--Which accounts used facebook as a channel to contact customers more than 6 times?
Select acc.name as Account_name, 
       web.channel as Channel_name,
       Count(web.channel) as Channel_Count
From accounts as acc
Inner join web_events as web on acc.id=web.account_id
Where web.channel="Facebook"
Group by Account_name, Channel_name
having Channel_count>6
Order by Channel_Count Desc;

--Which account used facebook most as a channel?
Select acc.name as Account_name, 
       web.channel as Channel_name,
       Count(web.channel) as Channel_Count
From accounts as acc
Inner join web_events as web on acc.id=web.account_id
Where web.channel="Facebook" 
Group By Account_name, Channel_name
Order by Channel_Count Desc
Limit 1;

--Which channel was most frequently used by most accounts?
Select acc.name as Account_name, 
       web.channel as Channel_name,
       Count(web.channel) as Channel_Count
From accounts as acc
Inner join web_events as web on acc.id=web.account_id
Group By  Account_name, Channel_name  
-- If we only group by Account_name then it will produce the count of all the channels used 
-- by them under each channel name, Hence to get the correct aggregation of channels, we use 
-- account and channel in the group by Clause
Order by Channel_Count Desc
Limit 20;

SELECT DATE_FORMAT(occurred_at, '%Y-%m-%d 00:00:00') as Datess;
From web_events

--Find the sales in terms of total dollars for all orders in each year, ordered from greatest 
--to least. Do you notice any trends in the yearly sales totals?
Select Year(web.occurred_at) as Years,
      Sum(o.total_amt_usd) as Total_Sales     
From accounts as acc
Inner Join web_events as web on acc.id=web.account_id
inner join orders as o on acc.id=o.account_id
Group by Year(web.occurred_at)
Order by Total_Sales  DESC

--Write a query to display for each order, the account ID, total amount of the order, and the 
--level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller 
--than $3000.
Select account_id, total_amt_usd,
      (Case When total_amt_usd>=3000 THEN "Large"
      ELSE "Small" END) as Order_level
From orders

--Write a query to display the number of orders in each of three categories, based on the total 
--number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' 
--and 'Less than 1000'.
Select Case WHEN total<=1000 THEN "Less than 1000"
           WHEN total>1000 AND total<2000 THEN "B/W 1000 and 2000"
           ELSE "At Least 2000" END as Qty_group,
      Count(*)     
From orders
Group by Qty_group

--We would like to understand 3 different levels of customers based on the amount associated with 
--their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) 
--greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is
-- anyone under 100,000 usd. Provide a table that includes the level associated with each account. 
--You should provide the account name, the total sales of all orders for the customer, and the 
--level. Order with the top spending customers listed first.
Select acc.name as Account_name,
       Sum(o.total_amt_usd) as Total_Sales,
       Case When Sum(o.total_amt_usd)>=200000 Then "Highest"
       When sum(o.total_amt_usd)<200000 AND sum(o.total_amt_usd)<=100000 Then "Middle"
       ELSE "Lowest" END as Total_group
From accounts as acc
Inner Join orders as o on acc.id=o.account_id
GROUP BY acc.name

--identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table 
--with the sales rep name, the total number of orders, and a column with top or not depending on if they have 
--more than 200 orders. Place the top sales people first in your final table.
Select sr.name as Rep_name,
       Count(o.id) as Total_Orders,
       (Case WHEN COUNT(o.id)>200 Then "TOP"
       ELSE "Bottom" END) as Order_level
From accounts as acc
Inner Join orders as o on acc.id=o.account_id
Inner join sales_reps as sr on acc.sales_rep_id=sr.id
Group By sr.name;

--The previous didn't account for the middle, nor the dollar amount associated with the sales. Management 
--decides they want to see these characteristics represented as well. We would like to identify top performing 
--sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. 
--The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep 
--name, the total number of orders, total sales across all orders, and a column with top, middle, or low 
--depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table
Select sr.name as Rep_name,
      Count(o.id) as Total_Orders,
      SUM(o.total_amt_usd) as Total_Sales,
      (
            CASE
                  WHEN COunt(o.id) >= 200
                  OR sum(o.total_amt_usd) >= 750000 THEN "TOP"
                  WHEN Count(o.id) >= 150
                  AND Count(o.id) < 200
                  OR sum(o.total_amt_usd) >= 50000
                  AND sum(o.total_amt_usd) < 75000 THEN "Middle"
                  ELSE "Bottom"
            END
      ) as Order_Level
From accounts as acc
      Inner Join orders as o on acc.id = o.account_id
      Inner join sales_reps as sr on acc.sales_rep_id = sr.id
Group By sr.name;

-- Find the first ever order ever created, then find the avg of all the paper types for that given 
-- month and Sum of total amt.

SELECT Sum(total_amt_usd) as Sum_total,
      ROUND(avg(standard_qty), 2) as avg_standard,
      ROUND(avg(gloss_qty), 2) as avg_gloss,
      ROUND(avg(poster_qty), 2) as avg_poster,
      Month(occurred_at) as Months,
      Year(occurred_at) as Years
From orders
Where Month(occurred_at) = (
            Select Month(occurred_at) as Months
            From orders
            Order by Months DESC
            LImit 1
      )
      AND YEAR(occurred_at) = (
            Select YEAR(occurred_at) as Years
            From orders
            Order by Years
            LImit 1
      )
group by Years;

--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
--** Break a Subquery Problem into two or more parts, Achieve each part using a query and then Join those queries together
--Solution 1

Select t3.Top_rep_name,
      t3.Region_name,
      t3.Total_Sales --The result of the Subquery and join will only yield
      -- a table of 4 rows which is thus selected for output.
From (
            Select Region_name,
                  MAX(Total_sales) as MAX_sales       -- Took out the max of total sales for Each Region
            FROM (
                        Select sr.name as Top_Rep_name,
                              reg.name as Region_name,
                              Sum(o.total_amt_usd) as Total_Sales
                        From Accounts as acc
                              inner join sales_reps as sr on acc.sales_rep_id = sr.id
                              Inner join orders as o on acc.id = o.account_id
                              Inner join region as reg on sr.region_id = reg.id
                        Group by Region_name,
                              Top_Rep_name
                  ) as t1
            Group by Region_name -- Grouped max Sales for each region together
      ) as t2 
      Inner Join -- Joined with the same Table again to only yield the Max of each region
      (
            Select sr.name as Top_Rep_name,
                  reg.name as Region_name,
                  Sum(o.total_amt_usd) as Total_Sales
            From Accounts as acc
                  inner join sales_reps as sr on acc.sales_rep_id = sr.id
                  Inner join orders as o on acc.id = o.account_id
                  Inner join region as reg on sr.region_id = reg.id
            Group by Region_name,
                  Top_Rep_name
            Order by Total_Sales
      ) as t3 on t3.Region_name = t2.Region_name
      AND t3.Total_Sales = t2.Max_Sales -- Joined the two tables (t2 &t3) on total sales 
      --of region with the Max Sales from that Region
-- SOulution 2

Select Max(Total_sales) as Max_Sales,
      Region_name,
      Sales_Rep_name
From (
            Select reg.name as Region_name,
                  Sum(o.total_amt_usd) as Total_Sales,
                  Sr.name as Sales_Rep_name
            From accounts as acc
                  Inner Join orders as o on o.account_id = acc.id
                  Inner Join sales_reps as sr on acc.sales_rep_id = sr.id
                  Inner join region as reg on reg.id = sr.region_id
            Group by Region_name,
                  Sales_Rep_name
            Order By Total_Sales DESC
      ) as t1
Group by Region_name

-- Thought Process - 1) In the inner query we find the sum of all regions and sales_rep (grouped) and then arranged in 
-- descending order due to which only the Sales person with Max Sales contribution of that region becomes the first element
-- For each region and is retrieved by the select statement, As the Group by always retrieves the first element of all the 
-- non aggregated columns and all other columns apart from the grouped column (i.e Sales_Rep_name)


-- Q --> For the region with the largest sales total_amt_usd, how many total orders were placed?
-- ** Find the largest sales region and then use it to query the total orders of that region

Select Count(*) as Total_Orders,
      --Counting the Number of Row in the resulting dataset to find the number of orders
      reg.name as Region_name
From Accounts as acc
      inner join sales_reps as sr on acc.sales_rep_id = sr.id
      Inner join orders as o on acc.id = o.account_id
      Inner join region as reg on sr.region_id = reg.id
Where reg.id = (
            Select Region_ID -- Selecting the Region Id of Highest Sales region
            FROM (
                        Select Max(Total_Sales) as Max_Sales,
                              Region_name,
                              Region_ID --Selecting the Region which is max of total sales
                        From (
                                    Select reg.name as Region_name,
                                          --Selecting the Sum of of total sales grouped by regions
                                          Sum(o.total_amt_usd) as Total_Sales,
                                          reg.id as Region_ID
                                    From Accounts as acc
                                          inner join sales_reps as sr on acc.sales_rep_id = sr.id
                                          Inner join orders as o on acc.id = o.account_id
                                          Inner join region as reg on sr.region_id = reg.id
                                    Group by Region_name
                              ) as t1
                  ) as t2
            )
 

-- Q--> How many accounts had more total purchases than the account name which has bought the most standard_qty paper 
-- throughout their lifetime as a customer?

Select acc.name as Account_name,
       Count(o.id) as Order_Count
From accounts as acc
Inner join orders as o on acc.id=o.account_id
Group By acc.name
Having Count(o.id) > (
      Select Count(o.id) as Order_Count   
      From     
      (
            Select Account_ID
            From (
                        Select Sum(standard_qty) as Sum_standard,
                              o.account_id as Account_ID
                        From orders as o
                        Group by Account_ID
                        Order By Sum_standard DESC   -- Sorting in Desc and Limiting 1 gives the Max of sum of standard Qty
                        LIMIT 1
                  ) as t1
      ) as t2
Inner join orders as o on o.account_id=t2.Account_ID
)  
-- Thought Process 
-- 1) We take out the sum of all standard qty and Account id then use sorting and Limit 1 to get the max of sum of standard qty 
-- and its Accountid
-- 2) We use this Account Id to Join this Sub-table to the original Orders table to get all the orders matching the Above 
--  Accountid
-- 3) Count the number of row of this sub-query and then use Having to check this count against the count of orders for all 
-- the other accounts
-- 4) Selecting the Accountname and order count grouped by Accountname to get the final result


-- Q--> For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events 
-- did they have for each channel?

Select Count(*) as Web_Count,
      channel, acc.name as Account
From web_events as web
Inner Join accounts as acc on acc.id=web.account_id
Where web.account_id = (
            SELEct Account_ID
            FROM (
                        Select Sum(o.total_amt_usd) as Total_Sales,
                              o.account_id as Account_ID
                        From orders as o
                        Group by account_id
                        Order by Total_Sales DESC
                        Limit 1
                  ) as t1
      )
Group by channel

-- Thought Process - 1) Firstly we find the AccountID with the highed total_amt in lifetime
-- 2) We pass it thorugh the Where clause and Filter our Web_event table
-- 3) We Select the required output columns and then group it by channel


-- Q--> What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total 
-- spending accounts?

Select AVG(Total_Sales) as Top_10_Avg
From (
            Select Sum(total_amt_usd) as Total_Sales,
                  account_id as Account_ID
            From orders as o
            Group by Account_ID
            Order by Total_Sales DESC
            Limit 10
      ) as t1
-- Thought Process - 1) Take out the top 10 spending accounts and then pass it through the From clause as a table


-- Q--> What is the lifetime average amount spent in terms of total_amt_usd, including only the companies 
-- that spent more per order, on average, than the average of all orders.

Select Avg(Avg_Sales) as Avg_Sales
From (
            Select Avg(total_amt_usd) as Avg_sales,
                  account_id
            From orders as o
            Group by account_id
            Having Avg_Sales > (
                        Select Avg(total_amt_usd) as Avg_Sales
                        From orders as o
                  )
      ) as t1

-- Thought Process - 1) We take out the avg sales of all accounts.
-- 2) Then we use this to filter in the having clause all the accounts having avg more than the total avg
-- 3) Then we use this subquery as a table and then yield the outpur of the Avg of these accounts.


--Q--> Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.(Using With)
With t1 as( 
      Select reg.name as Region_name,
                  Sum(o.total_amt_usd) as Total_Sales,
                  Sr.name as Sales_Rep_name
            From accounts as acc
                  Inner Join orders as o on o.account_id = acc.id
                  Inner Join sales_reps as sr on acc.sales_rep_id = sr.id
                  Inner join region as reg on reg.id = sr.region_id
            Group by Region_name,
                  Sales_Rep_name
            Order By Total_Sales DESC
            )

 
Select Max(Total_sales) as Max_Sales,
      Region_name,
      Sales_Rep_name
From t1
Group by Region_name

-- Solution 2

SELECT Region_name, Top_sales_rep, row_num, sum_total
FROM (
    SELECT 
        Region_name, 
        Top_sales_rep, 
        sum_total,
        ROW_NUMBER() OVER (PARTITION BY Region_name ORDER BY sum_total DESC) AS row_num
    FROM (
        SELECT 
            reg.name AS Region_name, 
            sr.name AS Top_sales_rep, 
            SUM(total_amt_usd) AS sum_total
        FROM accounts AS acc
        INNER JOIN orders AS o ON o.account_id = acc.id
        INNER JOIN sales_reps AS sr ON acc.sales_rep_id = sr.id
        INNER JOIN region AS reg ON reg.id = sr.region_id
        GROUP BY Region_name, Top_sales_rep
        Order by sum_total Desc
    ) t1
) t2
WHERE row_num = 1;




--Use the accounts table and a CASE statement to create two groups: one group of company names that start with 
--a number and a second group of those company names that start with a letter. What proportion of company names 
--start with a letter?
Select Sum(num) as numbers,
      Sum(letter) as letter
From (
            Select name,
                  CASE
                        WHEN LEFT(Upper(name), 1) REGEXP '[0-9]' THEN 1
                        Else 0
                  End as num,
                  CASE
                        WHEN LEFT(upper(name), 1) REGEXP '[0-9]' THEN 0
                        Else 1
                  End as letter
            From accounts
      ) as t1

-- Q--> Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what 
-- percent start with anything else?
Select sum(vowels) as vowels,
      sum(cons) as consonants,
      (sum(cons) /(sum(cons) + sum(vowels))) * 100 as consonants_percent
From(
            Select name,
                  Case
                        WHEN Left(Upper(name), 1) IN ('A', 'E', 'I', 'O', 'U') Then 1
                        Else 0
                  END as vowels,
                  Case
                        WHEN Left(upper(name), 1) IN ('A', 'E', 'I', 'O', 'U') Then 0
                        Else 1
                  END as cons
            From accounts
      ) as t1

-- Q--> Use the accounts table to create first and last name columns that hold the first and last names for the 
-- primary_poc.
Select primary_poc, 
      Left(primary_poc, LOCate(" ", primary_poc)-1) as First_name,
      Right(
            primary_poc,
            length(primary_poc) - locate(" ", primary_poc)
      ) as last_name
from accounts

-- Q--> Each company in the accounts table wants to create an email address for each primary_poc. The email 
-- address should be the first name of the primary_poc . last name primary_poc @ company name .com.
Select Concat(First_name, ".", last_name, "@", company, ".com")
From (
            Select Left(primary_poc, Locate(" ", primary_poc) -1) as First_name,
                  Right(
                        primary_poc,
                        length(primary_poc) - locate(" ", primary_poc)
                  ) as last_name,
                  name as company
            From accounts
      ) as t1

-- Solution 2
With Full_name as (
      Select Substring_Index(primary_poc, " ", 1) as First_name,
            Substring_index(primary_poc, " ", -1) as last_name,
            Replace(name," ","") as Company
      From accounts
)
Select Concat(First_name, ".", last_name, "@", company, ".com") as Email
From Full_name


-- Q--> We would also like to create an initial password, which they will change after their first log in. 
-- The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter 
-- of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last 
-- name (lowercase), the number of letters in their first name, the number of letters in their last name, and then 
-- the name of the company they are working with, all capitalized with no spaces.

with t1 as(
      Select lower(Substring_Index(primary_poc, " ", 1)) as First_name,
            lower(Substring_index(primary_poc, " ", -1)) as last_name,
            (locate(" ", primary_poc) -1) as First_name_length,
            Length(primary_poc) - locate(" ", primary_poc) as Last_name_length,
            lower(Replace(name, " ", "")) as Company
      From accounts
)
Select Concat(
            Left(First_name, 1),
            Right(First_name, 1),
            Left(last_name, 1),
            right(last_name, 1),
            First_name_length,
            Last_name_length,
            Company
      )
from t1

-- Find the running totol of all standard_qty in the orders table
Select standard_qty,
      Sum(standard_qty) Over (
            Order by occurred_at
      ) as Running_total
From orders


-- Find the moving avg of all standard_qty in the orders table
Select standard_qty,
      Avg(standard_qty) Over(
            Order by occurred_at
      ) as Moving_Avg
From orders

-- Find running totol of all standard_qty partitioned by year in the orders table
Select standard_qty,
      Year(occurred_at) as Years,
      Sum(standard_qty) Over (
            Partition by year(occurred_at)
            Order by occurred_at
      ) as Running_Total_Year
From orders

--Find totol of all standard_qty partitioned by year in the orders table
Select standard_qty,
      Year(occurred_at) as Years,
      Sum(standard_qty) Over (
            Partition by year(occurred_at)           
      ) as Total_year
From orders


-- Select the id, account_id, and total variable from the orders table, then create a column called total_rank that ranks this 
-- total amount of paper ordered (from highest to lowest) for each account using a partition
Select id,
      account_id,
      total,
      Rank() Over (
            Partition by account_id
            Order by total DESC
      ) as Total_Rank
From orders

-- Multiple Aggregation functions with Partition by Account_id and Order by month.
SELECT id,
       account_id,
       Month(occurred_at) AS Month,
       DENSE_RANK() OVER account_year_window AS D_Rank,       
       SUM(total_amt_usd) OVER account_year_window AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_year_window AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_year_window AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_year_window AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_year_window AS max_total_amt_usd
FROM orders 
WINDOW account_year_window AS (PARTITION BY account_id ORDER BY  MONTH(occurred_at)) -- Window Alias

-- Lead and Lag Use Case
SELECT account_id,
       standard_sum,
       LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) AS lead_,
       standard_sum - LAG(standard_sum) OVER (ORDER BY standard_sum) AS lag_difference,
       LEAD(standard_sum) OVER (ORDER BY standard_sum) - standard_sum AS lead_difference
FROM (
SELECT account_id,
       SUM(standard_qty) AS standard_sum
  FROM orders 
 GROUP BY 1
 ) as sub

-- use occurred_at and total_amt_usd in the orders table along with LEAD to do so. In your query 
-- results, there should be four columns: occurred_at, total_amt_usd, lead, and lead_difference.
Select Date_,
      total_sum_usd,
      Lead(total_sum_usd) Over (
            Order by Date_
      ) as Lead_,
      Lead(total_sum_usd) Over (
            Order by Date_
      ) - total_sum_usd as Lead_Diff
From (
            Select Sum(total_amt_usd) as total_sum_usd,
                  Date(occurred_at) as Date_
            From orders
            GROUP BY occurred_at
      ) as t1

-- Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of 
--standard_qty for their orders. Your resulting table should have the account_id, the occurred_at 
--time for each order, the total amount of standard_qty paper purchased, and one of four levels in a 
--standard_quartile column.
Select account_id,
      (standard_qty) as Sum_standard,
      Date(occurred_at) as Date_,
      Ntile(4) Over (
            Partition by account_id
            Order by (standard_qty) DESC
      ) as Quartile
From orders
Order by account_id DESC

-- write a query that left joins the accounts table and the sales_reps tables on each sale rep's ID 
-- number and joins it using the < comparison operator on accounts.primary_poc and sales_reps.name,

SELECT accounts.name as account_name,
       accounts.primary_poc as poc_name,
       sales_reps.name as sales_rep_name
  FROM accounts
  LEFT JOIN sales_reps
    ON accounts.sales_rep_id = sales_reps.id
   AND accounts.primary_poc < sales_reps.name -- produces all accounts wher primary_poc names comes 
-- alphabetically before the sales_rep name