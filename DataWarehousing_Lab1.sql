REM   Script: Lab assignment # 1 - DDL, DML, constraints and transaction processing

-- Task 1 create a sequence object 
create sequence my_seq 
start with 1 
increment by 1;

-- Task 2 Create a table structure
--Table CUSTOMER
create table CUSTOMER(
cust_id varchar2(20) not null,
username varchar2(20) not null,
passwd varchar2(20) not null,
first_name varchar2(20) not null,
last_name varchar2(20) not null,
credit_type varchar2(20) not null,
phone varchar2(20)
);

alter table CUSTOMER
add constraint customer_cust_id_pk primary key(cust_id)
;

--Table CUST_ORDER
create table CUST_ORDER(
ord_id varchar2(20) not null,
cust_id varchar2(20) not null,
order_date date default sysdate not null
);

alter table CUST_ORDER
add primary key(ord_id)
add constraint custorder_custid_fk foreign key(cust_id) references customer(cust_id)
;

--Table PROD_GROUP
create table PROD_GROUP(
group_id varchar2(20) not null,
group_name varchar2(20) not null
);

alter table PROD_GROUP
add primary key(group_id)
;

--Table PRODUCT
create table PRODUCT(
prod_id varchar2(20) not null,
group_id varchar2(20) not null,
prod_name varchar2(20) not null,
price varchar2(20) not null
);

alter table PRODUCT
add primary key(prod_id)
add constraint product_groupid_fk foreign key(group_id) references prod_group(group_id)
;

--Table CART
create table CART(
row_id varchar2(20) not null,
ord_id varchar2(20) not null,
prod_id varchar2(20) not null,
amount varchar2(20) not null
);

alter table CART
add primary key(row_id)
add constraint cart_ordid_fk foreign key(ord_id) references cust_order(ord_id)
add constraint cart_prodid_fk foreign key(prod_id) references product(prod_id)
;

--Table PROD_PICT
create table PROD_PICT(
pict_id varchar2(20) not null,
prod_id varchar2(20) not null,
file_type varchar2(20) not null,
width varchar2(20) not null,
height varchar2(20) not null,
path varchar2(100) not null
);

alter table PROD_PICT
add primary key(pict_id)
add constraint prodpict_prodid_fk foreign key(prod_id) references product(prod_id)
;

--Addtitional settings
--customer.credit_type CHECK ('high','average','low')
alter table CUSTOMER
add constraint customer_credit_type_ch check(credit_type in('high','average','low'));
--prod_pict.file_type CHECK ('gif','jpg')
alter table PROD_PICT
add constraint prod_pict_file_type_ch check(file_type in('gif','jpg'));
--customer.username (should be unique, constraint UNIQUE)
alter table customer
add constraint customer_username_uq unique(username);


-- Task 3 Insert three rows in the customer table.
insert into customer(cust_id, username, passwd, first_name, last_name, credit_type, phone)
values(my_seq.nextval,'Tsoy', '264', 'Viktor', 'Tsoy', 'high', '01');

insert into customer(cust_id, username, passwd, first_name, last_name, credit_type, phone)
values(my_seq.nextval,'Kurt', '222', 'Kurt', 'Cobain', 'average', '02');

insert into customer(cust_id, username, passwd, first_name, last_name, credit_type, phone)
values(my_seq.nextval,'Peppa', '228', 'Peppa', 'Pig', 'low', '03');


-- Task 4 Insert two rows in the prod_group table.
insert into prod_group(group_id, group_name)
values(my_seq.nextval,'food');

insert into prod_group(group_id, group_name)
values(my_seq.nextval,'drinks');


-- Task 5 Insert two rows in the product table.
insert into product(prod_id, group_id, prod_name, price)
-- group_id for this one is 4
values(my_seq.nextval, (select group_id from prod_group where GROUP_NAME = 'food'), 'bacon', '10');

insert into product(prod_id, group_id, prod_name, price)
-- group_id for this one is 5
values(my_seq.nextval, (select group_id from prod_group where GROUP_NAME = 'drinks'), 'vodka', '20');



-- Task 6 Perform a sale by creating one row in the cust_order table and two rows in the cart table. 
insert into cust_order(ord_id, cust_id, order_date)
-- Peppa's id is 3
values(my_seq.nextval, '3', sysdate);

-- first good in a cart of that order (Peppa buyed 1 pcs of bacon)
insert into cart(row_id, ord_id, prod_id, amount)
values(my_seq.nextval, (SELECT ORD_ID FROM (SELECT ROW_NUMBER() OVER (ORDER BY ord_id) as RowNumber, ord_id FROM cust_order) WHERE ROWNUMBER ='1'), (select prod_id from product where PROD_NAME = 'bacon'), '1');

-- second good in a cart of that order (Peppa buyed 5 pcs of vodka)
insert into cart(row_id, ord_id, prod_id, amount)
values(my_seq.nextval, (SELECT ORD_ID FROM (SELECT ROW_NUMBER() OVER (ORDER BY ord_id) as RowNumber, ord_id FROM cust_order) WHERE ROWNUMBER ='1'), (select prod_id from product where PROD_NAME = 'vodka'), '5');


-- -- Task 7 Increase the price on all articles by 12%.
update product
set price = price * 1.12;


-- Task 8 Update the phone number.
update customer
set phone = '112'
where username = 'Tsoy';


-- Task 9 Delete all rows from the cust_order table, by using DML. What happens and why!
delete
from cust_order;

commit;
-- The error arose because we tried to delete a table with a parent row while a child row still exists.


