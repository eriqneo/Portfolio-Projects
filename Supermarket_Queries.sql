--Total Sales Revenue Over Time
--let us understand the total sales revenue over time, showing any trends or patterns in sales 

SELECT 
    Date, SUM(Total) AS Total_Sales_Revenue
FROM 
    supermarket
GROUP BY
    Date
ORDER BY
    Total_Sales_Revenue DESC;
    

-- Sales Breakdown by Product Line
--insights into the performance of different product lines, helping us identify which categories contribute the most to sales

SELECT
    [Product line], SUM(Total) AS Total_Sales
FROM 
    supermarket
GROUP BY
    [Product line]
ORDER BY
    Total_Sales DESC;
    
    

-- Identify which Customer type has most sales

SELECT
     [Customer type], SUM(Total) AS Total_Sales
FROM supermarket
GROUP BY [Customer type];

--Identify Gender with most sales

SELECT
      Gender, SUM(Total) AS Total_Sales
FROM
     supermarket
GROUP BY
     Gender;
     
     
--Identify number of people shopped

SELECT
    Gender, COUNT(Gender) AS Number_of_people
FROM
   supermarket
GROUP BY
   Gender;


--Sales by Branch and City
--Identify most sales by branch and city

SELECT 
     Branch, City, SUM(Total) AS Total_Sales
FROM
   supermarket
GROUP BY
    Branch, City
ORDER BY
    Total_Sales DESC;
    
    
--Average Rating by Product Line
--identify average rating by product line

SELECT
     [Product line], AVG(Rating) AS Avg_Rating
FROM
   supermarket
GROUP BY
   [Product line]
ORDER BY
    Avg_Rating DESC;


--Sales Seasonality Analysis
-- dentify any seasonality patterns in sales by analyzing total sales figures month-wise.

SELECT
    strftime('%m', DATE(Date)) AS Month,
    SUM(Total) AS Total_Sales
FROM 
    supermarket
WHERE
    Date IS NOT NULL
GROUP BY 
    strftime('%m', DATE(Date));
    
    
--Payment Method Analysis
-- insights into the preferred payment methods among customers and their contribution to total sales.

SELECT
     Payment, 
     COUNT(Payment) AS Transaction_Count,
     SUM(Total) AS Total_Sales
FROM
    supermarket
GROUP BY 
    Payment
ORDER BY
      Total_Sales;
      

-- Customer Type Analysis
-- understand the distribution of customer types and their average satisfaction ratings, which can inform customer segmentation strategies

SELECT
     [Customer type],
     COUNT([Customer type]) AS Customer_Count,
     AVG(Rating) AS Avg_Rating
FROM 
    supermarket
GROUP BY 
    [Customer type];
    
    

--COGS and Gross Margin Analysis
--insights into the cost of goods sold and the average gross margin percentage across different product lines.

SELECT
    [Product line], 
    AVG(cogs) AS Avg_Cog,
    AVG([gross margin percentage]) AS Avg_gmp
FROM 
    supermarket
GROUP BY
   [Product line];
   
   
   --KPI'S

--Sales Growth Over Time
-- total sales for each year and month, allowing us to track sales growth over time.

SELECT 
    strftime('%m', Date) AS Year_Month,
    SUM(Total) AS Total_Sales
FROM 
    supermarket 
GROUP BY 
    Year_Month
ORDER BY 
    Year_Month;
    
 --Average Order Value (AOV)
 -- average order value, providing insight into the typical amount spent by customers per transaction.
 
 SELECT
      AVG(Total) AS Avg_Order_Value
 FROM supermarket;
 
 --Customer Acquisition Cost (CAC)
 --average total sales divided by the count of unique customer IDs, giving an estimation of the cost of acquisition for each customer.
 
 SELECT
     SUM(Total) / COUNT(DISTINCT [Invoice ID]) AS Customer_Acquisition_Type
 FROM
     supermarket;
     
-- Customer Retention Rate
--This query calculates the ratio of retained days to total days as the retention rate.

SELECT 
    COUNT(DISTINCT Date) AS Total_Days,
    COUNT(DISTINCT CASE WHEN Date >= '2019-01-01' AND Date < '2019-03-01' THEN Date END) AS Retained_Days,
    CAST(COUNT(DISTINCT CASE WHEN Date >= '2019-01-01' AND Date < '2019-03-01' THEN Date END) AS REAL) / CAST(COUNT(DISTINCT Date) AS REAL) * 100 AS Customer_Retention_Rate 
FROM 
    supermarket;


 --Repeat Purchase Rate
 -- number of unique customers and the number of customers who made repeat purchases. It then computes the repeat purchase rate as the ratio of repeat customers to total customers.
 
 WITH CustomerTransactions AS (
    SELECT 
        Date,
        COUNT(DISTINCT [Invoice ID]) AS Transaction_Count
    FROM 
        supermarket
    GROUP BY 
        Date
)
SELECT 
    COUNT(*) AS Total_Customers,
    COUNT(*) - COUNT(CASE WHEN Transaction_Count = 1 THEN 1 END) AS Repeat_Customers,
    (COUNT(*) - COUNT(CASE WHEN Transaction_Count = 1 THEN 1 END)) / CAST(COUNT(*) AS REAL) AS Repeat_Purchase_Rate
FROM 
    CustomerTransactions;


--Average Revenue Per User (ARPU)
--calculate the total revenue and divide it by the count of distinct dates to approximate the average revenue per user.

SELECT
     SUM(Total) / COUNT(DISTINCT Date) AS Average_Revenue_Per_User
FROM supermarket


--Segment Customers Based on Purchase Frequency
--purchase frequency for each customer type.

CREATE VIEW CustomerPurchaseFrequency AS
SELECT
     [Customer type],
     COUNT([Invoice ID]) AS Purchase_Count 
FROM
    supermarket
GROUP BY
    [Customer type];


 --Segment Customers Based on Total Spending
 --total spending for each customer type.
 
CREATE VIEW CustomerTotalSpending AS
SELECT
     [Customer type],
     SUM(Total) AS Total_Spending
FROM
    supermarket
GROUP BY
    [Customer type];
    
    
-- Average Purchase Value
-- average purchase value for each customer type.    
    
SELECT
     [Customer type],
     Total_Spending / Purchase_Count AS Avg_Purchase_Value
FROM
    CustomerTotalSpending
    JOIN CustomerPurchaseFrequency USING ([Customer type]);
    

