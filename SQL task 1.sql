-- By filtering the orders table by the valid_to column, we can show the last order versions.
-- The filtered orders table can be the result of task 1, 
-- but we can also join it with the positions table 
-- to show the positions (order items) per the last order version. 

WITH
  last_versions AS (
  SELECT
    *
  FROM
    `flaschenpost-351510.order_details.orders`
  WHERE
    valid_to = "9999-01-01 23:59:00 UTC" )
SELECT
  *
FROM
  `flaschenpost-351510.order_details.positions` positions
LEFT JOIN
  last_versions
ON
  positions.order_id = last_versions.order_id
ORDER BY
  positions.order_id
  
  
-- There are other ways to achieve this result, i.e. to filter the orders table
-- to show the last order versions:
-- a) casting order_version_id to number type and finding the maximum/highest id number 
--    in a table grouped by order_id (under the assumption that the ids are sequential numbers)
-- b) finding the maximum valid_to date in a table grouped by order_id (which would be useful in case
--    the valid_to date of the last order version is set to another specified date in the future, 
--    rather than to a fixed default value of 9999-1-1)

-- The following is an example of a: 

WITH
  last_versions AS (
  SELECT
    order_id,
    MAX(CAST(order_version_id as INT64)) AS order_version_id
  FROM
    `flaschenpost-351510.order_details.orders`
  GROUP BY
    order_id )
SELECT
  all_versions.order_id,
  all_versions.order_version_id,
  all_versions.date,
  all_versions.total,
  all_versions.quantity,
  all_versions.valid_from,
  positions.*
FROM
  `flaschenpost-351510.order_details.orders` all_versions
JOIN
  last_versions
ON
  all_versions.order_id = last_versions.order_id
  AND all_versions.order_version_id = last_versions.order_version_id
RIGHT JOIN
  `flaschenpost-351510.order_details.positions` positions
ON
  all_versions.order_id = positions.order_id
ORDER BY
  all_versions.order_id
