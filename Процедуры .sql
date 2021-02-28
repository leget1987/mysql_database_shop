-- процедура покажет остаток всех товаров

delimiter //
drop procedure if exists balance_of_goods//
CREATE PROCEDURE balance_of_goods()
BEGIN
	SELECT 
		p.id,
		p.name,
		p.price,
		st.quantity 
	FROM 
		products p 
	join
		storehouse st
	on 
		st.product_id = p.id; 

END//

-- CALL balance_of_goods 

-- процедура покажет остаток определенного товара по id

delimiter //
drop procedure if exists balance_of_goods_position//

CREATE PROCEDURE balance_of_goods_position(in prod_id int)
BEGIN
	SELECT 
		p.id,
		p.name,
		p.price,
		st.quantity 
	FROM 
		products p 
	join
		storehouse st
	on 
		st.product_id = p.id
	where
		p.id = prod_id;

END//

-- CALL balance_of_goods_position(13) 


-- процедура, добавляющая при заказе изменения в таблицы orders, payments, 
-- delivery, и обновляет данные о наличии в storehouse

DELIMITER //
DROP PROCEDURE IF EXISTS sp_add_orders//
CREATE PROCEDURE sp_add_orders (user_order_id bigint, prod_id bigint, quantity_new int)
BEGIN
           
    START TRANSACTION;
		INSERT INTO ozon_shop.orders
		(user_id, product_id, quantity, created_at, updated_at)
		VALUES(user_order_id, prod_id, quantity_new, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
		set @last_insert_id_order = LAST_INSERT_ID(); 

		UPDATE ozon_shop.storehouse
		SET product_id=prod_id, quantity=quantity-quantity_new 
		WHERE id=prod_id;
		
		set @total = quantity_new * (SELECT price from products where id = prod_id);
		INSERT INTO ozon_shop.payments
		(payer_id, payment_date, pay_order_id, pay_status, amount_of_payment)
		VALUES(user_order_id, CURRENT_TIMESTAMP, @last_insert_id_order, b'0', @total);

		set @shipping_default = (SELECT shipping_address_default FROM profiles where user_id = user_order_id);
		INSERT INTO ozon_shop.delivery
		(user_id, shipping_address, order_id)
		VALUES(user_order_id, @shipping_default, @last_insert_id_order);

	
	    COMMIT;
	
END//
DELIMITER ;

-- call sp_add_orders (12, 7, 5)




