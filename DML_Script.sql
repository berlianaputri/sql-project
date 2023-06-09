-- insert 

insert into customers (customer_name, contact_name, address, city, postal_code, country)
values ('Robert', 'Alan', 'Langsat', 'Jakarta', '12130', 'Indonesia');

insert into customers (customer_name, city, country)
values ('Berliana', 'Bandung', 'Indonesia');


-- UPDATE DATA
update customers set contact_name = 'Alfred Schmit', city = 'Frankfurt'
	where customer_id = 1;

update customers set  postal_code = '00000'
	where country = 'Mexico';

-- DELETE DATA

delete from customers where contact_name is null;

-- SELECT 

select * from customers c ;

select customer_id, city, postal_code, country from customers c; 

select distinct country from customers c;

select count(distinct country) from customers c ;


-- WHERE
select * from customers c where country = 'Italy';

select * from products p  where price < 10;

-- postgres operators

-- equal =
-- greater than >
-- less than <
-- grater than or equal >=
-- less than or equal <=
-- not equal <>
-- between -> between a certain range 
-- like mirip equal/search for a pattern
-- in specify multiple values 

--DATE FORMAT 
--MM/DD/YYYY (Based or system region
--YYYY-MM-DD (universal)

-- AND, OR, NOT

select * from products p where price >= 50;

select * from orders o where shipper_id <> 1;

select * from orders o where order_date between '1996-12-01' and '1997-01-31';

select * from orders o where order_date >= '1997-01-01';

select * from orders o where order_date = '12/05/1996';

select * from customers c where country in ('Spain', 'Canada');

select * from customers c where country = 'Germany' and city = 'Frankfurt';

select * from customers c where country = 'Germany' or city = 'London';

select * from customers c where not country = 'Germany';

select * from customers c where country <> 'Germany';

select * from customers c where country not like 'Germany';

select * from customers c where country <> 'Germany' and country <> 'USA';

select * from customers c where not (country = 'Germany' or country = 'USA');


-- order by (untuk mengurutkan query)

select * from customers c where not (country = 'Germany' or country = 'USA') 
	order by customer_id;

select * from customers c where not (country = 'Germany' or country = 'USA') 
	order by country;

select * from customers c order by country, customer_id;

select * from customers c order by customer_id desc 

select * from customers c order by city, customer_id ;

insert into customers (customer_name, city, country)
	values ('Berliana', 'Bandung', 'Indonesia');

-- null values

select * from customers c where address is null;

select * from customers c where address is not null;

select * from customers c where address notnull;

select * from customers c where customer_id = 95;

update customers set country = null where customer_name = 'Berliana';

-- NULL TRAP
select * from customers c where country is null or country <> 'Germany';

select distinct country from customers c 

select * from customers c where country not like 'Germany';

-- window function
-- MIN, MAX, COUNT, AVG, SUM

select * from products p ;

select min(price) from products p ;

select max(price) from products p ;

select max(product_id) from products p;

select count(product_id) from products p; 

select count(*) from order_details od ; 

select avg(price) from products p ;

select sum(quantity) from order_details od ;

-- ke tabel product, hitung berapa barang yang harganya 18

select count(product_id) from products p where price = 18; 

-- between
select * from products p where price between 10 and 20 order by price ;

select * from products p where price not between 10 and 20 order by price ;

select * from products p 
	where price not between 10 and 20
	and category_id not in (1,2,3)
	order by price ;

select * from products p order by product_name ;

select * from products p where product_name
	between 'Camembert Pierrot' and 'Chef Anton''s Cajun Seasoning'
	order by product_name ;

--limit (membatasi jumlah row yang ingin diambil)

select * from order_details od 
	order by product_id 
	limit 10;


select * from customers c where customer_name  like 'A%';

select * from customers c where customer_name  like '%a';

select * from customers c where customer_name  like 'A%a';

select * from customers c where customer_name  like '%a%';

select * from customers c where customer_name  like '%ab%';

select * from customers c where country like 'Denm_rk'; 

select * from customers c where country like '_e%';

select * from customers c where country like '_____';

select * from customers c where customer_name  like '% ____';

-- cari negara yang huruf keduanya 'r'

select distinct country from customers c where country like '_r%';

-- negara yang huruf kedua dari terakhir 'i'
select distinct country from customers c where country like '%i_';

-- case sensirive (using ilike)
select * from products p where product_name ilike 'c%';

-- GROUP BY

select country , count(customer_id) 
	from customers c 
	group by country 
	order by count(customer_id) desc
	limit 5;

select country, city, count(customer_id)  from customers c
	group by country, city
	order by country ;

-- coba cari berapa jumlah kota unik di setiap negara

--check city in every country
select country, city from customers c 
--	group by country 
	order by country;

select country, count(distinct city) from customers c 
	group by country 
	order by country;

select customer_id id, customer_name nama, city kota, country negara 
	from customers c 

select country, count(distinct city) cnt_kota from customers c 
	group by country 
	order by cnt_kota desc;

select country, count(distinct city) cnt_kota from customers c 
	group by country 
	having count(distinct city)  > 3 
	order by cnt_kota desc;

select country, count(distinct city) cnt_kota from customers c 
	group by country 
	having country not like 'USA' 
	order by cnt_kota desc;

select country, count(distinct city) cnt_kota from customers c
	where country not like 'USA' 
	group by country 
	order by cnt_kota desc;

select category_id kategori, avg(price) avg_price
	from products
	group by category_id
	having avg(price) > 25 
	order by avg_price desc;

-----------------MINI EXERCISE----------------------

-- 1
select *  from customers c 
	where city = 'London' and customer_name ilike 'b%'
	
-- 2
select address, postal_code  from customers c 
	where city = 'London' and customer_name ilike 'b%'
	order by length(customer_name) asc ;
-- 3
select count(city)-count(distinct city) as selih_kota from customers c; 

--4
select distinct city from customers c 
	where city like 'A%' or city like 'I%' 
	or city like 'U%' or city like 'E%' or city ilike 'O%'
	order by city asc ;

select distinct city from customers c 
	where (city ilike 'a%' 
	or city ilike 'i%' 
	or city ilike 'u%' 
	or city ilike 'e%' 
	or city ilike 'o%'
	order by city ;

-- any untuk conditional or yang banyak
-- all untuk conditional and yang banyak

select distinct city from customers c 
	where city ilike any(array['a%', 'i%', 'i%', 'e%', 'o%']);

-- 5
select distinct city from customers c 
	where (city ilike 'a%' 
	or city ilike 'i%' 
	or city ilike 'u%' 
	or city ilike 'e%' 
	or city ilike 'o%') 
	and (city ilike '%a' 
	or city ilike '%i' 
	or city ilike '%u' 
	or city ilike '%e' 
	or city ilike '%o')
	order by city asc ;


-- 6
select distinct city from customers c 
	where not (city ilike 'a%' 
	or city ilike 'i%' 
	or city ilike 'u%' 
	or city ilike 'e%' 
	or city ilike 'o%');

-- 7

select distinct city from customers c 
	where (city not ilike 'a%'
	and city not ilike 'i%' 
	and city not ilike 'u%' 
	and city not ilike 'e%' 
	and city not ilike 'o%') 
	and (city not ilike '%a' 
	and city not ilike '%i' 
	and city not ilike '%u' 
	and city not ilike '%e' 
	and city not ilike '%o')
	order by city asc;

select distinct city from customers c 
	where not (city ilike 'a%' 
	or city ilike 'i%' 
	or city ilike 'u%' 
	or city ilike 'e%' 
	or city ilike 'o%') 
	and (city ilike '%a' 
	or city ilike '%i' 
	or city ilike '%u' 
	or city ilike '%e' 
	or city ilike '%o')
	order by city asc ;

----------------------------

select * from employees e ;

-- 8
select first_name, last_name from employees e where birth_date < '1968-01-01';


-- date formatting in postgres
select first_name, last_name from employees e 
	where extract (year from now()) - extract(year from birth_date) > 55;

-- 9
select product_name from products p
order by product_name asc ;

-- 10
select * from products p where supplier_id = 3 and price < 40 ;

-- 11
select count(product_id) from products p where category_id = 8;

-- 12
select shipper_id, count(*) jumlah from orders o 
	where shipper_id in (1,2,2)
	group by shipper_id 
	order by jumlah desc ;

select * from order_details od ;

-- 13
select product_id, sum(quantity) jumlah from order_details od
	group by product_id
	order by jumlah desc 
	limit 10;

-- 14
select order_id, sum(quantity) jumlah from order_details od
	group by order_id 
	order by jumlah asc  
	limit 10;

--15
select order_id, count(distinct product_id) jumlah from order_details od
	group by order_id 
	order by jumlah desc 
	limit 10;


 

