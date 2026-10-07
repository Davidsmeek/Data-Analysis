# Retail Hub SQL Capstone Project

## 📌 Project Overview
This is the capstone project for the **Learn with George** SQL course. Using a retail database called **RetailHub**, I wrote **10 SQL queries** to answer sales questions, practising the concepts taught in the course: aggregates, `GROUP BY`, joins, subqueries, `CASE` statements, Common Table Expressions (CTEs) and window functions.

The project covers the full workflow: creating the database and tables, backing up the data, adding calculated columns, and then querying the data to answer business questions.

---

## 🛠️ Tools & Technologies
- **MySQL**: Database, tables, calculated columns and all queries
- **SQL concepts used**: `SUM`, `AVG`, `COUNT`, `GROUP BY`, `JOIN`, subqueries, `CASE`, CTE (`WITH`), `ROW_NUMBER()` window function

---

## 📁 Data Source
- **Script**: `Retail_Hub_Capstone.sql`
- **Datasets** (7 files provided by the course): `categories`, `cities`, `countries`, `customers`, `employees`, `products`, `sales`

| Table | Rows | Description |
|---|---|---|
| categories | 11 | Product categories |
| cities | 96 | Cities with zip code and country |
| countries | 206 | Countries and country codes |
| customers | 500 | Customer name, city and address |
| employees | 23 | Employee name, birth date, gender, city, hire date |
| products | 452 | Product name, price, category, class and other attributes |
| sales | 50 | Sales transactions: salesperson, customer, product, unit price, quantity, discount, date |

**Relationships**
- `sales.ProductID` → `products.ProductID` → `categories.CategoryID`
- `sales.SalesPersonID` → `employees.EmployeeID`
- `sales.CustomerID` → `customers.CustomerID`
- `customers.CityID` and `employees.CityID` → `cities.CityID` → `countries.CountryID`

---

## 🧹 Data Preparation
- Created the `RetailHub` database and one table for each file, with suitable data types (for example `decimal(10,2)` for prices and `date` for dates)
- Created a **backup copy** of every table before changing anything (`categories_backup`, `sales_backup`, and so on)
- The supplied `sales` file had about 23,000 empty rows and dates in `dd/mm/yyyy` format. The cleaned file has the **50 real transactions** (SalesID 1–50) with dates in `yyyy/mm/dd`, the format MySQL expects for `DATE` columns

**Calculated columns** (stored in the table `sales_calculatedColumn`)
- **salesBeforeDiscount** = `UnitPrice * Quantity`
- **salesAfterDiscount** = `ROUND(UnitPrice * Quantity * (1 - Discount), 2)`

---

## 📊 Data Overview
- **Period**: 1 January 2018 to 6 May 2018
- **Sales**: 50 transactions, each with a unique transaction number, from 50 different customers and 23 salespeople
- **Products sold**: 49 different products
- **Sales before discount**: $34,938.16 | **After discount**: $34,017.16
- **Discounts**: 10 of the 50 sales (20%) had a discount, 3 at 10% and 7 at 20%. Together they took $921.00 off sales (2.6%)
- **Average sale**: $680.34 | **Median sale**: $437.62

---

## 📈 Questions, Queries & Results

### 1. What is the total sales amount?
```sql
SELECT ROUND(SUM(salesAfterDiscount), 2) AS TotalSales
FROM sales_calculatedcolumn;
```
**Result:** total sales (after discount) = **$34,017.16**

### 2. Which product has the highest total sales amount?
```sql
SELECT p.ProductName,
       SUM(s.UnitPrice * s.Quantity * (1 - s.Discount)) AS TotalSalesAmount
FROM Sales AS s
JOIN Products AS p ON s.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSalesAmount DESC
LIMIT 1;
```
**Result:** **Rambutan**, with **$2,005.14** (one sale of 23 units at $87.18 with no discount). The next two are Crab - Imitation Flakes ($1,896.48) and Pasta - Orecchiette ($1,896.00)

### 3. What is the name of the top customer and their address who purchased the most?
```sql
SELECT c.FirstName, c.MiddleInitial, c.LastName, c.Address,
       SUM(s.UnitPrice * s.Quantity * (1 - s.Discount)) AS TotalSpent
FROM Sales AS s
JOIN Customers AS c ON s.CustomerID = c.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.MiddleInitial, c.LastName, c.Address
ORDER BY TotalSpent DESC
LIMIT 1;
```
**Result:** **no rows are returned.** None of the 50 customer IDs in `sales` (655 to 96,120) exists in the `customers` table (IDs 1 to 500), so the join finds no match. The customer who spent the most is **CustomerID 87577** ($2,005.14), but the dataset has no name or address for this ID. A `LEFT JOIN` would still list this customer, with empty name and address columns.

### 4. Show all the employee names and the cities they live in
```sql
SELECT e.FirstName, e.MiddleInitial, e.LastName, c.CityName
FROM Employees AS e
JOIN Cities AS c ON e.CityID = c.CityID;
```
**Result:** all **23 employees** are listed with their city (for example, Nicole T Fuller, New Orleans; Christine W Palmer, Fremont; Pablo Y Cline, Rochester).

