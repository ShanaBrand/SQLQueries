use sakila;

-- Display the first and last names of all actors from the table actor.
SELECT first_name,last_name FROM actor;


-- First and last name of each actor in a single column in upper case letters.
SELECT CONCAT(first_name,' ',last_name) as Actor_Name from actor;


-- Find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
SELECT actor_id,first_name, last_name FROM actor WHERE first_name='Joe';


-- Find all actors whose last name contain the letters GEN
SELECT * FROM actor WHERE last_name like '%GEN%';


-- Find all actors whose last names contain the letters LI
SELECT * FROM actor WHERE last_name LIKE '%LI%' ORDER BY last_name DESC;

-- Display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and 
SELECT country_id, country FROM country WHERE country IN('Afghanistan','Bangladesh', 'China');


-- CREATE description column in table 'actor'
ALTER TABLE actor
ADD description BLOB;


-- DELETE the description column from table 'actor'
ALTER TABLE actor 
DROP description;


-- List the last names of actors, as well as how many actors have that last name.
SELECT last_name, Count(last_name) as Num_Actors
FROM actor
GROUP BY last_name;


-- names that are shared by at least two actors
SELECT last_name, Count(last_name) as Num_Actors
FROM actor
GROUP BY last_name
HAVING (num_Actors>=2);


-- Change GROUCHO to HARPO
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name ='WILLIAMS';


-- Change HARPO to GROUCHO 
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name ='WILLIAMS';


-- Recreate the schema for the 'address' table
SHOW CREATE TABLE address;


-- Display the first and last names, as well as the address, of each staff member
SELECT s.first_name, s.last_name, a.address
FROM staff as s
JOIN address as a ON s.address_id = a.address_id;


-- Display the total amount rung up by each staff member in August of 2005.
SELECT s.first_name, s.last_name, SUM(p.amount) AS TotalAmount_for_Aug2005
FROM staff AS s 
JOIN payment AS p USING(staff_id)
WHERE payment_date BETWEEN '2005-08-01' AND '2005-08-31'
GROUP BY s.staff_id;


-- List each film and the number of actors who are listed for that film.
SELECT f.title, count(fa.actor_id) as NumActors
FROM film_actor AS fa
LEFT JOIN film AS f using(film_id)
GROUP BY fa.actor_id;


-- How many copies of HUNCKBACK IMPOSSIBLE  exist in the inventory system?
SELECT f.title, COUNT(f.film_id) AS Num_Copies_Inventory
FROM film AS f
INNER JOIN inventory AS i USING(film_id)
GROUP BY f.film_id
HAVING (f.title = 'Hunchback Impossible');


-- Total paid by each customer (sort alphabetically by Lastname)
SELECT C.first_name, C.last_name,sum(P.amount) As AmountPaid
FROM customer AS C
JOIN payment AS P on C.customer_id = P.customer_id
GROUP BY C.customer_id
ORDER BY last_name ASC;

-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT f.title
FROM film AS f
WHERE f.title LIKE 'K%' or 'Q%' and language_id IN 
(
	SELECT language_id
    FROM language AS l
    WHERE l.name = 'English' 
); 



-- Use subqueries to display all actors who appear in the film Alone Trip
SELECT first_name, last_name
FROM actor AS a
WHERE actor_id in
(
	SELECT actor_id
    FROM film AS f
    WHERE f.title = 'Alone Trip'
);
    



-- Email marketing campaign targetting Canandian Customers
SELECT c.first_name, c.last_name,c.email,co.country
FROM customer AS c
JOIN address AS a USING (address_id)
JOIN city As ct USING (city_id)
JOIN country AS co USING(country_id)
WHERE co.country = 'Canada';



-- Identify all movies categorized as family films.
SELECT f.title, c.name
FROM film AS f
JOIN film_category AS fc USING(film_id)
JOIN category AS c USING (category_id)
WHERE c.name = 'Family';


-- Display the most frequently rented movies in descending order.
SELECT f.title,COUNT(rental_id)as Rental_Frequency
FROM film AS f
JOIN inventory AS i USING (film_id) 	-- ON f.film_id = i.film_id
JOIN rental AS r USING (inventory_id) 	-- ON i.inventory_id = r.inventory_id
GROUP BY f.film_id
ORDER BY Rental_Frequency DESC;



-- How much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount) AS Business_in_Dollars
FROM store AS s
JOIN customer AS c USING (store_id) 	 -- ON s.store_id = c.store_id
JOIN payment AS p USING (customer_id)	 -- ON c.customer_id = p.customer_id
GROUP BY s.store_id;



-- Display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country 
FROM store AS s
JOIN address AS a USING (address_id)     -- ON s.address_id= a.address_id
JOIN city AS c USING (city_id)           -- ON a.city_id = c.city_id 
JOIN country AS co USING (country_id)    -- ON c.country_id = co.country_id
GROUP BY s.store_id;



-- Gross revenue for the Top five genres in descending order
SELECT c.name, sum(p.amount) as revenue_generated_by_Genre 
FROM category AS c
JOIN film_category AS fc USING (category_id)
JOIN inventory AS i USING (film_id)
JOIN rental AS r USING(inventory_id)
JOIN payment AS p USING(rental_id)
GROUP BY c.category_id
ORDER BY revenue_generated_by_Genre DESC
limit 5
;

-- create a view of the solution above ( all genres inclusive)
CREATE VIEW genreRevenue AS
SELECT c.name, sum(p.amount) as revenue_generated_by_Genre 
FROM category AS c
JOIN film_category AS fc USING (category_id)
JOIN inventory AS i USING (film_id)
JOIN rental AS r USING(inventory_id)
JOIN payment AS p USING(rental_id)
GROUP BY c.category_id
ORDER BY revenue_generated_by_Genre DESC
;


-- Display the view that you created
SELECT * FROM genreRevenue;

-- Write a query to delete the view.
DROP VIEW genreRevenue;