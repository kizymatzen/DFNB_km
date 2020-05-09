--Q1: By Order Quantity, what were the five most popular products sold in 2014?
--Include these data points in the output:
--Order Date Year
--Product ID
--Product Name
--Product Number
--Product Color
--Sales Order Count
--Order Quantity 
--Sales Order Line total

SELECT TOP 5 soh.OrderDate AS 'Order Date Year'
           , p.ProductID
           , p.Name AS ProductName
           , p.ProductNumber
           , p.Color AS ProductColor
           , COUNT(sod.SalesOrderID) AS 'Sales Order Count'
           , SUM(sod.OrderQty) AS 'Sales Order Count'
           , SUM(sod.LineTotal) AS 'Sales Orde Line Total SUM'
  FROM Production.Product AS p
       INNER JOIN
       Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
       INNER JOIN
       Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
 WHERE soh.OrderDate BETWEEN '01/01/2014' AND '12/31/2014'
 GROUP BY soh.OrderDate
        , p.ProductID
        , p.Name
        , p.ProductNumber
        , p.Color
 ORDER BY 7 DESC;

--Q2: How long are the 7 longest Person names and to whom do they belong? Rank by Full Name length, Last Name Length, First Name Length
--Include these data points in the output:
--Business Entity ID
--Full Name
--Full Name Length
--First Name
--First Name Length
--Middle Name
--Last Name
--Last Name Length

SELECT TOP 7 BusinessEntityID
           , CONCAT(FirstName, '', LastName) AS 'Full Name'
           , LEN(CONCAT(FirstName, '', LastName)) AS 'Full Name Length'
           , FirstName
           , LEN(FirstName) AS 'First Name Length'
           , MiddleName
           , LastName
           , LEN(LastName) AS 'Last Name Length'
  FROM Person.Person
 ORDER BY LEN(CONCAT(FirstName, '', LastName)) DESC;

 --Q3: Which Department pays its female workers on average the most per year?
--Include these fields:
--Department ID
--Department Name
--Gender
--Total Yearly Pay
--Business Entity ID Count
--Average Yearly Pay

WITH s1
     AS (SELECT d.DepartmentID
              , d.Name AS DepartmentName
              , e.Gender
              , eph.rate
              , eph.PayFrequency
              , e.SalariedFlag
              , CASE
                    WHEN e.SalariedFlag = 1
                    THEN rate * 1000
                    WHEN e.SalariedFlag = 0
                    THEN rate * 2080
                    ELSE 0
                END AS 'Yearly Pay'
              , COUNT(e.BusinessEntityID) AS 'Business Entity ID Count'
              , CASE
                    WHEN e.SalariedFlag = 1
                    THEN rate * 1000
                    WHEN e.SalariedFlag = 0
                    THEN rate * 2080
                    ELSE 0
                END * COUNT(e.BusinessEntityID) AS 'Total Yearly Pay'
           FROM HumanResources.Department AS d
                INNER JOIN
                HumanResources.EmployeeDepartmentHistory AS edh ON edh.BusinessEntityID = edh.BusinessEntityID
                INNER JOIN
                HumanResources.Employee AS e ON d.DepartmentID = edh.DepartmentID
                INNER JOIN
                HumanResources.EmployeePayHistory AS eph ON e.BusinessEntityID = eph.BusinessEntityID
          WHERE e.Gender = 'F'
          GROUP BY d.DepartmentID
                 , d.Name
                 , e.Gender
                 , eph.Rate
                 , eph.PayFrequency
                 , e.SalariedFlag
                 , CASE
                       WHEN e.SalariedFlag = 1
                       THEN rate * 1000
                       WHEN e.SalariedFlag = 0
                       THEN rate * 2080
                       ELSE 0
                   END)
     SELECT TOP 10 s1.DepartmentID
                 , s1.DepartmentName
                 , s1.Gender
                 , SUM(s1.[Total Yearly Pay]) AS TotalYear
                 , SUM(s1.[Business Entity ID Count]) AS BusinessEntityIDCount
                 , SUM(s1.[Total Yearly Pay]) / SUM(s1.[Business Entity ID Count]) AS AvarageYearlyPay
       FROM s1
      GROUP BY s1.DepartmentID
             , s1.DepartmentName
             , s1.Gender
      ORDER BY 6 DESC;


 