-- We can use the code from Task 1 to filter the orders table. 
-- As the table view within this task is intended for other teams, we can transform some column names
-- to make them clearer and intuitive, and calculate additional relevant metrics. 
-- The other teams can further visualize and interact with the data using visualization tools.


WITH
  latest_orders AS (
  SELECT
    *
  FROM
    `flaschenpost-351510.order_details.orders`
  WHERE
    valid_to = "9999-01-01 23:59:00 UTC" )
SELECT
  positions.order_id,
  CAST(latest_orders.date AS date) AS date_of_order,
  positions.wine_id,
  positions.wine_name,
  positions.price AS unit_price,
  positions.netto_netto_price AS unit_cost,
  positions.price - positions.netto_netto_price AS unit_margin,
  positions.quantity,
  positions.price * positions.quantity AS total_revenue,
  positions.netto_netto_price * positions.quantity AS total_cost,
  (positions.price * positions.quantity) - (positions.netto_netto_price * positions.quantity) AS gross_profit
FROM
  `flaschenpost-351510.order_details.positions` positions
LEFT JOIN
  latest_orders
ON
  positions.order_id = latest_orders.order_id
ORDER BY
  positions.order_id
