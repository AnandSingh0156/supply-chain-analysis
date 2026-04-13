-- Project: Supply Chain & Logistics Analysis
-- Author: Anand Singh
-- Description: SQL-based KPI and performance analysis

CREATE DATABASE supply_chain;
USE supply_chain;

-- =====================================
-- SUPPLY CHAIN KPI ANALYSIS (SQL)
-- =====================================

-- =====================================
-- 1. INITIAL DATA CHECK
-- =====================================

-- Check total number of records in dataset
SELECT COUNT(*) AS total_records
FROM cleaned_supply_chain_data;

-- Insight:
-- The dataset contains a large number of records, indicating strong transaction volume.

-- =====================================
-- 2. BUSINESS KPIs
-- =====================================

-- Master KPI Summary (Single View)
SELECT 
    COUNT(*) AS total_orders,
    SUM(product_price) AS total_revenue,
    ROUND(AVG(product_price),2) AS avg_order_value,
    ROUND(AVG(delivery_time),2) AS avg_delivery_time,
    ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage
FROM cleaned_supply_chain_data;

-- Insight:
-- Provides a consolidated overview of business performance and logistics efficiency.


-- Total number of orders
SELECT COUNT(*) AS total_orders
FROM cleaned_supply_chain_data;

-- Insight:
-- Represents overall platform activity and demand.

-- Total revenue generated
SELECT SUM(product_price) AS total_revenue
FROM cleaned_supply_chain_data;

-- Insight:
-- Indicates total business earnings from all transactions.

-- Average order value
SELECT AVG(product_price) AS avg_order_value
FROM cleaned_supply_chain_data;

-- Insight:
-- Most orders fall into low-to-medium value range, suggesting typical customer spending behavior.

-- Average delivery time
SELECT AVG(delivery_time) AS avg_delivery_time
FROM cleaned_supply_chain_data;

-- Insight:
-- Reflects overall logistics efficiency across all orders.

-- On-time vs delayed orders distribution
SELECT
delay,                 -- 0 = On-time, 1 = Delayed
COUNT(*) AS total_orders
FROM cleaned_supply_chain_data
GROUP BY delay;

-- Insight:
-- Majority of orders are delivered on time, but delays still represent a significant portion.

-- Delay percentage
SELECT
ROUND((SUM(delay)/COUNT(*))*100, 2) AS delay_percentage
FROM cleaned_supply_chain_data;

-- Insight:
-- Provides a clear KPI to measure logistics inefficiency.

-- =====================================
-- 3. TIME-BASED ANALYSIS
-- =====================================

-- Monthly order trend
SELECT
MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,  -- Extract month
COUNT(*) AS total_orders
FROM cleaned_supply_chain_data
GROUP BY month
ORDER BY month;

-- Insight:
-- Order volume varies across months, indicating seasonal demand patterns.

-- Average delivery time by month
SELECT
MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,
AVG(delivery_time) AS avg_delivery_time
FROM cleaned_supply_chain_data
GROUP BY month
ORDER BY month;

-- Insight:
-- Delivery time increases during peak demand months, suggesting operational pressure.

-- Monthly revenue trend
SELECT
MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,
SUM(product_price) AS total_revenue
FROM cleaned_supply_chain_data
GROUP BY month
ORDER BY month;

-- Insight:
-- Revenue trends align with order volume, highlighting peak business periods.

-- Monthly delay rate
SELECT
MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,
ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage
FROM cleaned_supply_chain_data
GROUP BY month
ORDER BY month;

-- Insight:
-- Higher delays are observed in certain months, indicating seasonal inefficiencies.

-- =====================================
-- 4. REGIONAL ANALYSIS
-- =====================================

-- Top 10 states by order volume
SELECT
state,
COUNT(*) AS total_orders
FROM cleaned_supply_chain_data
GROUP BY state
ORDER BY total_orders DESC
LIMIT 10;

