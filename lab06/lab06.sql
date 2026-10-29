select
    c.customer_state,
    avg(o.order_delivered_customer_date - o.order_purchase_timestamp) as avg_delivery_time
from olist.orders o
join olist.customers c
    on c.customer_id = o.customer_id
where o.order_status = 'delivered'
group by c.customer_state
having avg(o.order_delivered_customer_date - o.order_purchase_timestamp) >
       (
           select avg(order_delivered_customer_date - order_purchase_timestamp)
           from olist.orders
           where order_status = 'delivered'
       );


-- 1 подзапрос коррелированный (customer_state)
select distinct
    c.customer_state
from olist.customers c
where (
    select avg(o.order_delivered_customer_date - o.order_purchase_timestamp)
    from olist.orders o
    join olist.customers c2
        on c2.customer_id = o.customer_id
    where c2.customer_state = c.customer_state
      and o.order_status = 'delivered'
) > (
    select avg(order_delivered_customer_date - order_purchase_timestamp)
    from olist.orders
    where order_status = 'delivered'
);




with state_avg as (
    select
        c.customer_state,
        avg(o.order_delivered_customer_date - o.order_purchase_timestamp) as avg_delivery_time
    from olist.orders o
    join olist.customers c
        on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_state
),

overall_avg as (
    select
        avg(order_delivered_customer_date - order_purchase_timestamp) as avg_delivery_time
    from olist.orders
    where order_status = 'delivered'
)

select
    s.customer_state,
    s.avg_delivery_time
from state_avg s
cross join overall_avg a
where s.avg_delivery_time > a.avg_delivery_time;



with states as (
    select distinct customer_state
    from olist.customers
),

result_subquery as (
    select
        s.customer_state
    from states s
    where (
        select avg(o.order_delivered_customer_date - o.order_purchase_timestamp)
        from olist.orders o
        join olist.customers c
            on c.customer_id = o.customer_id
        where c.customer_state = s.customer_state
          and o.order_status = 'delivered'
    ) > (
        select avg(order_delivered_customer_date - order_purchase_timestamp)
        from olist.orders
        where order_status = 'delivered'
    )
),

state_avg as (
    select
        c.customer_state,
        avg(o.order_delivered_customer_date - o.order_purchase_timestamp) as avg_delivery_time
    from olist.orders o
    join olist.customers c
        on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_state
),

overall_avg as (
    select
        avg(order_delivered_customer_date - order_purchase_timestamp) as avg_delivery_time
    from olist.orders
    where order_status = 'delivered'
),

result_cte as (
    select
        s.customer_state
    from state_avg s
    cross join overall_avg a
    where s.avg_delivery_time > a.avg_delivery_time
)

select 'subquery_minus_cte' as check_name, customer_state
from (
    select customer_state
    from result_subquery
    except
    select customer_state
    from result_cte
) differences

union all

select 'cte_minus_subquery', customer_state
from (
    select customer_state
    from result_cte
    except
    select customer_state
    from result_subquery
) differences;



-- штаты, у которых средняя доставка больше средней доставки каждого из некоторого набора штатов
with state_avg as (
    select
        c.customer_state,
        avg(o.order_delivered_customer_date - o.order_purchase_timestamp) as avg_delivery_time
    from olist.orders o
    join olist.customers c
        on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_state
)

select
    s.customer_state,
    s.avg_delivery_time
from state_avg s
where s.avg_delivery_time > all (
    select s2.avg_delivery_time
    from state_avg s2
    where s2.customer_state in ('SP', 'RJ', 'MG')
);