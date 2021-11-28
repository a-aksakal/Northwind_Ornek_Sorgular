SELECT LOWER('WÝSSEN')
SELECT UPPER('wissen')

SELECT MONTH(GETDATE())
SELECT DATENAME(MM, GETDATE())
SELECT DATENAME(YEAR, GETDATE())

SELECT customerID, DATENAME(MM,OrderDate)+' '+DATENAME(YEAR,OrderDate) AS "Sipariþ Tarihi" 
FROM Orders

SELECT TOP 50 ProductName 
from Products 

--Birim Fiyatý 18 ve 55 arasýnda olan ürünleri listele.

SELECT * 
FROM Products 
Where(UnitPrice>=18 AND UnitPrice <= 55)

--Ürün fiyatý 18 ve 50 arasýnda olanlarý listele.

SELECT * 
FROM Products 
where UnitPrice BETWEEN 18 And 50

--01.01.1998 tarihinden sonra verilmiþ sipariþlerin tarihi ve veren müþterinin adý.

SELECT C.ContactName, O.OrderDate 
From Orders  O 
join Customers C on c.CustomerID=o.CustomerID 
Where(OrderDate >= '01.01.1998')

--10248 nolu sipariþ hangi kargo þirketi ile gönderilmiþtir?

SELECT s.CompanyName 
FROM ORDERS o 
join Shippers s on o.ShipVia = s.ShipperID 
where(o.OrderID=10248)

--Çalýþanlarýn baðlý bulunduðu satýþ bölgesini göster.

SELECT DISTINCT t.TerritoryDescription 
FROM ORDERS o 
join EmployeeTerritories et on o.EmployeeID=et.EmployeeID 
join Territories t on et.TerritoryID=t.TerritoryID 
where (o.EmployeeID=6)

--Ürün adý tofu olanlarýn sipariþ id lerini listele.

SELECT o.OrderID 
FROM Products p 
join [Order Details] od on p.ProductID=od.ProductID 
join Orders o on od.OrderID=o.OrderID 
where(p.ProductName='Tofu')

--Dumon veya ALFKI müþterilerinin aldýðý 1 ID LÝ çalýþanýn onayladýðý 1 veya 3 nolu kargo firmasýyla taþýnmýþ sipariþleri geitirin.

SELECT * 
FROM Orders 
where CustomerID in('DUMON','ALFKI') AND EmployeeID=1 AND ShipVia IN(1,3)

Select COUNT(*) FROM Products

--Category name ait ürünlerin sayýsý

Select c.CategoryName, COUNT(*) Sayi   
From Categories c 
join Products p on c.CategoryID=p.CategoryID 
group by c.CategoryName 
Order By Sayi DESC

--Sipariþleri Sipariþ numarasý ve sipariþ toplam tutarý olarak listeleyiniz.

SELECT OrderID ,ROUND(SUM(UnitPrice*Quantity*(1-Discount)),2) [Toplam Tutar]
FROM [Order Details] od
group by od.OrderID

--Hangi ürünün ne kadarlýk sipariþ edilmiþ

SELECT p.ProductName, Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) [Tutar]
FROM [Order Details] od
join Products p on od.ProductID=p.ProductID
GROUP BY p.ProductName
ORDER BY Tutar DESC

--Hangi tedarikçiden ne kadarlýk tedarik edilmiþ

SELECT s.CompanyName, p.ProductName,Round(sum(od.UnitPrice*od.Quantity*(1-od.discount)),2) Tutar
FROM [Order Details] od
join Products p on od.ProductID=p.ProductID
join Suppliers s on p.SupplierID=s.SupplierID
group by s.CompanyName,p.ProductName
order by s.CompanyName

--Hangi çalýþandan toplam ne kadarlýk sipariþ edilmiþ.

SELECT (e.FirstName+' '+e.LastName) as [Ad Soyad], Round(sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) as Tutar
FROM [Order Details] od
join Orders o on od.OrderID=o.OrderID
join Employees e on o.EmployeeID=e.EmployeeID
group by e.FirstName,e.LastName
order by Tutar DESC

--Her bir çalýþanýn sorumlu olduðu satýþ bölgesi 

Select e.FirstName,t.TerritoryDescription
From Employees e
join EmployeeTerritories et on e.EmployeeID=et.EmployeeID
join Territories t on et.TerritoryID=t.TerritoryID

--Hangi üründen ne kadarlýk sipariþ edilmiþ (yýllara göre gruplandýrýnýz)

Select p.ProductName,Round(sum(od.Quantity*od.UnitPrice*(1-od.Discount)),2) Toplam, DATENAME(YEAR,o.OrderDate) Yýl
From Products p
Join [Order Details] od on p.ProductID=od.ProductID
join Orders o on od.OrderID=o.OrderID
group by DATENAME(YEAR,o.OrderDate), p.ProductName


--Ortalama fiyatýn üstünde sattýðým ürünlerin listesi

Select p.ProductName,od.UnitPrice
From [Order Details] od
join Products p on od.ProductID=p.ProductID
group by p.ProductName,od.UnitPrice Having od.UnitPrice > 26.2185
Order by od.UnitPrice DESC

--Henüz sipariþ vermemiþ müþteriler

Select c.CustomerID
From Orders o
Full outer Join Customers c on o.CustomerID=c.CustomerID
where o.OrderID is null 


--29 yýl ve üzeri çalýþanlardan satýþ ortalamasýnýn üstünde olanlarý listeleyelim.

Select e.FirstName, Round(Sum(od.UnitPrice*od.Quantity*(1-od.Discount)),2) Tutar, e.HireDate
From Employees e
join Orders o on e.EmployeeID=o.EmployeeID
join [Order Details] od on o.OrderID=od.OrderID
Where DATENAME(YEAR,e.HireDate)<1993 
group by e.FirstName,e.HireDate having sum(UnitPrice*Quantity*(1-Discount)) >619.02
Order By Tutar DESC
