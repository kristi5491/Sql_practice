--1 Знайдіть пари Агент-Клієнт, які колись співпрацювали між собою.
SELECT DISTINCT Agents.AgtFirstName AS AgentFirstName, Agents.AgtLastName AS AgentLastName,
                Customers.CustFirstName AS CustomerFirstName, Customers.CustLastName AS CustumerLastName
FROM EntertainmentAgency.dbo.Engagements 
INNER JOIN Agents ON Engagements.AgentID = Agents.AgentID
INNER JOIN Customers ON Engagements.CustomerID = Customers.CustomerID;
--2 Знайдіть агентів, які мають більше трьох клієнтів.
SELECT AgtFirstName AS AgentFirstName, Agents.AgtLastName AS AgentLastName
FROM EntertainmentAgency.dbo.Agents
INNER JOIN Engagements ON Agents.AgentID = Engagements.AgentID
INNER JOIN Customers ON Engagements.CustomerID = Customers.CustomerID
GROUP BY Agents.AgtFirstName, Agents.AgtLastName
HAVING COUNT(DISTINCT Engagements.CustomerID) > 3;
--3 Знайдіть всіх клієнтів, які цікавляться репом (будь-якими напрямками) та виведіть їх дані для розсилки реклами. 
SELECT Customers.*
FROM Customers
INNER JOIN Musical_Preferences ON Customers.CustomerID = Musical_Preferences.CustomerID
INNER JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID
WHERE Musical_Styles.StyleName = 'Jazz'
--4 Виведіть перелік всіх заходів класичної музики, які відбулись в Сіетлі.
SELECT  DISTINCT EntStsgeName
FROM Engagements eng
INNER JOIN Entertainers ON eng.EntertainerID = Entertainers.EntertainerID
INNER JOIN Entertainer_Styles ON eng.EntertainerID = Entertainers.EntertainerID
INNER JOIN Musical_Styles ON Entertainer_Styles.StyleID = Musical_Styles.StyleID
WHERE Entertainers.EntCity = 'Seattle' AND Musical_Styles.StyleName LIKE '%Classical%'
--5 Виведіть перелік всіх заходів, в яких брала участь більша кількість жінок, ніж чоловіків.
WITH EntetainersCTE AS (
    SELECT Entertainers.EntStsgeName, Entertainers.EntertainerID,
           COUNT(DISTINCT CASE WHEN Gender = 'F' THEN Members.MemberID END) AS FemaleCount,
           COUNT(DISTINCT CASE WHEN Gender = 'M' THEN Members.MemberID END) AS MaleCount
    FROM Entertainers 
    INNER JOIN Entertainer_Members ON Entertainers.EntertainerID = Entertainer_Members.EntertainerID
    INNER JOIN Members ON Entertainer_Members.MemberID = Members.MemberID
    GROUP BY Entertainers.EntertainerID, Entertainers.EntStsgeName
)
SELECT EntStsgeName
FROM EntetainersCTE
WHERE FemaleCount > MaleCount;
--Бажано окремо прораховувати кількість чоловіків і жінок і тоді лише порібвнювати
--6.Хто з клієнтів найбільше платить свому агенту?
SELECT TOP(1) ContractPrice, CustFirstName, CustLastName
FROM Engagements
INNER JOIN  Customers ON Engagements.CustomerID = Customers.CustomerID
INNER JOIN Agents ON Engagements.AgentID = Agents.AgentID
ORDER BY ContractPrice DESC
--7 Знайдіть віх клієнтів, які живуть в Bellevue і люблять класичну музику.
SELECT CustFirstName, CustLastName , CustCity
FROM Customers
INNER JOIN Musical_Preferences On Customers.CustomerID = Musical_Preferences.CustomerID
INNER JOIN Musical_Styles ON Musical_Preferences.StyleID = Musical_Styles.StyleID
WHERE Musical_Styles.StyleName = 'Classical' AND Customers.CustCity = 'Bellevue'
--8 В якому штаті відбулось найбільше концертів в третьому кварталі 1999 року?
SELECT TOP(1) Agents.AgttState
FROM Engagements 
INNER JOIN Agents ON Engagements.AgentID = Agents.AgentID
WHERE Engagements.StartDate >= '1999-06-01' AND Engagements.EndDate <= '1999-08-31'
GROUP BY Agents.AgttState
ORDER BY COUNT(Engagements.EngagementNumber) DESC
--9.Який з агентів отримав найбільші прибутки за 1999 рік?
SELECT TOP(1) Agents.AgentID,Agents.AgtFirstName, Agents.AgtLastName
FROM Engagements
INNER JOIN  Agents ON Engagements.AgentID = Agents.AgentID
WHERE Engagements.StartDate >= '1999-01-01' AND Engagements.EndDate <= '1999-12-31'
GROUP BY Agents.AgentID, Agents.AgtFirstName, Agents.AgtLastName
ORDER BY COUNT(Engagements.ContractPrice) DESC
