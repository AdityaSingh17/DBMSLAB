--Create table salesman.
create table salesman
(
	salesman_id number(4),
	name varchar(15),
	city varchar(15),
	commission number(7,2),
	Constraint pk_salesmanid primary key(salesman_id)
);

--Create table customer.
create table customer
(
	customer_id number(4),
	customer_name varchar(15),
	city varchar(15),
	grade number(3),
	salesman_id number(4),
	Constraint pk_customerid primary key(customer_id),
	Constraint fk_salesmanid foreign key(salesman_id) references salesman(salesman_id) on delete cascade
);

--Create table orders.
create table orders
(
	ord_no number(4),
	purchase_amt number(10,2),
	ord_date date,
	customer_id number(4),
	salesman_id number(4),
	Constraint pk_ordno primary key(ord_no),
	Constraint fk_salesmanid1 foreign key(salesman_id) references salesman(salesman_id) on delete cascade,
	Constraint fk_customerid foreign key(customer_id) references customer(customer_id) on delete cascade
);

--Insert values into respective tables.
insert into salesman values (&salesman_id, '&name', '&city', &commission);

insert into customer values (&customer_id, '&customer_name', '&city', &grade, &salesman_id);

insert into orders values (&ord_no, &purchase_amt, '&ord_date', &customer_id, &salesman_id);

-- 1. Count the customers with grades above Bangalore’s average.
select COUNT(c.customer_id)
from customer c
where c.grade > (select AVG(grade) from customer where city='bangalore');

-- 2. Find the name and numbers of all salesmen who had more than one customer.
select s.name, s.salesman_id
from salesman s, customer c
where s.salesman_id = c.salesman_id
group by s.name, s.salesman_id
having count(customer_id) > 1;

-- 3. List all salesmen and indicate those who have and don’t have customers in their cities. (Use UNION operation)
(select s.name, s.salesman_id, c.customer_name
from salesman s, customer c
where s.salesman_id = c.salesman_id and s.city=c.city)
union
(select s1.name, s1.salesman_id, 'No customer'
	from salesman s1, customer c1
	where s1.salesman_id = c1.salesman_id and s1.city != c1.city
);

-- 4. Create a view that finds the salesman who has the customer with the highest order of a day.
create view max_ord as
	select s.salesman_id, s.name, c.customer_id, c.customer_name, o.ord_date, o.purchase_amt
	from salesman s, customer c, orders o
	where s.salesman_id = c.salesman_id and c.customer_id = o.customer_id;
select * from max_ord m
where m.purchase_amt = (select max(m1.purchase_amt) from max_ord m1 where m.ord_date = m1.ord_date);

-- 5. Demonstrate the DELETE operation by removing salesman with id 1000. All his orders must also be deleted.
delete from salesman where salesman_id = 1000;