-- Insight:
-- These states represent key markets with highest demand.

-- Top 10 states by delivery time (problem regions)
SELECT
state,
AVG(delivery_time) AS avg_delivery_time
FROM cleaned_supply_chain_data
GROUP BY state
ORDER BY avg_delivery_time DESC
LIMIT 10;

-- Insight:
-- These regions face logistical challenges and require optimization.

-- Top 5 states by revenue
SELECT
state,
SUM(product_price) AS total_revenue
FROM cleaned_supply_chain_data
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 5;

-- Insight:
-- Revenue is concentrated in a few regions, indicating uneven business distribution.

-- States with highest delay rate
SELECT
state,
ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage
FROM cleaned_supply_chain_data
GROUP BY state
ORDER BY delay_percentage DESC
LIMIT 10;

-- Insight:
-- These states have the highest inefficiencies in delivery performance.

-- =====================================
-- 5. DELIVERY & COST ANALYSIS
-- =====================================

-- Correlation Insight (Summary Level)

SELECT 
    AVG(product_price) AS avg_price,
    AVG(shipping_cost) AS avg_shipping,
    AVG(delivery_time) AS avg_delivery
FROM cleaned_supply_chain_data;

-- Insight:
-- Provides a high-level comparison between order value, shipping cost, 
-- and delivery time, helping identify general relationships in logistics performance.

-- Shipping cost vs delivery time
SELECT
AVG(shipping_cost) AS avg_shipping_cost,
AVG(delivery_time) AS avg_delivery_time
FROM cleaned_supply_chain_data;

-- Insight:
-- Higher shipping cost does not necessarily guarantee faster delivery.

-- Average shipping cost by state
SELECT
state,
AVG(shipping_cost) AS avg_shipping_cost
FROM cleaned_supply_chain_data
GROUP BY state
ORDER BY avg_shipping_cost DESC
LIMIT 10;

-- Insight:
-- Some regions incur higher logistics costs due to distance or infrastructure issues.

-- Delivery speed category performance
SELECT
delivery_speed,
COUNT(*) AS total_orders,
ROUND(AVG(delivery_time),2) AS avg_delivery_time
FROM cleaned_supply_chain_data
GROUP BY delivery_speed;

-- Insight:
-- Majority of orders fall into slower categories, indicating room for improvement.

-- =====================================
-- 6. ORDER VALUE ANALYSIS
-- =====================================

-- High vs medium vs low value orders
SELECT
CASE
WHEN product_price > 1000 THEN 'High Value'
WHEN product_price BETWEEN 500 AND 1000 THEN 'Medium Value'
ELSE 'Low Value'
END AS order_category,
COUNT(*) AS total_orders,
AVG(delivery_time) AS avg_delivery_time
FROM cleaned_supply_chain_data
GROUP BY order_category;

-- Insight:
-- Delivery time remains consistent across order categories, showing no dependency on order value.

-- Top 20 high-value orders
SELECT
product_price,
delivery_time
FROM cleaned_supply_chain_data
ORDER BY product_price DESC
LIMIT 20;

-- Insight:
-- High-value orders do not significantly increase delivery time.

-- =====================================
-- 7. DELAY & PERFORMANCE ANALYSIS
-- =====================================

-- Peak delay weekday
SELECT
order_weekday,
COUNT(*) AS total_delays
FROM cleaned_supply_chain_data
WHERE delay = 1
GROUP BY order_weekday
ORDER BY total_delays DESC;

-- Insight:
-- Certain weekdays experience higher delays, indicating operational bottlenecks.

-- Monthly delay vs revenue
SELECT
MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,
SUM(product_price) AS revenue,
SUM(delay) AS total_delays
FROM cleaned_supply_chain_data
GROUP BY month
ORDER BY month;

-- Insight:
-- Delays do not show a strong direct impact on revenue.

-- =====================================
-- 8. EXTREME CASE ANALYSIS
-- =====================================

