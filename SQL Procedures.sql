--Dimensiones:

--Dim_Customer
SELECT c.CustomerID, c.CustomerName, c.BillToCustomerID, cc.CustomerCategoryName, c.BuyingGroupID, bg.BuyingGroupName,
c.PrimaryContactPersonID,p.FullName AS PrimaryContact, c.AlternateContactPersonID, ci.CityName,
sp.StateProvinceName,co.CountryName,c.CreditLimit, c.IsStatementSent,c.IsOnCreditHold,
c.PaymentDays,c.PhoneNumber,c.FaxNumber,c.WebsiteURL,c.DeliveryAddressLine1, c.DeliveryAddressLine2
,c.DeliveryPostalCode,c.PostalAddressLine1,c.PostalAddressLine2,c.PostalPostalCode,c.LastEditedBy,c.ValidFrom,c.ValidTo
FROM Sales.Customers AS c
JOIN Sales.CustomerCategories AS cc
ON c.CustomerCategoryID = cc.CustomerCategoryID
LEFT JOIN Sales.BuyingGroups AS bg
ON c.BuyingGroupID = bg.BuyingGroupID
LEFT JOIN Application.People AS p
ON c.PrimaryContactPersonID = p.PersonID
JOIN Application.Cities AS ci
ON c.DeliveryCityID = ci.CityID
JOIN Application.StateProvinces AS sp
ON ci.StateProvinceID = sp.StateProvinceID
JOIN Application.Countries AS co
ON sp.CountryID = co.CountryID

--Dim_Product
SELECT si.StockItemID AS ProductID, si.StockItemName AS ProductName, s.SupplierName, pt1.PackageTypeName AS UnitPackage,
pt2.PackageTypeName AS OuterPackage, c.ColorName AS Color, si.Size, si.Brand, si.IsChillerStock
FROM Warehouse.StockItems AS si
JOIN Purchasing.Suppliers AS s
ON si.SupplierID = s.SupplierID
JOIN Warehouse.PackageTypes AS pt1
ON si.UnitPackageID = pt1.PackageTypeID
JOIN Warehouse.PackageTypes AS pt2
ON si.OuterPackageID = pt2.PackageTypeID
LEFT JOIN Warehouse.Colors AS c
ON si.ColorID = c.ColorID

--Dim_Employee
SELECT PersonID as EmployeeID, FullName, PreferredName, SearchName, IsPermittedToLogon, LogonName, IsExternalLogonProvider, HashedPassword,
IsSalesperson, UserPreferences, PhoneNumber, FaxNumber, EmailAddress, Photo, LastEditedBy, ValidFrom, ValidTo
FROM Application.People WHERE IsEmployee = 1

--Dim_Supplier
SELECT s.SupplierID, s.SupplierName, sc.SupplierCategoryName, p.FullName AS PrimaryContact, s.PostalPostalCode,
ci.CityName, sp.StateProvinceName, co.CountryName
FROM Purchasing.Suppliers AS s
JOIN Purchasing.SupplierCategories AS sc
ON s.SupplierCategoryID = sc.SupplierCategoryID
LEFT JOIN Application.People AS p
ON s.PrimaryContactPersonID = p.PersonID
JOIN Application.Cities AS ci
ON s.DeliveryCityID = ci.CityID
JOIN Application.StateProvinces AS sp
ON ci.StateProvinceID = sp.StateProvinceID
JOIN Application.Countries AS co
ON sp.CountryID = co.CountryID

--Dim_PaymentMethod
--SELECT * FROM Application.PaymentMethods

--Fact_Orders
SELECT so.OrderID, so.CustomerID, so.PickedByPersonID, so.ContactPersonID,
so.BackorderOrderID, so.OrderDate, so.ExpectedDeliveryDate, so.CustomerPurchaseOrderNumber,
so.IsUndersupplyBackordered,
    (SELECT TOP 1 ct.CustomerTransactionID
     FROM Sales.CustomerTransactions AS ct
     WHERE ct.InvoiceID = si.InvoiceID
     AND ct.TransactionTypeID = (SELECT TransactionTypeID FROM Application.TransactionTypes WHERE TransactionTypeName = 'Customer Payment')
     ORDER BY ct.TransactionDate DESC, ct.CustomerTransactionID DESC
    ) AS CustomerTransactionID,
    (SELECT TOP 1 ct.PaymentMethodID
     FROM Sales.CustomerTransactions AS ct
     WHERE ct.InvoiceID = si.InvoiceID
     AND ct.TransactionTypeID = (SELECT TransactionTypeID FROM Application.TransactionTypes WHERE TransactionTypeName = 'Customer Payment')
     ORDER BY ct.TransactionDate DESC, ct.CustomerTransactionID DESC
    ) AS PaymentMethodID,
    sol.OrderLineID,
    sol.StockItemID AS ProductID,
    sol.PackageTypeID,
    sol.Quantity,
    sol.UnitPrice,
    (sol.TaxRate / 100.0) AS TaxRate,
    (sol.Quantity * sol.UnitPrice) AS Subtotal,
    ((sol.Quantity * sol.UnitPrice) * (sol.TaxRate / 100.0)) AS Taxes,
    ((sol.Quantity * sol.UnitPrice) + ((sol.Quantity * sol.UnitPrice) * (sol.TaxRate / 100.0))) AS Total,
    si.InvoiceID,
    si.BillToCustomerID,
    si.DeliveryMethodID,
    si.AccountsPersonID,
    si.SalespersonPersonID AS EmployeeID,
    si.PackedByPersonID,
    si.InvoiceDate,
    si.TotalDryItems,
    si.TotalChillerItems,
    s.SupplierID
FROM Sales.Orders AS so

JOIN Sales.OrderLines AS sol
ON so.OrderID = sol.OrderID

JOIN Sales.Invoices AS si
ON so.OrderID = si.OrderID

JOIN Sales.Customers AS c
ON si.CustomerID = c.CustomerID

LEFT JOIN Warehouse.StockItems AS ws
ON sol.StockItemID = ws.StockItemID

LEFT JOIN Purchasing.Suppliers AS s
ON ws.SupplierID = s.SupplierID