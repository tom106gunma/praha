INSERT INTO customer_info (name, phone_number, remind_flag, created_at, updated_at)
VALUES
    ('kawata', '1234567890', TRUE, NOW(), NOW());

INSERT INTO prices (price)
VALUES
    (100),
    (150),
    (180),
    (220),
    (8650);

INSERT INTO price_history (price_id, menu_id, start_at, end_at)
VALUES
    (1, 1, NOW(), NULL),
    (2, 2, NOW(), NULL),
    (3, 3, NOW(), NULL),
    (4, 4, NOW(), NULL),
    (5, 5, NOW(), NULL);

INSERT INTO categories (name, type, created_at, updated_at)
VALUES
    ('お好みすし', 'single', NOW(), NOW()),
    ('盛り込み', 'set', NOW(), NOW());

INSERT INTO menu (name, price_id, category_id, takeout_flag, start_at, end_at, created_at, updated_at)
VALUES
    ('玉子', 1, 1, TRUE, NULL, NULL, NOW(), NOW()),
    ('明太子サラダ', 2, 1, TRUE, NULL, NULL, NOW(), NOW()),
    ('えび', 3, 1, TRUE, NULL, NULL, NOW(), NOW()),
    ('生サーモン', 4, 1, TRUE, NULL, NULL, NOW(), NOW()),
    ('はな', 5, 2, TRUE, NULL, NULL, NOW(), NOW());

INSERT INTO orders (customer_id, payment_status, remark, received_at, created_at, updated_at)
VALUES
    (1, TRUE, '', NOW(), NOW(), NOW());
    (1, FALSE, '', NOW(), NOW(), NOW());

INSERT INTO order_details (order_id, menu_id, quantity, has_wasabi, created_at, updated_at)
VALUES
    (1, 1, 5, FALSE, NOW(), NOW()),
    (1, 3, 1, FALSE, NOW(), NOW()),
    (1, 2, 1, FALSE, NOW(), NOW()),
    (1, 4, 1, FALSE, NOW(), NOW()),
    (2, 5, 2, TRUE, NOW(), NOW());

INSERT INTO order_detail_options (order_detail_id, shari_size, created_at, updated_at)
VALUES
    (1, 'large', NOW(), NOW()),
    (2, 'large', NOW(), NOW());

INSERT INTO points (customer_id)
VALUES
    (1);


INSERT INTO point_details (order_id, point_id, point, created_at, updated_at)
SELECT
    od.order_id,
    p.id,
    FLOOR(SUM(pr.price * od.quantity) / 100) AS point,
    NOW(),
    NOW()
FROM
    order_details od
INNER JOIN
    menu m ON od.menu_id = m.id
INNER JOIN
	prices pr on m.price_id  = pr.id
INNER JOIN
    orders o ON od.order_id = o.id
INNER JOIN
    points p ON o.customer_id = p.customer_id
GROUP BY
    od.order_id, p.id;
