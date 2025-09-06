-- 1. categories
use amdocs;
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
select * from categories;

-- 2. suppliers

select * from suppliers;
CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100),
    phone VARCHAR(20)
);


-- 3. products

CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category_id INT REFERENCES categories(category_id) ,
    supplier_id INT REFERENCES suppliers(supplier_id) ,
    price NUMERIC(10, 2) CHECK (price >= 0),
    stock_quantity INT CHECK (stock_quantity >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----Insert into categories-----

INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Devices and gadgets'),
('Books', 'Printed and digital books'),
('Clothing', 'Apparel and accessories');

-- ---Insert into  suppliers------

INSERT INTO suppliers (supplier_name, contact_email, phone) VALUES
('Best Supplier Inc.', 'contact@bestsupplier.com', '123-456-7890'),
('Global Goods', 'sales@globalgoods.com', '987-654-3210');

-- ---Insert into  products-------

INSERT INTO products (product_name, category_id, supplier_id, price, stock_quantity) VALUES
('Smartphone Model X', 1, 1, 699.99, 50),
('Wireless Headphones', 1, 2, 199.99, 30),
('Mystery Novel', 2, 1, 14.99, 100),
('T-shirt Classic', 3, 2, 9.99, 200),
('E-reader', 1, 1, 129.99, 10);


-- Questions (DDL + DML)
/* Write SQL to create the three tables: categories, suppliers, and products.

(a) Retrieve a list of all products with their category name and supplier name.
(b) Find all products where stock quantity is below 5.
(c) Add a new column discount_percent to the products table with a default value of 0.
(d) Write a query to reduce the price of all products in the "Electronics" category by 15%.

Questions (Aggregate, Filtering, Grouping, Sorting)
(e) Find the total number of products available in the products table.
(f) Find the average price of all products.
(g) Find the maximum and minimum price of products in the "Electronics" category.
(h) List categories along with the count of products in each category.
(i) List suppliers who supply products priced between $50 and $200.
(j) Find all products whose category_id is in the list of category IDs (1, 3).
(k) Find the total stock quantity per category but only for categories having more than 1 product.
(l) List all products grouped by supplier and show the average price per supplier, but only for suppliers whose average product price is greater than $100.
(m) List all products sorted by price in descending order.
(n) List the total value of stock (price * stock_quantity) for each category, ordered by total value from highest to lowest.

10 Questions on JOINS
(a) Write a query to list all products with their corresponding category name using an INNER JOIN.
(b) Write a query to list all products with their category name, including products that do not belong to any category (LEFT JOIN).
(c) Write a query to list all categories and the count of products in each category, including categories with no products (LEFT JOIN and GROUP BY).
(d) Write a query to list all products along with their supplier names, including products that have no supplier assigned (LEFT JOIN).
(e) Write a query to list all suppliers and the products they supply, including suppliers who supply no products (RIGHT JOIN).
(f) Write a query to find all products that do not have a supplier assigned.
(g) Write a query to get all products with their category name and supplier name using multiple JOINs (join products with both categories and suppliers).
(h) Write a query to get a list of all suppliers and categories, even if there are no products linking them (FULL OUTER JOIN between suppliers and categories).
(i) Write a query to find products where the supplier's contact email is not null using a join.
(j) Write a query to find categories that have products supplied by supplier named 'Global Goods'. */

select * from products;
-- (a) Retrieve a list of all products with their category name and supplier name.

select p.product_name,c.category_name,s.supplier_name from products p
join categories c on p.category_id= c.category_id
join suppliers s on s.supplier_id=p.supplier_id;

-- (b) Find all products where stock quantity is below 5:

select * from products where stock_quantity < 5;

-- (c) add new column discount_percent to the products table with a default value of 0:

alter table products
add column discount_percent numeric(5,2) default 0;

-- (d) Write a query to reduce the price of all products in the "Electronics" category by 15%:

UPDATE products
SET price = price * 0.85
WHERE category_id IN (SELECT category_id FROM categories WHERE category_name = 'Electronics');

-- Aggregate, Filtering, Grouping, Sorting Queries -----------
select * from products;
-- (e) Find the total number of products available in the products table:

select count(*) from products;

-- (f) Find the average price of all products:

select avg(price) as avg_price from products;

-- (g) Find the maximum and minimum price of products in the "Electronics" category:

select max(price) as maximum,min(price) as minimun from products p
join categories c on p.category_id =c.category_id where c.category_name="electronics";

-- (h) List categories along with the count of products in each category:

select category_name,count(product_id) as product_count
from categories c 
join products p on p.category_id=c.category_id group by(category_name);

-- (i) List suppliers who supply products priced between $50 and $200:

select distinct supplier_name from suppliers s 
join products p on p.supplier_id=s.supplier_id where p.price between 50 and 200;

-- (j) Find all products whose category_id is in the list of category IDs (1, 3):

select * from products where category_id in (1,3 );

-- (k) Find the total stock quantity per category but only for categories having more than 1 product:

SELECT c.category_name, SUM(p.stock_quantity) AS total_stock
FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name
HAVING COUNT(p.product_id) > 1;

-- (L) List all products grouped by supplier and show the average price per supplier, 
-- but only for suppliers whose average product price is greater than $100:

select supplier_name,avg(price) as avg_price 
from suppliers s
join products p where p.supplier_id = s.supplier_id
group by s.supplier_name 
having avg(p.price)>100;

-- (M) List all products sorted by price in descending order:

select * from products order by price DESC;

-- (N) List the total value of stock (price * stock_quantity) for each category,
-- ordered by total value from highest to lowest:

select c.category_name,sum(p.price * p.stock_quantity) as total_value_stock from categories c
join products p where c.category_id = p.category_id
group by c.category_name
order by total_value_stoke DESC;


-- ---------JOINS------------
-- (a) List all products with their corresponding category name using an INNER JOIN:

SELECT p.product_name, c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id;


-- (b) List all products with their category name, including products that do not belong to any category (LEFT JOIN):

SELECT p.product_name, c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id;


-- (c) List all categories and the count of products in each category, including categories with no products (LEFT JOIN and GROUP BY):

SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;


-- (d) List all products along with their supplier names, including products that have no supplier assigned (LEFT JOIN):

SELECT p.product_name, s.supplier_name
FROM products p
LEFT JOIN suppliers s ON p.supplier_id = s.supplier_id;


-- (e) List all suppliers and the products they supply, including suppliers who supply no products (RIGHT JOIN):

SELECT s.supplier_name, p.product_name
FROM suppliers s
RIGHT JOIN products p ON s.supplier_id = p.supplier_id;


-- (f) Find all products that do not have a supplier assigned:

SELECT * 
FROM products
WHERE supplier_id IS NULL;


-- (g) Get all products with their category name and supplier name using multiple JOINs (join products with both categories and suppliers):

SELECT p.product_name, c.category_name, s.supplier_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id;


-- (h) Get a list of all suppliers and categories, even if there are no products linking them (FULL OUTER JOIN between suppliers and categories):

SELECT s.supplier_name, c.category_name
FROM suppliers s
FULL OUTER JOIN categories c ON s.supplier_id = c.category_id;


-- (i) Find products where the supplier's contact email is not null using a join:

SELECT p.product_name, s.contact_email
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE s.contact_email IS NOT NULL;


-- (j) Find categories that have products supplied by supplier named 'Global Goods':

SELECT DISTINCT c.category_name
FROM categories c
INNER JOIN products2 p ON c.category_id = p.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE s.supplier_name = 'Globa
