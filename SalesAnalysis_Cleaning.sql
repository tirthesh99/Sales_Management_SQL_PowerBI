--Selected only required column from DimDate table
SELECT [DateKey],
       [FullDateAlternateKey] AS Date,
       [EnglishDayNameOfWeek] AS Day,
       [WeekNumberOfYear] AS WeekNumber,
       [EnglishMonthName] AS Month,
	   LEFT([EnglishMonthName], 3) AS MonthShort,
       [MonthNumberOfYear] AS MonthNumber,
       [CalendarQuarter] AS Quarter,
       [CalendarYear] AS Year
FROM [AdventureWorksDW2022].[dbo].[DimDate]
WHERE CalendarYear >= 2019

-------------------------------------------------------------------------------------------------------------------------------------
--Cleaning DimCustomer table and joining it with DimGeography table 

SELECT C.CustomerKey AS Customer_Key,
       C.FirstName AS First_Name,
       C.LastName AS Last_Name,
	   C.FirstName + '' + LastName AS Full_name,
       CASE WHEN C.Gender = 'M' THEN 'Male' WHEN C.Gender = 'F' THEN 'Female' END AS Gender,
	   C.DateFirstPurchase AS DateFirstPurchased,
	   G.City AS Customer_City -- Joined in from DimGeagraphy table
FROM [AdventureWorksDW2022].[dbo].[DimCustomer] AS C
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimGeography] AS G
ON C.GeographyKey = G.GeographyKey
ORDER BY Customer_City 

--------------------------------------------------------------------------------------------------------------------------------------

--Cleaning DimProduct table and joining it with DimProductCategory and DimProductSubCategory tables

SELECT P.ProductKey,
       P.ProductAlternateKey As ProductItemCode,
       P.[EnglishProductName],
	   PSC.EnglishProductSubcategoryName AS Product_Sub_Category, --Joined in from ProductSubCategory table
	   PC.EnglishProductCategoryName AS Product_Category, --Joined in from ProductCategory table
	   P.Color AS Product_Color,
	   P.Size AS Product_Size, 
	   P.ProductLine AS Product_Line,
	   P.ModelName AS Product_Model_Name,
	   P.EnglishDescription AS Product_Description,
	   ISNULL(P.Status, 'OUTDATED') AS Product_Status	   
FROM [AdventureWorksDW2022].[dbo].[DimProduct] AS P
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimProductSubcategory] AS PSC ON P.ProductSubcategoryKey = PSC.ProductSubcategoryKey
LEFT JOIN [AdventureWorksDW2022].[dbo].[DimProductCategory] AS PC ON PSC.ProductCategoryKey = PC.ProductCategoryKey
ORDER BY ProductKey

--------------------------------------------------------------------------------------------------------------------------------------

--Cleaning FactInternetSales table

SELECT ProductKey,
       OrderDateKey,
       DueDateKey,
       ShipDateKey,
       CustomerKey,
       SalesOrderNumber,
       SalesAmount   
FROM [AdventureWorksDW2022].[dbo].[FactInternetSales]
WHERE LEFT(OrderDateKey,4) >= YEAR(GETDATE())- 5 
ORDER BY OrderDateKey
