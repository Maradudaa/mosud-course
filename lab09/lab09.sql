create table lab.nf_9_customers (
    customer_id text,
    customer_city text not null,

    constraint pk_nf_9_customers
        primary key (customer_id)
);

create table lab.nf_9_statuses (
    status_code text,
    status_name text not null,

    constraint pk_nf_9_statuses
        primary key (status_code),

    constraint uq_nf_9_status_name
        unique (status_name)
);

create table lab.nf_9_disputes (
    dispute_id integer,
    order_id text not null,
    customer_id text not null,
    status_code text not null,

    constraint pk_nf_9_disputes
        primary key (dispute_id),

    constraint fk_nf_9_disputes_customer
        foreign key (customer_id)
        references lab.nf_9_customers(customer_id),

    constraint fk_nf_9_disputes_status
        foreign key (status_code)
        references lab.nf_9_statuses(status_code)
);

create table lab.nf_9_messages (
    message_id integer,
    dispute_id integer not null,
    created_at timestamp not null,

    constraint pk_nf_9_messages
        primary key (message_id),

    constraint fk_nf_9_messages_dispute
        foreign key (dispute_id)
        references lab.nf_9_disputes(dispute_id)
);

insert into lab.nf_9_customers (
    customer_id,
    customer_city
)
values
    ('C1', 'Moscow'),
    ('C2', 'Kazan'),
    ('C3', 'Moscow');

insert into lab.nf_9_statuses (
    status_code,
    status_name
)
values
    ('OPEN', 'Open'),
    ('IN_PROGRESS', 'In progress'),
    ('RESOLVED', 'Resolved');

insert into lab.nf_9_disputes (
    dispute_id,
    order_id,
    customer_id,
    status_code
)
values
    (1, 'ORDER1', 'C1', 'OPEN'),
    (2, 'ORDER2', 'C1', 'IN_PROGRESS'),
    (3, 'ORDER3', 'C2', 'RESOLVED'),
    (4, 'ORDER4', 'C3', 'OPEN');


insert into lab.nf_9_messages (
    message_id,
    dispute_id,
    created_at
)
values
    (101, 1, '2026-11-01 10:00:00'),
    (102, 1, '2026-11-01 11:00:00'),
    (103, 2, '2026-11-02 09:00:00'),
    (104, 3, '2026-11-03 12:00:00'),
    (105, 4, '2026-11-04 14:00:00');


select * from lab.nf_9_customers;
select * from lab.nf_9_statuses;
select * from lab.nf_9_disputes;
select * from lab.nf_9_messages;