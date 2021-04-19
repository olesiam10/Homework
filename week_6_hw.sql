/* 1.Show all customers whose last names start with T. Order them by first name from A-Z

sequel code for this problem: */

select *
from customer /* first 2 lines select all columns from customer tabel*/
where last_name like 'T%' /* this line helps select only last names that start with T.*/
order by last_name asc; /* this line orders last names from A to Z ascending*/

/* 2.Show all rentals returned from 5/28/2005 to 6/1/2005 
sequel code for this problem: */

select *
from rental /* first 2 lines select all columns from the rental tabel*/
where return_date between '2005-05-28' and '2005/06/01'; /* this filters the data to show only rental returns that happened between
'2005-05-28' and '2005/06/01*/

/* 3.	How would you determine which movies are rented the most?
sequel code for this problem: */

select count(*), f.title, f.film_id /*selecting all the columns we need */
from film f
join inventory i
on f.film_id = i.film_id
join rental r
on i.inventory_id = r.inventory_id /* in the last 4 lines we're joining inventory and rental tables on film_id and inventory_id*/
group by f.film_id /* grouping by film_id*/
order by 1 desc; /* odering in descending order to see which were rented the most at the top*/

/* 4.Show how much each customer spent on movies (for all time) . Order them from least to most.
sequel code for this problem: */

select customer_id, sum(amount) as Total /* selecting columns we're going to work with*/
from payment
group by customer_id /* grouping by customer so the sum of spent shows up for each customer*/
order by total asc; /* ordering from least to most

5.	Which actor was in the most movies in 2006 (based on this dataset)? 
Be sure to alias the actor name and count as a more descriptive name. 
Order the results from most to least.
sequel code for this problem: */

select actor.actor_id,actor.first_name, actor.last_name, count(distinct film_actor.film_id) as NumberOfFilms /* selecting all the
columns we'll need for this query and aliasing unique count of films as Number of Films*/
from film_actor
join actor 
on film_actor.actor_id = actor.actor_id /* joining film_actor and actor tables on actor_id column */
group by actor.actor_id /* grouping count by the actor id*/
order by numberoffilms desc; /* ordering in descending order*/

/* based on thie query Gina Degeneres was in most movies (42) in 2006.*/

/*6. Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one.*/

/*explain for #4*/

explain analyze
select customer_id, sum(amount) as Total 
from payment
group by customer_id 
order by total asc; 


/*explain for #5*/
explain analyze
select actor.actor_id,actor.first_name, actor.last_name, count(distinct film_actor.film_id) as NumberOfFilms /* selecting all the
columns we'll need for this query and aliasing unique count of films as Number of Films*/
from film_actor
join actor 
on film_actor.actor_id = actor.actor_id
group by actor.actor_id /* grouping count by the actor id*/
order by numberoffilms desc;

/* the explain itself shows us the plan for query execution. Explain analyze actually runs the query and shows the statistics on it. They are used to 
help us analyze how queries execute and find the most optimized ways to run them.

/* 7.What is the average rental rate per genre?
sequel code for this problem: */

select category.name, avg(film.rental_rate) as avg_rental_rate /* selecting the right columns columns and aliasing average rental rate
as average rental rate new column*/
from film
left join film_category
on film.film_id = film_category.film_id
left join category
on film_category.category_id = category.category_id /* joining film, category and film_category tables on the proper column*/
group by category.name; /* grouping by the genre

8.	How many films were returned late? Early? On time? */


WITH RentalDetails AS (SELECT EXTRACT(DAY FROM rental.return_date - rental.rental_date) as ActualRental,
film.rental_duration
FROM rental
left join inventory
on rental.inventory_id = inventory.inventory_id
left join film
on inventory.film_id = film.film_id), /* in a subquery selecting all the informating we need to get the data insights 
and saving it in a temporary table "RentalDetails" for ease of access later*/

RentalStatuses AS (SELECT ActualRental, rental_duration,
case 
when (ActualRental > rental_duration) then 'Late'
when (ActualRental < rental_duration) then 'Early'
when (ActualRental = rental_duration) then 'On Time'
end as RentalStatus
from RentalDetails)  /* creating another temporary table "RentalStatuses" to hold all of our statuses of returns: early, on time, and late*/

select RentalStatus, count(RentalStatus) 
from RentalStatuses
where RentalStatus is not null
group by RentalStatus; /* in this last section counting how many films were returned on time, early and late and grouping it by their rental status.*/


/* 9.	What categories are the most rented and what are their total sales?
sequel code for this problem: */
select sum(payment.amount) as TotalSales, category.name as Category /* suming total sales and 
aliasing these 2 columns for the readability*/
from payment
left join rental
on payment.customer_id = rental.customer_id
left join inventory
on rental.inventory_id = inventory.inventory_id
left join film_category
on inventory.film_id = film_category.film_id
left join category
on film_category.category_id = category.category_id /* joining all the necessary tables (rental, payment, inventory, film_category and category) on the proper
columns to get all the data we need*/
group by Category; /* grouping the total sales by the category

10. Create a view for 8 and a view for 9. Be sure to name them appropriately. 

view for #9*/
create view sales_by_category as
select sum(payment.amount) as TotalSales, category.name as Category
from payment
left join rental
on payment.customer_id = rental.customer_id
left join inventory
on rental.inventory_id = inventory.inventory_id
left join film_category
on inventory.film_id = film_category.film_id
left join category
on film_category.category_id = category.category_id
group by category; 

/*view for #8 */
create view rental_statuses_count as

WITH RentalDetails AS (SELECT EXTRACT(DAY FROM rental.return_date - rental.rental_date) as ActualRental,
film.rental_duration
FROM rental
left join inventory
on rental.inventory_id = inventory.inventory_id
left join film
on inventory.film_id = film.film_id),

RentalStatuses AS (SELECT ActualRental, rental_duration,
case 
when (ActualRental > rental_duration) then 'Late'
when (ActualRental < rental_duration) then 'Early'
when (ActualRental = rental_duration) then 'On Time'
end as RentalStatus
from RentalDetails)

select RentalStatus, count(RentalStatus)
from RentalStatuses
where RentalStatus is not null
group by RentalStatus;