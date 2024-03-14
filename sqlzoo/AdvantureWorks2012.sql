--1.Show the first name and the email address of customer with CompanyName 'Bike World'
SELECT FirstName, EmailAddress
FROM SalesLT.Customer
WHERE CompanyName = 'Bike World'
--2 Show the CompanyName for all customers with an address in City 'Dallas'.
SELECT  DISTINCT  CompanyName
FROM SalesLT.Customer
INNER JOIN SalesLT.CustomerAddress ON SalesLT.Customer.CustomerID = CustomerAddress.CustomerID
INNER JOIN SalesLT.Address ON CustomerAddress.AddressID = Address.AddressID
WHERE Address.City = 'Dallas'

--3 How many items with ListPrice more than $1000 have been sold?
SELECT COUNT(s.OrderQty) as ItemsSold
FROM SalesLT.Product p
JOIN SalesLT.SalesOrderDetail s ON p.ProductID = s.ProductID
WHERE p.ListPrice > 1000

--4 Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight.
SELECT CompanyName
FROM SalesLT.Customer c
JOIN SalesLT.SalesOrderHeader s ON c.CustomerID = s.CustomerID
WHERE SubTotal + TaxAmt + Freight > 100000

--5 Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'.
SELECT COUNT(s.OrderQty) AS LeftRacingSocksNums
FROM SalesLT.Product p
JOIN SalesLT.SalesOrderDetail s ON p.ProductID = s.ProductID
JOIN SalesLT.SalesOrderHeader sh ON s.SalesOrderID = sh.SalesOrderID
JOIN SalesLT.Customer c ON sh.CustomerID = c.CustomerID
WHERE p.Name = 'Racing Socks, L' AND c.CompanyName = 'Riding Cycles'

--MEDIUM

--6 A "Single Item Order" is a customer order where only one item is ordered. 
--Show the SalesOrderID and the UnitPrice for every Single Item Order.
SELECT sl.SalesOrderID, MAX(sl.UnitPrice) as MaxUnitPrice 
FROM SalesLT.SalesOrderDetail sl
GROUP By sl.SalesOrderID
HAVING COUNT(DISTINCT SalesOrderID) = 1

--7 Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'.
SELECT c.CompanyName, p.Name AS ProductName
FROM SalesLT.Customer as c
INNER JOIN SalesLT.SalesOrderHeader sh ON c.CustomerID = sh.CustomerID
INNER JOIN SalesLT.SalesOrderDetail sod ON sh.SalesOrderID = sod.SalesOrderID
INNER JOIN SalesLT.Product p ON sod.ProductID = p.ProductID
INNER JOIN SalesLT.ProductModel spm ON p.ProductModelID = spm.ProductModelID
WHERE spm.Name = 'Racing Socks'

--8 Show the product description for culture 'fr' for product with ProductID 736.
SELECT pd.Description AS ProductDescription, pmpd.Culture, p.ProductID 
FROM SalesLT.Product p
INNER JOIN SalesLT.ProductModelProductDescription pmpd ON p.ProductModelID = pmpd.ProductModelID
INNER JOIN SalesLT.ProductDescription pd ON pmpd.ProductDescriptionID = pd.ProductDescriptionID
WHERE pmpd.Culture = 'fr' AND p.ProductID = '736'

--9.Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest.
-- For each order show the CompanyName and the SubTotal and the total weight of the order.
SELECT
    Customer.CompanyName,
    SalesOrderHeader.SubTotal,
    SUM(SalesOrderDetail.OrderQty * Product.Weight) AS TotalWeight
FROM SalesLT.SalesOrderHeader AS SalesOrderHeader
JOIN SalesLT.SalesOrderDetail AS SalesOrderDetail ON SalesOrderHeader.SalesOrderID = SalesOrderDetail.SalesOrderID
JOIN SalesLT.Product AS Product ON SalesOrderDetail.ProductID = Product.ProductID
JOIN SalesLT.Customer AS Customer ON SalesOrderHeader.CustomerID = Customer.CustomerID
GROUP BY
    SalesOrderHeader.SalesOrderID,
    Customer.CompanyName,
    SalesOrderHeader.SubTotal
ORDER BY
    SalesOrderHeader.SubTotal DESC;
--VIEW, CTE

--1 Створіть VIEW, який містить інформацію про клієнтів (CustomerID, FirstName, LastName, Email) та їхні замовлення (OrderID, OrderDate).
CREATE VIEW full_inform AS 
SELECT c.CustomerID, c.FirstName, c.LastName, c.EmailAddress
FROM SalesLT.Customer c
RIGHT JOIN SalesLT.SalesOrderDetail sod ON c.CustomerID = sod.




