use AdventureWorks2022

--Create a view called VW_Products that displays a list of the products from the Production.Product table joined to the 
--Production.ProductCostHistory table.Include columnsthat show the cost history for each product.
	select * from Production.Product
	select * from Production.ProductCostHistory
create view VW_Products as
select p.ProductID,p.Name,p.ProductNumber,pch.StartDate,pch.EndDate
from Production.Product p
join Production.ProductCostHistory pch
on p.ProductID=pch.ProductID
	select * from VW_Products

--Write a SQL query that concatenate the columns name, productnumber, colour, and a new line character from the following table, each
--separated by a specified character. (Use production.product)
	select * from Production.Product
select concat(Name,' | ',
	ProductNumber,' | ',
	isnull(color,'noColor')
		)as ProductDetails
	from Production.Product

--Write a query in SQL to return the five leftmost characters of each product name. (Use production.product)
	select * from production.product
select left(Name,5) as ProductName_5chars from Production.Product

--Write a query in SQL to remove the substring 'HN' from the start of the column productnumber. Filter the results to only show those 
--productnumbers that start with "HN". Return original productnumber column and 'TrimmedProductnumber'. (Use production.Product)
	select * from production.product
select ProductNumber,
	substring(ProductNumber,3,len(ProductNumber)) as TrimmedProductNumber
	from Production.Product
	where ProductNumber like 'HN%'

--Write a query in SQL to replace null values with 'N/A' and return the names separated by commas in a single row. (Use Person.Person)
	select * from Person.Person
select concat(
				isnull(firstname,'N/A'),' , ',
				isnull(MiddleName,'N/A'),' , ',
				isnull(LastName,'N/A')
				) from Person.Person

--Create a view called VW_CustomerTotals that displays the total sales from the TotalDuecolumn per year and month for each customer. 
--(use Sales.SalesOrderHeader tables)
	select * from Sales.SalesOrderHeader order by CustomerID
create view VW_CustomerTotals as
select CustomerID,
	MONTH(OrderDate) as OrderedMonth,
	Year(OrderDate) as OrderedYear,
	sum(TotalDue) as TotalSales
	from Sales.SalesOrderHeader
	group by CustomerID,
	MONTH(OrderDate),Year(OrderDate)
select * from VW_CustomerTotals

--Create a temp table called #CustInfo that contains CustomerID, FirstName, and LastNamecolumns. Include CountOfSales (use COUNT()) 
--andSumOfTotalDue(use SUM()) columns. Populate the table with a query using the Sales.Customer, Person.Person, and Sales.SalesOrderHeader tables.
select * from Sales.Customer
select * from Person.Person
select * from Sales.SalesOrderHeader

create table #CustInfo(
	CustomerID int,
	FirstName varchar(50),
	LastName varchar(50),
	CountOfSales int,
	SumOfTotalDue int)
insert into #CustInfo
	select c.CustomerID,p.FirstName,p.LastName,
	count(soh.SalesOrderID) as CountOfSales,
	sum(soh.TotalDue) as SumOfTotalDue
from Sales.Customer c
 left join Person.Person p
	on c.PersonID=p.BusinessEntityID
 left join Sales.SalesOrderHeader soh
	on c.CustomerID=soh.CustomerID
group by 
	c.CustomerID,p.FirstName,p.LastName
select * from #CustInfo

--Create a global table called ##Test that contains two columns (id int identity, random int).use a loop to insert the table with 1000 
--random integers data using the following formula: CAST(RAND()*1000 AS INT). display the data from global table in another tab.
create table ##Test(
	id int identity(1,1),
	random int
	)
declare @i int=1
while @i<=1000
begin
	insert into ##Test (random)
	values (cast(rand()*1000 as int))
	set @i=@i+1
end
	select * from ##Test