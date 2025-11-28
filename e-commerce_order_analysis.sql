-- CREATE TABLE
CREATE TABLE orders (
    order_id int primary key,
    order_date DATE,
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code int,
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    product_id VARCHAR(50),
    quantity INT,
    discount DECIMAL(7, 2),
    sales_price DECIMAL(7, 2),
    profit DECIMAL(7, 2)
);



-- VIEW TABLE
SELECT * FROM orders;




-- FIND TOP 10 HIGHEST REVENUE GENERATING PRODUCTS
select product_id,sum(quantity * sales_price) as total_revenue
from orders
group by product_id
order by total_revenue DESC
LIMIT 10;





-- FIND TOP 5 HIGHEST SELLING PROUDCTS IN EACH REGION
with cte as (
SELECT region,product_id, SUM(sales_price) AS sales
FROM orders
GROUP BY region,product_id)
SELECT * from (
select *,
row_number() over (partition by region order by sales DESC) as rn
from cte) A
where rn<=5;




--- FIND MONTH OVER MONTH GROWTH COMPARISON FOR 2022 AND 2023 SALES eg; JAN 2022 VS JAN 2023
WITH cte as(
select extract (year from order_date) as order_year,extract (month from order_date) as order_month,
sum(sales_price) as sales
from orders
group by extract( year from order_date),extract (month from order_date)
--order by year(order_date), month(order_date)
)
select order_month
, sum (case when order_year=2022 then sales else 0 end) as sales_2022
, sum (case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by order_month
order by order_month;






-- FOR EACH CATEGORY WHICH MONTH HAD THE HIGHEST SALES
with cte as (
select category, TO_CHAR(order_date,'yyymm') as order_year_month
, sum(sales_price) as sales
from orders
group by category,TO_CHAR(order_date,'yyymm')
--order by category,format(order_date,('yyymm')
)
select *
FROM (
SELECT *,
row_number()over(partition by category order by sales DESC) as rn
from cte
) t
WHERE rn = 1;





 -- FOR EACH CATEGORY WHICH MONTH HAD THE LOWEST SALES
 with cte as (
select category, TO_CHAR(order_date,'yyymm') as order_year_month
, sum(sales_price) as sales
from orders
group by category,TO_CHAR(order_date,'yyymm')
--order by category,format(order_date,('yyymm')
)
select *
FROM (
SELECT *,
row_number()over(partition by category order by sales ASC) as rn
from cte
) t
WHERE rn = 1;






-- WHICH SUB_CATEGORY SAW THE HIGEST SALES
WITH cte as(
select sub_category, EXTRACT ( YEAR from order_date) as order_year,
sum(sales_price) as sales
from orders
group by sub_category, EXTRACT ( YEAR from order_date)
--order by year(order_date), month(order_date)
)
select sub_category
, sum (case when order_year=2022 then sales else 0 end) as sales_2022
, sum (case when order_year=2023 then sales else 0 end) as sales_2023
from cte
group by sub_category
order by (SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) +
SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END )) DESC
LIMIT 1;







)