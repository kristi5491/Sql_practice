--1 
SELECT emp_no, project_no, job, enter_date
    FROM [dbo].[works_on]
    ORDER BY enter_date DESC

--2 
SELECT COUNT(DISTINCT job) AS count, project_no
    FROM [dbo].[works_on]
    GROUP BY project_no
    ORDER BY project_no

--3 
SELECT SUM(budget) AS sum
    FROM [dbo].[project]

--4 
SELECT DISTINCT *
    FROM [dbo].[works_on]
        WHERE job LIKE 'M%'

--5 
SELECT emp_no, emp_lname
    FROM [dbo].[employee]
        WHERE dept_no NOT IN ('d2')

--6 
SELECT TOP (1) *
    FROM [dbo].[works_on]
        WHERE job LIKE 'manager'
    ORDER BY enter_date DESC
    
--7 
SELECT emp_no, project_no,
    ISNULL(job, 'Job unknown') AS job
    FROM [dbo].[works_on]
        WHERE project_no IN ('p1')
        
--8 
SELECT AVG(budget) AS average
    FROM [dbo].[project]
    WHERE budget > 100000

--9 запит
SELECT dept_no, emp_fname, emp_lname
    FROM [dbo].[employee]
    WHERE emp_no < 20000
    ORDER BY emp_lname ASC, emp_fname ASC

--10 запит
SELECT * FROM [dbo].[department]
    WHERE [location] IN ('Dallas')

--11 запит
SELECT COUNT(DISTINCT emp_no) AS emp_count, project_no
    FROM [dbo].[works_on]
    GROUP BY project_no
    HAVING COUNT(DISTINCT emp_no) < 4
    ORDER BY project_no

--12 запит
SELECT *
    FROM [dbo].[works_on]
    WHERE YEAR(enter_date) = 2007