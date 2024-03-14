USE Sample
GO
--1 Створіть представлення, яке містить дані всіх співробітників, які працюють у відділі d1.
-- CREATE VIEW employees_d1 AS
-- SELECT *
-- FROM dbo.employee
-- WHERE dept_no = 'd1';

SELECT * FROM  employees_d1;
--2 Для таблиці project створіть представлення, яке може використовуватись тими співробітниками, яким дозволено переглядати дані з цієї таблиці за винятком стовпця budget.
-- CREATE VIEW access_employees AS
-- SELECT project_no, project_name
-- FROM project

SELECT * FROM access_employees;
--3 Створіть представлення, яке містить імена та прізвища всіх співробітників, які почали працювати над проектами в другій половині 2007 року.
-- CREATE VIEW work_on_2_part_2007 AS
-- SELECT emp_fname, emp_lname
-- FROM dbo.employee
-- INNER JOIN dbo.works_on on dbo.employee.emp_no = dbo.works_on.emp_no
-- WHERE works_on.enter_date >= '2007-06-01' AND works_on.enter_date <= '2007-12-31'

-- SELECT *  FROM work_on_2_part_2007;

--4 Змінити результат завдання 3 так, щоб оригінальні стовпці f_name та l_name отримали в представленні нові імена: first та last відповідно.
-- SELECT  emp_fname AS first,emp_lname AS last
-- FROM work_on_2_part_2007;
-- SELECT *  FROM work_on_2_part_2007;
--5 Використовуючи представлення з вправи 1, відобразіть всі дані кожного співробітника, чиє прізвище починається з літери М.
SELECT *
FROM employees_d1
WHERE emp_lname LIKE 'M%'
--6 Створіть представлення, яке містить повні дані по всіх проектах, над якими працює Smith.
-- CREATE VIEW works_on_Smith AS
-- SELECT project_no
-- FROM  dbo.employee
-- INNER JOIN dbo.works_on ON dbo.employee.emp_no = dbo.works_on.emp_no
-- WHERE employee.emp_lname = 'Smith'

SELECT *  FROM works_on_Smith
--7 Використовуючи оператор ALTER VIEW, змініть умову в представленні з вправи 1. Модифіковане представлення  повинно містити дані про всіх співробітників, які працюють або у відділі d1, або у відділі d2, або в обох.
-- ALTER VIEW employees_d1 AS
-- SELECT *
-- FROM employee
-- WHERE employee.dept_no = 'd1' OR employee.dept_no = 'd2' OR (employee.dept_no = 'd1' AND employee.dept_no = 'd2');
 
 SELECT * FROM employees_d1

 --8 Знищіть представлення, створене у вправі 3. Що відбудеться із представленням, створеним у вправі 4?
-- DROP VIEW work_on_2_part_2007;
-- представлення з вправи 4 буде втрачено 

--9 Використовуючи представлення із вправи 2, додайте дані про новий проект з номером проекту p2 та назвою Moon. 
SELECT * FROM access_employees
UNION ALL
SELECT 'p2' as project_no, 'Moon' as project_name

--10 Створіть представлення (з опцією WITH CHECK OPTION), яке містить імена та прізвища всіх співробітників, у яких номер співробітника менше, ніж 10000. Після цього використати це представлення для  додавання даних про нового співробітника з прізвищем Kohn та номером 22123, який працює у відділі d3.
-- CREATE VIEW employee_less_then_1000 AS
-- SELECT *
-- FROM employee
-- WHERE emp_no < 1000
-- WITH CHECK OPTION;

SELECT * FROM employee_less_then_1000
UNION ALL
SELECT '22123' as emp_no, NUll AS emp_fname, NULL as emp_lname, 'd3' as dept_no
--11Використайте представлення з вправи 10 без опції WITH CHECK OPTION та знайдіть відмінність у додаванні даних.
--Без опції WITH CHECK OPTION система не буде перевіряти умову (номер співробітника менше 10000) під час вставки нового запису
--Тому новий співробітник може бути доданий, навіть якщо його номер перевищує 10000.

--12Створіть представлення (з опцією WITH CHECK OPTION) з усіма подробицями з таблиці works_on для всіх всіх співробітників, які почали працювати над проектами в період з  2007 до 2008 року. Після цього змініть дату початку роботи над проектом у співробітника з номером 29346. Нова дата має бути 06/01/2006.
-- CREATE VIEW workk_on_2007_200888 AS
-- SELECT *
-- FROM works_on
-- WHERE enter_date >= '2007-01-01' AND enter_date <= '2007-12-31'
-- WITH CHECK OPTION

SELECT * FROM workk_on_2007_200888

UPDATE workk_on_2007_200888
SET enter_date = '2006-06-01'
WHERE emp_no = '29346';
--13Використайте представлення з вправи 12 без без опції WITH CHECK OPTION та знайдіть відмінність у додаванні даних.
---Без опції WITH CHECK OPTION система не буде перевіряти умову (робітники які почали роботу над проектами в період з  2007 до 2008 року) під час вставки нового запису

--TRIGGERS
--1

