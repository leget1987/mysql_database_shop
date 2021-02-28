drop database if exists ozon_shop;
CREATE database ozon_shop;
use ozon_shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
    phone BIGINT unique,
    user_password varchar(100)
) comment 'Данные покупателя';

drop table if exists profiles;
CREATE table profiles(
	user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
    created_at DATETIME DEFAULT NOW(),
    hometown VARCHAR(100),
    shipping_address_default text,
    foreign key (user_id) references users(id)
    
)comment 'Профиль покупателя';

drop table if exists catalogs;
CREATE table catalogs(
	catalog_id serial primary key,
	name varchar(100)
) comment 'Разделы каталога';

drop table if exists catalog_subdivision;
CREATE table catalog_subdivision(
	catalog_subdivision_id serial primary key,
	catalog_id BIGINT unsigned NOT NULL,
	name varchar(100),
	foreign key (catalog_id) references catalogs(catalog_id)
) comment 'подкаталоги';

drop table if exists products;
CREATE table products(
	id serial primary key,
	name VARCHAR(255) COMMENT 'Название',
    desription TEXT COMMENT 'Описание',
    image_id BIGINT UNSIGNED NULL,
    price DECIMAL (11,2) COMMENT 'Цена',
    catalog_sub_id BIGINT unsigned NOT NULL,
   	foreign key (catalog_sub_id) references catalog_subdivision(catalog_subdivision_id)

) COMMENT 'Товарные позиции';


drop table if exists storehouse;
CREATE table storehouse(
	id serial primary key,
	product_id BIGINT unsigned NOT NULL,
	quantity int default 0 COMMENT 'остаток',
	foreign key (product_id) references products(id)
	) comment 'Остаток товаров';

drop table if exists media;
CREATE table media(
	media_id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    foreign key (media_id) references products(id)
	) comment 'фото товара';


drop table if exists orders;
CREATE table orders(
	order_id SERIAL PRIMARY KEY,
    user_id BIGINT unsigned NOT NULL,
    product_id BIGINT unsigned NOT NULL,
    quantity int default 1 COMMENT 'количество товара',
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    foreign key (user_id) references users(id),
    foreign key (product_id) references products(id),
    index orders_quantity_idx(quantity)
	) comment 'корзина покупателя';

drop table if exists feedback;
CREATE table feedback(
	feedback_id serial primary key,
	user_id BIGINT unsigned NOT NULL,
	feedback_body text,
	product_id BIGINT unsigned NOT NULL,
	foreign key (user_id) references users(id),
    foreign key (product_id) references products(id)
	) comment 'отзывы покупателей';

drop table if exists payments;
CREATE table payments(
	pay_id serial primary key,
	payer_id BIGINT unsigned NOT NULL,
	payment_date DATETIME DEFAULT NOW(),
	pay_order_id BIGINT unsigned NOT NULL,
	pay_status bit default 0,
	amount_of_payment DECIMAL (11,2) COMMENT 'Стоимость',
	FOREIGN KEY (payer_id) REFERENCES users(id),
	FOREIGN KEY (pay_order_id) REFERENCES orders(order_id)
	)COMMENT 'Оплата заказа'; 

-- может стоит создать отдельную таблицу статус платежа


drop table if exists delivery;
create table delivery(
	id serial primary key,
	user_id BIGINT unsigned NOT NULL,
	shipping_address text,
	order_id BIGINT unsigned NOT NULL,
	foreign key (order_id) references orders(order_id),
	foreign key (user_id) references users(id)
	) comment 'доставка'; 
  