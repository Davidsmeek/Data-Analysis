#Creating Data base
create database RetailHub;

#Categories Table
create table categories
(
	CategoryID int,
    CategoryName text
);

#Cities Table
create table cities
(
	CityID int,
    CityName text,
    Zipcode int,
    CountryID int
);

#Countries Table
create table countries
(
	CountryID int,
    CountryName text,
    CountryCode text
);

#Customers Table
create table customers
(
	CustomerID int,
    FirstName text,
    MiddleInitial text,
    LastName text,
    CityID int,
    Address text
);

#Employees Table
create table employees
(
	EmployeeID int,
    FirstName text,
    MiddleInitial text,
    LastName text,
    BirthDate Date,
    Gender text,
    CityID int,
    HireDate date
);

#Product Table
create table products
(
	ProductID int,
    ProductName text,
    Price decimal (10,4),
    CategoryID int,
    Class text,
    ModifyDate date,
    Resistant text,
    IsAllergic text,
    VitalityDays int
);

#Sales Table
create table sales
(
	SalesID	int,
    SalesPersonID int,
	CustomerID	int,
    ProductID	int,
    UnitPrice	decimal(10,2),
    Quantity	int,
    Discount	float,
    SalesDate	date,
    TransactionNumber text
);

#Backing-up tables
create table categories_backup
select* from categories;

create table cities_backup
select* from cities;

create table countries_backup
select* from countries;

create table customers_backup
select* from customers;

create table employees_backup
select* from employees;

create table products_backup
select* from products;

create table sales_backup
select* from sales;

#calculated columns
#Sales before discount
select 
SalesID,
SalesPersonID,
CustomerID,
ProductID,
UnitPrice,
Quantity,
Discount,
UnitPrice * Quantity as salesBeforeDiscount
from sales;

#sales after discount
select 
SalesID,
SalesPersonID,
CustomerID,
ProductID,
UnitPrice,
Quantity,
Discount,
round(UnitPrice * Quantity * (1 - Discount),2) as salesAfterDiscount
from sales;

create table sales_calculatedColumn as
select 
SalesID,
SalesPersonID,
CustomerID,
ProductID,
UnitPrice,
Quantity,
Discount,
UnitPrice * Quantity as salesBeforeDiscount,
round(UnitPrice * Quantity * (1 - Discount),2) as salesAfterDiscount
from sales;

select * from sales_calculatedcolumn;

#QUESTIONS
#1. What is the total sales amount?
select 
round(sum(salesAfterDiscount),2) as TotalSales
from sales_calculatedcolumn;

#2. Which product has the highest total sales amount? 

SELECT p.ProductName,
       SUM(s.UnitPrice * s.Quantity * (1 - s.Discount)) AS TotalSalesAmount
FROM Sales as s
JOIN Products as p 
ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSalesAmount DESC
LIMIT 1;

#3. What is the name of the top customer and their address who purchased the most? 
SELECT
c.FirstName,
c.MiddleInitial,
c.LastName,
c.Address,
       SUM(s.UnitPrice * s.Quantity * (1 - s.Discount)) AS TotalSpent
FROM Sales as s
JOIN Customers as c 
ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.MiddleInitial, c.LastName, c.Address
ORDER BY TotalSpent DESC
LIMIT 1;


#4.Show all the employee names and the cities they live in? 
SELECT e.FirstName,
       e.MiddleInitial,
       e.LastName,
       c.CityName
FROM Employees as e
JOIN Cities c 
ON e.CityID = c.CityID;

#5. What are the average sales purchased per customer? 
-- Total each customer's sales first, then average those totals
SELECT ROUND(AVG(CustomerTotal),2) AS AverageSalesPerCustomer
FROM (
    SELECT CustomerID,
           SUM(salesAfterDiscount) AS CustomerTotal
    FROM sales_calculatedcolumn
    GROUP BY CustomerID
) AS CustomerTotals;

#6.Show all the ProductName and what categories they belong to? 
SELECT p.ProductName,
       c.CategoryName
FROM Products as p
JOIN Categories as c 
ON p.CategoryID = c.CategoryID;

#7. Classify the totalSalesAfterDiscount column as High sales, Medium sales, or Low sales based on their total sales amount. 
SELECT *,
       CASE
           WHEN totalSalesAfterDiscount >= 1000 THEN 'High sales'
           WHEN totalSalesAfterDiscount >= 500 THEN 'Medium sales'
           ELSE 'Low sales'
       END AS SalesCategory
FROM (
    SELECT SalesID, UnitPrice, Quantity, Discount,
           round(UnitPrice * Quantity * (1 - Discount),2) AS totalSalesAfterDiscount
    FROM Sales
) AS SalesWithTotals;

/*8. Display each product’s sales information — including ProductID, ProductName, 
and totalSalesAfterDiscount — along with a row number that orders the total 
sales (after discount) for each product. Use a Common Table Expression (CTE) 
and the ROW_NUMBER() function*/

WITH ProductSales AS (
    SELECT p.ProductID,
           p.ProductName,
           SUM(s.UnitPrice * s.Quantity * (1 - s.Discount)) AS totalSalesAfterDiscount
    FROM Sales as s
    JOIN Products as p 
    ON s.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT ProductID,
       ProductName,
       totalSalesAfterDiscount,
       ROW_NUMBER() OVER (ORDER BY totalSalesAfterDiscount DESC) AS RowNum
FROM ProductSales;

#9. Find the average discount given for each product 

SELECT p.ProductID,
       p.ProductName,
       round(AVG(s.Discount),2) AS AverageDiscount
FROM Sales as s
JOIN Products as p 
ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName;

#10.  List the products that are greater than the average price using a subquery. 
SELECT ProductID,
       ProductName,
       Price
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);