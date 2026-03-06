create database employeeDB3
use employeeDB3
create table employee03(
	id varchar(10),
	name varchar(25),
	dob date,
	salary int,
	city varchar(30)
	)

insert into employee03(id,name,dob,salary,city)
	values('E01','tulasi','1982-01-26',12000,'ahmedabad'),
		('E02','gopi','1983-08-15',15000,'anand'),
		('E03','rajshree','1984-10-31',20000,'vadodara'),
		('E04','vaishali','1985-03-23',25000,'surat'),
		('E05','laxmi','1983-02-14',18000,'anand'),
		('E06','shivali','1984-09-05',20000,null)

select * from employee03

--Display birth date for employees having id ‘E01’ and ‘E03’.
select name, day(dob) from employee03 where id in ('E01','E03')
select *, day(dob) from employee03 where id in ('E01','E03')

--List all employees details having salary either 18000 or 20000.
select * from employee03 where salary in (18000,20000)

--List all employees details who do not stay in city ‘Ahmedabad’ or ‘Surat’.
select * from employee03 where city not in ('ahmedabad','surat')

--List all employees details who stay in cities having ‘d’ as last character.
select * from employee03 where city like '%d'

--List all employees details whose name ends with ‘ali’
select * from employee03 where name like '%ali'

--Add check constraints in salary. (minimum 10000)
alter table employee03
add constraint chK_sal check(salary>=10000)

--List all employees details whose birth date is between ’01-jan-82’ and ’31-dec-83’.
select * from employee03 where dob between '1982-01-04' and '1983-12-31'

--Display city and average of salary for the employees according to their city.
select city,avg(salary) as average_salary
from employee03
group by city

--Count the employees who earn more than 16000.
select count(*) from employee03 where salary > 16000

--Now create copy of table employees. Which name is Employees2. (not manually)
create table mplyss2 AS
select * from employee03
 
 select * into mplyss2 from employee03
 select * from mplyss2
--Update the employees Record. 
--Name: (‘Tulsi’ to ‘Tulsiben’ and ‘Rajshree’ to ‘Rajshreekumari’)
update employee03 set name=
case 
	name when 'tulasi' then 'Tulsiben'
		 when 'rajshree' then 'Rajshreekumari'
	else name
	end

--Now update Employees2 table in name column. (Not manually, use update join scenario)
update mplyss2
set E2.name = E1.name
from employee03 E1
join mplyss2 E2
on E2.id = E1.id
select * from mplyss2
select * from employee03














