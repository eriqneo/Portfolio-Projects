--Since we have empty strings in Income column, lets set them to Null

UPDATE marketing_campaign
SET Income = NULL
WHERE Income = '';

-- show all where income is NULL

SELECT *
FROM marketing_campaign
WHERE Income IS NULL

-- Fix all Null values with Avg of corespondent Education and Marital status

UPDATE marketing_campaign
SET Income = (
    SELECT ROUND(AVG(d2.Income), 1) --round of to 1 decimal point
    FROM 
        marketing_campaign AS d2
    WHERE d2.Education = marketing_campaign.Education
    AND d2.Marital_Status = marketing_campaign.Marital_Status
    AND d2.Income IS NOT NULL
)
WHERE Income IS NULL

--Identify customers who received specific campaigns

SELECT 
    Education, 
    --Marital_Status,
    COUNT(CASE WHEN AcceptedCmp1 = '1' THEN 1 END) AS Accepted_Campaign1_counts,
    COUNT(CASE WHEN AcceptedCmp2 = '1' THEN 1 END) AS Accepted_Campaign2_counts,
    COUNT(CASE WHEN AcceptedCmp3 = '1' THEN 1 END) AS Accepted_Campaign3_counts, 
    COUNT(CASE WHEN AcceptedCmp4 = '1' THEN 1 END) AS Accepted_Campaign4_counts,
    COUNT(CASE WHEN AcceptedCmp5 = '1' THEN 1 END) AS Accepted_Campaign5_counts
FROM 
    marketing_campaign
GROUP BY 
    Education
    --Marital_Status;

-- In aggregate Identify customers who received campaigns , can do by education or marital status or both   

SELECT 
    Education,
    --Marital_Status,
    SUM(
         CASE WHEN AcceptedCmp1 = '1' THEN 1 ELSE 0 END +
         CASE WHEN AcceptedCmp2 = '1' THEN 1 ELSE 0 END +
         CASE WHEN AcceptedCmp3 = '1' THEN 1 ELSE 0 END +
         CASE WHEN AcceptedCmp4 = '1' THEN 1 ELSE 0 END +
         CASE WHEN AcceptedCmp1 = '1' THEN 1 ELSE 0 END) AS Total_Accepted_Counts
FROM 
    marketing_campaign
GROUP BY
  Education
  --Marital_Status
  
--  Analyze purchase behavior after campaign exposure: BY Marital_Status

SELECT
     Marital_Status, 
    SUM(MntFruits) AS Total_Fruits_Spend,
    SUM(MntWines) AS Total_Wines_Spend
FROM
    marketing_campaign
GROUP BY 
   Marital_Status
ORDER BY
   Total_Wines_Spend DESC
 
-- Average birth year and income for customers who participated in each campaign

SELECT
    ROUND(AVG(Year_Birth), 0) AS Avg_Birth_Year,
    ROUND(AVG(Income), 1) AS Avg_Income,
     'Campaign 1' AS Campaign_Name
FROM      
    marketing_campaign 
WHERE 
     AcceptedCmp1 = '1'

UNION

SELECT
    ROUND(AVG(Year_Birth), 0) AS Avg_Birth_Year,
    ROUND(AVG(Income), 1) AS Avg_Income,
     'Campaign 2' AS Campaign_Name
FROM      
    marketing_campaign 
WHERE 
     AcceptedCmp2 = '1'

UNION

SELECT
    ROUND(AVG(Year_Birth), 0) AS Avg_Birth_Year,
    ROUND(AVG(Income), 1) AS Avg_Income,
     'Campaign 3' AS Campaign_Name
FROM      
    marketing_campaign 
WHERE 
     AcceptedCmp3 = '1'
     
UNION

SELECT
    ROUND(AVG(Year_Birth), 0) AS Avg_Birth_Year,
    ROUND(AVG(Income), 1) AS Avg_Income,
     'Campaign 4' AS Campaign_Name
FROM      
    marketing_campaign 
WHERE 
     AcceptedCmp4 = '1'
     
UNION

SELECT
    ROUND(AVG(Year_Birth), 0) AS Avg_Birth_Year,
    ROUND(AVG(Income), 1) AS Avg_Income,
     'Campaign 5' AS Campaign_Name
FROM      
    marketing_campaign 
WHERE 
     AcceptedCmp5 = '1'
     
--Aggregate Website Visits by Campaign Exposure

SELECT 
    SUM(NumWebVisitsMonth) AS Total_Website_Visits,
    SUM(CASE WHEN AcceptedCmp1 = 1 THEN NumWebVisitsMonth ELSE 0 END) AS Visits_After_Campaign1,
    SUM(CASE WHEN AcceptedCmp2 = 1 THEN NumWebVisitsMonth ELSE 0 END) AS Visits_After_Campaign2,
    SUM(CASE WHEN AcceptedCmp3 = 1 THEN NumWebVisitsMonth ELSE 0 END) AS Visits_After_Campaign3,
    SUM(CASE WHEN AcceptedCmp4 = 1 THEN NumWebVisitsMonth ELSE 0 END) AS Visits_After_Campaign4,
    SUM(CASE WHEN AcceptedCmp5 = 1 THEN NumWebVisitsMonth ELSE 0 END) AS Visits_After_Campaign5
