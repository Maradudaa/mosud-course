select order_id, order_delivered_customer_date, order_estimated_delivery_date
from olist.orders
where order_delivered_customer_date> order_estimated_delivery_date;

with projected_orders as (
    select
        order_id,
        order_delivered_customer_date,
        order_estimated_delivery_date
    from olist.orders
)
select order_id, order_delivered_customer_date, order_estimated_delivery_date
from projected_orders
where order_delivered_customer_date > order_estimated_delivery_date;

select count(*)
from (
    select order_id, order_delivered_customer_date, order_estimated_delivery_date
    from olist.orders
    where order_delivered_customer_date > order_estimated_delivery_date
);

select count(*)
from (
    select distinct order_id, order_delivered_customer_date, order_estimated_delivery_date
    from olist.orders
    where order_delivered_customer_date > order_estimated_delivery_date
);