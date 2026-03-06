use AdventureWorks2022

--Write a query displaying the Sales.SalesOrderHeader where the total due exceeds 1000. 
--Retrieve only thoserows where the salesperson ID is 279 or the territory ID is 6. 
--This query is perform by stored procedure with 2 parameter. (@SalesPersonID, @TerritoryID)
--like,exec dbo.sp_dispSalesOrder @SalesPersonID = 279,@TerritoryID = 6
select * from Sales.SalesOrderHeader

CREATE PROCEDURE dbo.sp_dispSalesOrder_v1
    @SalesPersonID INT,
    @TerritoryID INT
AS
BEGIN
    SELECT *
    FROM Sales.SalesOrderHeader
    WHERE TotalDue > 1000
      AND (SalesPersonID = @SalesPersonID
           OR TerritoryID = @TerritoryID);
END;
exec dbo.sp_dispSalesOrder_v1 @SalesPersonID=279,@TerritoryID=6
exec dbo.sp_dispSalesOrder_v1 @TerritoryID = 1

create procedure dbo.sp_dispSalesOrder_v2
@SalesPersonID int=null,
@TerritoryID int=null
as
begin
    if @SalesPersonID is null and @TerritoryID is null
    begin
        print 'Please pass either SalesPersonID or TerritoryID.'
        return
    end
    select * from Sales.SalesOrderHeader
    where TotalDue>1000
    and ( (@SalesPersonID is not null and SalesPersonID=@SalesPersonID)
    or(@TerritoryID is not null and TerritoryID = @TerritoryID)
    )
end

--Write a query in SQL to calculate the average vacation hours, sum of 
--vacation hours and the sum of sick leave hours, by year, quarter, month.
--This query is perform by stored procedure with 4 parameter 
--(@JobTitle,@Year,@Quarter,@Month)if there was no leave consider then pass
--message  and , if I pass any one parameter so retrieve only that parameter 
--related data.(Use HumanResources.Employee)
select * from HumanResources.Employee
create procedure dbo.sp_EmployeeLeaveStatus
    @JobTitle varchar(50)=null,
    @Year int = null,
    @Quarter int = null,
    @Month int=null
as
begin
    with empLeave as(
    select HireDate,VacationHours,SickLeaveHours,JobTitle from HumanResources.Employee
    where (VacationHours>0 or SickLeaveHours>0)
    and (@JobTitle is null or JobTitle=@JobTitle)
    and (@Year is null or Year(HireDate)=@Year)
    and (@Quarter is null or datepart(Quarter,HireDate)=@Quarter)
    and (@Month is null or month(HireDate)=@Month)
    )
    select year(HireDate) as Year,
        datepart(Quarter,HireDate) as Quarter,
        month(HireDate) as Month,
        avg(VacationHours) as AvgVacationHours,
        sum(VacationHours) as TotalVacationHours,
        sum(SickLeaveHours) as TotalSickLeaveHours
    from empLeave 
group by
year(HireDate),
datepart(quarter,HireDate),
month(HireDate)
end
exec dbo.sp_EmployeeLeaveStatus @year=2013,@Quarter=2
exec dbo.sp_EmployeeLeaveStatus @year=2013 
EXEC dbo.sp_EmployeeLeaveStatus @JobTitle = 'Engineering Manager'
EXEC dbo.sp_EmployeeLeaveStatus
     @JobTitle = 'Engineering Manager',
     @Year = 2013,
     @Quarter = 2,
     @Month = 5

--Write a query in SQL to return a moving average of yearly sales for each
--territory. Return BusinessEntityID, TerritoryID, SalesYear, SalesYTD, 
--average SalesYTD as MovingAvg, and total SalesYTD as CumulativeTotal This
--query is perform by stored procedure with 2 parameter 
--(@TerritoryID, @SalesYear). if I will not pass any one parameter so retrieve
--all related data.(Use Sales.SalesPerson)
select * from Sales.SalesPerson
CREATE PROCEDURE dbo.sp_MovingAvgSalesByTerritory
    @TerritoryID INT = NULL,
    @SalesYear   INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        BusinessEntityID,
        TerritoryID,
        YEAR(ModifiedDate) AS SalesYear,
        SalesYTD,

        -- Moving Average of SalesYTD
        AVG(SalesYTD) OVER (
            PARTITION BY TerritoryID
            ORDER BY YEAR(ModifiedDate)
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS MovingAvg,

        -- Cumulative Total of SalesYTD
        SUM(SalesYTD) OVER (
            PARTITION BY TerritoryID
            ORDER BY YEAR(ModifiedDate)
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS CumulativeTotal

    FROM Sales.SalesPerson
    WHERE (@TerritoryID IS NULL OR TerritoryID = @TerritoryID)
      AND (@SalesYear   IS NULL OR YEAR(ModifiedDate) = @SalesYear)
      AND SalesYTD IS NOT NULL
    ORDER BY TerritoryID, SalesYear;
END;

exec dbo.sp_MovingAvgSalesByTerritory @TerritoryID=4
exec dbo.sp_MovingAvgSalesByTerritory @SalesYear=2013
exec dbo.sp_MovingAvgSalesByTerritory @TerritoryID=4,@SalesYear=2013