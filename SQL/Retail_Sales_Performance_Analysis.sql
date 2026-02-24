/* ============================================================
   PROJECT: Retail Sales Performance Analysis (2015–2018)
   TOOL: Microsoft SQL Server (SSMS)
   DATASET: Superstore Sales Dataset
   OBJECTIVE:
   Analyze sales trends, customer behavior, and product performance
   to generate business insights.
   ============================================================ */


/* ============================================================
   1. DATA OVERVIEW
   ============================================================ */

-- Total number of records in dataset
SELECT COUNT(*) AS Total_Rows
FROM train;

-- Preview first 5 rows to understand structure
SELECT TOP 5 *
FROM train;


/* ============================================================
   2. OVERALL REVENUE ANALYSIS
   ============================================================ */

-- Total revenue across all years
SELECT SUM(Sales) AS Total_Revenue
FROM train;

-- Revenue by Year
SELECT 
    YEAR(Order_Date) AS Order_Year,
    SUM(Sales) AS Total_Revenue
FROM train
GROUP BY YEAR(Order_Date)
ORDER BY Order_Year;

-- Monthly Revenue Trend (Time Series Base)
SELECT 
    FORMAT(Order_Date, 'yyyy-MM') AS Year_Month,
    SUM(Sales) AS Monthly_Revenue
FROM train
GROUP BY FORMAT(Order_Date, 'yyyy-MM')
ORDER BY Year_Month;


/* ============================================================
   3. MONTH-OVER-MONTH (MoM) GROWTH ANALYSIS
   ============================================================ */

-- Calculate monthly revenue and growth percentage
WITH MonthlySales AS (
    SELECT 
        FORMAT(Order_Date, 'yyyy-MM') AS Year_Month,
        SUM(Sales) AS Monthly_Revenue
    FROM train
    GROUP BY FORMAT(Order_Date, 'yyyy-MM')
)

SELECT 
    Year_Month,
    Monthly_Revenue,

    -- Previous month's revenue using window function
    LAG(Monthly_Revenue) OVER (ORDER BY Year_Month) 
        AS Previous_Month_Revenue,
    
    -- Month-over-Month Growth %
    CASE 
        WHEN LAG(Monthly_Revenue) OVER (ORDER BY Year_Month) IS NULL 
        THEN NULL
        ELSE 
            (Monthly_Revenue - 
             LAG(Monthly_Revenue) OVER (ORDER BY Year_Month)) * 100.0
            / LAG(Monthly_Revenue) OVER (ORDER BY Year_Month)
    END AS MoM_Growth_Percent

FROM MonthlySales
ORDER BY Year_Month;


/* ============================================================
   4. CUSTOMER ANALYSIS
   ============================================================ */

-- Top 10 customers by total revenue contribution
SELECT TOP 10
    Customer_Name,
    SUM(Sales) AS Total_Spent
FROM train
GROUP BY Customer_Name
ORDER BY Total_Spent DESC;

-- Revenue contribution by customer segment
SELECT 
    Segment,
    SUM(Sales) AS Total_Revenue,
    SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER() 
        AS Contribution_Percent
FROM train
GROUP BY Segment;


/* ============================================================
   5. PRODUCT PERFORMANCE ANALYSIS
   ============================================================ */

-- Revenue distribution by category
SELECT 
    Category,
    SUM(Sales) AS Total_Revenue,
    SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER() 
        AS Contribution_Percent
FROM train
GROUP BY Category
ORDER BY Total_Revenue DESC;

-- Revenue by sub-category
SELECT 
    Sub_Category,
    SUM(Sales) AS Total_Revenue
FROM train
GROUP BY Sub_Category
ORDER BY Total_Revenue DESC;


/* ============================================================
   END OF ANALYSIS
   Key Focus:
   - Revenue trends & seasonality
   - Customer concentration
   - Segment contribution
   - Product performance
   ============================================================ */
