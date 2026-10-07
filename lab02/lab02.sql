-- для A
select count(*), count(DISTINCT product_id) as distinct_products
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered';

-- для B 
select count(*), count(DISTINCT product_id) as distinct_products
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered';

-- множество union a и b  (объединение) (множество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
union 
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
);

-- множество union b и a (объединение) (мультимножество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
union 
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
);

-- множество union all (мультимножество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
union all
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
);

-- intersect a и b (пересечение) (множество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
intersect
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
);

-- intersect b и a (пересечение) (множество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
intersect
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
);

-- except a-b (множество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
except
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
);

-- except b-a (множество)
select count(*)
from (
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'AM'  and o.order_status = 'delivered'
except
select oi.product_id 
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'  and o.order_status = 'delivered'
);

-- EXISTS вместо INTERSECT (без повторов) (множество)
select count(*)
from (
select distinct oi.product_id
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'
  and o.order_status = 'delivered'
  and exists (
      select 1
      from olist.order_items oi2
      join olist.orders o2
          on o2.order_id = oi2.order_id
      join olist.customers c2
          on c2.customer_id = o2.customer_id
      where c2.customer_state = 'AM'
        and o2.order_status = 'delivered'
        and oi2.product_id = oi.product_id
  )
  );

-- EXISTS вместо INTERSECT (с повтороами) (мультимножество)
select count(*)
from (
select  oi.product_id
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
where c.customer_state = 'PA'
  and o.order_status = 'delivered'
  and exists (
      select 1
      from olist.order_items oi2
      join olist.orders o2
          on o2.order_id = oi2.order_id
      join olist.customers c2
          on c2.customer_id = o2.customer_id
      where c2.customer_state = 'AM'
        and o2.order_status = 'delivered'
        and oi2.product_id = oi.product_id
  )
  );