### 5. What are the average sales purchased per customer?
```sql
SELECT ROUND(AVG(CustomerTotal), 2) AS AverageSalesPerCustomer
FROM (
    SELECT CustomerID,
           SUM(salesAfterDiscount) AS CustomerTotal
    FROM sales_calculatedcolumn
    GROUP BY CustomerID
) AS CustomerTotals;
```
**Result:** **$680.34** per customer. Each of the 50 customers made exactly one purchase, so this equals the average sale.

### 6. Show all the ProductName and what categories they belong to
```sql
SELECT p.ProductName, c.CategoryName
FROM Products AS p
JOIN Categories AS c ON p.CategoryID = c.CategoryID;
```
**Result:** all **452 products** are matched to one of the 11 categories (for example, Flour - Whole Wheat: Cereals; Cookie Chocolate Chip With: Cereals).

### 7. Classify the sales after discount as High, Medium or Low sales
```sql
SELECT *,
       CASE
           WHEN totalSalesAfterDiscount >= 1000 THEN 'High sales'
           WHEN totalSalesAfterDiscount >= 500  THEN 'Medium sales'
           ELSE 'Low sales'
       END AS SalesCategory
FROM (
    SELECT SalesID, UnitPrice, Quantity, Discount,
           ROUND(UnitPrice * Quantity * (1 - Discount), 2) AS totalSalesAfterDiscount
    FROM Sales
) AS SalesWithTotals;
```
The thresholds ($1,000 and $500) were my own choice, as the brief gives none.

| Class | Sales | Share of sales | Total amount |
|---|---|---|---|
| High sales (≥ $1,000) | 15 | 30% | $21,503.51 |
| Medium sales ($500–$999.99) | 9 | 18% | $6,585.97 |
| Low sales (< $500) | 26 | 52% | $5,927.68 |

**Result:** the 15 high sales bring in **63%** of revenue, while the 26 low sales bring in 17%.

### 8. Product sales with a row number (CTE and ROW_NUMBER)
```sql
WITH ProductSales AS (
    SELECT p.ProductID, p.ProductName,
           SUM(s.UnitPrice * s.Quantity * (1 - s.Discount)) AS totalSalesAfterDiscount
    FROM Sales AS s
    JOIN Products AS p ON s.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName
)
SELECT ProductID, ProductName, totalSalesAfterDiscount,
       ROW_NUMBER() OVER (ORDER BY totalSalesAfterDiscount DESC) AS RowNum
FROM ProductSales;
```
**Result:** 49 products ranked by total sales. Top 5:

| RowNum | ProductID | ProductName | Total sales |
|---|---|---|---|
| 1 | 369 | Rambutan | $2,005.14 |
| 2 | 23 | Crab - Imitation Flakes | $1,896.48 |
| 3 | 108 | Pasta - Orecchiette | $1,896.00 |
| 4 | 215 | Veal - Brisket, Provimi,bnls | $1,712.28 |
| 5 | 377 | Wine - Red, Cooking | $1,689.30 |

### 9. Find the average discount given for each product
```sql
SELECT p.ProductID, p.ProductName,
       ROUND(AVG(s.Discount), 2) AS AverageDiscount
FROM Sales AS s
JOIN Products AS p ON s.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName;
```
**Result:** one row for each of the 49 products sold. Most products had no discount (average 0.00), because only 10 of the 50 sales were discounted (10% or 20%).

### 10. List the products that are greater than the average price (subquery)
```sql
SELECT ProductID, ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);
```
**Result:** the average product price is **$50.80**, and **232 of the 452 products** cost more than that. The cheapest of them is Lamb - Ground ($50.88).

---

## 💡 Key Findings
- Total sales after discount were **$34,017.16** from 50 transactions, an average of $680.34 per sale
- **Rambutan** is the top product by sales ($2,005.14), followed by Crab - Imitation Flakes and Pasta - Orecchiette
- **15 high-value sales (30% of transactions) produced 63% of revenue**
- Discounts were rare and small: 20% of sales were discounted, costing $921 (2.6% of sales)

---

## ⚠️ Limitations
- **Q3 cannot be answered from this data.** The customer IDs in `sales` do not exist in the `customers` table, so no customer name or address can be shown
- **Small sales table**: 50 transactions, each customer appears once, and almost every product was sold once. "Highest selling product" is therefore the largest single sale, and the averages per customer and per product are not meaningful for comparing customers or products
- **Category labels look unreliable**: some products sit in categories that do not fit them (for example, Onions - Cippolini is in Poultry), so category-level analysis was not attempted
- **The class thresholds in Q7 are my own choice**
- Only about four months of sales (January to early May 2018)

---

## 📁 Additional Assets
- 🗄️ SQL script with all queries: `Retail_Hub_Capstone.sql`
- 📊 Dataset files: `categories`, `cities`, `countries`, `customers`, `employees`, `products`, `sales`

---

> 📬 *Feel free to reach out if you'd like help building a dashboard, SQL queries, or a presentation deck!*
