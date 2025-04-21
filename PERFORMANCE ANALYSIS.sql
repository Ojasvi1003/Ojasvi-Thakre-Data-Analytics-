-- Analyse yearly performance of products by comparing their sales to avg sales performance of the product and prev year sales
select * from gold.fact_sales;
select * from gold.dim_products;
WITH yearly_product_sales AS 
(
SELECT YEAR(s.order_date) AS order_year, p.product_name, SUM(s.sales_amount) AS current_sales FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
ON s.product_key=p.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(s. order_date), p.product_name
)

SELECT * , 
AVG(current_sales) OVER (PARTITION BY product_name) AS average_sales,
current_sales - AVG(current_sales) over(partition by product_name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) over(partition by product_name)>0 THEN 'Above Average'
     WHEN current_sales - AVG(current_sales) over(partition by product_name)<0 THEN 'Below Average'
	 ELSE 'AVG'
END avg_change,
LAG(current_sales) OVER (PARTITION BY product_name order by order_year) AS Prev_yr_sales,
current_sales - LAG(current_sales) over(partition by product_name order by order_year) AS diff_prev_yr_sales,
CASE WHEN current_sales - LAG(current_sales) over(partition by product_name order by order_year)>0 THEN 'Increase'
     WHEN current_sales - LAG(current_sales) over(partition by product_name order by order_year)<0 THEN 'Decrease'
	 ELSE 'No Change'
END prev_yr_change
FROM yearly_product_sales
order by product_name, order_year;