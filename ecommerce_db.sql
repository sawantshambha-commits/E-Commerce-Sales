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
select avg(price)
from products;

-- 7. Total products per category
select category, count(*)
from products
group by category
order by category;

-- 8. Find top 5 highest priced products
select product_name, price 
from products
order by price desc
limit 5;

-- Intermediate Level (Real Work)
-- 9. Total revenue per customer

select c.customer_id, c.name, sum(oi.total_price) as total_Revenue
from customers as c 
inner join orders as o
on c.customer_id = o.customer_id
inner join order_items as oi
on o.order_id = oi.order_id
inner join products as p
on oi.product_id = p.product_id
group by c.customer_id, name;

-- 10. Top 10 customers by revenue
SELECT c.name, SUM(oi.total_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 10;

-- 11. Most sold products (by quantity)
select p.product_name, sum(oi.quantity) as Total_Qty
from order_items as oi
inner join products as p
on oi.product_id = p.product_id
group by product_name
order by Total_Qty desc
limit 1;

-- 12. Monthly revenue
select month(order_date), sum(total_price) as Total_Revenue
from order_items as oi
inner join orders as o
on oi.order_id = o.order_id
group by order_date
order by order_date
limit 1;

-- 13. Customers with no orders
select c.name, o.order_id
from customers as c
inner join orders as o
on c.customer_id = o.customer_id
where order_id is Null;

-- 14. Orders with more than 2 items
select * from order_items
where quantity > 2;

-- 15. Revenue by category
select p.category, sum(oi.total_price) as Total_Revenue
from products as p
inner join order_items as oi
on p.product_id = oi.product_id
group by category;

-- 16. Payment success rate
select 
(count(case
when 
payment_status = "Success" then 1 end)) * 100 / count(*) 
from payments;
-- Advanced Level (Interview Killer 🔥)
-- 17. Rank customers by total spending
-- Advanced Level (Interview Killer 🔥)
-- 17. Rank customers by total spending
SELECT 
    c.customer_id,
    c.name,
    SUM(oi.total_price) AS total_spent,
    RANK() OVER (ORDER BY SUM(oi.total_price) DESC) AS rank_no
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name;
select * from customers; -- customer_id, name, city, signup_date
select * from order_items; -- order_item-id, order_id, product_id, uantity, total_price
select * from orders; -- order-id, customer_id, order_date, status
select * from payments; -- payment_id, order_id, payment_method, payment_status
select * from products; -- prodcut_id, product_name, category, price 

-- 18. Top product in each category
SELECT *
FROM (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity) AS total_qty,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(oi.quantity) DESC) AS rnk
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    GROUP BY p.category, p.product_name
) t
WHERE rnk = 1;

-- 19. Running total of revenue by date
SELECT 
    o.order_date,
    SUM(oi.total_price) AS daily_revenue,
    SUM(SUM(oi.total_price)) OVER (ORDER BY o.order_date) AS running_total
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_date;


-- 20. Customer retention (customers ordering more than once)
select customer_id, count(order_id) as Total_Order 
from orders
group by customer_id
having Total_Order > 1;

-- 21. Find repeat vs new customers
SELECT 
    CASE 
        WHEN order_count = 1 THEN 'New'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(*) 
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
) t
GROUP BY customer_type;

-- 22. Highest revenue month
SELECT MONTH(o.order_date) AS month, SUM(oi.total_price) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY month
ORDER BY revenue DESC
LIMIT 1;

-- 23. Customer lifetime value (CLV)
SELECT 
    c.customer_id,
    c.name,
    SUM(oi.total_price) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC;

-- 24. Detect duplicate orders (same customer same date)
select customer_id, order_date, count(*)
from orders
group by customer_id, order_date
having count(*) > 1;

-- 25. Most popular payment method
select payment_method, count(*) as total_usage
from payments
group by payment_method 
order by payment_method desc
limit 1;