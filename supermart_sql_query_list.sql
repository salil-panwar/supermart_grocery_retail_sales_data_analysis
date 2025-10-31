SELECT *
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
ORDER BY order_date ASC
--1 Standard KPIs Calculations
SELECT
ROUND(SUM(sales), 2)AS total_sales,
ROUND(SUM(discounts), 2) AS total_discounts_disbursed,
ROUND(SUM(profits), 2) AS total_profits,
ROUND(AVG(sales), 2) AS avg_sale_value,
ROUND(AVG(discounts), 2) AS avg_discount_disbursed,
ROUND(AVG(profits), 2) AS avg_profit_per_sale
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
--1 Standard KPIs Calculations

--2 Standard KPIs Calculations Per Product Category
SELECT
product_category,
ROUND(SUM(sales), 2)AS total_sales,
ROUND(SUM(discounts), 2) AS total_discounts_disbursed,
ROUND(SUM(profits), 2) AS total_profits,
ROUND(AVG(sales), 2) AS avg_sale_value,
ROUND(AVG(discounts), 2) AS avg_discount_disbursed,
ROUND(AVG(profits), 2) AS avg_profit_per_sale
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY product_category
ORDER BY total_sales DESC;
--2 Standard KPIs Calculations Per Product Category

--3 Standard KPIs Calculations Per Product Category & Sub Category
SELECT
product_category,
sub_category,
ROUND(SUM(sales), 2)AS total_sales, ROUND(SUM(discounts), 2) AS total_discounts_disbursed, ROUND(SUM(profits), 2) AS total_profits,
ROUND(AVG(sales), 2) AS avg_sale_value, ROUND(AVG(discounts), 2) AS avg_discount_disbursed, ROUND(AVG(profits), 2) AS avg_profit_per_sale

FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY product_category, sub_category
ORDER BY total_sales DESC;
--3 Standard KPIs Calculations Per Product Category & Sub Category

--4 Standard KPIs Calculations Per City
SELECT 
mart_city, 
ROUND(SUM(sales), 2)AS total_sales, ROUND(SUM(discounts), 2) AS total_discounts_disbursed, ROUND(SUM(profits), 2) AS total_profits,
ROUND(AVG(sales), 2) AS avg_sale_value, ROUND(AVG(discounts), 2) AS avg_discount_disbursed, ROUND(AVG(profits), 2) AS avg_profit_per_sale
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY mart_city
ORDER BY total_sales;
--4 Standard KPIs Calculations Per City

--5 Standard KPIs Calculations Per Region
SELECT 
mart_region, 
ROUND(SUM(sales), 2)AS total_sales, ROUND(SUM(discounts), 2) AS total_discounts_disbursed, ROUND(SUM(profits), 2) AS total_profits,
ROUND(AVG(sales), 2) AS avg_sale_value, ROUND(AVG(discounts), 2) AS avg_discount_disbursed, ROUND(AVG(profits), 2) AS avg_profit_per_sale
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY mart_region
ORDER BY total_sales;
--5 Standard KPIs Calculations Per Region

--6 Standard KPIs calculations + profit margins per product category
SELECT product_category,
ROUND(SUM(sales), 2)AS total_sales, ROUND(AVG(sales), 2) AS avg_sale_value,
ROUND(SUM(discounts), 2) AS total_discounts_disbursed, ROUND(AVG(discounts), 2) AS avg_discount_disbursed,
ROUND(SUM(profits), 2) AS total_profits, ROUND(AVG(profits), 2) AS avg_profit_per_sale,
(SUM(profits)/NULLIF(SUM(sales), 0) ) AS profit_margin
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY product_category
--6 Standard KPIs calculations + profit margins per product category

--7 Standard KPIs calculations + profit margins per customer name
SELECT customer_name,
ROUND(SUM(sales), 2)AS total_sales, ROUND(AVG(sales), 2) AS avg_sale_value,
ROUND(SUM(discounts), 2) AS total_discounts_disbursed, ROUND(AVG(discounts), 2) AS avg_discount_disbursed,
ROUND(SUM(profits), 2) AS total_profits, ROUND(AVG(profits), 2) AS avg_profit_per_sale,
(SUM(profits)/NULLIF(SUM(sales), 0) ) AS profit_margin
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY customer_name
ORDER BY total_profits DESC;
--7 Standard KPIs calculations + profit margins per customer name

--8 Standard KPIs calculations + profit margins per customer monthly basis
SELECT FORMAT(order_date, 'MM-yyyy') AS months,
customer_name,
ROUND(SUM(sales), 2)AS total_sales, ROUND(AVG(sales), 2) AS avg_sale_value,
ROUND(SUM(discounts), 2) AS total_discounts_disbursed, ROUND(AVG(discounts), 2) AS avg_discount_disbursed,
ROUND(SUM(profits), 2) AS total_profits, ROUND(AVG(profits), 2) AS avg_profit_per_sale,
(SUM(profits)/NULLIF(SUM(sales), 0) ) AS profit_margin
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
GROUP BY customer_name, FORMAT(order_date, 'MM-yyyy')
ORDER BY FORMAT(order_date, 'MM-yyyy') ASC;
--8 Standard KPIs calculations + profit margins per customer monthly basis

--9 Dynamic Pivot Of Sales Data Of Product Categories Per City

DECLARE @product_category_pivot NVARCHAR(MAX) ,  @product_category_columns NVARCHAR(MAX) , @total_sales NVARCHAR(MAX)
SELECT @product_category_columns = STRING_AGG(QUOTENAME(product_category), ',')
FROM(
SELECT DISTINCT product_category
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
) AS data_for_product_column;
SELECT @total_sales = STRING_AGG('ISNULL( ' + QUOTENAME(product_category) + ', 0)', ' + ')
FROM(
SELECT DISTINCT product_category
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
) AS data_for_total_column;
SET @product_category_pivot = '
SELECT mart_city , ' + @product_category_columns + ' , ' + @total_sales + ' AS grand_total
FROM
(
SELECT mart_city, product_category, sales
FROM [supermart_grocery_sales].dbo.[supermart_grocery_sales_retail_analytics_dataset]
) AS primary_table_to_pivot
PIVOT
(
SUM(sales)
FOR product_category IN (' + @product_category_columns + ')
) AS pivoted_table
ORDER BY mart_city;
'
EXEC sp_executesql @product_category_pivot

--9 Dynamic Pivot Of Sales Data Of Product Categories Per City





