-- Which categories contribute the most to overall sales?
select * from gold.fact_sales;
select * from gold.dim_products;

with category_sales AS(
select category, SUM(sales_amount) AS total_sales
from gold.fact_sales s
LEFT JOIN gold.dim_products p
ON p.product_key=s.product_key
GROUP BY category)

SELECT category, total_sales, 
SUM(total_sales) OVER() AS overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/(sum(total_sales) OVER()))*100,2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;