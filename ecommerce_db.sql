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

