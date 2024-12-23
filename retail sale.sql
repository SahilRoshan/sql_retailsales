-- sql retail sales -p1
create database sql_project_1;

-- create table
drop table if exists retail_sales;
create table retail_sales(
transactions_id	int primary key , 
sale_date Date,
sale_time	time,
customer_id	int,
gender	varchar(15),
age	int null,
category varchar(15),
quantiy	int null,
price_per_unit	float null,
cogs float null,
total_sale float null
);

-- selecting specific customer detailss
select*from retail_sales
where transactions_id=1679;

select count(*)from retail_sales;

-- Data exploration
select count(distinct customer_id ) as unique_customer from retail_sales;

select distinct(category) from retail_sales;

-- category as clothing in month of november having quantiy greater than 3
select * from retail_sales
where category='Clothing' and date_format(sale_date, '%Y-%m')='2022-11' and quantiy>3 ;

-- categiry wise total sale
select category as  Category,sum(total_sale) as Total,count(*) as orders from retail_sales
group by Category;

-- in catrgory of beauty average age
select round(avg(age),2) from retail_sales
where category='Beauty';

-- all sales greater than 1000
select * from retail_sales
where total_sale>1000;

-- transactions as category and gender wise
select category,gender,count(*) as total_transaction from retail_sales
group by category,gender
order by gender;


-- In year which month average sales is highest
select
  Year,Month,per_month_sale
from(
select YEAR(sale_date) as Year,MONTH(sale_date) as Month ,avg(total_sale) as per_month_sale ,
rank() over(partition by YEAR(sale_date) order by avg(total_sale) desc) as Rannk from retail_sales
group by 1,2
)as t1
where Rannk=1 ;


-- shift wise sales as morning afternoon evening

With
 hourly_sales as
 (
select *,
case
     when hour(sale_time) < 12 then 'morning'
     when hour(sale_time) between 12 and 17 then 'afternoon'
     else 'evening'
  end as shift
from retail_sales)

select shift,
count(*) as total_orders
from hourly_sales
group by shift

--end --