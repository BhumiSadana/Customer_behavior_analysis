
select * from customer;

select gender,sum(purchase_amount) as revenue
from customer
group by gender;

select customerid,purchase_amount 
from customer
where discountapplied='Yes' and purchase_amount>(select avg(purchase_amount) from customer)

select itempurchased,avg(reviewrating) as "Average Product Rating"
from customer
group by itempurchased
order by ROUND(avg(reviewrating::numeric),2) desc
limit 5;

select shippingtype,
ROUND(avg(purchase_amount),2)
from customer
where shippingtype in ('Standard','Express')
group by shippingtype

select subscriptionstatus,count(customerid) as total_customers,
ROUND(avg(purchase_amount),2) as avg_spent,
ROUND(sum(purchase_amount),2) as total_revenue
from customer
group by subscriptionstatus
order by avg_spent,total_revenue desc;

select itempurchased,
ROUND(100*SUM(CASE WHEN discountapplied ='Yes' THEN 1 ELSE 0 END)/COUNT(*),2) as discount_rate
from customer
group by itempurchased
order by discount_rate desc
limit 5;

with customer_type as(
select customerid,previouspurchases,
CASE
  WHEN previouspurchases=1 THEN 'New'
  WHEN previouspurchases BETWEEN 2 AND 10 THEN 'Returning'
  ELSE 'Loyal'
  END AS customer_segment
from customer  
  
)

select customer_segment,count(*) as "Number of Customers"
from customer_type
group by customer_segment

with item_counts as(
select category,
itempurchased,
count(*) as total_orders,
row_number() over(partition by category order by count(customerid) desc) as item_rank
from customer
group by category,itempurchased
)

select item_rank,category,itempurchased,total_orders
from item_counts
where item_rank<=3;

select subscriptionstatus,
count(customerid) as repeat_buyers
from customer
where previouspurchases> 5
group by subscriptionstatus;


select age_group,
sum(purchase_amount) as total_reveue
from customer
group by age_group
order by total_reveue desc;



