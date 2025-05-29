-- Create Database and use it
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Create tables
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Insert sample data
INSERT INTO customers VALUES
(1, 'Alice', 'New York'),
(2, 'Bob', 'Los Angeles'),
(3, 'Charlie', 'Chicago');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 1000.00),
(2, 'Phone', 'Electronics', 500.00),
(3, 'Desk Chair', 'Furniture', 150.00);

INSERT INTO orders VALUES
(1, 1, '2024-05-01', 1200.00),
(2, 2, '2024-05-02', 500.00),
(3, 1, '2024-05-03', 150.00);

INSERT INTO order_items VALUES
(1, 1, 1, 1),
(2, 1, 3, 1),
(3, 2, 2, 1),
(4, 3, 3, 1);

-- Queries for analysis

-- 1. Select customers from New York ordered by name
SELECT * FROM customers WHERE city = 'New York' ORDER BY name;

-- 2. Sum of amounts per customer
SELECT customer_id, SUM(amount) AS total_spent
FROM orders
GROUP BY customer_id;

-- 3. Inner join customers with orders
SELECT c.name, o.order_id, o.amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- 4. Left join customers with orders
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

-- 5. Subquery: Customers who spent more than $1000
SELECT * FROM customers
WHERE customer_id IN (
  SELECT customer_id FROM orders WHERE amount > 1000
);

-- 6. Create a view with customer order summary
CREATE VIEW customer_order_summary AS
SELECT c.name, COUNT(o.order_id) AS total_orders, SUM(o.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Check view contents
SELECT * FROM customer_order_summary;


-- 7. Create index for optimization
CREATE INDEX idx_customer_id ON orders(customer_id);
SHOW INDEX FROM orders;
