-- Group customers based on 3 segments depending on their spending behaviour
 -- VIP: Customers with at least 12 motnths of history and spending more than 5000
 -- Regular:  Atleast 12 months of history but spending less tahn 5000
 -- New: Customers with history of less than 12 months
 -- Find the tutal number of customers in each group

 WITH customer_spending AS(
 SELECT c.customer_key, SUM(f.sales_amount) as total_spending, MIN(order_date) AS first_order, MAX(order_date) AS last_order, 
 DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
 from gold.fact_sales f
 LEFT JOIN gold.dim_customers c
 ON f.customer_key = c.customer_key
 GROUP BY c.customer_key
 )

 SELECT customer_segment, COUNT(customer_key) AS total_customers FROM(
 SELECT customer_key, total_spending, lifespan, 
 CASE WHEN lifespan >= 12 AND total_spending>5000 THEN 'VIP'
      WHEN lifespan >= 12 AND total_spending<5000 THEN 'Regular'
	  ELSE 'New'
END customer_segment
FROM customer_spending ) Segment
GROUP BY customer_segment
ORDER BY total_customers DESC;

