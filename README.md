Project Overview:
This project contains SQL queries practiced using the AdventureWorks dataset.
The goal of this project is to improve SQL skills by analyzing sales, customer, and product data using different SQL concepts.

Tools Used:
* SQL
* Microsoft SQL Server(SSMS)

Dataset
The **AdventureWorks** database is a sample dataset provided by Microsoft that simulates a real company's business operations.
It includes tables related to customers, products, sales orders, and sales territories.

SQL Concepts Practiced:
* SELECT statements
* Filtering using WHERE
* Sorting using ORDER BY
* Aggregate functions (SUM, AVG, COUNT)
* GROUP BY and HAVING
* INNER JOIN and other joins
* Subqueries
* Basic data analysis queries

Sample Question I have practiced:

* Add new column in ‘HumanResources.Employee’ table, column name is ‘experience_level’ char data type?
* Update the ‘experience_level’ column; in which data is, employee’s experience is above 10 years so fill ‘A’, below 10 years and above 5 years so fill ‘B’ otherwise ‘C’. Here, employee experience related column is not existing, so calculate through its HireDate column?
* Write a query in SQL to ordered the BusinessEntityID column descendingly when SalariedFlag set to 'true' and BusinessEntityID in ascending order when SalariedFlag set to 'false'. Return BusinessEntityID, SalariedFlag columns?
* Write a query in SQL to find those persons who lives in a territory and the value of salesytd except 0. Return first name, last name, row number as 'Row Number', 'Rank', 'Dense Rank' and NTILE as 'Quartile', salesytd and postalcode. Order the output on postalcode column?
* Write a SQL query to retrieve the product name and salesorderid. Both ordered and unordered products are included in the result set?
* Write a SQL query to retrieve the territory name and BusinessEntityID. The result set includes all salespeople, regardless of whether or not they are assigned a territory?
* Write a SQL query to locate the position of the string "yellow" where it appears in the product name?

Purpose of the Project:
The purpose of this project is to practice SQL queries and understand how SQL can be used to analyze business data and generate useful insights.

