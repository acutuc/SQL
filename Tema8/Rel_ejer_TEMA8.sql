-- Para la base de datos empresaclase haz los siguientes ejercicios:
use empresaclase;

-- 1.Comprueba que no podamos contratar a empleados que no tengan 16 años.
delimiter $$
drop trigger if exists compruebaedad $$
create trigger compruebaedad
	before insert on empleados
for each row
begin
	-- if date_sub(curdate(), interval 16 year) < new.fecnaem then
    if date_add(new.fecnaem, interval 16 year) > curdate() then
    
		signal sqlstate '45000' set message_text = 'no se cumple la edad';
	end if;
end $$
delimiter ;
-- lo probamos:
insert into empleados
	(numem, numde, extelem, fecnaem, fecinem,salarem,
	 comisem, numhiem,nomem,ape1em,ape2em,dniem, userem, passem)
values
	(1201, 110, '342','2010/12/12', curdate(), 1000,10,
	0,'María', 'del Campo', 'Flores','10000001a','maria','1234');


-- 2.Comprueba que el departamento de las personas que ejercen la dirección de los departamentos pertenezcan a dicho departamento.
/*
Trigger before insert on dirigir
*/
delimiter $$
DROP TRIGGER IF EXISTS compruebadeptodir $$
CREATE TRIGGER compruebadeptodir BEFORE INSERT
ON dirigir
FOR EACH ROW
BEGIN
	DECLARE mensaje varchar(100);
    IF (SELECT numde FROM empleados WHERE numem = NEW.numempdirec) <> NEW.numdepto THEN
    BEGIN
		SET mensahe = concat('El empleado no pertenece al departamento ', NEW.numdepto);
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = mensaje;
	END;
    END IF;
END $$
delimiter ;

-- 3.Añade lo que consideres oportuno para que las comprobaciones anteriores se hagan también cuando se modifiquen la fecha de nacimiento de un empleado o al director/a de un departamento.
-- sobre ejer 1
delimiter $$
drop trigger if exists compruebaedadEditar $$
create trigger compruebaedadEditar
	before update on empleados
for each row
begin
	if old.fecnaem <> new.fecnaem -- siempre se comprueba en los triggers de update si el campo modificado es el que nos afecta
		and date_add(new.fecnaem, interval 16 year) > curdate() then
    
		signal sqlstate '45000' set message_text = 'el empleado no cumple la edad';
	end if;
end $$
delimiter ;
-- lo probamos:
update empleados
set extelem = '567'
where numem = 999;

update empleados
set fecnaem = '2007/1/1'
where numem = 999;

-- sobre ejer 2
delimiter $$
drop trigger if exists compruebadeptodirEditar $$
create trigger compruebadeptodirEditar
	before update on dirigir
for each row
begin
	declare mensaje varchar(100);
	if old.numdepto <> new.numdepto -- comprobamos si el campo modificado es el que nos afecta
		and (select numde from departamentos where numem = new.numempdirec) <> new.numdepto then
	begin
		set mensaje = concat('El empleado no pertenece al departamento ', new.numdepto);
		signal sqlstate '45000' set message_text = mensaje;
	end;
    end if;
end $$
delimiter ;
-- lo probamos:
update dirigir
set	fecfindir = curdate()
where numempdirec = 150 
	and numdepto = 121 and fecinidir = '2003/08/03';

update dirigir
set	numdepto = 111
where numempdirec = 150 
	and numdepto = 121 and fecinidir = '2003/08/03';

-- 4.Añade una columna numempleados en la tabla departamentos. En ella vamos a almacenar el número de empleados de cada departamento.
ALTER TABLE departamentos
ADD COLUMN numepleados INT NOT NULL DEFAULT 0;

-- 5.Prepara un procecdimiento que para cada departamento calcule el número de empleados y guarde dicho valor en la columna creada en el apartado 4.
delimiter $$
drop procedure if exists calculaNumEmple $$
create procedure calculaNumEmple ()
begin
	-- call calculaNumEmple ();
    -- select * from departamentos;
	update departamentos
    set numempleados = (select count(*)
						from empleados
						where empleados.numde = departamentos.numde);
end $$
delimiter ;

-- 6.Prepara lo que consideres necesario para que cada trimestre se compruebe y actualice, en caso de ser necesario, el número de empleados de cada departamento.
delimiter $$
create event actualizaNumeroEmpleados
on schedule
	every 1 quarter
    starts '2022/6/1'
do
	begin
		call calculaNumEmple();
    end $$
    
delimiter ;

-- 7.Asegúrate de que cuando eliminemos a un empleado, se actualice el número de empleados del departamento al que pertenece dicho empleado.
delimiter $$
DROP TRIGGER IF EXISTS calcularNumEmpleborrado $$
CREATE TRIGGER calculaNumEmpleborrado AFTER DELETE
ON empleados
FOR EACH ROW
BEGIN
	UPDATE departamentos
    SET numepleados = (SELECT count(*) FROM empleados WHERE numde = OLD.numde)
--  SET numepleados = numepleados -1
    WHERE numde = OLD.numde;
END $$
delimiter ;

-- EJ. PROPUESTO: COMPROBAR PARA CUANDO BORRO UN EMPLEADO, SI ES DIRECTOR DE UN DEPARTAMENTO NO SE PUEDA HACER

-- Para la base de datos gestionTests haz los siguientes ejercicios:
use GBDgestionaTests;
-- 8.El profesorado también puede matricularse en nuestro centro pero no de las materias que imparte. Para ello tendrás que hacer lo sigjuiente:
	-- a)Añade el campo dni en la tabla de alumnado.
	-- b)Añade la tabla profesorado (codprof, nomprof, ape1prof, ape2prof, dniprof).
	-- c)Añade una clave foránea en materias ⇒ codprof references a profesorado (codprof).
    -- d)Introduce datos en las tablas y campos creados para hacer pruebas.
    

-- 9.La fecha de publicación de un test no puede ser anterior a la de publicación.
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

-- 10.El alumnado no podrá hacer más de una vez un test (ya existe el registro de dicho test para el alumno/a) si dicho test no es repetible (tests.repetible = 0|false).
DROP TRIGGER IF EXISTS ej10;
delimiter $$
CREATE TRIGGER ej10 BEFORE UPDATE
ON respuestas
FOR EACH ROW
BEGIN
 -- IF IF (NEW.numrepeticion > (SELECT repetible FROM tests WHERE codtest = NEW.codtest) THEN -- Si repetible me diera
	IF (SELECT repetible FROM tests WHERE codtest = NEW.codtest) = 0 AND
		(SELECT count(*) FROM respuestas WHERE codtest = NEW.codtest AND numexped = NEW.numexped) > 0 THEN
	SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El test no se puede repetir';
    END IF;
END $$
delimiter ;