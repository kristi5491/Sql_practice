--1. Для кожного працівника виведіть суму продажів за 1-ше півріччя 1999 року.
USE SalesOrders
Go 
WITH Sales_CTE AS(
    SELECT SUM(ORDER_DETAILS.QUOTEDPRICE) AS TotalSales, EMPLOYEES.EMPLOYEEID
    FROM ORDERS
    INNER JOIN EMPLOYEES ON ORDERS.EMPLOYEEID = EMPLOYEES.EMPLOYEEID
    INNER JOIN ORDER_DETAILS ON ORDERS.ORDERNUMBER = ORDER_DETAILS.ORDERNUMBER
    WHERE ORDERS.SHIPDATE >= '1999-07-01' AND ORDERS.ORDERDATE <= '1999-12-31'
    GROUP BY EMPLOYEES.EMPLOYEEID
)
SELECT EMPLOYEES.EMPLOYEEID,EMPLOYEES.EMPFIRSTNAME,Sales_CTE.TotalSales
FROM 
    EMPLOYEES
LEFT JOIN 
    Sales_CTE ON EMPLOYEES.EMPLOYEEID = Sales_CTE.EMPLOYEEID;

--2. Створіть тимчасову таблицю, яка містить імена та прізвища всіх співробітників, у яких номер співробітника менше, ніж 10000.
--Після цього використати цю тимчасову таблицю для  додавання даних про нового співробітника з прізвищем Kohn та номером 22123,
-- який працює у відділі d3.
USE Sample
GO
WITH Semple_CTE AS (
    SELECT emp_fname, emp_lname
    FROM employee
    WHERE emp_no < 10000
)
SELECT emp_fname, emp_lname
FROM Semple_CTE
INSERT INTO employee(emp_fname,emp_lname,emp_no,dept_no)
VALUES ('len', 'Kohn', '22123', 'd3')

SELECT * FROM employee;

--3.Створити функцію, яка повертає суму всіх замовлень, зроблених в останню п’ятницю.
USE AdventureWorks2012
GO 
CREATE FUNCTION dbo.SumOrder()
RETURNS DECIMAL(18, 2)
AS
BEGIN 
    DECLARE @TotalPrice DECIMAL(18, 2);
   SELECT @TotalPrice = SUM(SalesOrderDetail.UnitPrice)
    FROM SalesOrderDetail
    WHERE DATEPART(WEEKDAY, ModifiedDate) = 6

    RETURN ISNULL(@TotalPrice, 0)
END;

SELECT dbo.SumOrder() AS TotalPrice;
--4 (Процедура) Створити процедуру, яка шукає всіх клієнтів, в яких сьогодні день народження.
USE AdventureWorks2012
GO 
CREATE PROCEDURE CustomersssBirthday
AS
BEGIN
    DECLARE @Today DATE = GETDATE()
    SELECT Person.Person.FirstName, Person.LastName , Employee.BirthDate
    FROM HumanResources.Employee
    INNER JOIN Person.Person ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
    WHERE MONTH(BirthDate) = MONTH(@Today) AND DAY(BirthDate) = DAY(@Today);
END;

EXEC CustomersssBirthday;
--1. Для кожного працівника виведіть суму продажів за 1-ше півріччя 1999 року.
USE SalesOrders
Go 
WITH Sales_CTE AS(
    SELECT SUM(ORDER_DETAILS.QUOTEDPRICE) AS TotalSales, EMPLOYEES.EMPLOYEEID
    FROM ORDERS
    INNER JOIN EMPLOYEES ON ORDERS.EMPLOYEEID = EMPLOYEES.EMPLOYEEID
    INNER JOIN ORDER_DETAILS ON ORDERS.ORDERNUMBER = ORDER_DETAILS.ORDERNUMBER
    WHERE ORDERS.SHIPDATE >= '1999-07-01' AND ORDERS.ORDERDATE <= '1999-12-31'
    GROUP BY EMPLOYEES.EMPLOYEEID
)
SELECT EMPLOYEES.EMPLOYEEID,EMPLOYEES.EMPFIRSTNAME,Sales_CTE.TotalSales
FROM 
    EMPLOYEES
LEFT JOIN 
    Sales_CTE ON EMPLOYEES.EMPLOYEEID = Sales_CTE.EMPLOYEEID;

--2. Створіть тимчасову таблицю, яка містить імена та прізвища всіх співробітників, у яких номер співробітника менше, ніж 10000.
--Після цього використати цю тимчасову таблицю для  додавання даних про нового співробітника з прізвищем Kohn та номером 22123,
-- який працює у відділі d3.
USE Sample
GO
WITH Semple_CTE AS (
    SELECT emp_fname, emp_lname
    FROM employee
    WHERE emp_no < 10000
)
SELECT emp_fname, emp_lname
FROM Semple_CTE
INSERT INTO employee(emp_fname,emp_lname,emp_no,dept_no)
VALUES ('len', 'Kohn', '22123', 'd3')

SELECT * FROM employee;

--3.Створити функцію, яка повертає суму всіх замовлень, зроблених в останню п’ятницю.
USE AdventureWorks2012
GO 
CREATE FUNCTION dbo.SumOrder()
RETURNS DECIMAL(18, 2)
AS
BEGIN 
    DECLARE @TotalPrice DECIMAL(18, 2);
   SELECT @TotalPrice = SUM(SalesOrderDetail.UnitPrice)
    FROM SalesOrderDetail
    WHERE DATEPART(WEEKDAY, ModifiedDate) = 6

    RETURN ISNULL(@TotalPrice, 0)
END;

SELECT dbo.SumOrder() AS TotalPrice;
--4 (Процедура) Створити процедуру, яка шукає всіх клієнтів, в яких сьогодні день народження.
USE AdventureWorks2012
GO 
CREATE PROCEDURE CustomersssBirthday
AS
BEGIN
    DECLARE @Today DATE = GETDATE()
    SELECT Person.Person.FirstName, Person.LastName , Employee.BirthDate
    FROM HumanResources.Employee
    INNER JOIN Person.Person ON HumanResources.Employee.BusinessEntityID = Person.Person.BusinessEntityID
    WHERE MONTH(BirthDate) = MONTH(@Today) AND DAY(BirthDate) = DAY(@Today);
END;

EXEC CustomersssBirthday;