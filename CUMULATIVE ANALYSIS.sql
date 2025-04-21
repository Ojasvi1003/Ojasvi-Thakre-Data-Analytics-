SELECT order_date, total_sales, 
       SUM(total_sales) OVER (PARTITION BY (DATETRUNC(YEAR, order_date)) ORDER BY order_date) AS running_total_sales
FROM (
    SELECT DATETRUNC(month, order_date) AS order_date, 
           SUM(sales_amount) AS total_sales 
    FROM gold.fact_sales 
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) AS running_total; 
-- If you don’t put a label on the table (alias), the SQL engine doesn’t know what to call it. Every "from" has to have a table name

SELECT order_date, total_sales, 
       SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
	   AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price
FROM (
    SELECT DATETRUNC(month, order_date) AS order_date, 
           SUM(sales_amount) AS total_sales,
		   AVG(price) as avg_price
    FROM gold.fact_sales 
    WHERE order_date IS NOT NULL
    GROUP BY DATETRUNC(month, order_date)
) AS moving_avg; 

SELECT * FROM gold.fact_sales;
