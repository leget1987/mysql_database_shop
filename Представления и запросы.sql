-- представление показывает наличие товаров по разделу каталога

CREATE OR REPLACE VIEW view_products_in_catalog
as
SELECT c.catalog_id, p.name, st.quantity as count_prod, c.name as name_catalog
FROM 
	products p
join
	catalog_subdivision cs
join 
	catalogs c
join 
	storehouse st
on
	p.catalog_sub_id = cs.catalog_subdivision_id and cs.catalog_id = c.catalog_id and p.id = st.product_id 

-- посмотрим наименования и количество товаров в каталоге Одежда
	
SELECT * FROM view_products_in_catalog
where catalog_id = 2

-- представление выводит статистику покупок по пользователям и сортирует по количеству заказов

CREATE or REPLACE VIEW view_user_activ
as
SELECT CONCAT(u.firstname, ' ', u.lastname) as us, COUNT(o.order_id) as cnt
FROM 
	users u 
join
	orders o
on
	u.id = o.user_id 
GROUP by us
ORDER by cnt desc

-- посмотрим статистику покупок

select * FROM view_user_activ

-- пример вложенного запроса, выводит пользователя его пол и количество отзывов

SELECT
	id,
  lastname,
  (SELECT gender from profiles where user_id = users.id) as gend,
  (SELECT count(*) from feedback where user_id = id) as cnt
FROM
  users
order by cnt desc
 

