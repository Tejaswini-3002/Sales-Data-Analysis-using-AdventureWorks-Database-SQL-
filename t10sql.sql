use AdventureWorks2022

--Display FirstName and LastName for those employee who gets more Rate than the employee whose NationalIDNumber is 456839592. 
--(use HumanResources.Employee, HumanResources.EmployeePayHistory, Person.Person) 
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory
select * from Person.Person

select p.FirstName,p.LastName 
from HumanResources.Employee e 
join HumanResources.EmployeePayHistory eph
	on e.BusinessEntityID=eph.BusinessEntityID
join Person.Person p
	on e.BusinessEntityID=p.BusinessEntityID
where eph.Rate> (
				select eph2.Rate from HumanResources.Employee e2
				join HumanResources.EmployeePayHistory eph2
				on e2.BusinessEntityID=eph2.BusinessEntityID
				where e2.NationalIDNumber='456839592'
				)

--Display first_name and last_name, Rate, department_id, job_title for those employees who works in the same job_title as the 
--employee works whose NationalIDNumber is 295847284. 
--(use HumanResources.Employee, HumanResources.EmployeePayHistory, Person.Person, HumanResources.EmployeeDepartmentHistory)
select * from HumanResources.Employee
select * from HumanResources.EmployeePayHistory
select * from Person.Person
select * from HumanResources.EmployeeDepartmentHistory
select p.FirstName,p.LastName,eph.Rate,edh.DepartmentID,e.JobTitle 
from HumanResources.Employee e
join HumanResources.EmployeePayHistory eph
	on e.BusinessEntityID=eph.BusinessEntityID
join Person.Person p
	on e.BusinessEntityID=p.BusinessEntityID
join HumanResources.EmployeeDepartmentHistory edh
	on e.BusinessEntityID=edh.BusinessEntityID
where e.JobTitle=
				( select e2.JobTitle from HumanResources.Employee e2
				 where e2.NationalIDNumber='295847284'
				 ) 

--Display the first_name and last_name, HireDate, department_name for those employee whos Rate which is the smallest Rate of 
--any of the departments.(use HumanResources.Employee, Person.Person, HumanResources.EmployeePayHistory, 
--HumanResources.EmployeeDepartmentHistory, HumanResources.Department)
    select * from HumanResources.Employee
    select * from Person.Person
    select * from HumanResources.EmployeePayHistory
    select * from HumanResources.EmployeeDepartmentHistory
    select * from HumanResources.Department
SELECT
    p.FirstName,
    p.LastName,
    e.HireDate,
    d.Name AS DepartmentName
FROM HumanResources.Employee e
JOIN Person.Person p
    ON e.BusinessEntityID = p.BusinessEntityID
JOIN HumanResources.EmployeePayHistory eph
    ON e.BusinessEntityID = eph.BusinessEntityID
JOIN HumanResources.EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
  AND eph.Rate =
    (
        SELECT MIN(eph2.Rate)
        FROM HumanResources.EmployeePayHistory eph2
        JOIN HumanResources.EmployeeDepartmentHistory edh2
            ON eph2.BusinessEntityID = edh2.BusinessEntityID
        WHERE edh2.DepartmentID = edh.DepartmentID
        AND edh2.EndDate IS NULL
    )

--Display all the information of the employee whose RateChangeDate is within the range of year 2009 and 2012. 
--(use HumanResources.Employee, HumanResources.EmployeePayHistory)
    select * from HumanResources.Employee
    select * from HumanResources.EmployeePayHistory
select * from HumanResources.Employee e
join HumanResources.EmployeePayHistory eph
on e.BusinessEntityID=eph.BusinessEntityID
where year(eph.RateChangeDate) between 2009 and 2012

--Display all the information of the employees whose Rate if within the range of smallest Rate and 10. 
--(use HumanResources.Employee, HumanResources.EmployeePayHistory) 
    select * from HumanResources.Employee
    select * from HumanResources.EmployeePayHistory
select * from HumanResources.Employee e
join HumanResources.EmployeePayHistory eph
on e.BusinessEntityID=eph.BusinessEntityID
where eph.Rate between(
                        select min(Rate) from HumanResources.EmployeePayHistory)
                        and 10
 
--Display all the information of the employees who does not work in those departments where some employees work whose ShiftID 
--is 2. (use HumanResources.Employee, HumanResources.EmployeeDepartmentHistory, HumanResources.Department) 
    select * from HumanResources.Employee
    select * from HumanResources.EmployeeDepartmentHistory
    select * from HumanResources.Department
select distinct e.* from HumanResources.Employee e
join HumanResources.EmployeeDepartmentHistory edh
    on e.BusinessEntityID=edh.BusinessEntityID
    where edh.DepartmentID not in(
        select DepartmentID from HumanResources.EmployeeDepartmentHistory
        where ShiftID=2
    )

