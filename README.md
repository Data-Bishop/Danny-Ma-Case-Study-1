### DANNY MA'S SQL Case Study #1 - Danny's Diner
Completed by **Abasifreke Nkanang**
#### Introduction
Danny seriously loves Japanese food so in the beginning of 2021, he decides to embark upon a risky venture and opens up a cute little restaurant that sells his 3 favourite foods: sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat - the restaurant has captured some very basic data from their few months of operation but have no idea how to use their data to help them run the business.

#### Problem Statement
Danny wants to use the data to answer a few simple questions about his customers, especially about their visiting patterns, how much money they’ve spent and also which menu items are their favourite. Having this deeper connection with his customers will help him deliver a better and more personalised experience for his loyal customers.

He plans on using these insights to help him decide whether he should expand the existing customer loyalty program - additionally he needs help to generate some basic datasets so his team can easily inspect the data without needing to use SQL.

Danny has provided you with a sample of his overall customer data due to privacy issues - but he hopes that these examples are enough for you to write fully functioning SQL queries to help him answer his questions!

Danny has shared with you 3 key datasets for this case study:
- sales
- menu
- members

All datasets exist within the **dannys_diner database schema** - be sure to include this reference within your SQL scripts as you start exploring the data and answering the case study questions.

**Table 1: sales**
-> The sales table captures all customer_id level purchases with an corresponding order_date and product_id information for when and what menu items were ordered.

|customer_id   |order_date	|product_id|
|:-------------|:----------:|----------:|
|A	|2021-01-01	|1 |
|A	|2021-01-01	|2 |
|A	|2021-01-07	|2 |
|A	|2021-01-10	|3 |
|A	|2021-01-11	|3 |
|A	|2021-01-11	|3 |
|B	|2021-01-01	|2 |
|B	|2021-01-02	|2 |
|B	|2021-01-04	|1 |
|B	|2021-01-11	|1 |
|B	|2021-01-16	|3 |
|B	|2021-02-01	|3 |
|C	|2021-01-01	|3 |
|C	|2021-01-01	|3 |
|C	|2021-01-07	|3 |


**Table 2: menu**
-> The menu table maps the product_id to the actual product_name and price of each menu item.

|product_id	|product_name |price |
|:----------|:-----------:|-----:|
|1	|sushi	|10 |
|2	|curry	|15 |
|3	|ramen	|12 |


**Table 3: members**
-> The final members table captures the join_date when a customer_id joined the beta version of the Danny’s Diner loyalty program.

|customer_id   |join_date |
|:-------------|---------:|
|A	|2021-01-07 |
|B	|2021-01-09 |


#### Case Study Questions
Each of the following case study questions can be answered using a single SQL statement:

1. What is the total amount each customer spent at the restaurant?
> The Query Result for the solution is shown below:

**Query #1**

    SELECT s.customer_id, 
            CONCAT('$', SUM(m.price)) AS total_amount_spent 
    FROM dannys_diner.sales s
    JOIN dannys_diner.menu m USING(product_id)
    GROUP BY s.customer_id
    ORDER BY total_amount_spent DESC;

| customer_id | total_amount_spent |
| ----------- | ------------------ |
| A           | $76                |
| B           | $74                |
| C           | $36                |

---

2. How many days has each customer visited the restaurant?
> The Query Result for the solution is shownn below:

**Query #2**

    SELECT customer_id, COUNT(DISTINCT order_date) AS number_of_days_visited
    FROM dannys_diner.sales
    GROUP BY customer_id;

| customer_id | number_of_days_visited |
| ----------- | ---------------------- |
| A           | 4                      |
| B           | 6                      |
| C           | 2                      |

---

3. What was the first item from the menu purchased by each customer?
> The Query Result for the Solution is shown below:

**Query #3**

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

| customer_id | first_order_date         | product_id | product_name |
| ----------- | ------------------------ | ---------- | ------------ |
| A           | 2021-01-01T00:00:00.000Z | 1          | sushi        |
| A           | 2021-01-01T00:00:00.000Z | 2          | curry        |
| B           | 2021-01-01T00:00:00.000Z | 2          | curry        |
| C           | 2021-01-01T00:00:00.000Z | 3          | ramen        |

**Note** - A Common Table Expression can be used instead of the subquery in the FROM statement.

---

4. What is the most purchased item on the menu and how many times was it purchased by all customers?
> The Query Result for the Solution is shown below:

**Query #4**

    SELECT s.product_id, m.product_name, COUNT(s.order_date) AS num_of_orders
      FROM dannys_diner.sales s
      JOIN dannys_diner.menu m USING(product_id)
      GROUP BY s.product_id, m.product_name
      ORDER BY num_of_orders DESC
      LIMIT 1;

| product_id | product_name | num_of_orders |
| ---------- | ------------ | ------------- |
| 3          | ramen        | 8             |

---

5. Which item was the most popular for each customer?
> The Query Result for the Solution is shown below:

**Query #5**

    WITH popularity AS (
    SELECT s.customer_id,
             m.product_id,
    		 m.product_name,
    		 COUNT(*) AS num_of_orders,
    		 RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS popularity_rank
    FROM dannys_diner.sales AS s 
    JOIN dannys_diner.menu m USING(product_id)
    GROUP BY s.customer_id, m.product_name, m.product_id)
    
    SELECT customer_id, product_id, product_name, num_of_orders
    FROM popularity
    WHERE popularity_rank = 1;

| customer_id | product_id | product_name | num_of_orders |
| ----------- | ---------- | ------------ | ------------- |
| A           | 3          | ramen        | 3             |
| B           | 2          | curry        | 2             |
| B           | 1          | sushi        | 2             |
| B           | 3          | ramen        | 2             |
| C           | 3          | ramen        | 3             |

---

6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?