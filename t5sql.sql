use AdventureWorks2022

--Add new column in ‘HumanResources.Employee’ table, column name is ‘experience_level’ char data type. 
select * from HumanResources.Employee

alter table HumanResources.Employee
add experience_level varchar(50)

--Update the ‘experience_level’ column; in which data is, employee’s experience is above 10 years so fill ‘A’, below 10 years and above 5 years
--so fill ‘B’ otherwise ‘C’. Here, employee experience related column is not existing, so calculate through its HireDate column. 
update HumanResources.Employee 
set experience_level =
case 
	when datediff(year,HireDate,getdate())>10 then 'A'
	when datediff(year,HireDate,getdate()) between 5 and 10 then 'B'
	else 'c'
end

select * from HumanResources.Employee


--Write a query in SQL to retrieve the total sales for each year. Return the year part of order date and total due amount. 
--Sort the result in ascending order on year part of order date.(Use Sales.SalesOrderHeader)  
select * from Sales.SalesOrderHeader

select year(OrderDate) as OrderYear,
	sum(TotalDue) as TotalSales
	from Sales.SalesOrderHeader 
	group by year(OrderDate)
	order by OrderYear asc

--Write a query in SQL to retrieve the RateChangeDate, full name (first name, middle name and last name) and weekly salary (40 hours in a week)
--of employees. In the output the RateChangeDate should appears in date format. Sort the output in ascending order on fullname.
--(Use HumanResources.EmployeePayHistory and Person.Person)
select * from HumanResources.EmployeePayHistory
select * from Person.Person

select day(eph.RateChangeDate) as RateChangeDate,
	concat(p.FirstName,' ',p.MiddleName,' ',p.LastName) as FullName,
	eph.rate*40 as weeklySalary
	from HumanResources.EmployeePayHistory eph
	join Person.Person p
	on eph.BusinessEntityID=p.BusinessEntityID
	order by FullName asc

--Write a query in SQL to find the sum, average, and number of order quantity for those orders whose ids are 43659 and 43664 and product id
--starting with '71'. Return SalesOrderID,ProductID, OrderQty, sum, average, and number of order quantity.
--(Use Sales.SalesOrderDetail)
select * from Sales.SalesOrderDetail

select SalesOrderID,ProductID,OrderQty,sum(OrderQty) as totalOrderQty,
avg(OrderQty) as averageOrderQty,
count(OrderQty) as NoOfOrderQty
from Sales.SalesOrderDetail
where SalesOrderID in (43659,43664) 
and ProductID like '71%'
group by SalesOrderID,ProductID,OrderQty

--Write a query in SQL to ordered the BusinessEntityID column descendingly when SalariedFlag set to 'true' and BusinessEntityID in ascending order 
--when SalariedFlag set to 'false'. Return BusinessEntityID, SalariedFlag columns. (Use HumanResources.Employee)
select * from HumanResources.Employee

select BusinessEntityID, SalariedFlag 
from HumanResources.Employee
order by SalariedFlag desc,
	case
		when SalariedFlag=1 then BusinessEntityID
	end desc,
	case
		when SalariedFlag=0 then BusinessEntityID
	end asc

--Write a query in SQL to find those persons who lives in a territory and the value of salesytd except 0. Return first name, last name,
--row number as 'Row Number', 'Rank', 'Dense Rank' and NTILE as 'Quartile', salesytd and postalcode. Order the output on postalcode column.
--(Use select * from Sales.SalesPerson and Person.Person and Person.Address)
select * from Sales.SalesPerson
select * from Person.Person
select * from Person.Address

SELECT
    p.FirstName,
    p.LastName,
    ROW_NUMBER() OVER (ORDER BY sp.SalesYTD DESC) AS Number,
    RANK() OVER (ORDER BY sp.SalesYTD DESC) AS Rankk,
    DENSE_RANK() OVER (ORDER BY sp.SalesYTD DESC) AS DenseRank,
    NTILE(4) OVER (ORDER BY sp.SalesYTD DESC) AS Quartile,
    sp.SalesYTD,
    a.PostalCode
FROM Sales.SalesPerson sp
JOIN Person.Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
JOIN Person.Address a
    ON p.BusinessEntityID = a.AddressID
WHERE sp.TerritoryID IS NOT NULL
  AND sp.SalesYTD <> 0
ORDER BY a.PostalCode
