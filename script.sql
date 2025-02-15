--1.1
--You’ve been asked to extract the data on products from the Product table where there exists a product subcategory. And also include the name of the ProductSubcategory.
--Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name.
--Order results by SubCategory name.
SELECT
  pr.ProductID,
  pr.Name AS product_name,
  pr.ProductNumber AS product_number,
  pr.Size AS product_size,
  pr.Color AS product_color,
  sub.ProductSubcategoryId,
  sub.name AS product_sub_name
FROM `adwentureworks_db.product` AS pr
JOIN `adwentureworks_db.productsubcategory` AS sub
ON pr.ProductSubcategoryID = sub.ProductSubcategoryID
ORDER BY product_sub_name

--1.2
--In 1.1 query you have a product subcategory but see that you could use the category name.
--Find and add the product category name.
--Afterwards order the results by Category name.
SELECT
  pr.ProductID,
  pr.Name AS product_name,
  pr.ProductNumber AS product_number,
  pr.Size AS product_size,
  pr.Color AS product_color,
  sub.ProductSubcategoryId,
  sub.name AS product_sub_name,
  cat.Name As product_category
FROM `adwentureworks_db.product` AS pr
JOIN `adwentureworks_db.productsubcategory` AS sub
ON pr.ProductSubcategoryID = sub.ProductSubcategoryID
JOIN `adwentureworks_db.productcategory` AS cat
ON sub.ProductCategoryID = cat.ProductCategoryID
ORDER BY product_category

--1.3
--Use the established query to select the most expensive (price listed over 2000) bikes that are still actively sold (does not have a sales end date)
--Order the results from most to least expensive bike.
SELECT
  pr.ProductID,
  pr.Name AS product_name,
  pr.ProductNumber AS product_number,
  pr.ListPrice AS price,
  pr.Size AS product_size,
  pr.Color AS product_color,
  sub.ProductSubcategoryId,
  sub.name AS product_sub_name,
  cat.Name As product_category,
  pr.SellEndDate
FROM `adwentureworks_db.product` AS pr
JOIN `adwentureworks_db.productsubcategory` AS sub
ON pr.ProductSubcategoryID = sub.ProductSubcategoryID
JOIN `adwentureworks_db.productcategory` AS cat
ON sub.ProductCategoryID = cat.ProductCategoryID
WHERE pr.ListPrice > 2000 AND pr.SellEndDate IS NULL AND cat.Name = 'Bikes'
ORDER BY price DESC

--2.1
--Create an aggregated query to select the:
--Number of unique work orders.
--Number of unique products.
--Total actual cost.
--For each location Id from the 'workoderrouting' table for orders in January 2004.
SELECT
  LocationID,
  COUNT(DISTINCT WorkOrderID) AS no_un_work_orders,
  COUNT(DISTINCT ProductID) AS no_un_productID,
  SUM(ActualCost) as total_actual_cost
FROM `adwentureworks_db.workorderrouting`
WHERE ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY LocationID
ORDER BY COUNT(WorkOrderID) DESC

--2.2
--Update your 2.1 query by adding the name of the location
--and also add the average days amount between actual start date
--and actual end date per each location.
SELECT
  w.LocationID,
  l.name AS location,
  COUNT(DISTINCT w.WorkOrderID) AS no_un_work_orders,
  COUNT(DISTINCT w.ProductID) AS no_un_productID,
  SUM(w.ActualCost) AS total_actual_cost,
  ROUND(AVG(DATETIME_DIFF (w.ActualEndDate, w.ActualStartDate, DAY)), 2) AS avg_duration_days
FROM `adwentureworks_db.workorderrouting` w
JOIN `adwentureworks_db.location` l
ON w.LocationID = l.LocationID
WHERE CAST(w.ActualStartDate AS DATE) BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY w.LocationID, l.name
ORDER BY no_un_work_orders DESC

--2.3
--Select all the expensive work Orders
--(above 300 actual cost) that happened throught January 2004.
SELECT
  wor.WorkOrderID,
  SUM(wor.actualcost) actual_cost
FROM `adwentureworks_db.workorderrouting`wor
WHERE ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'
GROUP BY wor.WorkOrderID
HAVING SUM(wor.actualcost) > 300
ORDER BY actual_cost

--3.1
--Your colleague has written a query to find the list of orders connected to
--special offers. The query works fine but the numbers are off,
--investigate where the potential issue lies.
SELECT
sales_detail.SalesOrderId,
sales_detail.OrderQty,
sales_detail.UnitPrice,
sales_detail.LineTotal,
sales_detail.ProductId,
sales_detail.SpecialOfferID,
spec_offer_product.ModifiedDate,
spec_offer.Category,
spec_offer.Description
FROM `tc-da-1.adwentureworks_db.salesorderdetail`  AS sales_detail
LEFT JOIN `tc-da-1.adwentureworks_db.specialofferproduct` AS spec_offer_product
ON sales_detail.productId = spec_offer_product.ProductID
AND sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID
LEFT JOIN `tc-da-1.adwentureworks_db.specialoffer` AS spec_offer
ON spec_offer_product.SpecialOfferID = spec_offer.SpecialOfferID
ORDER BY LineTotal DESC

--3.2
--Your colleague has written this query to collect basic Vendor information.
--The query does not work, look into the query and find ways to fix it.
--Can you provide any feedback on how to make this query be easier to debug/read?
SELECT
vendor.VendorId AS Id,
vendor.Name,
vendor.CreditRating,
vendor.ActiveFlag,
vendor_contact.ContactId,
vendor_contact.ContactTypeId,
vendor_adress.AddressId,
address.City
FROM `adwentureworks_db.vendor` AS vendor
LEFT JOIN `adwentureworks_db.vendorcontact` AS vendor_contact
ON vendor.VendorId = vendor_contact.VendorId
LEFT JOIN `adwentureworks_db.vendoraddress` AS vendor_adress
ON vendor.VendorId = vendor_adress.VendorId
LEFT JOIN tc-da-1.adwentureworks_db.address AS address
ON vendor_adress.AddressID = address.AddressID
