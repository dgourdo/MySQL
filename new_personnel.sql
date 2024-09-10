-- Δημιουργία της ΒΔ
drop database if exists new_personnel;
create database new_personnel;
use new_personnel;

-- Δημιουργία των πινάκων της ΒΔ
create table dept
(deptno int(3) not null,dname varchar(40) not null,loc varchar(10),
primary key(deptno));

create table emp
(empno int(3) not null,ename varchar(40) not null,job varchar(20), hiredate varchar(15) not null,
 mgr varchar(15),sal float(7,2),comm float(5,2) , deptno int(3),
primary key(empno),
foreign key (deptno) references dept(deptno));

create table proj
(proj_code int(3) not null,description varchar(20),
primary key(proj_code));

create table assign
(empno int(2) not null,proj_code int(3) not null,a_time int(2) not null, 
primary key(empno,proj_code),    -- 2 primary keys
foreign key (empno) references emp(empno),
foreign key (proj_code) references proj(proj_code));


-- Εισαγωγή τιμών στους πίνακες
insert into dept (deptno,dname,loc) values
(10,'Accounting','Athens'),(20,'Sales','London'),(30,'Research','Athens'),(40,'Payroll','London');

insert into emp (empno, ename, job, hiredate, mgr, sal,comm , deptno) values
(10,'Codd'   ,'Analyst'   ,'1/1/89',15,3000,null,10),
(15,'Elmasri','Analyst'   ,'2/5/95',15,1200,150,10),
(20,'Navathe','Salesman'  ,'7/7/77',20,2000,null,20),
(30,'Dave'   ,'Programmer','4/5/04',15,1800,200,10);

insert into proj (proj_code,description) values
(100,'Payroll'),(200,'Personnel'),(300,'Sales');

insert into assign (empno ,proj_code ,a_time) values
(10,100,40),(10,200,60),(15,100,100),(20,200,100),(30,100,100);

-- Επαλήθευση των παραπάνω εντολών
show tables;
describe dept;
describe emp;
describe proj;
describe assign;

select * from dept;
select * from emp;
select * from proj;
select * from assign;


-- EX4
alter table emp add adress varchar(50);  
describe emp;

alter table dept modify loc varchar(30);
describe dept;

create table task
(task_code int not null,description varchar(20),
primary key(task_code));
describe task;

alter table task add proj_code int;
alter table task add foreign key (proj_code) references proj(proj_code);
describe task;

-- -----------------------------------------------------------------------------------------


-- Ex2.1
select ename,
concat(format(sal,'N3')," €") as "Μισθός",
format(comm,2,'N2') as "Προμήθεια",
concat(format(((ifnull(comm,0)/sal)*100) ,2,'N2')," %") as "Ποσοστό" 
from emp;


-- Ex2.2
select ename as "Επώνυμο",
ifnull(comm,0)+sal as "Μηνιαίες Αποδοχές",
concat(timestampdiff(year,hiredate,'2022-05-27')," έτη") as "Προϋπηρεσία"
from emp 
where timestampdiff(year,hiredate,'2022-05-27')>20;


-- Ex2.3
select ename as "Επώνυμο",
job as "Θέση",
hiredate as "Πρόσληψη"
from emp
where job in('Analyst','Salesman') and
(substring(hiredate,9,2)-substring('2022-05-05',9,2))<0;


-- Ex2.4
select ename 'Όνομα' 
from emp,dept
where  emp.deptno=dept.deptno and     
dept.dname='Accounting';                     



-- Ex2.5   
select ename,
ifnull(comm,0)+sal as "Μισθός",
emp.deptno as "Τμήμα"
from dept
join emp on dept.deptno=emp.deptno and 
emp.sal=(
         select(max(ifnull(comm,0)+sal)) 
         from emp
         where emp.deptno=dept.deptno
		 order by dept.deptno);




-- Ex2.6
select ename,sal
from dept
join emp on dept.deptno=emp.deptno and 
dept.dname='Accounting' and 
emp.sal<(
			select(max(emp.sal)) from emp join dept on emp.deptno=dept.deptno and  dept.dname='Research');
            
 -- -----------------------------------------------------------------------------------------------------------------------   
 
-- Ex3.1        
select emp.ename,dept.deptno,emp.comm
from dept
join emp on dept.deptno=emp.deptno  
where dept.deptno=10
order by emp.comm desc;



-- Ex3.2 
select emp.ename,emp.job,emp.sal
from emp
order by emp.job,emp.sal desc;



-- Ex3.3
select avg(emp.sal),dept.deptno
from dept
join emp on dept.deptno=emp.deptno 
group by dept.deptno
having count(emp.empno)>1;




-- Ex3.4
select dept.deptno as "Τμήμα", 
format(avg(timestampdiff(year,hiredate,'2022-06-09')),1,'N1') as "Προϋπηρεσία(έτη)"
from dept
join emp on dept.deptno=emp.deptno
group by dept.deptno;




-- Ex3.5
select proj.description as "Έργα",
emp.ename as "Απασχολούμενοι Υπάλληλοι",
emp.job as "Θέσεις"
from assign,proj,emp
where assign.empno=emp.empno and
      proj.proj_code=assign.proj_code
order by  proj.description,emp.job;     





-- Ex3.6 
select dept.dname as "Department",
mgr as "Manager",
ename as "Employee"
from dept,emp X                     -- self join
where mgr=(
              select mgr
			  from emp
			  where X.deptno=dept.deptno and
               emp.deptno=dept.deptno and
               X.empno=emp.empno
              )
order by dept.dname,ename;





-- Ex3.7
select emp.ename,emp.job,dept.loc
from dept
join emp on dept.deptno=emp.deptno 
where dept.dname='Research';



-- Ex3.8
select emp.ename, proj.description, assign.a_time
from emp,proj,assign
where assign.empno=emp.empno and
      proj.proj_code=assign.proj_code and
proj.description="Payroll" and
assign.a_time>50;


