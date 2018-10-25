use sakila;

select *
from actor;

-- 1a
select first_name, last_name from actor;

-- 1b
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- 2a
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2b
select actor_id, first_name, last_name
from actor
where last_name like '%GEN%';

-- 2c
select actor_id, last_name, first_name
from actor
where last_name like '%LI%';

-- 2d
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
ALTER TABLE actor
ADD description blob;

-- 3b
ALTER TABLE actor
drop column description;

-- 4a
SELECT COUNT(actor_id), last_name
FROM actor
GROUP BY last_name;

-- 4b
SELECT COUNT(actor_id), last_name
FROM actor
GROUP BY last_name
having count(actor_id) > 1;

-- 4c
UPDATE actor
SET first_name = 'Harpo', last_name= 'Williams'
WHERE first_name = 'Groucho' and last_name= 'Williams';

-- 4d
UPDATE actor
SET first_name = 'Groucho', last_name= 'Williams'
WHERE first_name = 'Harpo' and last_name= 'Williams';

-- 5a
SHOW CREATE TABLE address;
-- un-comment this and run it to create table
-- CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'

-- 6a
select s.first_name, s.last_name, a.address
    from staff s
    inner join address a
   on s.address_id=s.address_id;

-- 6b
-- select * from payment
-- where payment_date between '2005-08-01' and '2005-08-31';
select  s.staff_id, s.first_name, s.last_name, sum(p.amount), p.payment_date
    from staff s
    inner join payment p
	on s.staff_id=p.staff_id
    where payment_date between '2005-08-01' and '2005-08-31'
    group by staff_id;
 
 -- 6c
select f.film_id, f.title, sum(fa.actor_id)
    from film f
    inner join film_actor fa
	on f.film_id=fa.film_id
    group by film_id;
    
-- 6d
-- find ID number of the film
SELECT film_id, title FROM film
where title = 'Hunchback Impossible';
-- based on id number, find the count
select count(inventory_id) from inventory
where film_id = '439';
   
-- 6e
select  c.first_name, c.last_name, c.customer_id, sum(p.amount)
    from customer c
    inner join payment p
	on c.customer_id=p.customer_id
    group by customer_id
    ORDER BY last_name;

-- 7a 
SELECT title
FROM film
WHERE title LIKE 'k%' or 'q%' and language_id in
(
  SELECT language_id
  FROM language
  WHERE name = "English"
);  

-- 7b
select first_name, last_name
from actor
where actor_id in
(
select actor_id
from film_actor
where film_id in
(
select film_id
from film
where title = 'Alone Trip'
)); 

-- 7c
select c.first_name, c.last_name, c.email, c.address_id, a.district
    from customer c
    inner join address a
	on c.address_id=a.address_id
    where district in ('Ontario', 'Quebec', 'British Columbia', 'Alberta', 'Manitoba', 'Saskatchewan',
    'Nova Scotia', 'New Brunswick', 'Newfoundland and Labrador', 'Prince Edward Island', 'Northwest Territories',
    'Nunavut', 'Yukon');
  
-- 7d
SELECT title
FROM film
WHERE film_id in
(
	SELECT film_id
	FROM film_category
	where category_id in
(  
	SELECT category_id
	FROM category
	where name = 'family'	
));

-- 7e tha I couldn't get with a nested query
SELECT count(rental_id), inventory_id
FROM rental
group by inventory_id
having inventory_id in
(
	SELECT inventory_id
	FROM inventory
	where film_id in
(  
	SELECT film_id
	FROM film
));

-- 7e tha I couldn't get with a nested query
SELECT title
FROM film
where film_id in
(
select film_id
from inventory
where inventory_id in
(
SELECT count(rental_id), inventory_id
from rental
group by title
));

-- 7e
create view rent_times as
select f.title, count(rental_id) as rentals
from rental r
join inventory i
	on (r.inventory_id = i.inventory_id)
join film f
	on (i.film_id = f.film_id)
    group by title
    order by rentals desc;
    
select *
from rent_times;

drop view rent_times;


-- 7f
create view total_sales as
SELECT s.store_id, SUM(amount) AS Gross
FROM payment p
JOIN rental r
	ON (p.rental_id = r.rental_id)
JOIN inventory i
	ON (i.inventory_id = r.inventory_id)
JOIN store s
	ON (s.store_id = i.store_id)
GROUP BY s.store_id;

select *
from total_sales;

drop view total_sales;

-- 7g
create view store_geography as
select s.store_id, c.city, n.country
from address a
join store s
	on (a.address_id = s.address_id)
join city c
	on (a.city_id = c.city_id)
join country n
	on (c.country_id = n.country_id);
    
select *
from store_geography;

drop view store_geography;

-- 7h, 8a
create view gross_revenue as
SELECT p.rental_id, SUM(amount) AS Gross, c.name
FROM payment p
JOIN rental r
	ON (p.rental_id = r.rental_id)
JOIN inventory i
	ON (i.inventory_id = r.inventory_id)
JOIN film_category fc
	ON (fc.film_id = i.film_id)
Join category c
	ON (c.category_id = fc.category_id)
GROUP BY c.name limit 5;

-- 8b
select *
from gross_revenue;

-- 8c
drop view gross_revenue;









