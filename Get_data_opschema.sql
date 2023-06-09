/*
 * Berikan 10 nama customer yang 
 * total belanja (amount) nya paling besar di tahun 1997, 
 * urutkan dari yang paling besar.
 */

select customer_id from customers c where customer_id in 
(select customer_id from  
	(select o.customer_id, sum(od.quantity*p.price) total_amount from orders o 
		join order_details od on o.order_id = od.order_id 
		join products p on od.product_id = p.product_id
		where extract (year from o.order_date) = 1997
		group by o.customer_id
		order by 2 desc  
		limit 10)q1 where q1.customer_id = c.customer_id); 

select c.customer_id, c.customer_name, sum(od.quantity*p.price) total_amount from customers c 
	join orders o on o.customer_id = c.customer_id 
	join order_details od on o.order_id = od.order_id 
	join products p on od.product_id = p.product_id
	where extract (year from o.order_date) = 1997
	group by c.customer_id, c.customer_name
	order by 3 desc
	limit 10; 

/*
 * Kategori product dengan jumlah pembelian paling banyak dan paling sedikit di tahun 1997
 * 
 */

(select c.category_name, sum(od.quantity) qty from order_details od
join products p on p.product_id = od.product_id
join categories c on c.category_id = p.category_id 
join orders o on o.order_id = od.order_id 
where extract(year from o.order_date) = 1997
group by 1
order by 2 desc 
limit 1)
union
(select c.category_name, sum(od.quantity) qty from order_details od
join products p on p.product_id = od.product_id
join categories c on c.category_id = p.category_id 
join orders o on o.order_id = od.order_id 
where extract(year from o.order_date) = 1997
group by 1
order by 2
limit 1)


/*
 * Slowly Changing Dimensions
 * 
 * Attribute of fimension that would undergo changes over time
 * 
 * Types:
 * SCD Type 0 = Ignore any update
 * SCD Type 1 = Maintain the updated records (no history will maintain), Overwrite data in dimensions
 * SCD Type 2 = Maintain the updated records (history will maintain), accommodate historical aspects of data
 */

--- EXERCISE ----

-- SLIDE 3

select c.customer_name, count(order_id) total_order from orders o 
	join customers c on c.customer_id = o.customer_id
	where extract (year from order_date) = 1997
	group by 1
	order by 2 desc 
	limit 5;


-- SLIDE 4

select c.customer_name, count(order_id) from orders o 
	join customers c on c.customer_id = o.customer_id
	where extract (year from order_date) = 1997
	group by 1
	having count(order_id) > 3
	
-- SLIDE 5
	
select p2.product_name, sum(od2.quantity) qty from orders o2 
join order_details od2 on od2.order_id = o2.order_id 
join products p2 on p2.product_id = od2.product_id 
where o2.customer_id in  
(select customer_id from  
	(select o.customer_id, sum(od.quantity*p.price) total_amount from orders o 
		join order_details od on o.order_id = od.order_id 
		join products p on od.product_id = p.product_id
		where extract (year from o.order_date) = 1997
		group by o.customer_id
		order by 2 desc  
		limit 10)q1)
and extract (year from o2.order_date) = 1997
group by 1
order by 2 desc 
limit 5; 



-- slide 6
select s.supplier_name, sum(quantity) from orders o2  
join order_details od2 on od2.order_id = o2.order_id 
join products p2 on p2.product_id = od2.product_id 
join suppliers s on s.supplier_id = p2.supplier_id 
where o2.customer_id in  
(select customer_id from  
	(select o.customer_id, sum(od.quantity*p.price) total_amount from orders o 
		join order_details od on o.order_id = od.order_id 
		join products p on od.product_id = p.product_id
		where extract (year from o.order_date) = 1997
		group by o.customer_id
		order by 2 desc  
		limit 10) q1)
and extract (year from o2.order_date) = 1997
group by 1
order by 2 desc 
limit 1;


/*
 * TRIAL ERROR
 */
select q2.supplier_name, sum(q2.qty) from 
(select s.supplier_name, p2.product_name, sum(quantity) qty from customers c 
join orders o2 on o2.customer_id = c.customer_id 
join order_details od2 on od2.order_id = o2.order_id 
join products p2 on p2.product_id = od2.product_id 
join suppliers s on s.supplier_id = p2.supplier_id 
where c.customer_id in  
(select customer_id from  
	(select o.customer_id, sum(od.quantity*p.price) total_amount from orders o 
		join order_details od on o.order_id = od.order_id 
		join products p on od.product_id = p.product_id
		where extract (year from o.order_date) = 1997
		group by o.customer_id
		order by 2 desc  
		limit 10)q1)
and extract (year from o2.order_date) = 1997
group by 1,2
order by 3 desc
limit 5) q2 group by 1 order by 2 desc limit 1;




-- SLIDE 7
select c2.category_name, sum(quantity) from customers c 
join orders o2 on o2.customer_id = c.customer_id 
join order_details od2 on od2.order_id = o2.order_id 
join products p2 on p2.product_id = od2.product_id 
join categories c2 on p2.category_id = c2.category_id  
where c.customer_id in  
(select customer_id from  
	(select o.customer_id, sum(od.quantity*p.price) total_amount from orders o 
		join order_details od on o.order_id = od.order_id 
		join products p on od.product_id = p.product_id
		where extract (year from o.order_date) = 1997
		group by o.customer_id
		order by 2 desc  
		limit 10)q1)
