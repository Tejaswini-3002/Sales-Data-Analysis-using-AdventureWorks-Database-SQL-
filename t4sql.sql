use employeeDB3

create table department11(
	departmentID int primary key,
	departmentName varchar(10)
	)

insert into department11(departmentID,departmentName)
	values(1,'IT'),
	(2,'Comp'),
	(3,'Civil'),
	(4,'Sales'),
	(5,null)

create table employee11(
	id varchar(5),
	name varchar(20),
	dob date,
	salary int,
	city varchar(20)
	)

alter table employee11
add departmentID int

alter table employee11
add constraint fk_emp_dept
foreign key(departmentID) references department11(departmentID)

insert into employee03(id,name,dob,salary,city,departmentID)
	values('E07','mitesh','1973-11-21',12500,'jaipur',2),
		('E08','rehunma','1991-08-19',11000,'delhi',1),
		('E09','saurabh','1999-10-11',32000,'vadodara',1),
		('E10','parin','2000-03-09',38000,'gandhinagar',4),
		('E11','jyoti','2000-03-09',10000,'gandhinagar',1),
		('E12','shivali','1984-09-25',19000,'surat',2)

select * from department11
select * from employee11


--display the department name,highest salary for each of the department of the employees
select d.departmentName,max(e.salary) as highest_salary
from employee11 e
join department11 d
on e.departmentID = d.departmentID
group by departmentName

--count the employees with salary average above 'IT' department salary average
select count(*) as count_of_employees,avg(salary) from employee11
group by departmentID
having avg(salary)> (
	select avg(salary) from employee11 where departmentID=1)

--List all employees details whose birth is in the month of 'august'. (like, where dob = 'august')
select * from employee11 where datename(month,dob)='august'

--List all employees details with dob in form of ‘Friday,23 June,1995’ for all employees. 
select *, 
	datename(weekday,dob) +' ,'+
	datename(day,dob) + ' '+
	datename(month,dob)+' ,'+
	datename(year,dob) as  formattedDob
	from employee11

--List the employees details who are elder to 'Rajshree'-'rehnunma
select * from employee03 where dob < '1984-10-31'
select * from employee11 where dob < '1991-08-19'

--Create temp table #Emp same as employee table and insert record using select query.
select * into #emp from employee11 where 1=0
select * from #emp 

insert into employee11(id,name,dob,salary,city,departmentID)
	values('E13','vaishali','1985-03-23',25000,'surat',3),
		('E14','laxmi','1973-02-14',18000,'anand',3),
		('E15','shivali','1990-09-05',20000,null,5)

--Display the duplicate records in employees.
select name,count(*) from employee11
group by name
having count(*)>1

--Insert missing record in temp table #Emp using employee table.
insert into #emp
	select * from employee11
	where id not in (select id from #emp)
select * from #emp
	
--Find the name of department where more than two employees are working.
select d.departmentName,count(*) as employee_count 
from department11 d 
join employee11 e
on e.departmentID= d.departmentID
group by d.departmentName
having count(*) >2

--Find the employee details who not belong any department. 
select * from employee03 where departmentID = 5
select * from employee03 where departmentID not in(1,2,3,4)

--Display the name, salary, department name for those employees
--who earn such amount of salary which is the smallest salary of any of the departments.
select e.name,e.salary,d.departmentName 
from employee11 e 
join (
	select departmentID,min(salary)as min_salary from employee11 
	group by departmentID) m
on e.departmentID=m.departmentID
and e.salary=m.min_salary
join department d
	on e.departmentID=d.departmentID

--Write a query that contains loop that display the all alphabets. 
declare @fh int = ascii('A')--65
while @fh<=ascii('Z')--91
begin
	print(char(@fh))
	set @fh=@fh+1
end

select * from department11
select * from employee11
