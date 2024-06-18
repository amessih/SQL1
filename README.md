Project: Customers and Products Analysis Using SQL

This is my first SQL project after finishing the SQL fundamental course from Dataquest. I have provided a database about The Scale Model Cars. 

The scale model cars database schema includes 8 tables: productLine, products, orderdetails, orders, payments, customers, employees and offices. 

1. ProductLine table provides information about product in details including productLine, textDescription, htmlDescription, image with productLine is a connection with the products table. 
2. Products table provides more information about productCode, productName, productLine, productScale, productVendor, productDescription, quantityInStock, buyPrice, MSRP with productCode is a connection with the orderdetails table.
3. Orderdetails table prodives information about individual order including orderNumber, productCode, quantityOrdered, priceEach, orderLineNumber with orderNumber is a connection with the orders table. 
4. Orders table provides information about orders, shipping status and customer's information includingorderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber with customer Number as a connection with the customers table. 
5. Customers table provides detailed information about each customer" customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit with salesRepEmployeeNumber as a connection with the employees table. 
6. Employees table provides information about employees including employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle with officeCode as a connection with the offices table. 
7. Offices table provides informaiton about officeCode, city, phone, addressLine1, addressLine2, state, country, postalCode, territory. 
8. Payments table includes 4 columns customerNumber, checkNumber, paymentDate, amount with checkNumber and customerNumber are primary keys.

Based on the database, I have to find out some answers for this business to develop strategies. Those questions are: 
Question 1: Which products should we order more of or less of?
Question 2: How should we tailor marketing and communication strategies to customer behaviors?
Question 3: How much can we spend on acquiring new customers?

Please see my queries in the SQL database I've uploaded