--Display the department ID, full name (first and last name), Rate for those employees who is highest rate drawar in a department.
--(use HumanResources.Employee, Person.Person, HumanResources.EmployeeDepartmentHistory, HumanResources.EmployeePayHistory)
    select * from HumanResources.Employee    
    select * from Person.Person
    select * from HumanResources.EmployeeDepartmentHistory
    select * from HumanResources.EmployeePayHistory
SELECT
    edh.DepartmentID,
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    eph.Rate
FROM HumanResources.EmployeeDepartmentHistory edh
JOIN HumanResources.EmployeePayHistory eph
    ON edh.BusinessEntityID = eph.BusinessEntityID
JOIN Person.Person p
    ON edh.BusinessEntityID = p.BusinessEntityID
WHERE eph.Rate = (
    SELECT MAX(eph2.Rate)
    FROM HumanResources.EmployeeDepartmentHistory edh2
    JOIN HumanResources.EmployeePayHistory eph2
        ON edh2.BusinessEntityID = eph2.BusinessEntityID
    WHERE edh2.DepartmentID = edh.DepartmentID
)
ORDER BY edh.DepartmentID

--Display the detail information of those departments which starting rate is at least 20 in HumanResources.EmployeePayHistory.
--(use HumanResources.Department, HumanResources.EmployeeDepartmentHistory, HumanResources.EmployeePayHistory) 
select * from HumanResources.Department
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.EmployeePayHistory

select distinct d.* 
from HumanResources.Department d
join HumanResources.EmployeeDepartmentHistory edh
    on d.DepartmentID=edh.DepartmentID
join HumanResources.EmployeePayHistory eph
    on edh.BusinessEntityID=eph.BusinessEntityID
join (
        select BusinessEntityID,min(RateChangeDate) as StartDate
        from HumanResources.EmployeePayHistory
        group by BusinessEntityID
    ) x
on eph.BusinessEntityID=x.BusinessEntityID
and eph.RateChangeDate=x.StartDate
where eph.Rate>=20 


--Display the details of those departments which max rate is 30 or above for those employees who already done one or more jobs.
--(use HumanResources.Department, HumanResources.Employee, HumanResources.EmployeeDepartmentHistory, HumanResources.JobCandidate, 
--HumanResources.EmployeePayHistory)
select * from HumanResources.Department
select * from HumanResources.Employee
select * from HumanResources.EmployeeDepartmentHistory
select * from HumanResources.JobCandidate
select * from HumanResources.EmployeePayHistory

select distinct d.* from HumanResources.Department d
join HumanResources.EmployeeDepartmentHistory edh
    on d.DepartmentID=edh.DepartmentID
join HumanResources.EmployeePayHistory eph
    on edh.BusinessEntityID=eph.BusinessEntityID
where eph.Rate >=30
and edh.BusinessEntityID in(
    select BusinessEntityID from HumanResources.EmployeePayHistory
    group by BusinessEntityID having count(*)>1)

--Display counts the number of salesmen with their order date and ID registering orders for each day.
--(use Sales.SalesOrderHeader) 
select * from Sales.SalesOrderHeader
    
Select
    CONVERT(date, OrderDate) AS OrderDate,
    SalesPersonID,
    COUNT(SalesOrderID) AS OrderCount
from Sales.SalesOrderHeader
where SalesPersonID IS NOT NULL
group by
    CONVERT(date, OrderDate),
    SalesPersonID

--Create a view (VW_NewYorkSales) for all salesmen with columns full_name, bonus and TerritoryName.
--(use Sales.SalesPerson, Person.Person, Sales.SalesTerritory) 
    select * from Person.Person
    select * from Sales.SalesPerson
    select * from Sales.SalesTerritory)
create view VW_NewYorkSales
as
select concat(p.FirstName,' ',p.LastName) as FullName,
sp.Bonus,st.Name as TerritoryName
from Sales.SalesPerson sp
join Person.Person p
    on sp.BusinessEntityID=p.BusinessEntityID
join Sales.SalesTerritory st
    on sp.TerritoryID=st.TerritoryID
where st.Name='NewYork'
select * from VW_NewYorkSales

--Find the salesmen of the TerritoryName ‘Northwest’ who achieved the bonus more than 3500. (use VW_NewYorkSales) 
select * from VW_NewYorkSales where TerritoryName='NorthWest' and Bonus>3500

--Create a view (VW_BonusCount) to getting a count of how many SalesPerson we have at each level of a bonus. (use Sales.SalesPerson) 
    select * from Sales.SalesPerson
create view VW_BonusCount
as
select Bonus,count(*) as SalesPersonCount
    from Sales.SalesPerson group by Bonus
select * from VW_BonusCount

--Create a view (VW_TotalForDay) to keeping track the number of sales ordering number of salesmen attached, average amount of orders 
--and the total amount of orders in a day. (use Sales.SalesOrderHeader) 
create view VW_TotalForDay
as
select format(OrderDate,'yyyy-mm-dd') as OrderDate,
    count(SalesOrderID) as NumberOfOrders,
    count(distinct SalesPersonID) as NumberOfSalesmen,
    avg(TotalDue) as AverageOrderAmount,
    sum(TotalDue) as TotalOrderAmount
    from Sales.SalesOrderHeader 
    group by format(OrderDate,'yyyy-mm-dd')

