//Remove a previously inserted film from the inventory and all corresponding rental records


SELECT * FROM public.rental
order by inventory_id desc;

SELECT * FROM public.inventory
order by inventory_id desc;

SELECT film_id
FROM film
WHERE title = 'Inception'; 

SELECT *
FROM rental
WHERE inventory_id IN (
    SELECT inventory_id
    FROM inventory
    WHERE film_id = 1002
);

DELETE FROM inventory
WHERE film_id = (
    SELECT film_id FROM film WHERE title = 'Inception'
);

//Remove any records related to you (as a customer) from all tables except "Customer" and "Inventory"

SELECT customer_id, first_name, last_name
FROM customer
WHERE first_name = 'Makpal';

SELECT *
FROM payment
WHERE customer_id = (
    SELECT customer_id
    FROM customer
    WHERE first_name = 'Makpal'
      AND last_name = 'Chuinusheva'
);


select * FROM rental
WHERE customer_id = (
    SELECT customer_id
    FROM customer
    WHERE first_name = 'Makpal'
      AND last_name = 'Chuinusheva'
);


DELETE FROM payment
WHERE customer_id = (
    SELECT customer_id
    FROM customer
    WHERE first_name = 'Makpal'
      AND last_name = 'Chuinusheva'
);

DELETE FROM rental
WHERE customer_id = (
    SELECT customer_id
    FROM customer
    WHERE first_name = 'Makpal'
      AND last_name = 'Chuinusheva'
);


SELECT * FROM public.payment
order by customer_id asc;