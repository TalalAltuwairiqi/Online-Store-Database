/*
	Online Store Database - Schema
	Author: Talal Altuwairiqi
	Description: Creates all tables for the Online Store database,
	in dependency order, with primary keys and foreign keys.
*/

CREATE DATABASE OnlineStore;
GO

USE OnlineStore;
GO

-- 1. Product categories (no dependencies)
CREATE TABLE ProductCategory (
	CategoryID    INT IDENTITY(1,1) PRIMARY KEY,
	CategoryName  NVARCHAR(100) NOT NULL
);
GO

-- 2. Customers (no dependencies)
CREATE TABLE Customers (
	CustomerID  INT IDENTITY(1,1) PRIMARY KEY,
	Name        NVARCHAR(100) NOT NULL,
	Email       NVARCHAR(100) NOT NULL UNIQUE,
	Phone       NVARCHAR(20),
	Address     NVARCHAR(200),
	Username    NVARCHAR(100) NOT NULL UNIQUE,
	Password    NVARCHAR(100) NOT NULL
);
GO

-- 3. Product catalog (depends on ProductCategory)
CREATE TABLE ProductCatalog (
	ProductID        INT IDENTITY(1,1) PRIMARY KEY,
	ProductName      NVARCHAR(100) NOT NULL,
	Description      NVARCHAR(500),
	Price            SMALLMONEY NOT NULL,
	QuantityInStock  INT NOT NULL DEFAULT 0,
	CategoryID       INT NOT NULL,
	CONSTRAINT FK_Category_Product FOREIGN KEY (CategoryID)
		REFERENCES ProductCategory (CategoryID)
);
GO

-- 4. Product images (depends on ProductCatalog)
CREATE TABLE ProductImages (
	ImageID     INT IDENTITY(1,1) PRIMARY KEY,
	ImageURL    NVARCHAR(400) NOT NULL,
	ProductID   INT NOT NULL,
	ImageOrder  SMALLINT NOT NULL DEFAULT 1,
	CONSTRAINT FK_ProductImages_ProductCatalog FOREIGN KEY (ProductID)
		REFERENCES ProductCatalog (ProductID)
);
GO

-- 5. Reviews (depends on ProductCatalog and Customers)
CREATE TABLE Reviews (
	ReviewID    INT IDENTITY(1,1) PRIMARY KEY,
	ProductID   INT NOT NULL,
	CustomerID  INT NOT NULL,
	ReviewText  NVARCHAR(500),
	Rating      DECIMAL(3,1) NOT NULL CHECK (Rating BETWEEN 1 AND 5),
	ReviewDate  DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Product_Review FOREIGN KEY (ProductID)
		REFERENCES ProductCatalog (ProductID),
	CONSTRAINT FK_Customer_Review FOREIGN KEY (CustomerID)
		REFERENCES Customers (CustomerID)
);
GO

-- 6. Orders (depends on Customers)
CREATE TABLE Orders (
	OrderID      INT IDENTITY(1,1) PRIMARY KEY,
	CustomerID   INT NOT NULL,
	OrderDate    DATETIME NOT NULL DEFAULT GETDATE(),
	TotalAmount  SMALLMONEY NOT NULL,
	Status       SMALLINT NOT NULL DEFAULT 0,
	CONSTRAINT FK_Customer_Order FOREIGN KEY (CustomerID)
		REFERENCES Customers (CustomerID)
);
GO

-- 7. Order items (depends on Orders and ProductCatalog, composite primary key)
CREATE TABLE OrderItems (
	OrderID          INT NOT NULL,
	ProductID        INT NOT NULL,
	Quantity         INT NOT NULL CHECK (Quantity > 0),
	Price            SMALLMONEY NOT NULL,
	TotalItemsPrice  SMALLMONEY NOT NULL,
	CONSTRAINT PK_OrderItems PRIMARY KEY (OrderID, ProductID),
	CONSTRAINT FK_Order_OrderItem FOREIGN KEY (OrderID)
		REFERENCES Orders (OrderID),
	CONSTRAINT FK_Product_OrderItem FOREIGN KEY (ProductID)
		REFERENCES ProductCatalog (ProductID)
);
GO

-- 8. Payments (depends on Orders)
CREATE TABLE Payments (
	PaymentID        INT IDENTITY(1,1) PRIMARY KEY,
	OrderID          INT NOT NULL,
	Amount           SMALLMONEY NOT NULL,
	PaymentMethod    NVARCHAR(50) NOT NULL,
	TransactionDate  DATETIME NOT NULL DEFAULT GETDATE(),
	CONSTRAINT FK_Order_Payment FOREIGN KEY (OrderID)
		REFERENCES Orders (OrderID)
);
GO

-- 9. Shippings (depends on Orders)
CREATE TABLE Shippings (
	ShippingID           INT IDENTITY(1,1) PRIMARY KEY,
	OrderID              INT NOT NULL,
	CarrierName          NVARCHAR(100),
	TrackingNumber       NVARCHAR(50),
	ShippingStatus       SMALLINT NOT NULL DEFAULT 0,
	EstimatedDeliveryDate DATETIME,
	ActualDeliveryDate   DATETIME,
	CONSTRAINT FK_Order_Shipping FOREIGN KEY (OrderID)
		REFERENCES Orders (OrderID)
);
GO