-- Fastest vs slowest delivery
SELECT
MIN(delivery_time) AS fastest_delivery,
MAX(delivery_time) AS slowest_delivery
FROM cleaned_supply_chain_data;

-- Insight:
-- Presence of extreme delivery times indicates variability in logistics performance.

-- Optimized (remove zero-day anomalies)
SELECT
MIN(delivery_time) AS fastest_delivery,
MAX(delivery_time) AS slowest_delivery
FROM cleaned_supply_chain_data
WHERE delivery_time > 0;

-- Insight:
-- Removing zero values provides a more realistic delivery time range.

-- Top 10 highest delivery time orders
SELECT
order_id,
delivery_time,
state
FROM cleaned_supply_chain_data
ORDER BY delivery_time DESC
LIMIT 10;

-- Insight:
-- These cases represent extreme delays and potential operational failures.

-- =====================================
-- VIEW 1: KPI DASHBOARD SUMMARY
-- Purpose: Used for KPI cards in dashboard
-- =====================================

CREATE VIEW vw_kpi_dashboard AS
SELECT 
    COUNT(*) AS total_orders,              -- Total number of orders
    ROUND(SUM(product_price),2) AS total_revenue,   -- Total revenue generated
    ROUND(AVG(product_price),2) AS avg_order_value, -- Average order value
    ROUND(AVG(delivery_time),2) AS avg_delivery_time, -- Avg delivery efficiency
    ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage, -- % delayed orders
    ROUND(AVG(shipping_cost),2) AS avg_shipping_cost -- Avg shipping cost
FROM cleaned_supply_chain_data;


-- =====================================
-- VIEW 2: MONTHLY TRENDS
-- Purpose: Time-based analysis (line charts)
-- =====================================

CREATE VIEW vw_monthly_performance AS
SELECT 
    MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month, -- Extract month
    COUNT(*) AS total_orders,           -- Orders per month
    SUM(product_price) AS total_revenue, -- Revenue trend
    AVG(delivery_time) AS avg_delivery_time, -- Delivery performance
    ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage -- Monthly delay %
FROM cleaned_supply_chain_data
GROUP BY month;


-- =====================================
-- VIEW 3: STATE PERFORMANCE
-- Purpose: Regional comparison (bar charts, maps)
-- =====================================

CREATE VIEW vw_state_performance AS
SELECT 
    state,
    COUNT(*) AS total_orders,           -- Demand by state
    SUM(product_price) AS total_revenue, -- Revenue by state
    AVG(delivery_time) AS avg_delivery_time, -- Logistics efficiency
    ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage -- Delay issues
FROM cleaned_supply_chain_data
GROUP BY state;


-- =====================================
-- VIEW 4: DELIVERY SPEED DISTRIBUTION
-- Purpose: Delivery performance breakdown
-- =====================================

CREATE VIEW vw_delivery_speed AS
SELECT 
    delivery_speed,
    COUNT(*) AS total_orders,            -- Number of orders
    AVG(delivery_time) AS avg_delivery_time -- Avg time per category
FROM cleaned_supply_chain_data
GROUP BY delivery_speed;


-- =====================================
-- VIEW 5: ORDER VALUE ANALYSIS
-- Purpose: Compare high vs low value orders
-- =====================================

CREATE VIEW vw_order_value_category AS
SELECT 
    CASE 
        WHEN product_price > 1000 THEN 'High Value'
        WHEN product_price BETWEEN 500 AND 1000 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_category,
    COUNT(*) AS total_orders,             -- Orders in each category
    AVG(delivery_time) AS avg_delivery_time -- Delivery comparison
FROM cleaned_supply_chain_data
GROUP BY order_category;


-- =====================================
-- VIEW 6: WEEKDAY DELAY ANALYSIS
-- Purpose: Identify problematic days
-- =====================================

CREATE VIEW vw_weekday_delay AS
SELECT 
    order_weekday,
    COUNT(*) AS total_delays
