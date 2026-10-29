with target_states(state) as (
    values
        ('PB'),
        ('RN'),
        ('PE')
)


select distinct p.product_category_name
from olist.products p
where p.product_category_name is not null
  and not exists (
      select 1
      from target_states ts
      where not exists (
          select 1
          from olist.order_items oi
          join olist.orders o
              on o.order_id = oi.order_id
          join olist.customers c
              on c.customer_id = o.customer_id
          join olist.products p2
              on p2.product_id = oi.product_id
          where o.order_status = 'delivered'
            and c.customer_state = ts.state
            and p2.product_category_name = p.product_category_name
      )
  );



with target_states(state) as (
    values
        ('PB'),
        ('RN'),
        ('PE')
)
select
    p.product_category_name
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
join olist.products p
    on p.product_id = oi.product_id
join target_states ts
    on ts.state = c.customer_state
where o.order_status = 'delivered'
  and p.product_category_name is not null
group by p.product_category_name
having count(distinct c.customer_state) = 3
);


with target_states(state) as (
    values
        ('PB'),
        ('RN'),
        ('PE')
),

category_states as (
    select distinct
        p.product_category_name,
        c.customer_state
    from olist.order_items oi
    join olist.orders o
        on o.order_id = oi.order_id
    join olist.customers c
        on c.customer_id = o.customer_id
    join olist.products p
        on p.product_id = oi.product_id
    where o.order_status = 'delivered'
      and p.product_category_name is not null
),

categories as (
    select distinct product_category_name
    from category_states
)

select c.product_category_name
from categories c
where not exists (
    (
        select state
        from target_states
    )
    except
    (
        select cs.customer_state
        from category_states cs
        where cs.product_category_name = c.product_category_name
    )
);





with target_states(state) as (
    values
        ('PB'),
        ('RN'),
        ('PE')
),

result_not_exists as (
    select distinct
        p.product_category_name
    from olist.products p
    where p.product_category_name is not null
      and not exists (
          select 1
          from target_states ts
          where not exists (
              select 1
              from olist.order_items oi
              join olist.orders o
                  on o.order_id = oi.order_id
              join olist.customers c
                  on c.customer_id = o.customer_id
              join olist.products p2
                  on p2.product_id = oi.product_id
              where o.order_status = 'delivered'
                and c.customer_state = ts.state
                and p2.product_category_name = p.product_category_name
          )
      )
),

result_group_by as (
    select
        p.product_category_name
    from olist.order_items oi
    join olist.orders o
        on o.order_id = oi.order_id
    join olist.customers c
        on c.customer_id = o.customer_id
    join olist.products p
        on p.product_id = oi.product_id
    join target_states ts
        on ts.state = c.customer_state
    where o.order_status = 'delivered'
      and p.product_category_name is not null
    group by p.product_category_name
    having count(distinct c.customer_state) = (
        select count(*)
        from target_states
    )
),

category_states as (
    select distinct
        p.product_category_name,
        c.customer_state
    from olist.order_items oi
    join olist.orders o
        on o.order_id = oi.order_id
    join olist.customers c
        on c.customer_id = o.customer_id
    join olist.products p
        on p.product_id = oi.product_id
    where o.order_status = 'delivered'
      and p.product_category_name is not null
),

categories as (
    select distinct product_category_name
    from category_states
),

result_except as (
    select c.product_category_name
    from categories c
    where not exists (
        (
            select state
            from target_states
        )
        except
        (
            select cs.customer_state
            from category_states cs
            where cs.product_category_name = c.product_category_name
        )
    )
)

select 'not_exists_minus_group_by' as check_name, product_category_name
from (
    select product_category_name
    from result_not_exists
    except
    select product_category_name
    from result_group_by
) differences

union all

select 'group_by_minus_not_exists', product_category_name
from (
    select product_category_name
    from result_group_by
    except
    select product_category_name
    from result_not_exists
) differences

union all

select 'not_exists_minus_except', product_category_name
from (
    select product_category_name
    from result_not_exists
    except
    select product_category_name
    from result_except
) differences

union all

select 'except_minus_not_exists', product_category_name
from (
    select product_category_name
    from result_except
    except
    select product_category_name
    from result_not_exists
) differences;


with target_states(state) as (
    values
        ('PB'),
        ('RN'),
        ('PE')
)
select
    p.product_category_name,
    c.customer_state,
    count(distinct o.order_id) as orders_count
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
join olist.products p
    on p.product_id = oi.product_id
join target_states ts
    on ts.state = c.customer_state
where o.order_status = 'delivered'
  and p.product_category_name = 'alimentos'
group by
    p.product_category_name,
    c.customer_state
order by
    c.customer_state;


with target_states(state) as (
    select null::text
    where false
)

select distinct
    p.product_category_name
from olist.products p
where p.product_category_name is not null
  and not exists (
      select 1
      from target_states ts
      where not exists (
          select 1
          from olist.order_items oi
          join olist.orders o
              on o.order_id = oi.order_id
          join olist.customers c
              on c.customer_id = o.customer_id
          join olist.products p2
              on p2.product_id = oi.product_id
          where o.order_status = 'delivered'
            and c.customer_state = ts.state
            and p2.product_category_name = p.product_category_name
      )
  );


with target_states(state) as (
    values
        ('PB'),
        ('RN'),
        ('PE')
)
select
    oi.seller_id
from olist.order_items oi
join olist.orders o
    on o.order_id = oi.order_id
join olist.customers c
    on c.customer_id = o.customer_id
join target_states ts
    on ts.state = c.customer_state
where o.order_status = 'delivered'
group by oi.seller_id
having count(distinct c.customer_state) = (
    select count(*)
    from target_states
);