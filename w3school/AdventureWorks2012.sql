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

