--Retrieves all orders from CustomerID: "ALFKI"
select *
from Orders
where CustomerID = 'ALFKI'


--Retrieves all orders from year 1997
select *
from Orders
WHERE YEAR(OrderDate) = 1997


--Retrieves total number of orders for every customer
select CustomerID, COUNT(OrderID) AS OrderCount
from Orders
GROUP BY CustomerID


--Retrieves Product ID, Sum of Orders by Product ID, & Total Order Amount (Unit Price * Quantity)
select ProductID, COUNT(OrderID) AS CountOrders, SUM(UnitPrice * Quantity) AS TotalOrderAmount
from [Order Details]
GROUP BY ProductID

--Retrieves the Number of Customers per Country
select Country, COUNT(CustomerID) AS NumberOfCustomers
from Customers
GROUP BY Country 


--Retrieves the Number of Customers per Country & City
select Country, City, COUNT(CustomerID) AS NumberOfCustomers
from Customers
GROUP BY Country, City
ORDER BY NumberOfCustomers DESC

