use employeeDB3

--Display the data of employee with the same salary.
select * from employee03 where salary in(
	select salary from employee03 
	group by salary having count(*)>1)

--Display the 5th highest salary using aggregate or subquery.
select max(salary) as FifthHighestSalry from employee03
where salary<(select max(salary) from employee03 where salary<(
	select max(salary) from employee03 where salary<(
	select max(salary) from employee03 where salary<(
	select max(salary) from employee03 ))))

--Display all employees who work at the same department with employee id 5, not including employee id 5.
select * from employee03 
	where departmentID=(
		select departmentID from employee03 where id='E07')
			and id<>'EO5'

--The employees who earn more than the average salary in department id 2.
select * from employee03 where salary>(select avg(salary) from employee03 where departmentID=2)

--Retrieve the average summary of all departments whose average salary is greater than the average salary in department id 2.
select departmentID,avg(salary) as avgSalary from employee03
group by departmentID
having avg(salary)>
	(select avg(salary) from employee03 where departmentID=2)

--Retrieve all employees who earn more than employee id 3 and work at the same department as employee ID 1 but not including employee ID 1.
select * from employee03 where salary>(
select salary from employee03 where id='E03')
and departmentID=(select departmentID from employee03 where id='E01')
and id<>'E01'

--Display the average salary for each department from employee. without display the department id.
select avg(salary) as avgSalaryByDepartments from employee03 group by departmentID

use AdventureWorks2022
--Show odd rows from a Sales.SalesOrderDetail.
select * from(
	select *, row_number() over(order by SalesOrderID) as rn
from Sales.SalesOrderDetail) t
where rn%2=1
select * from Sales.SalesOrderDetail

--Show only even rows from a Sales.SalesOrderDetail.
select * from(
	select *, row_number() over(order by SalesOrderID) as rn
	from Sales.SalesOrderDetail) t
	where rn%2=0

--Retrieve the FullName and EmailID for each Person.Person table where FullName is not null and not including duplicate EmailID. 
--The FullName will be composed from first name ,middle name ,last name.
--The EmailID will be composed from the first letter of first name, concatenated with the three first letters of last_name, concatenated with @sql.com. (use CTE)
with cte_PersonEmail as(
	select BusinessEntityID,
	ltrim(rtrim(FirstName+' '+isnull(MiddleName+' ',' ')+LastName)) as FullName,
	lower(left(FirstName,1)+left(LastName,3)+'@sql.com') as EmailID,
	row_number() over( partition by lower(left(FirstName,1)+left(LastName,3)+'@sql.com')
	order by BusinessEntityID) as rn
	from Person.Person
	where FirstName is not null
	and LastName is not null)
select FullName,EmailID
from cte_PersonEmail where rn=1

--Display the department name and maximum rate for each department where not including department name 'Marketing','Finance','Sales'.
--use this table : 
--HumanResources.EmployeePayHistory,
--HumanResources.EmployeeDepartmentHistory,
--HumanResources.Department.
select d.Name as DepartmentName,
	max(eph.Rate) as MaxRate
from HumanResources.EmployeePayHistory eph
join HumanResources.EmployeeDepartmentHistory edh
	on eph.BusinessEntityID=edh.BusinessEntityID
join HumanResources.Department d
	on edh.DepartmentID=d.DepartmentID
where d.Name not in('Marketing','Finance','Sales')
group by d.Name

--List products name with order quantities greater than 20.
--use this table : 
--Production.Product,
--Sales.SalesOrderDetail.
select distinct p.Name as ProductName,sod.OrderQty
from Sales.SalesOrderDetail sod
join Production.Product p
	on sod.ProductID=p.ProductID
where sod.OrderQty>20