FROM cleaned_supply_chain_data
WHERE delay = 1
GROUP BY order_weekday;


-- =====================================
-- VIEW 7: DELAY VS ON-TIME DISTRIBUTION
-- Purpose: Pie chart (service quality)
-- =====================================

CREATE VIEW vw_delay_distribution AS
SELECT 
    CASE 
        WHEN delay = 1 THEN 'Delayed'
        ELSE 'On-Time'
    END AS delivery_status,
    COUNT(*) AS total_orders
FROM cleaned_supply_chain_data
GROUP BY delivery_status;


-- =====================================
-- VIEW 8: SHIPPING VS DELIVERY ANALYSIS
-- Purpose: Cost vs performance comparison
-- =====================================

CREATE VIEW vw_shipping_vs_delivery AS
SELECT 
    product_price,
    shipping_cost,
    delivery_time
FROM cleaned_supply_chain_data;

-- =====================================
-- VIEW 9: HIGH DELAY STATES
-- Purpose: Identify worst performing regions
-- =====================================

CREATE VIEW vw_high_delay_states AS
SELECT 
    state,
    COUNT(*) AS total_orders,
    ROUND((SUM(delay)/COUNT(*))*100,2) AS delay_percentage
FROM cleaned_supply_chain_data
GROUP BY state
HAVING delay_percentage > 20
ORDER BY delay_percentage DESC;


-- =====================================
-- VIEW 10: MONTHLY ORDER VALUE CATEGORY
-- Purpose: Trend of order value over time
-- =====================================

CREATE VIEW vw_monthly_order_category AS
SELECT 
    MONTH(STR_TO_DATE(order_date, '%Y-%m-%d')) AS month,
    CASE 
        WHEN product_price > 1000 THEN 'High'
        WHEN product_price BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS order_category,
    COUNT(*) AS total_orders
FROM cleaned_supply_chain_data
GROUP BY month, order_category;



-- =====================================
-- VIEW 11: DELIVERY TIME BUCKET
-- Purpose: Categorize delivery performance
-- =====================================

CREATE VIEW vw_delivery_time_bucket AS
SELECT 
    CASE 
        WHEN delivery_time <= 3 THEN 'Fast'
        WHEN delivery_time BETWEEN 4 AND 7 THEN 'Moderate'
        ELSE 'Slow'
    END AS delivery_category,
    COUNT(*) AS total_orders
FROM cleaned_supply_chain_data
GROUP BY delivery_category;




-- =====================================
-- FINAL CONCLUSION
-- =====================================

-- The SQL-based analysis of the supply chain dataset provides a comprehensive
-- understanding of business performance, delivery efficiency, and operational challenges.

-- The analysis reveals that the platform handles a high volume of orders and generates
-- consistent revenue, indicating strong business activity and customer demand.

-- However, delivery performance shows that while the majority of orders are delivered
-- on time, a noticeable percentage of delays still exist, highlighting areas for
-- improvement in logistics operations.

-- Time-based analysis indicates that order volume, revenue, and delays vary across months,
-- suggesting seasonal demand patterns and operational pressure during peak periods.

-- Regional analysis identifies key states contributing significantly to revenue and order volume,
-- while also highlighting regions with higher delivery times and delay percentages, indicating
-- geographical inefficiencies.

-- Cost analysis shows that higher shipping costs do not necessarily guarantee faster delivery,
-- suggesting inefficiencies in logistics planning and resource allocation.

-- Order value analysis indicates that delivery performance remains consistent across different
-- price categories, demonstrating a uniform logistics process irrespective of order size.

-- Overall, the analysis highlights the need for optimizing delivery operations, especially in
-- high-delay regions and peak demand periods, to improve overall supply chain efficiency.

-- The insights derived from SQL queries provide a strong foundation for building interactive
-- dashboards and supporting data-driven decision-making.
