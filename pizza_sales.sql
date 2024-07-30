CREATE DATABASE pizza_sales;

USE pizza_sales;

SELECT * FROM pizzas
SELECT * FROM pizza_types
SELECT * FROM orders
SELECT * FROM order_details

CREATE VIEW pizza_details AS
SELECT p.pizza_id, p.pizza_type_id, pt.name, pt.category, p.size, p.price, pt.ingredients
FROM pizzas p
JOIN pizza_types pt
ON pt.pizza_type_id = p.pizza_type_id

SELECT * FROM pizza_details

ALTER TABLE orders
MODIFY date DATE;

ALTER TABLE orders
MODIFY time TIME;

-- 1. Total Revenue
SELECT SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id;

-- Round off
SELECT ROUND(SUM(od.quantity * p.price),2) AS total_revenue
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id;

-- 2. Revenue by Hour of the Day
SELECT HOUR(o.time) AS hour, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY HOUR(o.time)
ORDER BY hour;

-- 3. Revenue by Day of the Week
SELECT DAYNAME(o.date) AS day_name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY DAYNAME(o.date)

-- 4. Revenue by Pizza Type
SELECT pt.name AS pizza_type, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizza_details p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC;

-- 5. Total no. of pizzas sold
SELECT SUM(od.quantity) AS pizza_sold
FROM order_details od;

-- 6. Total Orders
SELECT COUNT(DISTINCT(order_id)) AS total_orders
FROM order_details;

-- 7. Average Order values
SELECT SUM(od.quantity * p.price) / COUNT(DISTINCT(od.order_id)) AS avg_order_value
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id;

-- 8. Average number of pizza per order
SELECT ROUND(SUM(od.quantity) / COUNT(DISTINCT(od.order_id)), 0) AS avg_no_pizza_per_order
FROM order_details od;

-- 9. Revenue and Orders by Week Number
SELECT YEARWEEK(o.date, 1) AS week, SUM(od.quantity * p.price) AS total_revenue, COUNT(DISTINCT o.order_id) AS total_orders
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY YEARWEEK(o.date, 1)
ORDER BY week;

-- 10. Total Revenue and no of orders per category
SELECT p.category, SUM(od.quantity * p.price) AS total_revenue, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.category;

-- 11. Total Revenue and Number od orders per size
SELECT p.size, SUM(od.quantity * p.price) AS total_revenue, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.size;

-- 12. Monthly Revenue Growth
SELECT 
    YEAR(o.date) AS year, 
    MONTH(o.date) AS month, 
    SUM(od.quantity * p.price) AS total_revenue,
    LAG(SUM(od.quantity * p.price)) OVER (PARTITION BY YEAR(o.date) ORDER BY MONTH(o.date)) AS prev_month_revenue,
    SUM(od.quantity * p.price) - LAG(SUM(od.quantity * p.price)) OVER (PARTITION BY YEAR(o.date) ORDER BY MONTH(o.date)) AS revenue_growth
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY YEAR(o.date), MONTH(o.date)
ORDER BY year, month;

-- 13. Revenue by Pizza Size
SELECT p.size, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_revenue DESC;

-- 14. Average Order Value by Pizza Size
SELECT p.size, AVG(od.quantity * p.price) AS avg_order_value
FROM order_details od
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY avg_order_value DESC;

-- 15. Revenue and Order Count by Pizza Size and Category
SELECT p.size, p.category, SUM(od.quantity * p.price) AS total_revenue, COUNT(DISTINCT od.order_id) AS total_orders
FROM order_details od
JOIN pizza_details p ON od.pizza_id = p.pizza_id
GROUP BY p.size, p.category
ORDER BY total_revenue DESC;

