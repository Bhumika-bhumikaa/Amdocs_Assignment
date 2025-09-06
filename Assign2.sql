select * from categories;
select * from products;
select * from suppliers;

-- 1 create a function "total_stock_available " to return the total stock quqntity for a particular supplier name


delimiter $$
create function total_stock_available (s_id varchar(60))
returns int
deterministic
begin
return (select sum(stock_quantity) 
from products 
where supplier_id = s_id);
end $$
delimiter ;

select total_stock_available(2) as stocks;

-- 2 create a function as to return the product name for a supplier email as "sales@globalgoods.com" and category  id as'1'
delimiter $$

  
create function fetchName()
returns varchar(60)
deterministic
begin
return(
select product_name 
from products
where supplier_id = (
	select supplier_id from suppliers where contact_email = 'sales@globalgoods.com'
) and category_id = '1');
end $$
delimiter ;

select fetchName() as name;


select * from products;

-- 3 create a procedure to return all the products


delimiter $$
create procedure returnProds ()
begin
select product_name 
from products;
end $$
delimiter ;

call returntProds();

-- 4  create a procedure to return total stock quantity for a particular category id passed as input


delimiter $$
create procedure returnStocks (in cid int, out stocks int)
begin
select sum(stock_quantity) into stocks
from products
where category_id = cid;
end $$
delimiter ;

call returnStocks(3, @stocks);
select @stocks as stocks;
