/*
	Online Store Database - Seed Data
	Author: Talal Altuwairiqi
	Description: Sample data for every table, inserted in an order that
	respects foreign keys. Every primary key value is provided explicitly,
	since these tables do not auto-generate their IDs.
	Run this after your tables exist and before queries.sql.
*/

USE [P5 - OnlineShop];
GO

-- 1. Product categories (CategoryID: 1-4)
INSERT INTO ProductCategory (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Books'),
(3, 'Clothing'),
(4, 'Home & Kitchen');
GO

-- 2. Customers (CustomerID: 1-5)
INSERT INTO Customers (CustomerID, Name, Email, Phone, Address, Username, Password) VALUES
(1, 'Sara Ahmed',    'sara.ahmed@email.com',    '0501234567', 'Jeddah, Saudi Arabia', 'sara_a',   'Pass@123'),
(2, 'Omar Khalid',   'omar.khalid@email.com',   '0502345678', 'Riyadh, Saudi Arabia', 'omar_k',   'Pass@123'),
(3, 'Lama Fahad',    'lama.fahad@email.com',    '0503456789', 'Dammam, Saudi Arabia', 'lama_f',   'Pass@123'),
(4, 'Yousef Nasser', 'yousef.nasser@email.com', '0504567890', 'Jeddah, Saudi Arabia', 'yousef_n', 'Pass@123'),
(5, 'Noura Saeed',   'noura.saeed@email.com',   '0505678901', 'Makkah, Saudi Arabia', 'noura_s',  'Pass@123');
GO

-- 3. Products (ProductID: 1-8)
INSERT INTO ProductCatalog (ProductID, ProductName, Description, Price, QuantityInStock, CategoryID) VALUES
(1, 'Wireless Mouse',              'Ergonomic wireless mouse with USB receiver',          45.00,  120, 1),
(2, 'Mechanical Keyboard',         'Backlit mechanical keyboard, blue switches',         180.00,   60, 1),
(3, 'Noise-Cancelling Headphones', 'Over-ear headphones with active noise cancellation', 350.00,   40, 1),
(4, 'Clean Code',                  'Book on writing maintainable software',               90.00,   75, 2),
(5, 'The Pragmatic Programmer',    'Book on software craftsmanship',                      95.00,   50, 2),
(6, 'Cotton T-Shirt',              'Plain cotton T-shirt, various sizes',                 35.00,  200, 3),
(7, 'Denim Jacket',                'Classic denim jacket',                               150.00,   45, 3),
(8, 'Stainless Steel Kettle',      '1.7L electric kettle',                                80.00,   65, 4);
GO

-- 4. Product images (primary key column is "ID", not "ImageID")
INSERT INTO ProductImages (ID, ImageURL, ProductID, ImageOrder) VALUES
(1, '/images/wireless-mouse-1.jpg',      1, 1),
(2, '/images/mechanical-keyboard-1.jpg', 2, 1),
(3, '/images/mechanical-keyboard-2.jpg', 2, 2),
(4, '/images/headphones-1.jpg',          3, 1),
(5, '/images/clean-code-cover.jpg',      4, 1),
(6, '/images/denim-jacket-1.jpg',        7, 1);
GO

-- 5. Reviews (ReviewID: 1-6)
INSERT INTO Reviews (ReviewID, ProductID, CustomerID, ReviewText, Rating, ReviewDate) VALUES
(1, 1, 1, 'Works great and the battery lasts a long time.', 4.5, '2026-07-01'),
(2, 2, 2, 'Very satisfying to type on, slightly loud.',      4.0, '2026-07-03'),
(3, 3, 3, 'Excellent noise cancellation for the price.',     5.0, '2026-07-10'),
(4, 4, 4, 'A must-read for every developer.',                5.0, '2026-07-12'),
(5, 6, 1, 'Good quality cotton, true to size.',              4.0, '2026-07-15'),
(6, 7, 5, 'Nice fit, but runs a little large.',               3.5, '2026-07-18');
GO

-- 6. Orders (OrderID: 1-5)
-- TotalAmount matches the sum of TotalItemsPrice inserted below for that order.
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status) VALUES
(1, 1, '2026-08-01', 195.00, 1),  -- Order 1: Mouse + 2x T-Shirt + Kettle
(2, 2, '2026-08-03', 180.00, 1),  -- Order 2: Keyboard
(3, 3, '2026-08-05', 350.00, 2),  -- Order 3: Headphones
(4, 4, '2026-08-07', 185.00, 0),  -- Order 4: Jacket + T-Shirt
(5, 1, '2026-08-10', 185.00, 1);  -- Order 5: Clean Code + Pragmatic Programmer
GO

-- 7. Order items (composite key: OrderID + ProductID, both already provided)
INSERT INTO OrderItems (OrderID, ProductID, Quantity, Price, TotalItemsPrice) VALUES
(1, 1, 1, 45.00,  45.00),
(1, 6, 2, 35.00,  70.00),
(1, 8, 1, 80.00,  80.00),
(2, 2, 1, 180.00, 180.00),
(3, 3, 1, 350.00, 350.00),
(4, 7, 1, 150.00, 150.00),
(4, 6, 1, 35.00,  35.00),
(5, 4, 1, 90.00,  90.00),
(5, 5, 1, 95.00,  95.00);
GO

-- 8. Payments (PaymentID: 1-5)
INSERT INTO Payments (PaymentID, OrderID, Amount, PaymentMethod, TransactionDate) VALUES
(1, 1, 195.00, 'Credit Card',       '2026-08-01'),
(2, 2, 180.00, 'Credit Card',       '2026-08-03'),
(3, 3, 350.00, 'Apple Pay',         '2026-08-05'),
(4, 4, 185.00, 'Cash on Delivery',  '2026-08-07'),
(5, 5, 185.00, 'Mada',              '2026-08-10');
GO

-- 9. Shippings (ShippingID: 1-5)
INSERT INTO Shippings (ShippingID, OrderID, CarrierName, TrackingNumber, ShippingStatus, EstimatedDeliveryDate, ActualDeliveryDate) VALUES
(1, 1, 'Aramex', 'TRK10001', 2, '2026-08-05', '2026-08-04'),
(2, 2, 'SMSA',   'TRK10002', 2, '2026-08-07', '2026-08-06'),
(3, 3, 'Aramex', 'TRK10003', 1, '2026-08-10', NULL),
(4, 4, 'DHL',    'TRK10004', 0, '2026-08-12', NULL),
(5, 5, 'SMSA',   'TRK10005', 1, '2026-08-14', NULL);
GO
