/*Ejercicio// Crea la tabla de control de errores en la base de datos empresa. Averigua cual es el código de error para la restricción de integridad referencial (no existe el valor de clave foránea donde es clave primaria).
Prepara un procedimiento almacenado que inserte un empleado nuevo, incluye el manejador de error para clave primaria repetida del ejercicio anterior y añade un manejador de error de restricción de integridad referencial con la tabla departamentos).*/
use empresaclase;

-- create table if not exists control_errores (cod_control int, primary key (cod_control), fec_error datetime, mensaje_error varchar(100)) PREGUNTAR A EVA SOBRE ESTA VERSIÓN O LA OTRA.
-- Creo un empleado con un número de departamento inexistente, para forzar el error de restricción de integridad referencial.
insert into empleados
(numem, numde, extelem, fecnaem, fecinem, salarem, comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem)
values
(1, 10000, '140', '1994/10/07', '2012/05/10', 1000.10, 200.50, 2, 'Pepito', 'Grillo', 'Jeje', '67482974X', 'USUARIO10', 'USUARIO10');

-- Creo una tabla de control de errores.
CREATE TABLE if not exists control_errores(
    cod_control INT NOT NULL, 
    fec_error DATETIME,
    mensaje_error VARCHAR(100),
    constraint pk_cod_control primary key (cod_control)
);

-- añado el código de control 0 genérico para poder empezar a contar desde el 1 en adelante.
INSERT INTO control_errores
	(cod_control, fec_error, mensaje_error)
    values
    (0, current_date, 'EMPIEZA TABLA');

drop procedure if exists inserta_empleado;
delimiter $$
CREATE PROCEDURE inserta_empleado
(num_empleado int, 
numde int, 
extelem char(3), 
fecnaem date,
fecinem date,
salarem decimal(7,2), 
comisem decimal(7,2), 
numhiem tinyint, 
nomem varchar(20), 
ape1em varchar(20), 
ape2em varchar(20), 
dniem char(9), 
userem char(12), 
passem char(12))
MODIFIES SQL DATA
BEGIN
	DECLARE EXIT HANDLER FOR 1062 -- Código de error de clave primaria repetida.
	BEGIN
		DECLARE control INT;
		SET control = (select max(cod_control)+1 FROM control_errores);
        INSERT INTO control_errores 
					(cod_control, fec_error, mensaje_error)
                    values
                    (control, current_date, 'inserción clave duplicada en empleados');
	END;
    DECLARE EXIT HANDLER FOR 1452 -- Código de error para la restricción de integridad referencial.
	BEGIN
		DECLARE control INT;
		SET control = (select max(cod_control)+1 FROM control_errores);
        INSERT INTO control_errores 
					(cod_control, fec_error, mensaje_error)
                    values
                    (control, current_date, 'No existe el valor de clave foránea donde es clave primaria)');
	END;
	INSERT INTO empleados (numem, numde, extelem, fecnaem, fecinem, salarem, comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem)
    values
    -- los valores de abajo hacen referencia a los parámetros que entran en el procedimiento (línea 29)).
	(num_empleado, numde, extelem, fecnaem, fecinem, salarem, comisem, numhiem, nomem, ape1em, ape2em, dniem, userem, passem);
END $$
delimiter ;

-- ejemplo para el handler 1452:
call inserta_empleado(1, 10000, '140', '1994/10/07', '2012/05/10', 1000.10, 200.50, 2, 'Pepito', 'Grillo', 'Jeje', '67482974X', 'USUARIO10', 'USUARIO10');

-- ejemplo para el handler 1062:
call inserta_empleado(110, 110, '140', '1994/10/07', '2012/05/10', 1000.10, 200.50, 2, 'Pepito', 'Grillo', 'Jeje', '67482974X', 'USUARIO10', 'USUARIO10');

SELECT *
FROM control_errores;

SELECT *
FROM empleados;