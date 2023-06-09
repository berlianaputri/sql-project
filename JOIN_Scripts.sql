----- alias dan join--------------

select customer_id as id, customer_name name from customers c ;

select customer_name as "Customer", contact_name as "Contact Person" 
	from customers c ;

select customer_name, concat_ws(', ', address, postal_code, city, country) as address  
	from customers c  
	
select * from products p, categories c where p.category_id = c.category_id ;


select p.product_name, c.category_name, c.description 
	from products p, categories c 
	where p.product_id = c.category_id 
	order by p.category_id
	
select * from categories c 


----- JOIN -------------

-- inner join
select o.order_id, c.customer_name, c.country 
	from orders o inner join customers c 
	on c.customer_id = o.customer_id 
	order by c.customer_id;

select o.order_id, c.customer_name, c.country, s.shipper_name from orders o inner join customers c 
	on o.customer_id = c.customer_id inner join shippers s
	on	s.shipper_id = o.shipper_id
	order by c.customer_id ;

-- left join
select * from customers c left join orders o 
	on c.customer_id = o.customer_id ;
	
-- right join
select * from orders o right join employees e 
	on o.employee_id = e.employee_id;

-- full outer join
select * from customers c full outer join orders o 
	on c.customer_id = o.customer_id
	where o.order_id is not null;

-- self join
select A.customer_name name1, B.customer_name, A.city name2 from customers A, customers B
	where A.customer_id <> B.customer_id
	and A.city = B.city
	order by A.city;

-- group by join 
select shipper_name, count(distinct country) as country deliver from 
	(select o.order_id, c.customer_name, c.country, s.shipper_name from orders o 
		inner join customers c 
			on o.customer_id = c.customer_id 
		inner join shippers s
			on	s.shipper_id = o.shipper_id
		order by c.customer_id) t1
	group by t1.shipper_name;

select customer_name, count(order_id) as order_frek from
	(select o.order_id, c.customer_name, c.country 
		from orders o inner join customers c 
		on c.customer_id = o.customer_id 
		order by c.customer_id) t1
	group by t1.customer_name;

select shipper_name, count(distinct country) as country_deliver
	from orders o 
		inner join customers c 
			on o.customer_id = c.customer_id 
		inner join shippers s 
			on o.shipper_id  = s.shipper_id
	group by shipper_name; 

select shipper_name, count(o.order_id) total from orders o 
	left join shippers s 
		on o.shipper_id = s.shipper_id
	group by shipper_name
	order by total desc ;

-- exercise
-- cek list of employee name yang menghandle order lebih dari 10

select concat_ws(' ', e.first_name, e.last_name) nama, count(o.order_id) no_of_order from employees e 
	left join orders o 
		on e.employee_id = o.employee_id
	group by nama
	having count(order_id) > 10 
	order by no_of_order desc; 

select e.last_name, count(o.order_id) from orders o 
	inner join employees e 
		on o.employee_id = e.employee_id 
	where last_name = 'Davolio' or last_name = 'Fuller'
	group by 1;

-- exercise
-- keluarkan kolom yang berisi nama employee untuk setiap order id yang ada pada tabel order

select o.order_id, concat_ws(' ', first_name, last_name) employee_name from orders o 
	left join employees e 
		on e.employee_id = o.employee_id 
	order by 1;

-- keluarkan data mengenai product_id, nama produk, kategori, supplier
	
select p.product_id, p.product_name, c.category_name, s.supplier_name from products p
	join categories c 
		on c.category_id = p.category_id 
	join suppliers s 
		on s.supplier_id  = p.supplier_id
	order by 1;

-- data 5 negara yang paling banyak membeli barang pada category diary products di tahun 1997

select c.country, sum(od.quantity) total from order_details od 
	join orders o 
		ON o.order_id = od.order_id
	join products p 
		on p.product_id = od.product_id 
	join customers c 
		on c.customer_id = o.customer_id
	join categories c2 
		on c2.category_id = p.category_id 
	where c2.category_name ilike '%dairy%' and extract(year from o.order_date) = 1997
	group by 1
	order by 2 desc
	limit 5;

select c.country, sum(od.quantity) total from order_details od 
	left join orders o 
		ON o.order_id = od.order_id
	left join customers c 
		on c.customer_id = o.customer_id
	left join products p 
		on p.product_id = od.product_id 
	left join categories c2 
		on c2.category_id = p.category_id 
	where c2.category_name ilike '%dairy%' and extract(year from o.order_date) = 1997
	group by 1
	order by 2 desc
	limit 5;


-- EXISTS
select product_name from products p2 where exists
(select product_name from products p where price = 22 and p2.supplier_id = p.supplier_id);


-- supplier yang menjual barang dengan harga dibawah 20$

select * from products p where price < 20;

select * from suppliers s where exists 
	(select * from products p where price < 20 and
s.supplier_id = p.supplier_id) order by 2 asc;

select distinct supplier_name from suppliers s join products p on s.supplier_id = p.supplier_id 
where p.price < 20 order by 1 asc;

select customer_name from customers c where exists 
	(select 1 from orders o where o.customer_id = c.customer_id);


select customer_name from customers c where not exists 
	(select 1 from orders o where o.customer_id = c.customer_id);

select customer_name from orders o, customers c where o.customer_id = c.customer_id;

select product_name from products p where not exists 	
	(select 1 from order_details od where p.product_id = od.product_id);
	

select * from products p 

-- 25
-- list semua supplier yang menyuplai produk yang memiliki kategori yang sama dengan kode 17

select *  from suppliers s where exists 
	(select supplier_name from products p2 where exists  
		(select category_id from products p where p.product_id = 25 and p.category_id=p2.category_id) 
	and s.supplier_id = p2.supplier_id);

select *  from suppliers s where exists 
	(select supplier_name from products p2 where p2.category_id = 
		(select category_id from products p where p.product_id = 25) 
	and s.supplier_id = p2.supplier_id);

select distinct s.supplier_name from suppliers s join products p 
on p.supplier_id = s.supplier_id where p.category_id = (select category_id  from products p where product_id = 25);