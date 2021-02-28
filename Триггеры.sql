-- триггер запрещающий вставлять в поле телефон количесвто цифр отличные от 11
delimiter //
DROP trigger if exists add_users// 
CREATE TRIGGER add_users AFTER INSERT 
ON users 
FOR EACH ROW 
begin
	 IF LENGTH(NEW.phone) != 11 
	 then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Запонлите корректно поле телефон';
    END IF;
end//

-- триггер не дает купить товара, больше чем на складе
delimiter //
DROP trigger if exists few_items_to_order// 
CREATE TRIGGER few_items_to_order before INSERT 
ON orders 
FOR EACH ROW 
begin
	 DECLARE quantity_id bigINT;
  SELECT quantity INTO quantity_id FROM storehouse where product_id = NEW.product_id;

	
	if new.quantity > quantity_id
	then 
		
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Недостаточно товара для заказа.';
	
    END IF;
	
end//







