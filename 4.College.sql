--Create table student.
create table student
(
	USN varchar(10),
	sname varchar(20),
	Address varchar(20),
	Phone number(3),
	Gender char,
	Constraint pk_usn primary key(usn)
);

--Create table semsec.
create table semsec 
(
	ssid varchar(2),
	sem number(1),
	sec char,
	Constraint pk_ssid primary key(ssid),
	Constraint c check(sem between 1 and 8)
);

--Create table class.
create table class
(
	usn varchar(10),
	ssid varchar(2),
	Constraint cpk_ussid primary key(usn, ssid),
	Constraint fk_usn foreign key(usn) references student(usn) on delete cascade,
	Constraint fk_ssid foreign key(ssid) references semsec(ssid) on delete cascade
);

--Create table subject.
create table subject 
(
	subcode varchar(7),
	Title varchar(20),
	sem number(1),
	credits number(1),
	Constraint c1 check(sem between 1 and 8),
	Constraint pk_sub primary key(subcode)
);

--Create table iamarks.
create table iamarks
(
	usn varchar(10),
	subcode varchar(7),
	ssid varchar(2),
	test1 number(2), 
	test2 number(2),
	test3 number(2),
	finalia number(2),
	constraint cpk_uss primary key(usn, subcode, ssid),
	Constraint fk_ssid1 foreign key(ssid) references semsec(ssid) on delete cascade,
	Constraint fk_usn1 foreign key(usn) references student(usn) on delete cascade,
	Constraint fk_subcode foreign key(subcode) references subject(subcode) on delete cascade
);

--Insert values into respective table.
insert into student values ('&usn', '&name', '&address', &phone, '&gender'); 
insert into semsec values  ('&ssid', '&sem', '&sec');
insert into class values ('&usn', '&ssid');
insert into subject values ('&subcode', '&title', &sem, &credits);
insert into iamarks (usn, subcode, ssid, test1, test2, test3) values ('&usn', '&subcode', '&ssid', &test1, &test2, &test3);

-- 1. List all the student details studying in fourth semester ‘C’ section.
select s.usn, s.sname, s.gender
from student s, semsec ss, class c
where s.usn = c.usn and ss.ssid = c.ssid
and ss.ssid='4c';

-- 2. Compute the total number of male and female students in each semester and ineach section.
select ss.sem, ss.sec, s.gender, count(s.gender)
from semsec ss, student s, class c
where ss.ssid = c.ssid and s.usn = c.usn
group by ss.sem, ss.sec, s.gender
order by ss.sem, ss.sec;

-- 3. Create a view of Test1 marks of student USN ‘1mv16cs001’ in all subjects.
create view stud_test1 as
	select s.usn, ia.test1
	from student s, iamarks ia
	where s.usn = ia.usn and s.usn = '1mv16cs001';

-- 4. Calculate the FinalIA (average of three) and update the corresponding table for all students.
update iamarks
	set finalia = ((test1+test2+test3)/3;

-- 5. Categorize students based on the following criterion: 
--    If FinalIA = 17 to 20 then CAT = ‘Outstanding’
--    If FinalIA = 12 to 16 then CAT = ‘Average’
--    If FinalIA< 12 then CAT = ‘Weak’
--    Give these details only for 8th semester A, B, and C section students.
select s.usn, s.sname, ia.finalia, (case 
when finalia between 17 and 20 then 'Outstanding'
when finalia between 12 and 16 then 'Average'
else 'Weak'
end) as cat 
from student s, iamarks ia, semsec ss
where s.usn=ia.usn and ss.ssid = ia.ssid and ss.sem=8;
