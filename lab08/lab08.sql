create table lab.disputes (
    dispute_id integer generated always as identity,

    order_id text not null,

    reason text not null,

    status text not null,

    opened_at timestamp not null,

    constraint pk_disputes
        primary key (dispute_id),

    constraint fk_disputes_order
        foreign key (order_id)
        references olist.orders(order_id),

    constraint ck_disputes_status
        check (status in ('open', 'in_progress', 'resolved', 'rejected')),

    constraint ck_disputes_reason
        check (length(trim(reason)) > 0)
);

create table lab.dispute_messages (
    message_id integer generated always as identity,

    dispute_id integer not null,

    seller_id text,

    message_text text not null,

    created_at timestamp not null,

    constraint pk_dispute_messages
        primary key (message_id),

    constraint fk_dispute_messages_dispute
        foreign key (dispute_id)
        references lab.disputes(dispute_id),

    constraint fk_dispute_messages_seller
        foreign key (seller_id)
        references olist.sellers(seller_id)
);


create table lab.dispute_status_history (
    history_id integer generated always as identity,
    dispute_id integer not null,
    status text not null,
    changed_at timestamp not null,

    constraint pk_dispute_status_history
        primary key (history_id),

    constraint fk_dispute_status_history_dispute
        foreign key (dispute_id)
        references lab.disputes(dispute_id),

    constraint ck_dispute_status_history_status
        check (status in ('open', 'in_progress', 'resolved', 'rejected'))
);

alter table lab.dispute_status_history
add constraint uq_dispute_status_history_time
unique (dispute_id, changed_at);

select order_id
from olist.orders
limit 5;

select seller_id
from olist.sellers
limit 5;

insert into lab.disputes (
    order_id,
    reason,
    status,
    opened_at
)
values
    ('e481f51cbdc54678b7cc49136f2d6af7', 'Товар не получен', 'open', '2026-11-01 10:00:00'),
    ('53cdb2fc8bc7dce0b6741e2150273451', 'Товар поврежден', 'in_progress', '2026-11-01 11:00:00'),
    ('47770eb9100c2d0c44946d9cf07ec65d', 'Неверный товар', 'resolved', '2026-11-02 09:30:00'),
    ('949d5b44dbf5de918fe9c16f97b45f8a', 'Проблема с оплатой', 'rejected', '2026-11-02 12:00:00'),
    ('ad21c59c0840e6cb83a9ceb5573f8159', 'Заказ не соответствует описанию', 'open', '2026-11-03 15:00:00');


select *
from lab.disputes;

insert into lab.dispute_messages (
    dispute_id,
    seller_id,
    message_text,
    created_at
)
values
    (1, '3442f8959a84dea7ee197c632cb2df15', 'Получено обращение по заказу', '2026-11-01 10:15:00'),
    (1, null, 'Покупатель уточнил детали проблемы', '2026-11-01 10:30:00'),
    (2, 'd1b65fc7debc3361ea86b5f14c68d2e2', 'Продавец запросил фотографии повреждения', '2026-11-01 11:20:00'),
    (3, null, 'Покупатель подтвердил получение решения', '2026-11-02 10:00:00'),
    (4, 'ce3ad9de960102d0677a81f5d0bb7b2d', 'Продавец предоставил информацию по оплате', '2026-11-02 12:30:00');

select *
from lab.dispute_messages
order by message_id;

select dispute_id, status
from lab.disputes
order by dispute_id;

insert into lab.dispute_status_history (
    dispute_id,
    status,
    changed_at
)
values
    (1, 'open', '2026-11-01 10:00:00'),
    (1, 'in_progress', '2026-11-01 12:00:00'),
    (2, 'in_progress', '2026-11-01 11:00:00'),
    (3, 'resolved', '2026-11-02 09:30:00'),
    (4, 'rejected', '2026-11-02 12:00:00');

select *
from lab.dispute_status_history
order by history_id;

select
    table_schema,
    table_name
from information_schema.tables
where table_schema = 'lab'
  and table_name in (
      'disputes',
      'dispute_messages',
      'dispute_status_history'
  )
order by table_name;


select
    tc.table_name,
    tc.constraint_name,
    tc.constraint_type
from information_schema.table_constraints tc
where tc.table_schema = 'lab'
  and tc.table_name in (
      'disputes',
      'dispute_messages',
      'dispute_status_history'
  )
order by tc.table_name, tc.constraint_type, tc.constraint_name;