and extract (year from o2.order_date) = 1997
group by 1
order by 2 desc 
limit 1;

/*
 * TRIAL ERROR
 */
select q2.category_name, sum(q2.qty) qty from 
	(select c2.category_name, p2.product_name, sum(quantity) qty from customers c 
	join orders o2 on o2.customer_id = c.customer_id 
	join order_details od2 on od2.order_id = o2.order_id 
	join products p2 on p2.product_id = od2.product_id 
	join categories c2 on p2.category_id = c2.category_id  
	where c.customer_id in  
	(select customer_id from  
		(select o.customer_id, sum(od.quantity*p.price) total_amount from orders o 
			join order_details od on o.order_id = od.order_id 
			join products p on od.product_id = p.product_id
			where extract (year from o.order_date) = 1997
			group by o.customer_id
			order by 2 desc  
			limit 10)q1)
	and extract (year from o2.order_date) = 1997
	group by 1,2
	order by 3 desc 
	limit 5) q2 
group by 1
order by 2 desc
limit 1;



-- SLIDE 8
-- nama, jumlah_order dari employee lulusan university (dari notes)

select concat_ws(' ', e2.first_name, e2.last_name) name, count(order_id) as order_handle 
from employees e2 
	join orders o on o.employee_id = e2.employee_id 
	where e2.employee_id in 
	(select employee_id from employees e where notes ilike '%university%')
group by 1
order by 2 desc;

select concat_ws(' ', e2.first_name, e2.last_name) name, count(order_id) as order_handle 
from employees e2 
	join orders o on o.employee_id = e2.employee_id 
	where e2.notes ilike '%university%'
group by 1
order by 2 desc;

-- SLIDE 9
nama dan kota dari supplier yang mensupply produk dengan category Grains/Cereals, diurutkan berdasarkan nama

select distinct s.supplier_name, s.city from suppliers s 
	join products p on p.supplier_id = s.supplier_id 
	join categories c on p.category_id = c.category_id 
	where category_name ilike '%grains%'
	order by 1;

-- SLIDE 10
select concat(customer_name, ' (', left(country,1), ')') from customers c

select concat(customer_name, ' (', substring(country,1,1), ')') from customers c


-- SLIDE 11
Hitung besar discount yang diperoleh masing-masing orderid, dengan ketentuan sebagai berikut:
Total Amount dlm 1 orderid <= $700, disc 5%
Total Amount dlm 1 orderid > $700-1500, disc 10%
Total Amount dlm 1 orderid > $1500, disc 15%

select od.order_id, sum(od.quantity*p.price) total_amount,
	case 
		when sum(od.quantity*p.price) <= 700 then (0.05*sum(od.quantity*p.price))
		when 1500 >= sum(od.quantity*p.price) and sum(od.quantity*p.price) > 700 then (0.1*sum(od.quantity*p.price))
		when sum(od.quantity*p.price) > 1500 then (0.15*sum(od.quantity*p.price))
		else 0
	end as discount_amount
from order_details od
join products p on od.product_id = p.product_id
group by 1

select *,
case 
	when q1.total_amount <= 700 then (0.05*q1.total_amount)
	when 1500 >= q1.total_amount and q1.total_amount > 700 then (0.1*q1.total_amount)
	when q1.total_amount > 1500 then (0.15*q1.total_amount)
	else 0
end as discount_amount
from 
(select od.order_id, sum(od.quantity*p.price) total_amount
from order_details od
join products p on od.product_id = p.product_id
group by 1) q1

	
-- slide 12
order_id, product_id, product_name, discounted_price, quantity. dengan discounted price 10% dari original price
 
select od.order_id, p.product_id, p.product_name, 
 	(0.9*p.price) discounted_price, od.quantity  
 	from order_details od 
 	join products p on p.product_id = od.product_id 
 	
 	
 	
 	/*
 	 * Normalization: method of arranging the data in database efficiency
 	 * involve constructing table, setting up relationship between tables  
 	 * redundancy and inconsistent dependency can be removed
 	 * 1NF, 2NF, 3NF, BCNF, 4NF, 5NF
 	 * 
 	 * 
 	 * Denormalization : inverse process of normalization,
 	 * normalize schema converted into schema which has redundant information
 	 * performance improved by using redundancy and keeping redundant data concistent
 	 * reason : overheard produces in query procesor by an over-normalized structure;
 	 * 
 	 * 
 	 *
 	 * DIFFERENCE
 	 * 					NORMALIZATION		DENORMALIZATION
 	 * DATA INTEGRITY	MAINTAINED			HARDEER TO RETAIN
 	 * REDUNDANT		ELIMINATED			INCREASED
 	 * TABLE JOIN		INCREASED			REDUCES
 	 * DISK SPACE		OPTIMIZED			WASTED
 	 * STRONG POINT		Faster insertion	faster search
 	 * 					deletion			optimized read performance
 	 * 					update anomalie	
 	 */
	
	
	
	
	
	
	
	
	
	
	
	
	


