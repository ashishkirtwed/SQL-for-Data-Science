Practice Exercise1
-- 1. show all the database present in mysql

show databases;

-- 2. Use the database sakila as listed in mysql

use sakila;

-- 3. Show all the tables present in sakila database

show tables from sakila;

-- 4. Describe actor table
describe actor;

-- 5. Display the first and last names of all actors from the table actor.
select first_name,last_name from actor;

-- 6. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
select upper(concat(first_name,' ',last_name)) as Full_Name 
from actor;

-- 7. You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
select actor_id, first_name,last_name
from actor
where first_name='Joe'; 
---Note: Comparison case insensitive so no need to thing about upper or lower case

-- 8. Find all actors whose last name contain the letters GEN:
select * from actor where last_name like '%GEN%'; 
--Note: There is no need to use upper or lower as like is case sensitive

-- 9. Find all actors whose last names contain the letters LI. This time, order the rows by
 -- last name and first name, in that order:
select * from actor where last_name like '%LI%' order by last_name,first_name;

-- 10. Using IN, display the country_id and country columns of the following countries:
 -- Afghanistan, Bangladesh, and China
select country_id, country 
from country 
where country in ('Afghanistan','Bangladesh','China');

-- 11. You want to keep a description of each actor. You don't think you will be 
-- performing queries on a description, so create a column in the table actor named description and 
-- use the data type BLOB (Make sure to research the type BLOB, as the difference between it and
 -- VARCHAR are significant).
Select * from actor;

select * from actor; 
alter table actor add description BLOB;

Select * from actor;

-- 12. Very quickly you realize that entering descriptions for each actor is too much effort.
 -- Delete the description column
Alter table actor drop column description;

-- 13. List the last names of actors, as well as how many actors have that last name.
Select last_name,count(*) as actor_count
from actor 
group by last_name 
order by actor_count DESC;

-- 14. List last names of actors and the number of actors who have that last name, but only for names 
-- that are shared by at least two actors
Select last_name, actor_count 
from ( select last_name, count(*) as actor_count 
	from actor 
	group by last_name 
	order by actor_count desc, last_name ) as temp
where actor_count >=2;

Or
select last_name, count(*) actor_count
 from actor 
 group by last_name 
 having actor_count >1 
 order by actor_count desc, last_name;

-- 15. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
 -- Write a query to fix the record.
 SET SQL_SAFE_UPDATES=0;

update actor set first_name='HARPO',last_name="WILLIAMS" 
	where first_name="GROUCHO" and last_name="WILLIAMS";

select * from actor where last_name="WILLIAMS";

-- 16. You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

-- 17. Use JOIN to display the first and last names, as well as the address, of each staff member.
 -- Use the tables staff and address:
select staff.first_name, staff.last_name, addr.address, addr.district, addr.postal_code
 from staff left join address as addr on staff.address_id=addr.address_id;

-- 19. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
select stf.first_name,stf.last_name, sum(pymnt.amount) as rung_up
from staff as stf left outer join payment as pymnt on stf.staff_id = pymnt.staff_id
where month(pymnt.payment_date)= 8 and year(pymnt.payment_date)=2005 group by stf.staff_id;

-- 20. List each film and the number of actors who are listed for that film. Use tables film_actor and film. 
-- Use inner join.
select flm.film_id,flm.title,count(flm_actor.actor_id) as actor_count
from film as flm inner join film_actor as flm_actor on flm.film_id=flm_actor.film_id 
group by flm.film_id;

-- 21. How many copies of the film Hunchback Impossible exist in the inventory system?
select title,count(*) 'Copies' 
from film, inventory 
where film.title='Hunchback Impossible' and film.film_id = inventory.film_id;

OR

select flm.title, count(*) number_in_inventory 
from film flm inner join inventory inv on flm.film_id = inv.film_id where flm.title = 'Hunchback Impossible' 
group by flm.title;


-- 22. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
select * from customer;
select cust.first_name, cust.last_name, sum(pay.amount) as total_paid
from customer as cust inner join  payment as pay
on cust.customer_id=pay.customer_id
group by cust.customer_id
order by cust.last_name;
-- 23. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in 
-- popularity. Use subqueries to display the titles of movies starting with the letters 
-- K and Q whose language is English.
select title
from film 
where title like 'K%' or title like 'Q%' 
and language_id in (select language_id
from language 
where name="English");
-- 24. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name
from actor
where actor_id in (
	select actor_id 
		from film_actor
		where film_id in (  
					select film_id
					from film
					where title = 'Alone Trip'));
-- OR
select ac.first_name,ac.last_name
from actor as ac inner join film_actor as fa inner join film on
ac.actor_id=fa.actor_id and film.film_id=fa.film_id and film.title="Alone Trip";
-- 25.You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

