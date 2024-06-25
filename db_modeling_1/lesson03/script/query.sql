-- お客さんが会計をする際の最終的な支払金額を計算する
SELECT
  O.id AS '注文票No',
  CI.name AS 'お客様名',
  SUM(P.price * OD.quantity) AS '税別合計金額',
  ROUND(SUM(P.price * OD.quantity) * 0.08 , 1) AS '消費税',
  SUM(P.price * OD.quantity) + ROUND(SUM(P.price * OD.quantity) * 0.08 , 1) AS '支払金額'
FROM
  orders O
INNER JOIN
  customer_info CI on CI.id = O.customer_id

INNER JOIN
  order_details OD on O.id = OD.order_id
INNER JOIN
  menu M ON OD.menu_id = M.id
INNER JOIN
  prices P ON M.price_id = P.id
WHERE
O.id = 1

-- 今月注文された寿司ネタ別の個数
SELECT
  M.name,
  SUM(OD.quantity) AS total_quantity
FROM
  orders O
INNER JOIN
  order_details OD on O.id = OD.order_id
INNER JOIN
  menu M ON OD.menu_id = M.id
INNER JOIN
  categories C on M.category_id = C.id
WHERE
  C.type = 'single' AND
  O.created_at >= DATE_FORMAT(NOW(),'%Y-%m-01')
  AND O.created_at < DATE_FORMAT(NOW(),'%Y-%m-01') + INTERVAL 1 MONTH
GROUP By
  M.name
ORDER BY
  total_quantity DESC
