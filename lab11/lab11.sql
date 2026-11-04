create table lab.geo_tree (
   node_id text primary key,
   parent_id text references lab.geo_tree(node_id),
   node_type text not null check (node_type in ('country','state','city')),
   node_name text not null
);

insert into lab.geo_tree
values ('BR', null, 'country', 'Brazil');

insert into lab.geo_tree(node_id, parent_id, node_type, node_name)
select
    'ST:' || customer_state,
    'BR',
    'state',
    customer_state
from olist.customers
group by customer_state;

with city_counts as (
    select
        customer_state,
        customer_city,
        count(*) as customers_count
    from olist.customers
    group by
        customer_state,
        customer_city
),

ranked_cities as (
    select
        customer_state,
        customer_city,
        customers_count,
        row_number() over (
            partition by customer_state
            order by customers_count desc
        ) as rn
    from city_counts
)

insert into lab.geo_tree (
    node_id,
    parent_id,
    node_type,
    node_name
)
select
    'CITY:' || customer_state || ':' || customer_city,
    'ST:' || customer_state,
    'city',
    customer_city
from ranked_cities
where rn <= 20;


create or replace view lab.v_order_summary as
select
    o.order_id,
    c.customer_state,
    count(oi.order_item_id) as items_count,
    sum(oi.price + oi.freight_value) as total_amount
from olist.orders o
join olist.customers c
    on c.customer_id = o.customer_id
join olist.order_items oi
    on oi.order_id = o.order_id
group by
    o.order_id,
    c.customer_state;

select *
from lab.v_order_summary
limit 20;

create materialized view lab.mv_monthly_state_sales as
select
    date_trunc('month', o.order_purchase_timestamp) as month,
    c.customer_state,
    count(distinct o.order_id) as orders_count,
    sum(oi.price + oi.freight_value) as total_amount
from olist.orders o
join olist.customers c
    on c.customer_id = o.customer_id
join olist.order_items oi
    on oi.order_id = o.order_id
group by
    date_trunc('month', o.order_purchase_timestamp),
    c.customer_state;

refresh materialized view lab.mv_monthly_state_sales;


select *
from lab.mv_monthly_state_sales
order by month, customer_state
limit 20;


with order_totals as (
    select
        o.order_id,
        o.customer_id,
        date_trunc('month', o.order_purchase_timestamp) as month,
        sum(oi.price + oi.freight_value) as order_total
    from olist.orders o
    join olist.order_items oi
        on oi.order_id = o.order_id
    group by
        o.order_id,
        o.customer_id,
        date_trunc('month', o.order_purchase_timestamp)
),

orders_with_state as (
    select
        ot.order_id,
        ot.month,
        c.customer_state,
        ot.order_total
    from order_totals ot
    join olist.customers c
        on c.customer_id = ot.customer_id
),

state_month_stats as (
    select
        month,
        customer_state,
        count(*) as orders_count,
        sum(order_total) as total_sales,
        avg(order_total) as avg_order_value
    from orders_with_state
    group by
        month,
        customer_state
)

select *
from state_month_stats
order by month, customer_state;

with recursive geo_subtree as (

    -- Базовая часть (начинаем со штата CE)
    select
        node_id,
        parent_id,
        node_type,
        node_name,
        0 as depth,
        node_name::text as path
    from lab.geo_tree
    where node_id = 'ST:CE'

    union all

    -- Рекурсивная часть (ищем детей найденных узлов)
    select
        g.node_id,
        g.parent_id,
        g.node_type,
        g.node_name,
        s.depth + 1,
        s.path || ' -> ' || g.node_name
    from lab.geo_tree g
    join geo_subtree s
        on g.parent_id = s.node_id
)

select
    depth,
    node_id,
    path,
    node_name
from geo_subtree
order by depth, node_name;

with recursive geo_ancestors as (

    -- Базовая часть (начинаем с выбранного города)
    select
        node_id,
        parent_id,
        node_type,
        node_name,
        0 as depth,
        node_name::text as path
    from lab.geo_tree
    where node_id = 'CITY:CE:fortaleza'

    union all

    -- Рекурсивная часть (идём к родителю)
    select
        g.node_id,
        g.parent_id,
        g.node_type,
        g.node_name,
        a.depth + 1,
        a.path || ' -> ' || g.node_name
    from lab.geo_tree g
    join geo_ancestors a
        on g.node_id = a.parent_id
)

select
    depth,
    node_id,
    path,
    node_name
from geo_ancestors
order by depth;

with recursive descendants as (

    -- все штаты как стартовые узлы
    select
        node_id as state_id,
        node_id,
        0 as depth
    from lab.geo_tree
    where node_type = 'state'

    union all

    -- потомки каждого штата
    select
        d.state_id,
        g.node_id,
        d.depth + 1
    from descendants d
    join lab.geo_tree g
        on g.parent_id = d.node_id
)

select
    state_id,
    count(*) filter (where depth > 0) as descendants_count
from descendants
group by state_id
order by state_id;
