-- Ej. inicial.
-- En la base de datos GBDgestionaTest, crea un trigger que controle que la fecha de publicación de un test no sea anterior a la de creación.

use GBDgestionaTests;

delimiter $$
CREATE TRIGGER controlTests BEFORE INSERT
ON tests
FOR EACH ROW
begin
    if fecpublic > feccreacion then
    SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El test no se puede publicar antes de su creación';
	end if;
end $$
delimiter ;