-- Total Rows
SELECT COUNT(*) AS Total_Rows
FROM superstore;

-- Total Sales & Profit
SELECT
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore;

-- Regional Performance
SELECT
    Region,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Category Performance
SELECT
    Category,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

--Top 10 Products by Sales
SELECT
    `Product Name`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Top 10 Customers by Revenue
SELECT
    `Customer Name`,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM superstore
GROUP BY `Customer Name`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Segment Performance
SELECT
    Segment,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- Sub-Category Analysis
SELECT
    `Sub-Category`,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY `Sub-Category`
ORDER BY Total_Sales DESC;

-- Top Loss-Making Products
SELECT
    `Product Name`,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM superstore
GROUP BY `Product Name`
ORDER BY Total_Profit ASC
LIMIT 10;

-- Discount Impact Analysis
SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.20 THEN 'Low Discount'
        WHEN Discount <= 0.40 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS Discount_Band,

    ROUND(SUM(Sales),2) AS Sales,
    ROUND(SUM(Profit),2) AS Profit

FROM superstore
GROUP BY Discount_Band;

-- Advanced

-- Rank Products by Sales
SELECT
    `Product Name`,
    ROUND(SUM(Sales),2) AS Total_Sales,
    RANK() OVER(
        ORDER BY SUM(Sales) DESC
    ) AS Product_Rank
FROM superstore
GROUP BY `Product Name`;

-- Monthly Sales Trend
SELECT
    DATE_FORMAT(
        STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
        '%Y-%m'
    ) AS Month,

    ROUND(SUM(Sales),2) AS Total_Sales

FROM superstore

GROUP BY Month
ORDER BY Month;

-- Month-over-Month Growth (Interview Favorite)
WITH monthly_sales AS
(
SELECT
    DATE_FORMAT(
        STR_TO_DATE(`Order Date`, '%m/%d/%Y'),
        '%Y-%m'
    ) AS Month,

    SUM(Sales) AS Sales

FROM superstore

GROUP BY Month
)

SELECT
    Month,
    Sales,
    LAG(Sales) OVER(ORDER BY Month) AS Previous_Month,
    ROUND(
        ((Sales - LAG(Sales) OVER(ORDER BY Month))
        / LAG(Sales) OVER(ORDER BY Month))*100,
        2
    ) AS Growth_Percent
FROM monthly_sales;