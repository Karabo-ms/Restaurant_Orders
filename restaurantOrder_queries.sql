-- Exploring Restaurant Dataset.



1.1 -- Table structure for table "menu_items"

CREATE TABLE menu_items (
  menu_item_id SMALLINT NOT NULL,
  item_name VARCHAR(50),
  category VARCHAR(50),
  price DECIMAL(5,2),
  PRIMARY KEY (menu_item_id)
);






1.2 -- View the menu_items table.

SELECT * FROM menu_items;






1.3 -- Number of items on the menu.

SELECT COUNT(*) AS number_of_items
FROM menu_items;







1.4 -- The most and least expensive items on the menu.

SELECT *
FROM menu_items
ORDER BY price DESC;



SELECT *
FROM menu_items
ORDER BY price ASC;






1.5 -- The number of Mexican dishes on the menu.

SELECT COUNT(*) AS total_Mexican_dishes
FROM menu_items
WHERE category = 'Mexican';






1.6 -- The most expensive Mexican dishes on the menu.

SELECT *
FROM menu_items
WHERE category = 'Mexican'
ORDER BY price DESC;






1.7 -- The least expensive Mexican dishes on the menu.

SELECT *
FROM menu_items
WHERE category = 'Mexican'
ORDER BY price ASC;






1.8 -- Number of dishes available in each category.

SELECT category, COUNT(category) AS num_dishes
FROM menu_items
GROUP BY category;






1.9 -- The Average dish price in each category.

SELECT category, AVG(price) AS avg_price
FROM menu_items
GROUP BY category;






2.0 -- Table Structure for table "order_details"

CREATE TABLE order_details (
  order_details_id SMALLINT NOT NULL,
  order_id SMALLINT NOT NULL,
  order_date DATE,
  order_time TIME,
  item_id SMALLINT,
  PRIMARY KEY (order_details_id)
);






2.1 -- View the order_details table.                 

SELECT * FROM order_details;






2.2 -- What is the date range of the table?

SELECT MIN(order_date), MAX(order_date)
FROM order_details;






2.3 -- How many orders were made within this date range?

SELECT COUNT(*) AS total_orders
FROM order_details;






2.4 -- How many items were ordered within this date range?

SELECT COUNT(DISTINCT item_id) AS num_items
FROM order_details;






2.5 -- Which orders had the most number of items?

SELECT order_id, COUNT(item_id) AS num_items
FROM order_details
GROUP BY order_id
ORDER BY num_items DESC;






2.6 -- How many orders had more than 12 items?

SELECT COUNT(*) AS num_orders 
FROM 
     (SELECT order_id, COUNT(item_id) AS num_items
       FROM order_details
       GROUP BY order_id
	   HAVING COUNT(item_id) > 12) AS subq;








2.7 -- Combining the menu_items and order_details tables into a single table.

SELECT *
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id;






2.8 -- What were the least and most ordered items? What category were they in?

SELECT item_name, category, COUNT(order_details_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE item_name IS NOT NULL
GROUP BY item_name, category	
ORDER BY num_items ASC;



SELECT item_name, category, COUNT(order_details_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE item_name IS NOT NULL
GROUP BY item_name, category	
ORDER BY num_items DESC;






2.9 -- What were the top 5 orders that spend the most money?

SELECT order_id, SUM(price) AS total_spend 
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE item_name IS NOT NULL
GROUP BY order_id
ORDER BY total_spend DESC
LIMIT 5;






3.0 -- View the details of the highest spend order. What insights can you gather from the results?



-- We are able to see how many number of items were bought per category (from 'order_id 440') and which was the highest. --

SELECT category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category



--	We are able to see the 'item_name' that 'order_id 440' bought more than once. --	

SELECT category, item_name, COUNT(menu_item_id) AS num_orders
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE order_id = 440
GROUP BY category, item_name
HAVING COUNT(menu_item_id) > 1






3.1 -- View the details of the top 5 highest spend orders. What insights can you gather from the results?



-- We are able to see how many number of items were bought per category (from the top 5 orders that spend the most money). --

SELECT order_id, category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE order_id IN(440, 2075, 1957, 330, 2675)
GROUP BY order_id, category



SELECT category, COUNT(item_id) AS num_items
FROM order_details od
LEFT JOIN menu_items mi
     ON od.item_id = mi.menu_item_id
WHERE order_id IN(440, 2075, 1957, 330, 2675)
GROUP BY category