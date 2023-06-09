--- UNION ----------
-- digunakan untuk menempelkan 2 buah query

select distinct city from customers c 
	union
	select distinct city from suppliers s;
	
-- union all
select distinct city from customers c 
	union all
	select distinct city from suppliers s;

select city, country from customers c where country ilike 'germany'
	union
	select city, country from suppliers s where country ilike 'germany';

select city, country from customers c where country ilike 'germany'
	union all
	select city, country from suppliers s where country ilike 'germany';
	
select contact_name, city, country from customers c where country ilike 'germany'
union
select contact_name, city, country from suppliers s where country ilike 'germany';


---- ANY - ALL --------------------
-- any equal to multiple or based on query as reference,
-- all equal to multiple and based on quuery result 


select product_id, product_name from products p where product_id = any(
	select distinct product_id from order_details od where quantity = 10);

select product_id, product_name from products p where product_id = any(
	select distinct product_id from order_details od where quantity > 99);

-- list semua supplier yang menyuplai produk yang memiliki kategori yang sama dengan kode 25

select supplier_name  from suppliers s where supplier_id = any(
	select supplier_id from products p2 where category_id =
		(select category_id from products p where product_id = 25));

	
	
--- CASE ------------
	
select * from (select order_id, quantity,
	case
		when quantity > 30 then 'the qty is greater than 30'
		when quantity = 30 then 'the qty is 30'
	end as qty_text
from order_details od) q1 where q1.qty_text is not null ;

select customer_id, customer_name, 
	case 
		when country = 'UK' then 'United Kingdom'
		when country = 'USA' then 'United States of America'
		else country
	end as country
from customers c ;


--- subqueries ----------
-- subqueries merupakan query yang merupakan bagian dari query lain
-- select a from b where c
-- b bisa jadi suatu query
-- c bisa jadi suatu query


select country, count(customer_id) from 
	(select * from customers c where customer_name like 'B%') q1
	group by country;

select * from products p 
	where category_id in (select category_id from categories c where category_name like 'C%');

-- perlihatkan product yang harganya lebih mahal dari harga rata rata

select product_name, price from products p2 
	where price > (select avg(price) avg_price from products p);

-- perlihatkan list produk yang harganya kurang dari 20 dan nama kategorinya berawalan dari B

select * from products p where price < 20 and 
	category_id = (select category_id from categories c where category_name ilike 'b%');

-- berapa banyak order yang terjadi per harinya

select order_date, count(order_id) from orders
	group by order_date ;

-- berapa kuantitas barang yang diorder per daynya
select order_date, sum(quantity) quantity from 
	(select order_date, quantity from order_details od join orders o on o.order_id = od.order_id) q1
	group by 1 
	order by 1;

select order_date, sum(quantity) from order_details od join orders o on o.order_id = od.order_id
	group by 1
	order by 1;

select order_date, (select sum(quantity) from order_details od where o.order_id = od.order_id) qty
	from orders o order by 1;



	

