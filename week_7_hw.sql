/*1.Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time. */

WITH RentalDetails AS (SELECT EXTRACT(DAY FROM rental.return_date - rental.rental_date) as ActualRental,
film.rental_duration
FROM rental, film) /* in a subquery selecting all the informating we need to get the data insights 
and saving it in a temporary table "RentalDetails" for ease of access later*/

SELECT ActualRental, rental_duration,
case 
when (ActualRental > rental_duration) then 'Late'
when (ActualRental < rental_duration) then 'Early'
when (ActualRental = rental_duration) then 'On Time'
end as RentalStatus
from RentalDetails; /* setting all the conditions for late, early and on time and saving it in the new column called "RentalStatus"

2.	Show the total payment amounts for people who live in Kansas City or Saint Louis. */

with Main as (select p.amount as Total, p.customer_id, c.first_name, c.last_name, ci.city  as CityName
from payment p
left join customer c
on p.customer_id = c.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on a.city_id = ci.city_id
where ci.city = 'Saint Louis' or ci.city = 'Kansas City')
select sum(Total) as TotalAmount, CityName
from Main
group by 2;

/*  3.How many film categories are in each category? Why do you think there is a table for category and a table for film category?
baecause there're more films than categories?*/

select c.name, count(distinct film_id)
from category c
left join film_category fc
on c.category_id = fc.category_id
group by 1;

/* 4.Show a roster for the staff that includes their email, address, city, and country (not ids)*/

select s.first_name, s.Last_name, s.email, a.address, c.city, co.country
from staff s
left join address a
on s.address_id = a.address_id
left join city c
on a.city_id = c.city_id
left join country co
on c.country_id = co.country_id;

/* 5.Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005 */

select f.film_id, f.title, f.length
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
where r.return_date between '2005-05-15' and '2005-05-31';

/* 6.Write a subquery to show which movies are rented below the average price for all movies. */

select f.title, p.amount
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.customer_id = p.customer_id
where p.amount < (select avg(amount) from payment);

/* 7.Write a join statement to show which moves are rented below the average price for all movies */

/* 9.With a window function, write a query that shows the film, its duration, and what percentile the duration fits into.*/