select * from VW_TotalForDay order by OrderDate

--Create a view (VW_HighFreight) that shows all of the customers who have the highest Freight. 
--(use Sales.Customer, Sales.SalesOrderHeader) 
    select * from Sales.Customer
    select * from Sales.SalesOrderHeader
create view VW_HighFreight 
as
select distinct c.CustomerID,soh.salesOrderID,soh.Freight from Sales.Customer c
join Sales.SalesOrderHeader soh
    on c.CustomerID=soh.CustomerID
    where soh.Freight=(
                        select max(Freight) from Sales.SalesOrderHeader)
select * from VW_HighFreight

--Create a view (VW_TerritoryNum) that shows the number of the salesman in each Territory.
--(use Sales.SalesPerson, Sales.SalesTerritory) 
    select * from Sales.SalesPerson
    select * from Sales.SalesTerritory
create view VW_TerritoryNum 
as
select st.TerritoryID,st.Name as TerritoryName,count(sp.BusinessEntityID) as NumberOfSalesmen
from Sales.SalesTerritory st
left join Sales.SalesPerson sp
    ON  st.TerritoryID=sp.TerritoryID
    group by st.TerritoryID,st.Name
select * from VW_TerritoryNum

--Create a view (VW_TaxAmount) that shows the SalesPerson_full_name, average and total TaxAmt for each salesman. 
--(use Person.Person, Sales.SalesPerson, Sales.SalesOrderHeader)
create view VW_TaxAmount 
as
select concat(p.FirstName,' ',p.LastName) as SalesPerson_Full_Name,
    avg(soh.TaxAmt) as AvgTaxAmount,
    sum(soh.TaxAmt) as TotalTaxAmount
    from Sales.SalesPerson sp
    join Person.Person p
        on sp.BusinessEntityID=p.BusinessEntityID
    join Sales.SalesOrderHeader soh
        on sp.BusinessEntityID=soh.SalesPersonID
    group by p.FirstName,p.LastName
select * from VW_TaxAmount

--Create a view (VW_CityMatch) that shows all matches of customers with salesman such that at least one customer in the Territory of customer served by a salesman in the Territory of the salesman. 
--(use Sales.SalesPerson, Sales.Customer, Sales.SalesTerritory)
CREATE VIEW VW_CityMatch
AS
SELECT
    sp.BusinessEntityID AS SalesPersonID,
    c.CustomerID,
    t.TerritoryID,
    t.Name AS TerritoryName
FROM Sales.SalesPerson sp
JOIN Sales.Customer c
    ON sp.TerritoryID = c.TerritoryID
JOIN Sales.SalesTerritory t
    ON sp.TerritoryID = t.TerritoryID

select * from VW_CityMatch

--Create a view (VW_SalesOct) that finds the salesmen who issued orders on October 31st, 2011. 
--(use Sales.SalesPerson, Sales.SalesOrderHeader) 
CREATE VIEW VW_SalesOct
AS
SELECT
    sp.BusinessEntityID AS SalesPersonID,
    sp.TerritoryID
FROM Sales.SalesPerson sp
WHERE EXISTS (
    SELECT 1
    FROM Sales.SalesOrderHeader soh
    WHERE soh.SalesPersonID = sp.BusinessEntityID
      AND soh.OrderDate = '2011-10-31'
)
select * from VW_SalesOct

--Find the number of salesman currently listing for all of their customers.(use Sales.SalesOrderHeader) 
select count(distinct SalesPersonID) as NumberOfSalesmen
from Sales.SalesOrderHeader
where SalesPersonId is not null

--Which selects the highest SubTotal for each of the SalesTerritory Group of the customers. 
--(use Sales.Customer, Sales.SalesOrderHeader, Sales.SalesTerritory) 
WITH TerritoryOrders AS (
    SELECT
        st.[Group] AS TerritoryGroup,
        soh.SubTotal
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh
        ON c.CustomerID = soh.CustomerID
    JOIN Sales.SalesTerritory st
        ON c.TerritoryID = st.TerritoryID
)
SELECT
    TerritoryGroup,
    MAX(SubTotal) AS HighestSubTotal
FROM TerritoryOrders
GROUP BY TerritoryGroup

--Find the highest SalesLastYear ordered by the Each customer on a particular date with their ID, order date and highest SalesLastYear.
--(use Sales.Customer, Sales.SalesOrderHeader, Sales.SalesTerritory)
SELECT
    c.CustomerID,
    soh.OrderDate,
    MAX(st.SalesLastYear) AS HighestSalesLastYear
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesTerritory st
    ON c.TerritoryID = st.TerritoryID
WHERE soh.OrderDate = '2011-10-31'
GROUP BY
    c.CustomerID,
    soh.OrderDate
























