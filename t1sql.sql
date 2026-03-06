create database EmployeeDB

use EmployeeDB
create table state(
	stateid int identity(1,1),
	statename varchar(50)
)

insert into state(statename)
	values('gujarat'),
		   ('rajasthan'),
		   ('uttar pradesh')

create table city(
	cityid int identity(1,1),
	cityname varchar(50),
	stateid int
)

insert into city(cityname,stateid)
	values('rajkot',1),
		  ('gandhinagar',1),
		  ('jaipur',2),
		  ('udaipur',2),
		  ('lucknow',3),
		  ('kanpur',3),
		  ('varanasi',3)

create table company(
	companyid int identity(1,1),
	companyname varchar(50),
	cityid int
)

insert into company(companyname,cityid)
	values('R K Infotech',1),
		('Brevity Software',1),
		('Evision IT Solutions',2),
		('Hope IT Hub',2),
		('Octal IT Solutions',3),
		('Kansoft Solutions',4),
		('Vexil Infotech',5),
		('BillionByte IT Solutions',6),
		('Panacia Software',6),
		('Oceonic IT Solutions',7),
		('MRS Technology',7),
		('IPX Technology',7)

create table employee(
	empid int identity(1,1),
	empname varchar(50),
	empDOB date,
	empgender varchar(6),
	empDOJ date,
	empemail varchar(50),
	empsalary int,
	companyid int,
	cityid int
)

insert into employee(empname,empDOB,empgender,empDOJ,empemail,empsalary,companyid,cityid)
	values('AnilKumar','1967-05-09','M','2005-10-25','anil@gmail.com',50000,1,1),
		('Deepika','2001-03-20','F','2020-05-26','deepika@gmail.com',20000,4,2),
		('Rahul','1999-04-23','M','2019-08-12','rahul@gmail.com',30000,5,3),
		('Harsha','2000-12-03','F','2021-01-18','harsha@gmail.com',15000,2,1),
		('Hitesh','1992-02-19','M','2010-09-16','hitesh@gmail.com',37000,7,5),
		('Rajvi','1995-08-14','F','2015-07-11','rajvi@gmail.com',25000,11,7),
		('kunal','1998-03-29','M','2020-11-14','kunal@gmail.com',18000,1,1)

select * from state
select * from city
select * from company
select * from employee

--get all employee details
select * from employee

--display the details of the employee its name starts with 'r'
select * from employee where empname like 'r%'

--display oldest employee details
select * from employee where empDOB = (select min(empDOB) from employee)

--display the details of female employee who are born on 1995
select * from employee where empgender='F' and empDOB like '1995%'

--display the details of employee(both male and female) having maximum salary
select empgender,max(empsalary) from employee group by empgender

SELECT *
FROM employee e1
WHERE empsalary = (SELECT MAX(empsalary) FROM employee e2 WHERE e1.empgender = e2.empgender);

--display all records but replace domain name(not change actual data)
--like ami@gmail.com to ami@ymail.com
select *, replace(empemail,'@gmail.com','@ymail.com') as updated_email from employee

--Get only second highest salary (without use CTE). 
select max(empsalary) from employee where empsalary <
	(select max(empsalary) as second_highest_salary from employee)

--Display the employee age (like 25 year old ).
--incorrect--select *, datediff(year,empDOB,getdate()) as emp_age from employee 
--other method--
--select *, CONCAT(YEAR(getdate()) - YEAR(EmpDOB), ' years old') AS EmpAge
--FROM Employee;--incorrect
select * from employee where datediff(year,empDOB,getdate())=25 

--select *, 
--CONCAT(25, 'years old') as age
--from employee
--where datediff(year,empDOB,getdate())=25

--update the employee name first letter capital
select *, 
upper(left(empname,1)) + lower(substring(empname,2,len(empname))) as proper_name
from employee

--display the count of employees by gender
select empgender,count(*) as count_of_employees
from employee
group by empgender

--add column employee ContactNo and apply check constraints for contact number
alter table employee
add empContactNo varchar(15)

alter table employee
add constraint chk_empContactNo
check(empContactNo like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')

update employee set empContactNo='5467889076' where empid=1
update employee set empContactNo='967889076' where empid=1

select * from employee

--Display name, salary, dob, doj of employee with its CompanyName, 
-- CityName,StateName who are not belong to any state.
select empname,empsalary,empDOB,empDOJ,cityname,statename,companyname from employee e
join city c on e.cityid=c.cityid
join state s on c.stateid=s.stateid
join company comp on e.companyid=comp.companyid--common it gives

---who are not belong to any state
select e.empname,e.empsalary,e.empDOB,e.empDOJ,c.cityname,s.statename,comp.companyname 
from employee e
left join company comp on e.companyid=comp.companyid
left join city c on e.cityid=c.cityid
left join state s on c.stateid=s.stateid
where s.stateid is null

--List the name, salary, dob of employee with its CompanyName, CityName,
--StateName. working at ' R K Infotech ' and ' Vexil Infotech ' 
--and its salary is > 15000, but the salary should not be 33500.
select e.empname,e.empsalary,e.empDOB,comp.companyname,c.cityname,s.statename
from employee e
join city c on e.cityid=c.cityid
join state s on c.stateid=s.stateid
join company comp on e.companyid=comp.companyid
where comp.companyname in('R K Infotech','Vexil Infotech')
and e.empsalary>15000 and e.empsalary<>33500
