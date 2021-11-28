SELECT LOWER('W�SSEN')
SELECT UPPER('wissen')

SELECT MONTH(GETDATE())
SELECT DATENAME(MM, GETDATE())
SELECT DATENAME(YEAR, GETDATE())

SELECT customerID, DATENAME(MM,OrderDate)+' '+DATENAME(YEAR,OrderDate) AS "Sipari� Tarihi" 
FROM Orders

SELECT TOP 50 ProductName 
from Products 

--Birim Fiyat� 18 ve 55 aras�nda olan �r�nleri listele.

SELECT * 
FROM Products 
Where(UnitPrice>=18 AND UnitPrice <= 55)

--�r�n fiyat� 18 ve 50 aras�nda olanlar� listele.

SELECT * 
FROM Products 
where UnitPrice BETWEEN 18 And 50

--01.01.1998 tarihinden sonra verilmi� sipari�lerin tarihi ve veren m��terinin ad�.

SELECT C.ContactName, O.OrderDate 
From Orders  O 
join Customers C on c.CustomerID=o.CustomerID 
Where(OrderDate >= '01.01.1998')

--10248 nolu sipari� hangi kargo �irketi ile g�nderilmi�tir?

SELECT s.CompanyName 
FROM ORDERS o 
join Shippers s on o.ShipVia = s.ShipperID 
where(o.OrderID=10248)

--�al��anlar�n ba�l� bulundu�u sat�� b�lgesini g�ster.

SELECT DISTINCT t.TerritoryDescription 
FROM ORDERS o 
join EmployeeTerritories et on o.EmployeeID=et.EmployeeID 
join Territories t on et.TerritoryID=t.TerritoryID 
where (o.EmployeeID=6)

--�r�n ad� tofu olanlar�n sipari� id lerini listele.

SELECT o.OrderID 
FROM Products p 
join [Order Details] od on p.ProductID=od.ProductID 
join Orders o on od.OrderID=o.OrderID 
where(p.ProductName='Tofu')

--Dumon veya ALFKI m��terilerinin ald��� 1 ID L� �al��an�n onaylad��� 1 veya 3 nolu kargo firmas�yla ta��nm�� sipari�leri geitirin.

SELECT * 
FROM Orders 
where CustomerID in('DUMON','ALFKI') AND EmployeeID=1 AND ShipVia IN(1,3)

Select COUNT(*) FROM Products

--Category name ait �r�nlerin say�s�

Select c.CategoryName, COUNT(*) Sayi   
From Categories c 
join Products p on c.CategoryID=p.CategoryID 
group by c.CategoryName 
Order By Sayi DESC

--Sipari�leri Sipari� numaras� ve sipari� toplam tutar� olarak listeleyiniz.

SELECT OrderID ,ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) [Toplam Tutar]
FROM [Order Details] od
group by od.OrderID

--Hangi �r�n�n ne kadarl�k sipari� edilmi�

SELECT p.ProductName, Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) [Tutar]
FROM [Order Details] od
join Products p on od.ProductID=p.ProductID
GROUP BY p.ProductName
ORDER BY Tutar DESC

--Hangi tedarik�iden ne kadarl�k tedarik edilmi�

SELECT s.CompanyName, p.ProductName,Round(sum(od.UnitPrice*od.Quantity*(1-od.discount)),2) Tutar
FROM [Order Details] od
join Products p on od.ProductID=p.ProductID
join Suppliers s on p.SupplierID=s.SupplierID
group by s.CompanyName,p.ProductName
order by s.CompanyName

--Hangi �al��andan toplam ne kadarl�k sipari� edilmi�.

SELECT (e.FirstName+' '+e.LastName) as [Ad Soyad], Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) as Tutar
FROM [Order Details] od
join Orders o on od.OrderID=o.OrderID
join Employees e on o.EmployeeID=e.EmployeeID
group by e.FirstName,e.LastName
order by Tutar DESC

--Her bir �al��an�n sorumlu oldu�u sat�� b�lgesi 

Select e.FirstName,t.TerritoryDescription
From Employees e
join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
join Territories t on et.TerritoryID=t.TerritoryID

--Hangi �r�nden ne kadarl�k sipari� edilmi� (y�llara g�re grupland�r�n�z)

Select p.ProductName,Round(sum(od.Quantity*od.UnitPrice*(1-od.Discount)),2) Toplam, DATENAME(YEAR,o.OrderDate) Y�l
From Products p
Join [Order Details] od on p.ProductID=od.ProductID
join Orders o on od.OrderID=o.OrderID
group by DATENAME(YEAR,o.OrderDate), p.ProductName


--Ortalama fiyat�n �st�nde satt���m �r�nlerin listesi

Select p.ProductName,od.UnitPrice
From [Order Details] od
join Products p on od.ProductID=p.ProductID
group by p.ProductName,od.UnitPrice Having od.UnitPrice > 26.2185
Order by od.UnitPrice DESC

--Hen�z sipari� vermemi� m��teriler

Select c.CustomerID
From Orders o
Full outer Join Customers c on o.CustomerID=c.CustomerID
where o.OrderID is null 


--29 y�l ve �zeri �al��anlardan sat�� ortalamas�n�n �st�nde olanlar� listeleyelim.

Select e.FirstName, Round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) Tutar, e.HireDate
From Employees e
join Orders o on e.EmployeeID=o.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
Where DATENAME(YEAR,e.HireDate)<1993 
group by e.FirstName,e.HireDate having sum(UnitPrice*Quantity*(1-Discount)) >619.02
Order By Tutar DESC
