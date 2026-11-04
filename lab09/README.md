Исходное отношение:

dispute_flat(
    dispute_id,
    order_id,
    customer_id,
    customer_city,
    status_code,
    status_name,
    message_id,
    created_at
)

1. Функциональные зависимости

dispute_id → order_id, customer_id, status_code
customer_id → customer_city
status_code → status_name
message_id → dispute_id, created_at

2. Потенциальный ключ и замыкание

Замыкание message_id:

message_id⁺ = {message_id}

Из зависимости:

message_id → dispute_id, created_at

получаем dispute_id и created_at.

Далее из зависимости:

dispute_id → order_id, customer_id, status_code

получаем order_id, customer_id и status_code.

Из зависимостей:

customer_id → customer_city
status_code → status_name

получаем customer_city и status_name.

Итоговое замыкание:

message_id⁺ = {
    message_id,
    dispute_id,
    created_at,
    order_id,
    customer_id,
    customer_city,
    status_code,
    status_name
}

3. Частичные и транзитивные зависимости

Частичные зависимости отсутствуют, так как потенциальный ключ message_id состоит только из одного атрибута.

Присутствуют транзитивные зависимости:

message_id → dispute_id → customer_id → customer_city

message_id → dispute_id → status_code → status_name

4. Аномалии исходного отношения

INSERT-анomalия:
Нельзя независимо добавить новый статус и его название, если в таблице ещё нет спора или сообщения с данным статусом.

UPDATE-анomalия:
Название одного и того же статуса может повторяться во множестве строк. При его изменении необходимо обновить все строки. Если часть строк не обновить, данные станут противоречивыми.

Аналогичная проблема существует для customer_city, так как город одного клиента может повторяться во многих строках.

DELETE-анomalия:
Если удалить последнюю строку, содержащую определённый статус, можно одновременно потерять информацию о соответствии status_code и status_name.

5. Декомпозиция до 3НФ

Для устранения избыточности и транзитивных зависимостей исходное отношение было разделено на несколько отношений.

Шаг 1. Клиенты

Причина декомпозиции:

customer_id → customer_city

Создано отношение:

nf_9_customers(
    customer_id,
    customer_city
)

Шаг 2. Статусы

Причина декомпозиции:

status_code → status_name

Создано отношение:

nf_9_statuses(
    status_code,
    status_name
)

Шаг 3. Споры

Причина декомпозиции:

dispute_id → order_id, customer_id, status_code

Создано отношение:

nf_9_disputes(
    dispute_id,
    order_id,
    customer_id,
    status_code
)

Шаг 4. Сообщения

Причина декомпозиции:

message_id → dispute_id, created_at

Создано отношение:

nf_9_messages(
    message_id,
    dispute_id,
    created_at
)


6. Проверка НФБК

Для nf_9_customers:

customer_id → customer_city

customer_id является ключом отношения.

Для nf_9_statuses:

status_code → status_name

status_code является ключом отношения.

Для nf_9_disputes:

dispute_id → order_id, customer_id, status_code

dispute_id является ключом отношения.

Для nf_9_messages:

message_id → dispute_id, created_at

message_id является ключом отношения.

Таким образом, в каждой нетривиальной функциональной зависимости детерминант является ключом соответствующего отношения. Полученная схема удовлетворяет НФБК, при этом основные функциональные зависимости исходного отношения сохраняются.

До нормализации значения customer_city и status_name могли многократно повторяться в исходной плоской таблице.

После нормализации город клиента хранится один раз в таблице nf_9_customers, а название статуса — один раз в nf_9_statuses.

В таблице nf_9_disputes вместо повторного хранения этих значений используются customer_id и status_code.

Это уменьшает дублирование данных и снижает риск аномалий INSERT, UPDATE и DELETE.

