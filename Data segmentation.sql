-- segment products into cost ranges and count how many products fall into each range
WITH product_segments AS(
select 
product_key,
product_name, 
cost,
CASE WHEN cost < 100 THEN 'Below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	 WHEN COST BETWEEN 500 AND 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END cost_range
from gold.dim_products)

select cost_range, count(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products desc
