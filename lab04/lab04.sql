select customer_state, product_category_name, avg(freight_value) as avg_freight_value
from olist.customers c join olist.orders o --1:N
on o.customer_id = c.customer_id join olist.order_items oi --1:N
on oi.order_id = o.order_id join olist.products p -- 1:N
on p.product_id = oi.product_id
group by
    c.customer_state,
    p.product_category_name
order by
    c.customer_state,
    p.product_category_name;

-- пустые заказы
select
    o.order_id
from olist.orders o
left join olist.order_items oi
    on oi.order_id = o.order_id
where oi.order_id is null;


-- верная сумма доставки 
select sum(oi.freight_value) as correct_freight_sum
from olist.orders o
join olist.order_items oi
    on oi.order_id = o.order_id;

--сумма доставки с размноженными строками (один заказ может содержать несколько платежей, заказы размножаются)
select sum(oi.freight_value) as wrong_freight_sum
from olist.orders o
join olist.order_items oi
    on oi.order_id = o.order_id
join olist.order_payments op
    on op.order_id = o.order_id;
