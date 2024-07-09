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
--22. From the following table write a query in SQL to count the number of contacts for combination of each type and name.
--Filter the output for those who have 100 or more contacts. Return ContactTypeID and ContactTypeName and BusinessEntityContact. 
--Sort the result set in descending order on number of contacts.
SELECT  Person.BusinessEntityContact.ContactTypeID, Person.ContactType.Name ,  COUNT(*) AS nocontact
FROM Person.BusinessEntityContact
INNER JOIN Person.ContactType ON Person.BusinessEntityContact.ContactTypeID = Person.ContactType.ContactTypeID
GROUP BY  Person.BusinessEntityContact.ContactTypeID, Person.ContactType.Name
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC

--23. From the following table write a query in SQL to retrieve the RateChangeDate, full name (first name, middle name and last name)
--and weekly salary (40 hours in a week) of employees. In the output the RateChangeDate should appears in date format.
-- Sort the output in ascending order on NameInFull.
SELECT 
    CONVERT(VARCHAR, RateChangeDate, 101) AS RateChangeDate,
    CONCAT(pp.FirstName, '', pp.MiddleName, '', pp.LastName, '' ) AS NameInFull,
    (40 * ph.Rate) AS SalaryInWeek
FROM HumanResources.EmployeePayHistory ph
INNER JOIN Person.Person pp ON ph.BusinessEntityID = pp.BusinessEntityID
ORDER BY NameInFull ASC
--24. From the following tables write a query in SQL to calculate and display the latest weekly salary of each employee. Return RateChangeDate, 
--full name (first name, middle name and last name)and weekly salary (40 hours in a week) of employees 
--Sort the output in ascending order on NameInFull.

 --25 From the following table write a query in SQL to find the sum, average, count, minimum, and maximum order quentity
 --for those orders whose id are 43659 and 43664. Return SalesOrderID, ProductID, OrderQty, sum, average, count, max, and min order quantity.
SELECT Sales.SalesOrderDetail.SalesOrderID, Sales.SalesOrderDetail.ProductID,
Sales.SalesOrderDetail.OrderQty ,SUM(OrderQty) AS SumOrder ,
AVG(OrderQty) AS AvarageOrder, COUNT(OrderQty) AS CountOrdrers,
MAX(OrderQty) AS MAXOrders, MIN(OrderQty) AS MINOrders 
FROM Sales.SalesOrderDetail 
WHERE
    SalesOrderID IN ('43659', '43664')
GROUP BY
    SalesOrderID,
    ProductID,
    OrderQty;
--26. From the following table write a query in SQL to find the sum, average, and number of order quantity for those orders
--whose ids are 43659 and 43664 and product id starting with '71'.
-- Return SalesOrderID, OrderNumber,ProductID, OrderQty, sum, average, and number of order quantity.
SELECT  sd.SalesOrderID AS OrderNumber , sd.ProductID, sd.OrderQty,
SUM(OrderQty)  OVER ( ORDER BY SalesOrderID, ProductID  )  AS SUmOrders,
AVG(OrderQty) OVER (PARTITION BY SalesOrderID ORDER BY SalesOrderID, ProductID ) AS AvgOrders,
COUNT (OrderQty) OVER (ORDER BY SalesOrderID, ProductID ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS Count
FROM Sales.SalesOrderDetail sd
WHERE
    SalesOrderID IN  ('43659', '43664') AND ProductID LIKE '71%'
--27. From the following table write a query in SQL to retrieve the total cost of each salesorderID that exceeds 100000.
-- Return SalesOrderID, total cost.
SELECT sd.SalesOrderID , SUM(sd.UnitPrice * sd.OrderQty)  as orderidcost
FROM Sales.SalesOrderDetail sd
GROUP BY sd.SalesOrderID 
HAVING SUM(sd.UnitPrice * sd.OrderQty) >100000
--28. From the following table write a query in SQL to retrieve products whose names start with 'Lock Washer'.
-- Return product ID, and name and order the result set in ascending order on product ID column.
SELECT pp.ProductID  , pp.Name 
FROM  Production.Product pp
WHERE pp.Name LIKE 'Lock Washer%' 
ORDER BY pp.ProductID  ASC
--29. Write a query in SQL to fetch rows from product table and order the result set on an unspecified column listprice.
-- Return product ID, name, and color of the product.
SELECT pp.ProductID, pp.Name , pp.Color
FROM  Production.Product pp
ORDER BY pp.ListPrice
--30. From the following table write a query in SQL to retrieve records of employees. 
--Order the output on year (default ascending order) of hiredate. Return BusinessEntityID, JobTitle, and HireDate.
SELECT BusinessEntityID, JobTitle, HireDate
FROM HumanResources.Employee he
ORDER BY he.HireDate ASC
--31. From the following table write a query in SQL to retrieve those persons whose last name begins with letter 'R'.
-- Return lastname, and firstname and display the result in ascending order on firstname and descending order on lastname columns.
SELECT  LastName AS  lastname, FirstName AS firstname 
FROM Person.Person pp
WHERE LastName LIKE 'R%'
ORDER BY  FirstName ASC ,  LastName DESC
--32. From the following table write a query in SQL to ordered the BusinessEntityID column descendingly when SalariedFlag
-- set to 'true' and BusinessEntityID in ascending order when SalariedFlag set to 'false'.
-- Return BusinessEntityID, SalariedFlag columns.
SELECT hp.BusinessEntityID, hp.SalariedFlag 
FROM  HumanResources.Employee hp
ORDER BY
    CASE
    WHEN SalariedFlag = '1' THEN BusinessEntityID 
    END DESC,
    CASE
        WHEN  SalariedFlag = '0'  THEN BusinessEntityID 
    END ASC;
--35 From the following table write a query in SQL to skip the first 10 rows from the sorted result set and return all remaining rows.
SELECT DISTINCT *
FROM HumanResources.Department
ORDER BY DepartmentID 
OFFSET 10 ROWS
--36 From the following table write a query in SQL to skip the first 5 rows and return the next 5 rows from the sorted result set.
SELECT  *
FROM HumanResources.Department
ORDER BY DepartmentID 
OFFSET 5 ROWS
FETCH NEXT 5 ROWS ONLY
--37  From the following table write a query in SQL to list all the products that are Red or Blue in color.
-- Return name, color and listprice.Sorts this result by the column listprice.
SELECT Name, Color, ListPrice
FROM Production.Product
WHERE Color  IN ('Red','Blue')
ORDER BY ListPrice
--38 Create a SQL query from the SalesOrderDetail table to retrieve the product name and any associated sales orders.
-- Additionally, it returns any sales orders that don't have any items mentioned in the Product table as well as any products
-- that have sales orders other than those that are listed there. Return product name, salesorderid.
-- Sort the result set on product name column.
-- SELECT 
-- FROM Sales.SalesOrderDetail

--39. From the following table write a SQL query to retrieve the product name and salesorderid.
-- Both ordered and unordered products are included in the result set.
SELECT Name, SalesOrderID
FROM Production.Product 
INNER JOIN Sales.SalesOrderDetail ON Production.Product.ProductID = Sales.SalesOrderDetail.ProductID
ORDER BY Name, SalesOrderID 
--40 40. From the following tables write a SQL query to get all product names and sales order IDs.
-- Order the result set on product name column.

--62 From the following table write a query in SQL to return the five leftmost characters of each product name.
SELECT LEFT(Name, 5) AS left_elem
FROM Production.Product 

SELECT  '     five space then the text' as "Original Text",
LTRIM('     five space then the text') as "Trimmed Text(space removed)";