-- CREATE TRIGGER check_department_key 
-- ON employee
-- AFTER INSERT , UPDATE
-- AS
-- BEGIN
--     DECLARE @dep_exists INT

--     SELECT @dep_exists = COUNT(*)
--     FROM department
--     WHERE dept_no IN (SELECT dept_no FROM INSERTED);

--     IF @dep_exists = 0
--     BEGIN
--       PRINT 'Foreign key violation: Department does not exist.';
--     END
-- END;


--2 За допомогою тригерів задати цілісність посилань даних для первинного ключа таблиці project, стовпця project_no, який є зовнішнім ключем таблиці works_on.
-- CREATE TRIGGER check_project_key 
-- ON dbo.works_on
-- AFTER INSERT, UPDATE
-- AS 
-- BEGIN
--     IF EXISTS(
--         SELECT 1
--         FROM INSERTED i
--         LEFT JOIN project p ON i.project_no = p.project_no
--         WHERE p.project_no IS NULL
--     )
--     BEGIN
--         PRINT 'Foreign key violation: Project does not exist.'
--     END
-- END

--3Створити DDL тригер, який буде спрацьовувати кожен раз, коли в БД виконується інструкція DROP_TABLE або ALTER_TABLE – виводиться повідомлення, що даний тригер увімкнений, та зміна таблиць є неможливою.
-- CREATE TRIGGER ddl_drop_alter_table
-- ON dbo.Sample
-- FOR DROP_TABLE, ALTER_TABLE
-- AS
-- BEGIN
--     PRINT 'DDL Trigger Enabled: Modifying or dropping tables is not allowed.'
--       ROLLBACK
-- END;

-- --5 Створити DDL тригер, який виводить повідомлення, якщо в поточному екземплярі серверу відбувається подія CREATE_DATABASE.
-- CREATE TRIGGER ddl_trigger_create_databas
-- ON ALL SERVER
-- FOR CREATE_DATABASE
-- AS
-- BEGIN
--     PRINT 'DDL Trigger Enabled: Database creation detected.';
-- END;

--6 Створити тригер DМL, який відправляє клієнту повідомлення, якщо хтось намагається додати чи змінити дані в таблиці Customer.
-- USE AdventureWorks2012
-- GO
-- CREATE TRIGGER ddl_add_change_information
-- ON Sales.Customer
-- AFTER INSERT, UPDATE
-- AS
-- BEGIN
--     DECLARE @OperationType NVARCHAR(10)
--     IF EXISTS (SELECT 1 FROM INSERTED i)
--         SET @OperationType = 'INSERT'
--     ELSE
--         SET @OperationType = 'UPDATE'

--     PRINT 'Data' + @OperationType + 'in Customer table'
-- END;

--7 Створити тригер DМL, який відправляє вказаному користувачеві (MaryM) повідомлення на електронну пошту, якщо хтось намагається змінити дані в таблиці Customer.
-- CREATE TRIGGER ddl_send_message_MaryM
-- ON Person.Person
-- AFTER INSERT, UPDATE
-- AS
-- BEGIN
--       IF UPDATE(FirstName) OR UPDATE(MiddleName) OR UPDATE(LastName)
--         BEGIN

--         DECLARE @MaryMEmail NVARCHAR(255)
--             SELECT @MaryMEmail = EmailAddress
--             FROM Person.EmailAddress
--             WHERE BusinessEntityID = (SELECT BusinessEntityID FROM Person.Person WHERE FirstName = 'Mary' AND MiddleName = 'M.');

--         IF @MaryMEmail IS NOT NULL
--         BEGIN

--             EXEC msdb.dbo.sp_send_dbmail
--                 @recipients = 'mary6@adventure-works.com',
--                 @subject = 'Customer data has been modified',
--                 @body = 'Data in Customer table has been modified. Notifying MaryM...'
--             END;
--         END;
--     END;

--8
-- CREATE TRIGGER CheckCreditLimit
-- ON dbo.Purchasing.PurchaseOrderHeader
-- AFTER INSERT
-- AS
-- BEGIN
--     SET NOCOUNT ON;

--     DECLARE @VendorID INT;
--     DECLARE @CreditLimit MONEY;
--     DECLARE @TotalOrderAmount MONEY;

--     SELECT @VendorID = VendorID, @TotalOrderAmount = TotalDue
--     FROM inserted;

--     SELECT @CreditLimit = CreditLimit
--     FROM [Purchasing].[Vendor]
--     WHERE VendorID = @VendorID;

--     IF @TotalOrderAmount > @CreditLimit
--     BEGIN
--        PRINT ('Недостатньо кредитоспроможності для виконання замовлення.')
--         ROLLBACK; 
--     END
-- END;

--9
CREATE TRIGGER PreventOrderForDiscontinuedProducts
ON Purchasing.PurchaseOrderDetail
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductID INT;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Production.Product p ON i.ProductID = p.ProductID
        WHERE p.DiscontinuedDate IS NOT NULL
    )
    BEGIN
       PRINT ('Неможливо створити замовлення для продуктів зупиненої продажі.')
        ROLLBACK; 
    END
END;