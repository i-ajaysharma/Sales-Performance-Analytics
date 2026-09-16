USE sales_analytics;

-- 01. Executive KPIs
SELECT
    ROUND(SUM(NetSales),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit,
    ROUND(SUM(Profit)/NULLIF(SUM(NetSales),0)*100,2) AS Profit_Margin_Pct,
    COUNT(DISTINCT CASE WHEN Status <> 'Cancelled' THEN OrderID END) AS Orders,
    COUNT(DISTINCT CustomerID) AS Customers,
    ROUND(SUM(NetSales)/NULLIF(COUNT(DISTINCT CASE WHEN Status <> 'Cancelled' THEN OrderID END),0),2) AS AOV
FROM FactSales
WHERE Status <> 'Cancelled';

-- 02. Monthly revenue + YoY growth
WITH monthly AS (
    SELECT DATE_FORMAT(OrderDate,'%Y-%m-01') AS MonthStart,
           SUM(NetSales) Revenue
    FROM FactSales
    WHERE Status <> 'Cancelled'
    GROUP BY DATE_FORMAT(OrderDate,'%Y-%m-01')
)
SELECT MonthStart, ROUND(Revenue,2) Revenue,
       ROUND((Revenue - LAG(Revenue,12) OVER(ORDER BY MonthStart))
             / NULLIF(LAG(Revenue,12) OVER(ORDER BY MonthStart),0)*100,2) AS YoY_Growth_Pct
FROM monthly
ORDER BY MonthStart;

-- 03. Category performance
SELECT p.Category,
       ROUND(SUM(f.NetSales),2) Revenue,
       ROUND(SUM(f.Profit),2) Profit,
       ROUND(SUM(f.Profit)/NULLIF(SUM(f.NetSales),0)*100,2) Margin_Pct,
       SUM(f.Quantity) Units
FROM FactSales f
JOIN DimProduct p ON f.ProductID=p.ProductID
WHERE f.Status <> 'Cancelled'
GROUP BY p.Category
ORDER BY Revenue DESC;

-- 04. Top 10 products by revenue
SELECT p.ProductName,
       p.Category,
       ROUND(SUM(f.NetSales),2) Revenue,
       ROUND(SUM(f.Profit),2) Profit,
       SUM(f.Quantity) Units
FROM FactSales f
JOIN DimProduct p ON f.ProductID=p.ProductID
WHERE f.Status <> 'Cancelled'
GROUP BY p.ProductID,p.ProductName,p.Category
ORDER BY Revenue DESC
LIMIT 10;

-- 05. Region performance
SELECT r.Region,
       ROUND(SUM(f.NetSales),2) Revenue,
       ROUND(SUM(f.Profit),2) Profit,
       COUNT(DISTINCT f.CustomerID) Customers
FROM FactSales f
JOIN DimCustomer c ON f.CustomerID=c.CustomerID
JOIN DimRegion r ON c.RegionID=r.RegionID
WHERE f.Status <> 'Cancelled'
GROUP BY r.Region
ORDER BY Revenue DESC;

-- 06. Salesperson target achievement
WITH actual AS (
    SELECT DATE_FORMAT(OrderDate,'%Y-%m-01') MonthStart,
           SalespersonID,
           SUM(NetSales) Revenue
    FROM FactSales
    WHERE Status <> 'Cancelled'
    GROUP BY DATE_FORMAT(OrderDate,'%Y-%m-01'), SalespersonID
)
SELECT a.MonthStart,a.SalespersonID,
       ROUND(a.Revenue,2) Revenue,
       ROUND(t.SalesTarget,2) Target,
       ROUND(a.Revenue/NULLIF(t.SalesTarget,0)*100,2) Achievement_Pct,
       CASE WHEN a.Revenue >= t.SalesTarget THEN 'Achieved' ELSE 'Below Target' END Target_Status
FROM actual a
JOIN SalesTargets t
  ON t.MonthStart=a.MonthStart AND t.SalespersonID=a.SalespersonID
ORDER BY a.MonthStart,a.Revenue DESC;

-- 07. Customer segmentation using RFM-style scoring
WITH customer_metrics AS (
    SELECT CustomerID,
           MAX(OrderDate) LastPurchase,
           COUNT(DISTINCT OrderID) Orders,
           SUM(NetSales) Revenue
    FROM FactSales
    WHERE Status <> 'Cancelled'
    GROUP BY CustomerID
),
scored AS (
    SELECT *,
           NTILE(5) OVER(ORDER BY LastPurchase DESC) RecencyScore,
           NTILE(5) OVER(ORDER BY Orders) FrequencyScore,
           NTILE(5) OVER(ORDER BY Revenue) MonetaryScore
    FROM customer_metrics
)
SELECT *,
       (RecencyScore + FrequencyScore + MonetaryScore) RFM_Total
FROM scored
ORDER BY RFM_Total DESC;

-- 08. Return/cancellation rate
SELECT
    ROUND(100 * SUM(Status='Returned') / NULLIF(COUNT(*),0),2) Return_Rate_Pct,
    ROUND(100 * SUM(Status='Cancelled') / NULLIF(COUNT(*),0),2) Cancellation_Rate_Pct
FROM FactSales;

-- 09. Channel profitability
SELECT Channel,
       ROUND(SUM(NetSales),2) Revenue,
       ROUND(SUM(Profit),2) Profit,
       ROUND(SUM(Profit)/NULLIF(SUM(NetSales),0)*100,2) Margin_Pct
FROM FactSales
GROUP BY Channel
ORDER BY Profit DESC;

-- 10. Window-function ranking: top salesperson per region
WITH sp AS (
    SELECT r.Region, s.SalespersonID, s.SalespersonName,
           SUM(f.NetSales) Revenue
    FROM FactSales f
    JOIN DimSalesperson s ON f.SalespersonID=s.SalespersonID
    JOIN DimRegion r ON s.RegionID=r.RegionID
    WHERE f.Status <> 'Cancelled'
    GROUP BY r.Region,s.SalespersonID,s.SalespersonName
),
ranked AS (
    SELECT *, DENSE_RANK() OVER(PARTITION BY Region ORDER BY Revenue DESC) rnk
    FROM sp
)
SELECT Region,SalespersonID,SalespersonName,ROUND(Revenue,2) Revenue
FROM ranked
WHERE rnk=1
ORDER BY Revenue DESC;
