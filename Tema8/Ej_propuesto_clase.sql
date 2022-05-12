-- Ej. inicial.
-- En la base de datos GBDgestionaTest, crea un trigger que controle que la fecha de publicación de un test no sea anterior a la de creación.

use GBDgestionaTests;

/* PLANTEAMIENTO --> Trigger para antes del insert en test.
old ==> no tiene nada
new ==> los valores de test de lo que voy a insertar.
VALORES A LOS QUE PUEDO ACCEDER CON NEW:
new.codtest
new.descripcion
new.unidadtest
new.codmateria
new.repetible
new.feccreacion
new.fecpublic
*/
DROP TRIGGER IF EXISTS controlTests;
delimiter $$
CREATE TRIGGER controlTests BEFORE INSERT
ON tests
FOR EACH ROW
BEGIN
    IF NEW.fecpublic < NEW.feccreacion THEN
    SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El test no se puede publicar antes de su creación';
	END IF;
END $$
delimiter ;

-- PRUEBA:
INSERT INTO tests
(codtest, descrip, unidadtest, codmateria, repetible, feccreacion, fecpublic)
VALUES
(8, 'prueba', 1, 1, 0, '2022/5/12', '2022/5/11');

/*EL MISMO EJERCICIO PERO CON UPDATE*/
/* PLANTEAMIENTO --> Trigger antes de actualizar un test
old ==> Los datos antes de la actualización
new ==> Los datos después de la actualización
VALORES A LOS QUE PUEDO ACCEDER CON NEW:
new.codtest
new.descripcion
new.unidadtest
new.codmateria
new.repetible
new.feccreacion
new.fecpublic
*/
DROP TRIGGER IF EXISTS compruebafechatestEditar;
delimiter $$
CREATE TRIGGER compruebafechatestEditar BEFORE UPDATE
ON tests
FOR EACH ROW
BEGIN
	IF (NEW.fecpublic <> OLD.fecpublic OR NEW.feccreacion <> OLD.feccreacion) -- Si lo que han cambiado son las fechas
		AND NEW.fecpublic < NEW.feccreacion THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = "El test no se puede publicar antes de su creación";
    END IF;
END $$
delimiter ;

-- PRUEBA
UPDATE tests
SET repetible = 1
WHERE codtest = 8; -- No entrará dentro del IF del TRIGGER.
