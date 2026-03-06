create database employeeDB2
use employeeDB2

create table employee2(
	empId int identity(1,1) primary key,
	empFirstName varchar(50) not null,
	empMiddleName varchar(50) not null,
	empLastName varchar(50) not null,
	empGender varchar(50) not null,
	empDOJ date not null,
	empSalary int not null,
	department varchar(30) not null
	)

insert into employee2(empFirstName,empMiddleName,empLastName,empGender,empDOJ,empSalary,department)
	values('amit','sumit','patel','male','2019-12-24',15000,'banking'),
		('saurabh','jagdishbhai','soni','male','2015-07-14',7500,'insurance'),
		('mitesh','niranjanbhai','joshi','male','2015-09-27',45500,'banking'),
		('aakansha','bhogilal','mehta','female','2017-02-11',10500,'services'),
		('rehnuma','ibrahim','vora','female','2018-02-12',5000,'banking'),
		('parin','anilbhai','patel','male','2019-12-24',6500,'banking'),
		('kiran','vitthalbhai','prajapati','female','2019-12-24',15000,'banking'),
		('kiran','tusharkumar','shukla','male','2013-09-09',35000,'insurance'),
		('jyoti','sumit','patel','female','2013-04-05',34500,'services'),
		('sanskriti','jivanlal','joshi','female','2012-12-12',28000,'banking')
		
select * from employee2

--List name of all employee which work in ‘Insurance’  department.
select * from employee2 where department='insurance'

--List the employee whose middle name is same. 
select * from employee2 where empMiddleName in(
	select empMiddleName from employee2
	group by empMiddleName 
	having count(*)>1)

--Display the details of employee whose joining month is 9. 
select * from employee2 where empDOJ like '_____09___'
select * from employee2 where month(empDOJ)=9

--get department wise average salary from employee2 table order by salary ascending
select department , avg(empSalary) as average_salary from employee2
group by department
order by average_salary asc

--Change the department of employee ‘Jyoti’ from ‘Services’ to ‘Sales’. 
update employee2 set department='sales' where empFirstName='jyoti'

--Display department wise employee full name. 
--‘EmpFullName’ –apply suitable string function.
select department,
	concat(empFirstName,' ',empMiddleName,' ',empLastName) as empFullName 
	from employee2

--Add new column EmpEmail in employee table. (with suitable constraints). 
alter table employee2
add empEmail varchar(50) 

alter table employee2
add constraint chk_email check(empEmail like '%_@_%._%')

--Update the EmpEmail data. (dummy data) which department is ‘Banking’. 
update employee2
set empEmail=concat(empFirstName,'@gmail.com')
where department='banking'