//Choose one of your favorite films and add it to the "film" table. Fill in rental rates with 4.99 and rental durations with 2 weeks.

SELECT * FROM public.film
order by film_id desc;

INSERT INTO film (
    title, description, release_year, language_id,
    rental_duration, rental_rate, length, replacement_cost, rating
)
VALUES (
    'Inception',
    'A mind-bending thriller',
    2010,
    1,
    14,
    4.99,
    148,
    19.99,
    'PG-13'
)
RETURNING film_id;

//Add the actors who play leading roles in your favorite film to the "actor" and "film_actor" tables (three or more actors in total).

SELECT * FROM public.actor
order by actor_id desc;

INSERT INTO actor (first_name, last_name)
VALUES 
('Leonardo', 'DiCaprio'),
('Joseph', 'Gordon-Levitt'),
('Elliot', 'Page')
RETURNING actor_id;

SELECT * FROM public.film_actor
order by actor_id desc;


INSERT INTO film_actor (film_id, actor_id)
VALUES
(1002, 210),
(1002, 211),
(1002, 212);




//Add your favorite movies to any store's inventory.
SELECT * FROM public.inventory
order by film_id desc;

INSERT INTO inventory (film_id, store_id)
VALUES
(1002, 1),
(1002, 2);


