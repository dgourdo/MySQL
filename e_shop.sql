drop database if exists e_shop;
create database e_shop;
use e_shop;

create table Costumer
(AFM int(5) not null,name varchar(40) not null,adress varchar(50) not null,tel varchar(10) not null,
primary key(AFM));

create table Product
(pr_id int(7) not null,p_name varchar(40) not null,category varchar(20) not null, year int(4) not null,
cost float(6,2),avg_rating float(2,1),     -- cost: total of 6 digits, 4 to the left of decimal and 2 to the right of decimal
primary key(pr_id)
-- foreign key (avg_rating) references Rating(rate)
);

create table Orders
(order_id int(5) not null,pr_id int(7) not null,AFM int(5) not null, date datetime, -- 2022-12-9 18:20:13
pieces int(1),final_cost float(7,2),delivery_method varchar(30),
primary key(order_id),
foreign key (pr_id) references Product(pr_id),
foreign key (AFM) references Costumer(AFM)
);

create table Rating
(pr_id int(7) not null,AFM int(5) not null, rate float(2,1), 
foreign key (AFM) references Costumer(AFM),
foreign key (pr_id) references Product(pr_id),
check (rate between 0.0 and 5.0));    

insert into Costumer(AFM,name,adress,tel) values
(78521,"Papadopoulos Athanasios","Olympou 15 , Chalandri","6912345678"),
(24591,"Alafouzos Ioannis","Nafsikas 13 , Palaio Faliro","6913107895"),
(33221,"Koletsa Anna","Dimosthenous 99 , Kallithea","6912340012"),
(78410,"Anastasopoulou Maria","El. Venizelou 107 , Kallithea","6900358955"),
(11089,"Papadopoulos Anastasios","Ploutarchou 27 , Koukaki","6912045970");

insert into Product(pr_id,p_name,category,year,cost,avg_rating) values
(9993499,"iPhone 14","Smartphones",2022,1069.00,4.9),
(9994577,"Huawei Nova 9 SE","Smartphones",2022,319.00,3.5),
(9993498,"Samsung Galaxy S22","Smartphones",2022,789.99,4.8),
(9993497,"Xiaomi Redmi 9A","Smartphones",2021,111.90,4.2),
(9993491,"Xiaomi Redmi Note 11","Smartphones",2021,279.99,4.2),
(1324657,"Microwave SHARP R244S ","Appliances",2019,149.00,3.3),
(9123456,"Espresso Machine IZZY Amalfi IZ-6004","Appliances",2020,100.00,4.4),
(3332221,"Samsung Neo QLED 55 8K Smart","TVs",2022,1899.00,4.5),
(9876543,"Samsung Neo QLED 85t","TVs",2022,2799.00,4.0);


set @rand1=round((rand() * 99999));  -- order_id: random number up to 99.999(5 digit), rounded to be integer
set @rand2=round((rand() * 99999));  -- stored as a variable 
set @rand3=round((rand() * 99999));
set @rand4=round((rand() * 99999));
set @rand5=round((rand() * 99999));


insert into Orders(order_id,pr_id,AFM,date,pieces,final_cost,delivery_method) values
(@rand1,9993499,78521,"2022-12-9 18:20:13",1,1069.00,"pick-up from the store"),
(@rand2,1324657,78410,"2022-12-10 10:0:04",1,152.00,"courier"),     -- final_cost=cost=3 , for courier delivery_method
(@rand3,9876543,33221,"2022-12-10 11:37:55",2,(2799.00*2)+10,"courier"), -- courier cost=10 , heavy products
(@rand4,9993498,24591,"2022-12-13 13:13:13",1,789.99,"pick-up from the store"),
(@rand5,9993498,33221,"2022-12-13 13:55:58",1,789.99,"pick-up from the store");

insert into Rating(pr_id,AFM,rate) values
(9993499,78521,4.9),
(9993498,24591,4.7),
(9993498,33221,4.9),
(1324657,78410,3.3);


show tables;
describe Costumer;
describe Product;
describe Orders;
describe Rating;

select * from Costumer;
select * from Product;
select * from Orders;
select * from Rating;

-- Ασφαλής Ενημερώσιμη view
drop view if exists warehouse_department_view;
create view warehouse_department_view(w_order_id,w_pr_id,w_date,w_pieces,w_final_cost,w_delivery_method)
 as select o.order_id,o.pr_id,o.date,o.pieces,o.final_cost,o.delivery_method
 from orders o
 with check option
 ;                      -- Δεν περιέχει τη στήλη AFM για λόγους ασφαλείας.

select * 
from warehouse_department_view
order by w_date; 


-- Μη ενημερώσιμη view
drop view if exists TVs_view;
create view TVs_view(t_pr_id,t_p_name,t_year,t_cost,t_avg_rating)
 as select p.pr_id,p.p_name,p.year,p.cost,p.avg_rating
 from product p
 where p.pr_id in(select p.pr_id from product p where p.category="TVs")
 ;                      

select * 
from TVs_view
order by t_avg_rating desc,t_cost desc
;


-- DB backup




