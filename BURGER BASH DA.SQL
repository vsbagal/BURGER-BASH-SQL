-- QUE1. HOW MANY BURGERS WERE ORDERED?
SELECT COUNT(order_id) AS NUMBER_OF_ORDERS FROM runner_orders;

-- QUE2. HOW MANY UNIQUE CUSTOMERS ORDER WERE MADE?
SELECT COUNT(DISTINCT(CUSTOMER_ID)) AS UNIQUE_CUSTOMERS FROM CUSTOMER_ORDERS;

-- QUE3. HOW MANY SUCESSFUL ORDERS WERE DELIVERED BY EACH RUNNER?
SELECT RUNNER_ID, count(distinct ORDER_ID) AS SUCCESSFUL_ORDERS
FROM RUNNER_ORDERS WHERE CANCELLATION IS NULL
GROUP BY RUNNER_ID
ORDER BY SUCCESSFUL_ORDERS DESC;

-- QUE4. HOW MANY EACH TYPE OF BURGERS WAS DELIVERED?
SELECT P.BURGER_NAME, COUNT(C.BURGER_ID) AS DELIVERED_BURGERS 
FROM CUSTOMER_ORDERS AS C JOIN RUNNER_ORDERS AS R
ON C.ORDER_ID = R.ORDER_ID
JOIN BURGER_NAMES AS P 
ON C.BURGER_ID = P.BURGER_ID
WHERE R.DISTANCE <> 0
GROUP BY P.BURGER_NAME;

-- QUE5. HOW MANY VEGETERIAN AND MEATLOVER BURGERS WERE ORDERED BY EACH CUSTOMER?
SELECT C.CUSTOMER_ID, P.BURGER_NAME, COUNT(P.BURGER_NAME) AS ORDER_COUNT
FROM CUSTOMER_ORDERS AS C
JOIN BURGER_NAMES AS P
ON C.BURGER_ID=P.BURGER_ID
GROUP BY C.CUSTOMER_ID, P.BURGER_NAME
ORDER BY C.CUSTOMER_ID;

-- QUE6. WHAT WAS THE MAXIMUM NUBER OF BURGERS DELIVERED IN SINGLE ORDER?
WITH BURGER_COUNT_CTE AS
(
SELECT C.ORDER_ID, COUNT(C.BURGER_ID) AS BURGER_PER_ORDER
FROM CUSTOMER_ORDERS AS C JOIN RUNNER_ORDERS AS R
ON C.ORDER_ID = R.ORDER_ID
WHERE R.DISTANCE <> 0
GROUP BY C.ORDER_ID
)
SELECT MAX(BURGER_PER_ORDER) AS BURGER_COUNT 
FROM BURGER_COUNT_CTE

-- QUE7. FOR EACH CUSTOMER, HOW MANY DELIVERED BURGERS HAD AT LEAST 1 CHANGE & HOW MANY HAD NO CHANGES? 
SELECT C.CUSTOMER_ID, 
SUM(CASE
WHEN C.EXCLUSIONS<>' ' OR C.EXTRAS<>' '
THEN 1
ELSE 0 
END) AS  AT_LEASET_1_CHANGE,
SUM(CASE
WHEN C.EXCLUSIONS=' ' AND C.EXTRAS = ' '
THEN 1 
ELSE 0
END) AS NO_CHANGE
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R
ON C.ORDER_ID = R.ORDER_ID
WHERE R.DISTANCE <>0
GROUP BY C.CUSTOMER_ID
ORDER BY C.CUSTOMER_ID;

-- QUE8. WHAT WAS THE TOTAL VOLUME OF THE BURGERS ORDERD FOR EACH HOUR OF THE DAY?
SELECT EXTRACT(HOUR FROM ORDER_TIME)
AS HOUR_OF_DAY,
COUNT(ORDER_ID) AS BURGER_COUNT
FROM CUSTOMER_ORDERS
GROUP BY extract(HOUR FROM ORDER_TIME) 
ORDER BY BURGER_COUNT DESC;

-- QUE9. HOW MANY RUNNERS SIGNED UP FOR EACH 1 WEEK PERIOD?
SELECT extract(WEEK FROM REGISTRATION_DATE) AS REGISTRATION_WEEK, 
COUNT(RUNNER_ID) AS RUNNER_SIGNUP FROM BURGER_RUNNER
GROUP BY extract(WEEK FROM REGISTRATION_DATE);

-- QUE10. WHAT WAS THE AVRAGE DISTANCE TRAVELLED FOR EACH CUSTOMER?
SELECT C.CUSTOMER_ID, AVG(R.DISTANCE) AS AVG_DISTANCE
FROM CUSTOMER_ORDERS AS C
JOIN RUNNER_ORDERS AS R
ON C.ORDER_ID=R.ORDER_ID
WHERE R.DURATION <> 0
GROUP BY C.CUSTOMER_ID;
