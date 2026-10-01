/*
	Online Store Database - Queries
	Author: Talal Altuwairiqi
	Description: Sample queries demonstrating SELECT, JOIN, GROUP BY,
	subqueries, views and a stored procedure on the OnlineStore database.
*/

USE [P5 - OnlineShop];
GO

-- ============================================================
-- 1. BASIC QUERIES
-- ============================================================

-- List all products with their price and stock, cheapest first
SELECT ProductName, Price, QuantityInStock
FROM ProductCatalog
ORDER BY Price ASC;
GO

-- List all customers alphabetically by name
SELECT CustomerID, Name, Email
FROM Customers
ORDER BY Name ASC;
GO

-- Find products priced above 100
SELECT ProductName, Price
FROM ProductCatalog
WHERE Price > 100;
GO

-- Find all orders placed in the last 30 days
SELECT OrderID, CustomerID, OrderDate, TotalAmount
FROM Orders
WHERE OrderDate >= DATEADD(DAY, -30, GETDATE());
GO

-- ============================================================
-- 2. JOIN QUERIES
-- ============================================================

-- List each order with the customer who placed it
SELECT o.OrderID, c.Name AS CustomerName, o.OrderDate, o.TotalAmount
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderDate DESC;
GO

-- List each product with its category name
SELECT p.ProductName, pc.CategoryName, p.Price
FROM ProductCatalog p
INNER JOIN ProductCategory pc ON p.CategoryID = pc.CategoryID
ORDER BY pc.CategoryName;
GO

-- List each review with the product and customer names
SELECT p.ProductName, c.Name AS CustomerName, r.Rating, r.ReviewText, r.ReviewDate
FROM Reviews r
INNER JOIN ProductCatalog p ON r.ProductID = p.ProductID
INNER JOIN Customers c ON r.CustomerID = c.CustomerID
ORDER BY r.ReviewDate DESC;
GO

-- List every item inside a specific order (replace 1 with a real OrderID)
SELECT o.OrderID, p.ProductName, oi.Quantity, oi.Price, oi.TotalItemsPrice
FROM OrderItems oi
INNER JOIN Orders o ON oi.OrderID = o.OrderID
INNER JOIN ProductCatalog p ON oi.ProductID = p.ProductID
WHERE o.OrderID = 1;
GO

-- ============================================================
-- 3. AGGREGATE QUERIES
-- ============================================================

-- Number of products in each category
SELECT pc.CategoryName, COUNT(p.ProductID) AS ProductCount
FROM ProductCategory pc
LEFT JOIN ProductCatalog p ON pc.CategoryID = p.CategoryID
GROUP BY pc.CategoryName
ORDER BY ProductCount DESC;
GO

-- Total amount spent by each customer
SELECT c.Name AS CustomerName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name
ORDER BY TotalSpent DESC;
GO

-- Average rating for each product, highest rated first
SELECT p.ProductName, AVG(r.Rating) AS AverageRating, COUNT(r.ReviewID) AS ReviewCount
FROM ProductCatalog p
INNER JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductName
HAVING COUNT(r.ReviewID) > 0
ORDER BY AverageRating DESC;
GO

-- Number of orders grouped by status
SELECT Status, COUNT(*) AS OrderCount
FROM Orders
GROUP BY Status;
GO

-- ============================================================
-- 4. SUBQUERIES
-- ============================================================

-- Customers who have never placed an order
SELECT Name, Email
FROM Customers
WHERE CustomerID NOT IN (SELECT CustomerID FROM Orders);
GO

-- Products that have never been reviewed
SELECT ProductName
FROM ProductCatalog
WHERE ProductID NOT IN (SELECT ProductID FROM Reviews);
GO

-- Top 5 best-selling products by quantity sold
SELECT TOP 5 p.ProductName, SUM(oi.Quantity) AS TotalSold
FROM OrderItems oi
INNER JOIN ProductCatalog p ON oi.ProductID = p.ProductID
GROUP BY p.ProductName
ORDER BY TotalSold DESC;
GO

-- Customers who spent more than the average customer
SELECT c.Name, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.Name
HAVING SUM(o.TotalAmount) > (
	SELECT AVG(TotalAmount) FROM Orders
);
GO

-- ============================================================
-- 5. VIEWS
-- ============================================================

-- A view that summarizes each order with its customer and shipping status
CREATE OR ALTER VIEW vw_OrderSummary AS
SELECT
	o.OrderID,
	c.Name AS CustomerName,
	o.OrderDate,
	o.TotalAmount,
	o.Status AS OrderStatus,
	s.ShippingStatus,
	s.EstimatedDeliveryDate
FROM Orders o
INNER JOIN Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN Shippings s ON o.OrderID = s.OrderID;
GO

-- Example of using the view
SELECT * FROM vw_OrderSummary ORDER BY OrderDate DESC;
GO

-- A view that shows each product with its category and average rating
CREATE OR ALTER VIEW vw_ProductOverview AS
SELECT
	p.ProductID,
	p.ProductName,
	pc.CategoryName,
	p.Price,
	p.QuantityInStock,
	ISNULL(AVG(r.Rating), 0) AS AverageRating
FROM ProductCatalog p
INNER JOIN ProductCategory pc ON p.CategoryID = pc.CategoryID
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName, pc.CategoryName, p.Price, p.QuantityInStock;
GO

-- Example of using the view
SELECT * FROM vw_ProductOverview ORDER BY AverageRating DESC;
GO

-- ============================================================
-- 6. STORED PROCEDURE
-- ============================================================

-- Returns every order placed by a given customer
CREATE OR ALTER PROCEDURE sp_GetCustomerOrders
	@CustomerID INT
AS
BEGIN
	SELECT o.OrderID, o.OrderDate, o.TotalAmount, o.Status
	FROM Orders o
	WHERE o.CustomerID = @CustomerID
	ORDER BY o.OrderDate DESC;
END;
GO

-- Example of calling the stored procedure
EXEC sp_GetCustomerOrders @CustomerID = 1;
GO
