-- Query 1: counting number of columns and rows from each table in the databse


SELECT 'Customers' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('Customers')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM Customers

UNION ALL 

SELECT 'Products' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('Products')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM Products

UNION ALL

SELECT 'ProductLines' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('ProductLines')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM ProductLines
  
UNION ALL 

SELECT 'employees' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('employees')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM employees
  
  UNION ALL
  
  SELECT 'offices' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('offices')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM offices
  
  UNION ALL
  
  SELECT 'orderdetails' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('orderdetails')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM orderdetails
  
  UNION ALL
  
  SELECT 'orders' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('orders')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM orders
  
  UNION ALL
  
  SELECT 'payments' AS table_name,
       (SELECT COUNT(*) 
        FROM pragma_table_info('payments')
        ) AS number_of_attributes,
       COUNT(*) AS number_of_rows
  FROM payments;
  
  --Query 2 Write a query to compute the low stock for each product using a correlated subquery.


  
 SELECT o.productCode, (SELECT productName FROM products as p WHERE p.productCode = o.productCode) as ProdName, round (sum(quantityOrdered)/(SELECT quantityInStock 
																								               from products as p
																								                where o.productCode = p.productCode  ),2) as low_stock 
from orderdetails as o
GROUP by productCode
order by low_stock 
limit 10;

-- Query 3: Write a query to compute the product performance for each product.

SELECT o.productCode, sum(o.quantityOrdered *o.priceEach ) as product_performance, (SELECT productName FROM products as p WHERE p.productCode = o.productCode) as ProdName
FROM orderdetails as o
group by productCode 
order by product_performance DESC
LIMIT 10;

-- Query 4: Combine the previous queries using a Common Table Expression (CTE) to display priority products for restocking using the IN operator.


with cte as (  SELECT o.productCode, (SELECT productName FROM products as p WHERE p.productCode = o.productCode) as ProdName, round (sum(quantityOrdered)/(SELECT quantityInStock 
																								               from products as p
																								                where o.productCode = p.productCode  ),2) as low_stock 
from orderdetails as o
GROUP by productCode
having low_stock=0
)



SELECT o.productCode, sum(o.quantityOrdered *o.priceEach ) as product_performance, (SELECT productName FROM products as p WHERE p.productCode = o.productCode) as ProdName,
 (SELECT productLine FROM products as p WHERE p.productCode = o.productCode) as ProdLine
FROM orderdetails as o
where productCode in (SELECT productCode from cte)
group by productCode 
order by product_performance DESC
LIMIT 10;



--Query 5:  Write a query to join the products, orders, and orderdetails tables to have customers and products information in the same place.
-- 
--Select customerNumber.
--Compute, for each customer, the profit, which is the sum of quantityOrdered multiplied by priceEach minus buyPrice: SUM(quantityOrdered * (priceEach - buyPrice)).

-- calculate most engaged customers

with cte as (
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) as profit
FROM products as p
JOIN orderdetails as od
on p.productCode = od.productCode
JOIN orders as o
on o.orderNumber = od.orderNumber
GROUP by o.customerNumber)

SELECT c.contactFirstName || ' ' || c.contactLastName as full_name, c.city, c.country, c1.profit, c1.customerNumber
FROM customers as c
JOIN cte as c1
on c1.customerNumber = c.customerNumber
order by profit DESC
limit 5;

-- calculate least engaged customers


 
with cte as (
SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) as profit
FROM products as p
JOIN orderdetails as od
on p.productCode = od.productCode
JOIN orders as o
on o.orderNumber = od.orderNumber
GROUP by o.customerNumber)

SELECT c.contactFirstName || ' ' || c.contactLastName as full_name, c.city, c.country, c1.profit, c1.customerNumber
FROM customers as c
JOIN cte as c1
on c1.customerNumber = c.customerNumber
order by profit asc
limit 5;

--Query 6  How Much Can We Spend on Acquiring New Customers?

with cte as (SELECT o.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber)

 SELECT avg(profit) as clv
 from cte;
 
 /*
 
I have learn a lot after this project. Not only about coding, but business mindset. What have I learn from answering each question: 

Question 1: Which products should we order more of or less of?
6 out of  top 10 products that need to be restocked are classic cars. We can see this is the top performance products to keep an eye for. 

Question 2:  How should we match marketing and communication strategies to customer behaviors?
- For top 5 VIP customers, in order to maintain the good relationship with them, we can develop loyatly program or exclusive events for them. 
- For top 5 less engaging customers, to bring them back more frequently, we can offer some incentive programs or increasing the customer interaction via email, calls and direct customer support. 

Question 3: How much can we spend on acquiring new customers?
We know that for each customer which brings us £39.039 (net profit). In order to determine how much within that CLV to spend for acquiring a new customer, it also depends on the costs of sales and marketing. 
However, we can see the potential of each customer profit so we can make a business plan for getting new more customer every quarter/year/month. 

 */
