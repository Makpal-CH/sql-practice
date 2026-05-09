//Which staff members made the highest revenue for each store and deserve a bonus for the year 2017?

SELECT * FROM public.staff;
SELECT * FROM public.store;
SELECT * FROM public.payment;

SELECT st.store_id, p.staff_id, SUM(p.amount) AS revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
WHERE EXTRACT(YEAR FROM p.payment_date) = 2007
GROUP BY st.store_id, p.staff_id
HAVING SUM(p.amount) = (
    SELECT MAX(rev)
    FROM (SELECT staff_id, SUM(amount) AS rev
          FROM payment
          WHERE EXTRACT(YEAR FROM payment_date) = 2007
          GROUP BY staff_id
    )
);


SELECT *
FROM (
    SELECT st.store_id, st.staff_id,
           SUM(p.amount) AS revenue,
           RANK() OVER (
               PARTITION BY st.store_id 
               ORDER BY SUM(p.amount) DESC
           ) rnk
    FROM payment p
    JOIN staff st ON p.staff_id = st.staff_id
    WHERE EXTRACT(YEAR FROM p.payment_date) = 2007
    GROUP BY st.store_id, st.staff_id
) t
WHERE rnk = 1;


///Which five movies were rented more than the others, and what is the expected age of the audience for these movies?

SELECT *
FROM (
    SELECT f.title, f.rating, COUNT(*) AS rentals
    FROM film f
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
    GROUP BY f.title, f.rating
) t
ORDER BY rentals DESC
LIMIT 5;

SELECT f.title,
       f.rating,
       COUNT(r.rental_id) AS rentals,
       CASE 
           WHEN f.rating = 'G' THEN 'All ages'
           WHEN f.rating = 'PG' THEN '7+'
           WHEN f.rating = 'PG-13' THEN '13+'
           WHEN f.rating = 'R' THEN '17+'
           WHEN f.rating = 'NC-17' THEN '18+'
       END AS expected_age
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, f.rating
ORDER BY rentals DESC
LIMIT 5;
//Which actors/actresses didn't act for a longer period of time than the others?


1. SELECT *
FROM (
    SELECT 
        a.actor_id,
        a.first_name || ' ' || a.last_name AS actor_name,
        COUNT(DISTINCT f.film_id) AS films_count,
        RANK() OVER (ORDER BY COUNT(DISTINCT f.film_id)) AS rnk
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    GROUP BY a.actor_id, a.first_name, a.last_name
)
WHERE rnk <= 5;

2. WITH actor_counts AS (
    SELECT a.actor_id,
           COUNT(DISTINCT f.film_id) AS films_count
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    GROUP BY a.actor_id
)
SELECT *
FROM (
    SELECT 
        ac.actor_id,
        a.first_name || ' ' || a.last_name AS actor_name,
        ac.films_count,
        RANK() OVER (ORDER BY ac.films_count) AS rnk
    FROM actor_counts ac
    JOIN actor a ON ac.actor_id = a.actor_id
) t
WHERE rnk = 1;


//SELECT a.actor_id,
      // MIN(f.release_year) AS first_year,
      // MAX(f.release_year) AS last_year,
       //MAX(f.release_year) - MIN(f.release_year) AS career_length
//FROM actor a
//JOIN film_actor fa ON a.actor_id = fa.actor_id
//JOIN film f ON fa.film_id = f.film_id
//GROUP BY a.actor_id
//ORDER BY career_length ASC;

