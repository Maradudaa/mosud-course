select
    count(*) filter (where order_status is null) as order_status_nulls,
    count(*) filter (where order_purchase_timestamp is null) as purchase_nulls,
    count(*) filter (where order_approved_at is null) as approved_nulls,
    count(*) filter (where order_delivered_carrier_date is null) as carrier_nulls,
    count(*) filter (where order_delivered_customer_date is null) as delivered_nulls,
    count(*) filter (where order_estimated_delivery_date is null) as estimated_nulls
from olist.orders;

select
    count(*) filter (where product_category_name is null) as category_nulls,
    count(*) filter (where product_name_lenght is null) as name_length_nulls,
    count(*) filter (where product_description_lenght is null) as description_length_nulls,
    count(*) filter (where product_photos_qty is null) as photos_nulls,
    count(*) filter (where product_weight_g is null) as weight_nulls,
    count(*) filter (where product_length_cm is null) as length_nulls,
    count(*) filter (where product_height_cm is null) as height_nulls,
    count(*) filter (where product_width_cm is null) as width_nulls
from olist.products;

select
    count(*) filter (where review_score is null) as score_nulls,
    count(*) filter (where review_comment_title is null) as title_nulls,
    count(*) filter (where review_comment_message is null) as message_nulls,
    count(*) filter (where review_creation_date is null) as creation_date_nulls,
    count(*) filter (where review_answer_timestamp is null) as answer_timestamp_nulls
from olist.order_reviews;


select
    count(*) as all_rows,
    count(order_delivered_customer_date) as delivered_date_count
from olist.orders;


select *
from olist.orders
where order_delivered_customer_date = null;


select *
from olist.orders
where order_delivered_customer_date is null;


select *
from olist.orders
where order_delivered_customer_date <> null;


select *
from olist.orders
where order_delivered_customer_date is not null;


select
    order_id,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    order_delivered_customer_date  is distinct from order_estimated_delivery_date as dates_are_different
from olist.orders
limit 20;


create temporary table temp_ids (
    id text
);
insert into temp_ids(id)
select order_id
from olist.orders
limit 1;

insert into temp_ids(id)
values (null);
select *
from temp_ids;

select count(*)
from olist.orders
where order_id not in (
    select id
    from temp_ids
);

select count(*)
from olist.orders o
where not exists (
    select 1
    from temp_ids t
    where t.id = o.order_id
);


select count(*) as rows_count
from olist.orders o
left join olist.order_reviews r
    on r.order_id = o.order_id
   and r.review_score >= 4;

select count(*) as rows_count
from olist.orders o
left join olist.order_reviews r
    on r.order_id = o.order_id
where r.review_score >= 4;


select
    review_id,
    coalesce(review_comment_message, 'Комментарий отсутствует') as comment_text
from olist.order_reviews
limit 20;

select
    count(review_comment_message)::numeric
    / nullif(count(*), 0) as comment_share
from olist.order_reviews;


select
    (
        select round(
            100.0 * count(*) filter (
                where order_delivered_customer_date is null
            ) / nullif(count(*), 0),
            2
        )
        from olist.orders
    ) as orders_without_delivery_date_pct,

    (
        select round(
            100.0 * count(*) filter (
                where product_category_name is null
            ) / nullif(count(*), 0),
            2
        )
        from olist.products
    ) as products_without_category_pct,

    (
        select round(
            100.0 * count(*) filter (
                where review_comment_message is null
            ) / nullif(count(*), 0),
            2
        )
        from olist.order_reviews
    ) as reviews_without_text_pct;