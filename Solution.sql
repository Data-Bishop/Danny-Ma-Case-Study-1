CREATE SCHEMA dannys_diner;
SET search_path = dannys_diner;

-- CREATING THE sales TABLE 
CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER
);

-- INSERTING VALUES INTO THE sales TABLE
INSERT INTO sales
  ("customer_id", "order_date", "product_id")
VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 

-- CREATING THE menu TABLE
CREATE TABLE menu (
  "product_id" INTEGER,
  "product_name" VARCHAR(5),
  "price" INTEGER
);

-- INSERTING VALUES INTO THE menu TABLE
INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

-- CREATING THE members TABLE
CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

-- INSERTING VALUES INTO THE members TABLE
INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


-- CASE STUDY QUESTIONS AND SOLUTIONS

-- Question 1. What is the total amount each customer spent at the restaurant?
-- Solution for Question 1
SELECT s.customer_id, 
        CONCAT('$', SUM(m.price)) AS total_amount_spent 
FROM dannys_diner.sales s
JOIN dannys_diner.menu m USING(product_id)
GROUP BY s.customer_id
ORDER BY total_amount_spent DESC; 

-- Question 2. How many days has each customer visited the restaurant?
-- Solution for Question 2
SELECT customer_id, COUNT(DISTINCT order_date) AS number_of_days_visited
    FROM dannys_diner.sales
    GROUP BY customer_id;

-- Question 3.
-- Solution for Question 3
SELECT DISTINCT s.customer_id, o.first_order_date, m.product_id, m.product_name
FROM dannys_diner.sales s
JOIN (SELECT customer_id, MIN(order_date) AS first_order_date
        FROM dannys_diner.sales
        GROUP BY customer_id) o
  ON o.customer_id = s.customer_id
  AND o.first_order_date = s.order_date
JOIN dannys_diner.menu m
  ON m.product_id = s.product_id
ORDER BY s.customer_id; 

-- Question 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
-- Solution to Question 4
SELECT s.product_id, m.product_name, COUNT(s.order_date) AS num_of_orders
FROM dannys_diner.sales s
JOIN dannys_diner.menu m USING(product_id)
GROUP BY s.product_id, m.product_name
ORDER BY num_of_orders DESC
LIMIT 1;