-- 16. Hourly, daily and monthly trend in orders and revenue of pizza
SELECT
   CASE
      WHEN HOUR(o.time) BETWEEN 9 and 12 THEN 'Late Morning'
      WHEN HOUR(o.time) BETWEEN 12 and 15 THEN 'Lunch'
      WHEN HOUR(o.time) BETWEEN 15 and 18 THEN 'Mid Afternoon'
      WHEN HOUR(o.time) BETWEEN 18 and 21 THEN 'Dinner'
      WHEN HOUR(o.time) BETWEEN 21 and 23 THEN 'Late Night'
      ELSE 'others'
      END AS meal_time, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY meal_time

-- Ascending order
SELECT
   CASE
      WHEN HOUR(o.time) BETWEEN 9 and 12 THEN 'Late Morning'
      WHEN HOUR(o.time) BETWEEN 12 and 15 THEN 'Lunch'
      WHEN HOUR(o.time) BETWEEN 15 and 18 THEN 'Mid Afternoon'
      WHEN HOUR(o.time) BETWEEN 18 and 21 THEN 'Dinner'
      WHEN HOUR(o.time) BETWEEN 21 and 23 THEN 'Late Night'
      ELSE 'others'
      END AS meal_time, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY meal_time
ORDER BY total_orders DESC;

-- 17. Weekdays
SELECT DAYNAME(o.date) AS day_name, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
GROUP BY DAYNAME(o.date)
ORDER BY total_orders DESC

-- 18. Monthwise Trend
SELECT MONTHNAME(o.date) AS day_name, COUNT(DISTINCT(od.order_id)) AS total_orders
FROM order_details od
JOIN orders o
ON o.order_id = od.order_id
GROUP BY MONTHNAME(o.date)
ORDER BY total_orders DESC

-- 19. Most Ordered pizza
SELECT p.name, p.size, COUNT(od.order_id) AS count_pizzas
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name, p.size
ORDER BY count_pizzas DESC

SELECT p.name, COUNT(od.order_id) AS count_pizzas
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER BY count_pizzas DESC
LIMIT 1

-- 20. Percentage Contribution of Each Pizza Type to Total Revenue
WITH TotalRevenue AS (
    SELECT SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
)
SELECT pt.name AS pizza_type, 
       SUM(od.quantity * p.price) AS revenue,
       (SUM(od.quantity * p.price) / (SELECT total_revenue FROM TotalRevenue)) * 100 AS percentage_contribution
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY percentage_contribution DESC;

-- 21. Revenue Growth by Week Number of the Year
SELECT YEARWEEK(o.date, 1) AS week_number, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY YEARWEEK(o.date, 1)
ORDER BY week_number;

-- 22. Frequency of Orders by Hour of the Day
SELECT HOUR(o.time) AS hour, COUNT(DISTINCT od.order_id) AS total_orders
FROM order_details od
JOIN orders o ON o.order_id = od.order_id
GROUP BY hour
ORDER BY hour;

-- 23. Top 5 pizzas by revenue
SELECT p.name, SUM(od.quantity * p.price) AS total_revenue
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER  BY total_revenue DESC
LIMIT 5

-- 24. Top Pizzas by Sale
SELECT p.name, SUM(od.quantity) AS pizzas_sold
FROM order_details od
JOIN pizza_details p
ON od.pizza_id = p.pizza_id
GROUP BY p.name
ORDER  BY pizzas_sold DESC
LIMIT 5

-- 25. Pizza Analysis
SELECT name, price
FROM pizza_details
ORDER BY price DESC
LIMIT 1

-- 26. Top used ingredients
SELECT * FROM pizza_details

CREATE TEMPORARY TABLE numbers AS (
	SELECT 1 AS n UNION ALL
    SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL
    SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL
    SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10 
);

SELECT ingredient, COUNT(ingredient) AS ingredient_count
FROM (
         SELECT substring_index2(substring_index2(ingredients, ',' , n), -1) AS ingredient
         FROM order_details
         JOIN pizza_details ON pizza_details.pizza_id = order_details.pizza_id
         JOIN numbers ON CHAR_LENGTH(ingredients) - CHAR_LENGTH(REPLACE(ingredients, ',', '')) >= n-1
      ) AS subquery
Group By ingredient
ORDER BY ingredient_count DESC