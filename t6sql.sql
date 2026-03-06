use AdventureWorks2022

--Write a query that declares an integer variable called @Count to save the count of all the Sales.SalesOrderDetail records.
--Add an IF that prints 'Over 100000' if the value above 100000. Otherwise, print '100000 or less.'
select * from Sales.SalesOrderDetail

declare @count int
select @count=count(*) from Sales.SalesOrderDetail
if @count>100000
	print 'over 100000'
else
	print '100000 or less'

--Rewrite this query using a CTE.
select FirstName, LastName, e.JobTitle, HireDate, CountOfTitle
from HumanResources.Employee as e
join Person.Person as p one.BusinessEntityID = p.BusinessEntityID
join (
select count(*) asCountOfTitle, JobTitle
from HumanResources.Employee
group byJobTitle
) as j
On e.JobTitle = j.JobTitle   
	  select * from HumanResources.Employee
	  select * from Person.Person
with JobTitleCount as(
select JobTitle,count(*) as CountOfTitle from HumanResources.Employee
group by JobTitle)
select p.FirstName, p.LastName, e.JobTitle, e.HireDate,CountOfTitle
from HumanResources.Employee as e
join Person.Person p
on e.BusinessEntityID=p.BusinessEntityID
join JobTitleCount jtc
on e.JobTitle=jtc.JobTitle


--Write a query that group the products by ProductModelID along with a count. Display the rows that have a count that more than 1.
	select * from Production.Product
select ProductModelID,count(*)as ProductCount from Production.Product group by ProductModelID having count(*)>1

--Write a query in SQL to skip the first 5 rows and return the next 5 rows from the sorted result set (Use HumanResources.Department)
	select * from HumanResources.Department
order by DepartmentID
offset 5 rows 
fetch next 5 rows only

--Create a SQL query from the SalesOrderDetail table to retrieve the product name and any associated sales orders. Additionally, 
--it returns any sales orders that don't have any items mentioned in the Product table as well as any products that have sales orders other than 
--those that are listed there. Return product name, salesorderid. Sort the result set on product name column.
--(Use  Production.Product and Sales.SalesOrderDetail)
select * from Sales.SalesOrderDetail
select * from Production.Product

select p.Name as ProductName,sod.SalesOrderID as SalesOrderID
from Sales.SalesOrderDetail sod
full outer join Production.Product p
on sod.ProductID=p.ProductID
order by p.Name

--Write a SQL query to retrieve the product name and salesorderid. Both ordered and unordered products are included in the result set.
--(Use Production.Product and Sales.SalesOrderDetail)
	select * from Production.Product
	select * from Sales.SalesOrderDetail
select p.Name as ProductName,sod.SalesOrderID as SalesOrderID
from Production.Product p
full outer join Sales.SalesOrderDetail sod
on p.ProductID=sod.ProductID

--Write a SQL query to retrieve the territory name and BusinessEntityID. The result set includes all salespeople, regardless of whether 
--or not they are assigned a territory. (Use Sales.SalesTerritory and Sales.SalesPerson)
	select * from Sales.SalesTerritory 
	select * from Sales.SalesPerson
select st.Name as TerritoryName,sp.BusinessEntityID 
from Sales.SalesPerson sp 
left join Sales.SalesTerritory st
on sp.TerritoryID=st.TerritoryID

--Write a SQL query to locate the position of the string "yellow" where it appears in the product name. (Use  production.product)
	select * from Production.Product
select Name as ProductName, charindex('yellow',name) as positionOfYellow from Production.Product