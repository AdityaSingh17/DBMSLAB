--Create table employee.
create table employee
(
	ssn varchar(10),
	name varchar(10),
	salary number(8),
	superssn varchar(10),
	dno number(1),
	constraint pk_ssn primary key(ssn) 
);

--Create table department.
create table department
(
	dno number(1),
	dname varchar(15),
	mgrssn varchar(10),
	constraint pk_dno primary key(dno),
	constraint fk_ssn foreign key(mgrssn) references employee(ssn) on delete cascade
);

--Create table project.
create table project
(
	pno number(2),
	pname varchar(15),
	dno number(1),
	constraint pk_pno primary key(pno),
	constraint fk_dno foreign key(dno) references department(dno) on delete cascade
);

--Create table works_on
create table works_on
(
	ssn varchar(10),
	pno number(2),
	constraint cpk_ssnpno primary key(ssn, pno),
	constraint fk_ssn1 foreign key(ssn) references employee(ssn) on delete cascade,
	constraint fk_pno foreign key(pno) references project(pno) on delete cascade
);

--Insert values into respective table.
insert into employee values ('&ssn', '&name', &salary, '&superssn', &dno);
insert into department values (&dno, '&dname', '&mgrssn');
insert into project values (&pno, '&pname', &dno);
insert into works_on values ('&ssn', &pno); 

--Add the required foreign key for the "employee" table.
alter table employee add constraint fk_dno11 foreign key(dno) references department(dno) on delete cascade;

-- 1. Make a list of all project numbers for projects that involve an employee whose last name is ‘scott’, either as a worker or as a manager of thedepartment that controls the project.
(select distinct p.pno
from project p, employee e, department d
where e.ssn=d.mgrssn and d.dno = p.dno and e.name = 'scott')
union
(select distinct p.pno
from project p, employee e, works_on w
where e.ssn=w.ssn and p.pno=w.pno and e.name='scott');

-- 2. Show the resulting salaries if every employee working on the ‘IoT’ project isgiven a 10 percent raise.
select e.name, 1.1*e.salary as hike_sal
from employee e, works_on w, project p
where e.ssn=w.ssn and p.pno=w.pno
and p.pname='IoT';

-- 3. Find the sum of salaries of all employees of ‘accounts’ department as well as the max(salary),min(salary),avg(salary) in this department.
select sum(e.salary) as sum_sal, max(e.salary) as max_sal, avg(e.salary) as avg_sal, min(e.salary) as min_sal
from employee e, department d
where d.dno=e.dno and d.dname='accounts';

-- 4. Retrive the name of each employee who works on all the projects controlled by department no. 5.(use NOT EXISTS ) operator.
select e.name
from employee e where 
not exists((select p.pno from project p where p.dno=5)minus(select w.pno from works_on w where e.ssn=w.ssn));

-- 5. For each department that has more than 5 employees retrieve the dno and no. of its employees 	who are making more than 6,00,000.
select dno, count(*) as no_of_emp
from employee 
where salary > 600000
and dno in (select e.dno from employee e group by e.dno having count(*)>5)
group by dno;
