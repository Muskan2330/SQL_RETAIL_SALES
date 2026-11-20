create database sql_project_p2;

create table retail_sales(
				 transactions_id INT PRIMARY KEY ,	
				 sale_date DATE,
				 sale_time TIME,
				 customer_id INT,
				 gender VARCHAR(15),
				 age INT,	
				 category VARCHAR(25),
				 quantiy INT,
				 price_per_unit FLOAT,
				 cogs FLOAT,
				 total_sale FLOAT

		);


select * from retail_sales;

--count all the datasets

SELECT 
		COUNT(*) 
FROM retail_sales;

--------------------------DATA CLEANING-----------------------------------


--Query to check any of the following contains NULL values in the cloumn.
SELECT * FROM retail_sales
	WHERE
		transactions_id IS NULL
		OR
		sale_date IS NULL 
		OR
		sale_time IS NULL
		OR
		customer_id IS NULL 
		OR
		gender IS NULL
		OR
		category IS NULL
		OR
		quantiy IS NULL
		OR
		price_per_unit IS NULL
		OR
		cogs IS NULL
		OR
		total_sale IS NULL;

-- IF IT CONTAINS NULL VALUES THEN WE REMOVE THE ROWS FROM THE TABLE TABLE
DELETE FROM retail_sales
	WHERE
	transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id IS NULL
	OR
	gender IS NULL 
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-----------------------------------DATA EXPLORATION-----------------------------------

--HOW MANY SALES WE HAVE ?
SELECT 
	COUNT(*) AS total_sales
FROM retail_sales;

--HOW MANY UNIQUE CUSTOMERS WE HAVE??
SELECT
	count(DISTINCT customer_id) AS total_customers
FROM retail_sales;

--HOW MANY UNIQUE CATEGORY WE HAVE ??
SELECT 
	COUNT(DISTINCT category) AS total_categories
FROM retail_sales;

----------------DATA ANALYSIS AND BUSINEES KEY PROBLEMS AND ANSWES

--Q.1 WRITE A SQL QUERY TO RETRIEVE ALL CLOUMNS  FOR SALES MADE ON '2022-11-05'

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q.2 WRITE A SQL QUERY TO RETRIEVE ALL TRANSACATIONS WHERE THE CATEGORY IS 'Clothing' AND QUANTITY IS SOLD MORE THAN 4 IN MONTH OF 'Nov -2022'.

SELECT 
*
FROM retail_sales 
WHERE 
	category ='Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM')='2022-11'
	AND quantiy >= 4;

--Q.3 WRITE A SQL QUERY TO CALCULATE TOTAL SALES (total_sales) FOR EACH CATEGORY AND COUNT TOTALS ORDERS.
SELECT 
	category,
	SUM(total_sale) AS net_sales,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category ; --or GROUP BY 1;

--Q.4 WRITE A SQL QUERY TO FIND AVERAGE AGE OF CUSTOMER WHO PURCHASED ITEM FROM THE 'beauty' CATEGORY.

SELECT 
	ROUND(AVG(age),2) as avg_age
FROM retail_sales 
WHERE category = 'Beauty';

--Q.5 WRITE A SQL QUERY TO FIND ALL TRANSACTIONS WHERE TOTAL SALES IS GREATER THAN 1000.
SELECT 
*
FROM retail_sales
WHERE total_sale > 1000;

--Q.6 WRITE  A SQL QUERY TO FIND TOTAL NUMBER OF TRANSACTION MADE BY EACH GENDER IN EACH CATEGORY.
 SELECT 
 	COUNT(transactions_id) as total_transaction,
	 gender,category
FROM retail_sales
GROUP BY gender , category;

--Q.7 WRITE A SQL QUERY TO CALCULATE AVGERAGE SALES FOR EACH MONTH . FIND OUT BEST SELLING MONTH IN EACH YEAR.
SELECT 
   year,
   month,
   avg_sale
FROM(
		SELECT 
			EXTRACT(YEAR FROM sale_date) as year,
			EXTRACT(MONTH FROM sale_date) as month,
			AVG(total_sale) as avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
		FROM retail_sales
		GROUP BY 1,2
)as t1
where rank =1;


--Q.8 WRITE A SQL QUERY TO FIND THE TOP 5 CUSTOMERS  BASED ON THEIR HIGHEST TOTAL_SALE.
SELECT 
	customer_id ,
	SUM(total_sale) as Total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2
LIMIT 5;

--Q.9 WRITE A SQL QUERY  TO FIND THE NUMBER  OF UNIQUE CUSTOMER WHO PURCHASED ITEMS FROM EACH CATEGORY.
SELECT 
	COUNT(DISTINCT customer_id) as customers ,
	category
FROM retail_sales
GROUP BY category;

--Q.10 WRITE A SQL QUERY TO CREATE EACH SHIFT AND NUMBERS OF ORDERS (EXAMPLE MORNING <=12 ,  AFTERNOON  BETWEEN 12&17, EVENING >17)
WITH hourly_sale
AS(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time)< 12 THEN 'MORNING'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
		ELSE 'EVENING'
	END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) as total_orders FROM hourly_sale
GROUP BY shift;



---------------------------END OF THE PROJECT----------------------------



