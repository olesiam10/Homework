/*1.Create a new column called “status” in the rental table that uses a case statement to indicate if a film was returned late, early, or on time. */


WITH RentalDetails AS (SELECT EXTRACT(DAY FROM rental.return_date - rental.rental_date) as ActualRental,
film.rental_duration
FROM rental
left join inventory
on rental.inventory_id = inventory.inventory_id
left join film
on inventory.film_id = film.film_id) /* in a subquery selecting all the informating we need to get the data insights 
and saving it in a temporary table "RentalDetails" for ease of access later*/

SELECT ActualRental, rental_duration,
case 
when (ActualRental > rental_duration) then 'Late'
when (ActualRental < rental_duration) then 'Early'
when (ActualRental = rental_duration) then 'On Time'
end as RentalStatus
from RentalDetails; /* setting all the conditions for late, early and on time and saving it in the new column called "RentalStatus"

2.	Show the total payment amounts for people who live in Kansas City or Saint Louis. */

with Main as (select p.amount as Total, p.customer_id, c.first_name, c.last_name, ci.city  as CityName /*creating a temporary table to hold the results*/
from payment p
left join customer c
on p.customer_id = c.customer_id
left join address a
on c.address_id = a.address_id
left join city ci
on a.city_id = ci.city_id /* in this line and the above lines joing customer, address and city tables on a proper column */
where ci.city = 'Saint Louis' or ci.city = 'Kansas City') /*filtering information so it only includes STL and KS*/
select sum(Total) as TotalAmount, CityName /* summing the total of payments*/
from Main 
group by 2; /*grouping by the 2nd select element which is CityName*/

/*  3.How many film categories are in each category? Why do you think there is a table for category and a table for film category?

---> Because there're more films than categories. It's just easier to keep them in 2 tables because one table has only 16 lines with categories and
another one just refers each film into the proper category id */

select c.name, count(film_id) /*counting film_categories */
from category c
left join film_category fc
on c.category_id = fc.category_id /*in this line and the above lines joining category and film_category tables */
group by 1; /* grouping by category name*/

/* 4.Show a roster for the staff that includes their email, address, city, and country (not ids)*/

select s.first_name, s.Last_name, s.email, a.address, c.city, co.country
from staff s
left join address a
on s.address_id = a.address_id
left join city c
on a.city_id = c.city_id
left join country co
on c.country_id = co.country_id; /* in this line and the above lines joining staff, city, address, and country tables on the proper columns to get the roster*/

/* 5.Show the film_id, title, and length for the movies that were returned from May 15 to 31, 2005 */

select f.film_id, f.title, f.length
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id /* in this line and the above lines joining inventory and film and rental tables on the proper column*/
where r.return_date between '2005-05-15' and '2005-05-31'; /*filtering the return date to get the time frame we need for this assignment */

/* 6.Write a subquery to show which movies are rented below the average price for all movies. */

select f.title, p.amount
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.customer_id = p.customer_id
where p.amount < (select avg(amount) from payment); /* comparing p.amount to a subquery that contains overall price average */

/* 7.Write a join statement to show which moves are rented below the average price for all movies */

select f.title, p.amount
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.customer_id = p.customer_id
join
(select avg(amount) avg_amount from payment) as f2 on p.amount < f2.avg_amount
order by p.amount asc;

/* 8. Perform an explain plan on 6 and 7, and describe what you’re seeing and important ways they differ.*/

explain analyze
select f.title, p.amount
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.customer_id = p.customer_id
where p.amount < (select avg(amount) from payment);

explain analyze
select f.title, p.amount
from film f
left join inventory i
on f.film_id = i.film_id
left join rental r
on i.inventory_id = r.inventory_id
left join payment p
on r.customer_id = p.customer_id
join
(select avg(amount) avg_amount from payment) as f2 on p.amount < f2.avg_amount
order by p.amount asc;

/* Based on the explain plan the first query is faster (151.725ms vs 414.569 ms in the second query) 
and takes less memory (243kb vs 369kb in the second query)*/


/* 9.With a window function, write a query that shows the film, its duration, and what percentile the duration fits into.*/

select title, length, ntile(100) OVER
         (order by length)
         AS percentile
from film
order by percentile asc;

/* 10.In under 100 words, explain what the difference is between set-based and procedural programming. Be sure to specify which sql and python are. 

Procedural programming produces results using a sequence of operations or procedures. Python is a procedural-based programming.
Sequel is set-based programming. It's designed for sets manipulation. In procedural programming we tell the system what to do and how do it it and 
in set-based programming we tell the system what to do but we don't have to specify how to do it. 
We just specify the requirement for a processed result that has to be obtained from a "set of data" */




