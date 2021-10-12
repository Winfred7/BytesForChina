--1,2 defining beging tables
create table restaurant(
  id integer primary key,
  name varchar(50),
  description varchar(200),
  rating decimal,
  telephone char(14),
  hours varchar(200)
  
);

create table address(
  id integer primary key,
  street_name varchar(50),
  street_number varchar(50),
  city varchar(50),
  state varchar(50),
  google_map_link varchar(50)
);

---validate keys for first 2 tables
select constraint_name,table_name,column_name
from information_schema.key_column_usage
where table_name='restaurant';

select constraint_name,table_name,column_name
from information_schema.key_column_usage
where table_name='address';


--3 creating more tables
create table category(
  id char(2) primary key,
  name varchar(25),
  description varchar(200)
);
--valide key
select constraint_name,table_name,column_name
from information_schema.key_column_usage
where table_name='category';

--4 more tables
create table dish(
  id integer primary key,
  name varchar(50),
  description varchar(200),
  hot_n_spicy boolean
);
--5,6
create table review(
  id integer primary key,
  restaurant_id integer references restaurant(id),
  rating decimal,
  comment varchar(200),
  date date
);
-
--7 Define Relationships and foreign keys
alter table address
add column restaurant_id integer unique;

alter table address
add foreign key(restaurant_id) 
references restaurant(id);

select constraint_name,table_name,column_name
from information_schema.key_column_usage
where table_name='address';

select constraint_name,table_name,column_name
from information_schema.key_column_usage
where table_name='review';

--8 many to many btn cat. dish tbs
create table cats_dishes(
  category_id char(2) references category(id),
  dish_id integer references dish(id),
  primary key(category_id,dish_id),
    price money
);

select constraint_name,table_name,column_name
from information_schema.key_column_usage
where table_name='cats_dishes';

---9. Insert Sample Data
INSERT INTO category VALUES (
  'C',
  'Chicken',
  null
);

INSERT INTO category VALUES (
  'LS',
  'Luncheon Specials',
  'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'
);

INSERT INTO category VALUES (
  'HS',
  'House Specials',
  null
);

/* 
 *--------------------------------------------
 Insert values for dish
 *--------------------------------------------
 */
INSERT INTO dish VALUES (
  1,
  'Chicken with Broccoli',
  'Diced chicken stir-fried with succulent broccoli florets',
  false
);

INSERT INTO dish VALUES (
  2,
  'Sweet and Sour Chicken',
  'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers',
  false
);

INSERT INTO dish VALUES (
  3,
  'Chicken Wings',
  'Finger-licking mouth-watering entree to spice up any lunch or dinner',
  true
);

INSERT INTO dish VALUES (
  4,
  'Beef with Garlic Sauce',
  'Sliced beef steak marinated in garlic sauce for that tangy flavor',
  true
);

INSERT INTO dish VALUES (
  5,
  'Fresh Mushroom with Snow Peapods and Baby Corns',
  'Colorful entree perfect for vegetarians and mushroom lovers',
  false
);

INSERT INTO dish VALUES (
  6,
  'Sesame Chicken',
  'Crispy chunks of chicken flavored with savory sesame sauce',
  false
);

INSERT INTO dish VALUES (
  7,
  'Special Minced Chicken',
  'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.',
  false
);

INSERT INTO dish VALUES (
  8,
  'Hunan Special Half & Half',
  'Shredded beef in Peking sauce and shredded chicken in garlic sauce',
  true
);

/*
 *--------------------------------------------
 Insert valus for cross-reference table, categories_dishes
 *--------------------------------------------
 */
INSERT INTO cats_dishes VALUES (
  'C',
  1,
  6.95
);

INSERT INTO cats_dishes VALUES (
  'C',
  3,
  6.95
);


INSERT INTO cats_dishes VALUES (
  'LS',
  1,
  8.95
);

INSERT INTO cats_dishes VALUES (
  'LS',
  4,
  8.95
);

INSERT INTO cats_dishes VALUES (
  'LS',
  5,
  8.95
);

INSERT INTO cats_dishes VALUES (
  'HS',
  6,
  15.95
);

INSERT INTO cats_dishes VALUES (
  'HS',
  7,
  16.95
);

INSERT INTO cats_dishes VALUES (
  'HS',
  8,
  17.95
);

/* 
 *--------------------------------------------
 Insert values for restaurant
 *--------------------------------------------
 */
INSERT INTO restaurant VALUES (
  1,
  'Bytes of China',
  'Delectable Chinese Cuisine',
  3.9,
  '6175551212',
  'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm'
);

/* 
 *--------------------------------------------
 Insert values for address
 *--------------------------------------------
 */
INSERT INTO address VALUES (
  1,
  'Busy Street',
  '2020',
  'Chinatown',
  'MA',
  'http://bit.ly/BytesOfChina',
  1
);



/* 
 *--------------------------------------------
 Insert values for review
 *--------------------------------------------
 */
INSERT INTO review VALUES (
  1,
  1,
  5.0,
  'Would love to host another birthday party at Bytes of China!',
  '05-22-2020'
  
);

INSERT INTO review VALUES (
  2,
  1,
  4.5,
  'Other than a small mix-up, I would give it a 5.0!',
  '04-01-2020'
  
);

INSERT INTO review VALUES (
  3,
  1,
  3.9,
  'A reasonable place to eat for lunch, if you are in a rush!',
  '03-15-2020'
);
---10 making queries

select a.name, 
b.street_number||' '||b.street_name as address
from restaurant a,address b
where a.id=b.restaurant_id;

---11.get best ratin for restaurant
select max(a.rating) best_rating
from review a, restaurant b
where a.restaurant_id=b.id;

---12.
select a.name dish_name,
c.price price ,
b.name category
from dish a
join cats_dishes c
on c.dish_id=a.id
join category b
on b.id=c.category_id
order by a.name;


---13
select b.name category,
 a.name dish_name,
c.price price 
from dish a
join cats_dishes c
on c.dish_id=a.id
join category b
on b.id=c.category_id
order by b.name;

--14
 select a.name spicy_dish_name,
b.name category,
c.price price 
from dish a
join cats_dishes c
on c.dish_id=a.id
join category b
on b.id=c.category_id
where a.hot_n_spicy= 'true'
order by a.name;

---15
select dish_id,
 count(dish_id) as dish_count
 from cats_dishes
 group by 1
 ;

 --16
 select dish_id,
 count(dish_id) as dish_count
 from cats_dishes
 group by 1
 having count(dish_id) >1;

 ---17
 select b.name dish_name,
 count(dish_id) as dish_count
 from cats_dishes a
 join dish b
 on b.id=a.dish_id
 group by 1
 having count(dish_id) >1;

--18


select rating best_rating,
comment description
from review 
where  rating=(select max(a.rating)
from review a, restaurant b
where a.restaurant_id=b.id);


