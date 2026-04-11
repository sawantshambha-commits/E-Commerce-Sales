CREATE DATABASE ecommerce_db;
USE ecommerce_db;

-- Customers
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price INT
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(20)
);

-- Order Items
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    total_price INT
);

-- Payments
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_method VARCHAR(20),
    payment_status VARCHAR(20)
);

-- Insert 1000 Customers
INSERT INTO customers (customer_id, name, city, signup_date)
SELECT 
    id,
    CONCAT('Customer_', id),
    ELT(FLOOR(1 + (RAND() * 5)), 'Pune', 'Mumbai', 'Delhi', 'Bangalore', 'Chennai'),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1000) DAY)
FROM (
    SELECT @row := @row + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) t1,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) t2,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) t3,
         (SELECT @row := 0) t0
    LIMIT 1000
) AS temp;

-- Insert 200 Products
INSERT INTO products (product_id, product_name, category, price)
SELECT 
    id,
    CONCAT('Product_', id),
    ELT(FLOOR(1 + (RAND() * 4)), 'Electronics', 'Fashion', 'Home', 'Sports'),
    FLOOR(100 + (RAND() * 90000))
FROM (
    SELECT @row2 := @row2 + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) a,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) b,
         (SELECT @row2 := 0) t
    LIMIT 200
) temp;

-- Insert 5000 Orders
INSERT INTO orders (order_id, customer_id, order_date, status)
SELECT
    id,
    FLOOR(1 + (RAND() * 1000)),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*365) DAY),
    ELT(FLOOR(1 + (RAND() * 3)), 'Delivered', 'Cancelled', 'Pending')
FROM (
    SELECT @row3 := @row3 + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) a,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) b,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) c,
         (SELECT @row3 := 0) t
    LIMIT 5000
) temp;

-- Insert 10,000 Order Items
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, total_price)
SELECT
    id,
    FLOOR(1 + (RAND() * 5000)),
    FLOOR(1 + (RAND() * 200)),
    FLOOR(1 + (RAND() * 5)),
    FLOOR(100 + (RAND() * 50000))
FROM (
    SELECT @row4 := @row4 + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) a,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) b,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) c,
         (SELECT @row4 := 0) t
    LIMIT 10000
) temp;

-- Insert Payments
INSERT INTO payments (payment_id, order_id, payment_method, payment_status)
SELECT
    id,
    FLOOR(1 + (RAND() * 5000)),
    ELT(FLOOR(1 + (RAND() * 4)), 'UPI', 'Card', 'Net Banking', 'COD'),
    ELT(FLOOR(1 + (RAND() * 3)), 'Success', 'Failed', 'Pending')
FROM (
    SELECT @row5 := @row5 + 1 AS id
    FROM (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) a,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) b,
         (SELECT 0 UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) c,
         (SELECT @row5 := 0) t
    LIMIT 5000
) temp;

-- Beginner Level (Basics but important)
-- 1. Total number of customers
select count(customer_id) as Total_Customer
from customers;

-- 2. Total orders
select count(order_id) as Total_Orders 
from orders;

-- 3. Total revenue
select sum(total_price) as Total_Revenue 
from order_items;

-- 4. List all unique cities
select distinct(city) from customers;

-- 5. Count orders by status
select status, count(order_id) as Total
from orders
group by status;

-- 6. Average product price


-- 7. Total products per category


-- 8. Find top 5 highest priced products


-- Intermediate Level (Real Work)
-- 9. Total revenue per customer


-- 10. Top 10 customers by revenue


-- 11. Most sold products (by quantity)


-- 12. Monthly revenue


-- 13. Customers with no orders


-- 14. Orders with more than 2 items


-- 15. Revenue by category


-- 16. Payment success rate


-- Advanced Level (Interview Killer 🔥)
-- 17. Rank customers by total spending


-- 18. Top product in each category


-- 19. Running total of revenue by date


-- 20. Customer retention (customers ordering more than once)


-- 21. Find repeat vs new customers


-- 22. Highest revenue month


-- 23. Customer lifetime value (CLV)


-- 24. Detect duplicate orders (same customer same date)


-- 25. Most popular payment method
