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

select * 
from film
order by rental_rate desc; /* I'll use a code like this which orders movies' rental rate from the highest to the lowest, so the first
movies in my list will be the one that are rented the most*/

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
from film_actor, actor 
group by actor.actor_id /* grouping count by the actor id*/
order by numberoffilms desc; /* ordering from most to least*/ 

/* based on thie query Gina Degeneres was in most movies (42) in 2006.*/

/*6. Write an explain plan for 4 and 5. Show the queries and explain what is happening in each one.*/

/* Actually, #4 & #5 are very similar queries. First, we're selecting only the columns we'd need to get the insights we're looking for from.
Second, we're aliasing the sum and count columns under the proper name for the better readability of the query outcome
Third, we're grouping by the right elemtent, customer and actor.
And then finally, we're ordering the output data in ascending oder from #4 and in dewcending order for #5


/* 7.What is the average rental rate per genre?
sequel code for this problem: */

select category.name, avg(film.rental_rate) as avg_rental_rate /* selecting the right columns columns and aliasing average rental rate
as average rental rate new column*/
from film, category
group by category.name; /* grouping by the genre

8.	How many films were returned late? Early? On time? */


WITH RentalDetails AS (SELECT EXTRACT(DAY FROM rental.return_date - rental.rental_date) as ActualRental,
film.rental_duration
FROM rental, film), /* in a subquery selecting all the informating we need to get the data insights 
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
from payment, category
group by Category; /* grouping by the category

10. Create a view for 8 and a view for 9. Be sure to name them appropriately. 

view for #9*/
create view sales_by_category as
select  category.name as Category, sum(payment.amount) as TotalSales
from  category, payment
group by Category;

/*view for #8 */
create view rental_statuses_count as

WITH RentalDetails AS (SELECT EXTRACT(DAY FROM rental.return_date - rental.rental_date) as ActualRental,
film.rental_duration
FROM rental, film),

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