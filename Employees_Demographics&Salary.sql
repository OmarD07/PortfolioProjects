
--Pulls all data from the Demographics table
select * 
from EmployeeDemographics

--Pulls all data from the Salary table
select *
from EmployeeSalary


-- Joins both the Demographics & Salary table, pulling data based on EmployeeID by both tables
select *
from EmployeeDemographics
INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


-- Joins Demograhics & Salary table, pulling all data from both tables regardless if there is a match with the EmployeeID or not
select *
from EmployeeDemographics
FULL OUTER JOIN EmployeeSalary
ON EmployeeDemographics. EmployeeID = EmployeeSalary.EmployeeID


-- Pulls all data from the Left table (Demographics) regardless if there is a match with the EmployeeID from the Right table (Salary) or not
select *
from EmployeeDemographics
LEFT JOIN EmployeeSalary
ON EmployeeDemographics. EmployeeID = EmployeeSalary.EmployeeID


--Pulls all data from the Right table (Salary) regardless if there is a match with the EmployeeID from the Left table (Demographics) or not
select *
from EmployeeDemographics
RIGHT JOIN EmployeeSalary
ON EmployeeDemographics. EmployeeID = EmployeeSalary.EmployeeID

--Retreives employees First name, Last name, Jobtitle, & Salary using the employee ID from Demographics Table
select EmployeeDemographics.EmployeeID, FirstName, LastName, JobTitle, Salary
from EmployeeDemographics
INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


--Pulls data of the employee with the Highest salary
select EmployeeDemographics.EmployeeID, FirstName, LastName, Jobtitle, Salary
from EmployeeDemographics
INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE FirstName != 'Michael'
ORDER BY Salary DESC


--Calculates the Average salary for Salesman 
select Jobtitle, AVG(Salary) AS AverageSalary
from EmployeeDemographics
INNER JOIN EmployeeSalary
ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY Jobtitle 