FROM 
    marketing_campaign;

--Calculate Conversion Rate for Each Campaign

--Adding a column for Total Campaign
ALTER TABLE marketing_campaign
ADD COLUMN Total_Campaigns INTEGER;

--Update the table column with sum of all campaigns in a row

UPDATE
     marketing_campaign
     SET Total_Campaigns = AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5

--Calculate Conversion Rate for Each Campaign

SELECT
      SUM(CASE WHEN AcceptedCmp1 = 1 THEN 1 ELSE 0 END) * 100 / SUM(Total_Campaigns) AS Conversion_Rate_Campaign1,
      SUM(CASE WHEN AcceptedCmp2 = 1 THEN 1 ELSE 0 END) * 100 / SUM(Total_Campaigns) AS Conversion_Rate_Campaign2,
      SUM(CASE WHEN AcceptedCmp3 = 1 THEN 1 ELSE 0 END) * 100 / SUM(Total_Campaigns) AS Conversion_Rate_Campaign3,
      SUM(CASE WHEN AcceptedCmp4 = 1 THEN 1 ELSE 0 END) * 100 / SUM(Total_Campaigns) AS Conversion_Rate_Campaign4,
      SUM(CASE WHEN AcceptedCmp5 = 1 THEN 1 ELSE 0 END) * 100 / SUM(Total_Campaigns) AS Conversion_Rate_Campaign5
FROM
    marketing_campaign;

--lets create a new table to calculate ROI

ALTER TABLE marketing_campaign
ADD COLUMN ROI_Campaign INTEGER;


UPDATE
     marketing_campaign
     SET ROI_Campaign = Z_Revenue - Z_CostContact

--Calculate Average ROI

SELECT 
    SUM(ROI_Campaign) AS Total_ROI,
    AVG(ROI_Campaign) AS Average_ROI
FROM 
    marketing_campaign;
    
--Calculate Average ROI By Campaign  
    
SELECT 
    AcceptedCmp1 AS Campaign1,
    SUM(ROI_Campaign) AS Total_ROI,
    AVG(ROI_Campaign) AS Average_ROI
FROM 
    marketing_campaign
GROUP BY 
    AcceptedCmp1;
    
SELECT 
    AcceptedCmp2 AS Campaign2,
    SUM(ROI_Campaign) AS Total_ROI,
    AVG(ROI_Campaign) AS Average_ROI
FROM 
    marketing_campaign
GROUP BY 
    AcceptedCmp2;

-- Calculate Average ROI in percentage

SELECT 
    ROI_Campaign,
    (ROI_Campaign / Z_CostContact) * 100.0 AS ROI_Percentage
FROM 
    marketing_campaign;
    
    
-- Performing A/B testing analysis In Campaigns
    
SELECT 
    Campaign,
    AVG(Response) AS Avg_Response_Rate
FROM 
    (
        SELECT 'Campaign 1' AS Campaign, Response FROM marketing_campaign WHERE AcceptedCmp1 = 1
        UNION ALL
        SELECT 'Campaign 2' AS Campaign, Response FROM marketing_campaign WHERE AcceptedCmp2 = 1
        UNION ALL
        SELECT 'Campaign 3' AS Campaign, Response FROM marketing_campaign WHERE AcceptedCmp3 = 1
        UNION ALL
        SELECT 'Campaign 4' AS Campaign, Response FROM marketing_campaign WHERE AcceptedCmp4 = 1
        UNION ALL
        SELECT 'Campaign 5' AS Campaign, Response FROM marketing_campaign WHERE AcceptedCmp5 = 1
    ) AS campaigns
GROUP BY 
    Campaign;

--Behavioral Segmentation

SELECT 
    CASE 
        WHEN MntWines > MntMeatProducts THEN 'Wine Lovers'
        WHEN MntMeatProducts > MntWines THEN 'Meat Lovers'
        ELSE 'General Customers'
    END AS Customer_Segment,
    COUNT(*) AS Customer_Count
FROM 
    marketing_campaign
GROUP BY 
    CASE 
        WHEN MntWines > MntMeatProducts THEN 'Wine Lovers'
        WHEN MntMeatProducts > MntWines THEN 'Meat Lovers'
        ELSE 'General Customers'
    END;

--Segment customers based on Marital_Status and Education

SELECT 
     Education,
     Marital_Status,
     COUNT(*) AS Customer_Count
FROM 
    marketing_campaign
GROUP BY
     Education, Marital_Status;




