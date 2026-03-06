use EmployeeDB

--Create a simple static store procedure like a dbo.sp_IdArrangeOnEmployee.
--(Using Employee table in EmployeeDB database )
create procedure dbo.sp_IdArrangeOnEmployee
as
begin
	select * from employee
	order by empsalary
end
exec dbo.sp_IdArrangeOnEmployee

--Create a store procedure dbo.sp_PaggingOnEmployee with 2 paremeter (starting number and ending number) 
--(Using Employee table in EmployeeDB database ) like exec dbo.sp_PaggingOnEmployee 1,15
create procedure dbo.sp_PaggingOnEmployee
@starting_number int,
@ending_number int
as
begin
	select * from(
				select *,ROW_NUMBER() over(order by empid)as RowNum from employee)
				as e 
				where RowNum between @starting_number and @ending_number
end
exec dbo.sp_PaggingOnEmployee 1,15

create table Product(
	ProductID int identity(1,1) primary key,
	ProductName varchar(50),
	ProductUnitPrice int,
	ProductQtyAvl int)
	
insert into Product(ProductName,ProductUnitPrice,ProductQtyAvl)
	values('Laptop',25000,80),
		('TV',45000,45),
		('AC',35000,70)

create table ProductSales(
	ProductSalesID int identity(1,1) primary key,
	ProductID int,
	QtySold int,
	constraint fk_ProductSales_Product
	foreign key(ProductID)
	references Product(ProductID) )

insert into ProductSales(ProductID,QtySold)
	values(1,10),
		(2,5),
		(1,2)
	
select * from ProductSales
select * from Product

--Create a store procedure dbo.sp_ProductSelling with 2 parameter (ProductID and ProductQty). 
--sp_ProductSelling through insert new record in ProductSales and update its qty in Product table.
--like exec dbo.sp_ProductSelling 1,30
create procedure dbo.sp_ProductSelling1
@ProductID int,
@ProductQty int
as
begin
	insert into ProductSales(ProductID,QtySold)
		values(@ProductID,@ProductQty)
	update Product 
	set ProductQtyAvl=ProductQtyAvl-@ProductQty
	where ProductID=@ProductID
end
exec dbo.sp_ProductSelling1 1,30

select * from ProductSales
select * from Product

--Create procedure (sp_dynUpdateTbl) with 3 parameter (@ID, @Col, @ColData)
--in this perform updation query on employee table. Update only those data where the id is 
--applying by @ID and column, data is @Col, @ColData parameter. 
create procedure sp_dynUpdateTbl
@ID int,
@Col varchar(50),
@ColData varchar(200)
as
begin
	if @col='empname'
		update employee set empname=@ColData where empid=@ID
	else if @Col='empsalary'
		update employee set empsalary=@ColData where empid=@ID
end
exec sp_dynUpdateTbl 3,'empname','Rohith'
exec sp_dynUpdateTbl 2,'empsalary','75000'
	select * from employee

--Create a stored procedure that shows the products for a given Product name . 
--If the Product name is not in table then valid a message should be returned 'you must enter a valid Product.
create procedure dbo.GetProductByName
@ProductName varchar(50)
as
begin
	if exists(select 1 from Product where ProductName=@ProductName)
	begin
	 select * from Product where ProductName=@ProductName
	end
	else
	begin
		print 'You must enter a valid product'
	end
end
exec dbo.GetProductByName 'Laptop'
exec dbo.GetProductByName 'AC'
exec dbo.GetProductByName 'weijwiaf'

--Create a Stored procedure that has a while loop inside. The number of times the while
--loop will execute has to be given in a parameter. 
create procedure dbo.sp_WhileLoopDemo
@LoopCount int
as
begin
	declare @i int=1
	while @i<=@LoopCount
	begin
	 print @i
	 set @i=@i+1
	end
end
exec dbo.sp_WhileLoopDemo 11

--Create a procedure that inserts a new employee into the table with the following data:First name, last name, date of birth, 
--phone number. The procedure must use the current date for the employees hired date. The Employee should only be added if the 
--employee is not yet contained in the table. (Use Employee in EmployeeDB)
	select * from employee
create procedure dbo.sp_InsertEmployee
@FirstName varchar(50),
@lastName varchar(50),
@empDOB date,
@empGender varchar(6),
@empemail varchar(50),
@empsalary int,
@companyid int,
@cityid int,
@empContactNo varchar(15)
as
begin
	declare @fullname varchar(60)
	set @fullname=concat(@FirstName,' ',@LastName)
   if not exists(
	select 1 from employee
	where empname=@fullName
	and empDOB=@empDOB
	and empContactNo =@empContactNo
	)begin
		insert into employee(empname,empDOB,empgender,empDOJ,empemail,empsalary,companyid,cityid,empContactNo)
			values(@fullname,@empDOB,@empGender,getdate(),@empemail,@empsalary,@companyid,@cityid,@empContactNo)
		print 'Employee inserted successfully'
	end
	else
	begin
	 print 'employee already exists'
	end
end
exec dbo.sp_InsertEmployee 'Anil','Kumar','1995-06-12','M','anil@gmail.com',80000,1,1,'9876543210'
select * from employee

--Create a procedure that will delete an employee and reassign all their orders to another
--employee. The Procedure must expect the first name, last name of the two employees. 
--(Use Employee in EmployeeDB)
create procedure dbo.sp_deleteemployee
@empname varchar(50)
as 
begin
	if exists (select 1 from Employee where empname = @empname)
	begin 
		delete from Employee where empname = @empname
	end
	else
	begin
		print 'Employee not found'
	end
end
	exec dbo.sp_deleteemployee 'Rahul'