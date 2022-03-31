-- Gabriel Allende

/*1. Para la base de datos “TurRural” prepara un procedimiento que muestre un listado con los nombres y apellidos de los propietarios en columnas separadas.
Da por hecho que los nombres que tenemos son simples, esto es, nadie tiene un nombre o apellidos compuestos. Puedes modificar los datos para comprobar los resultados.*/
use GBDturRural2015;

drop procedure if exists ej1;
delimiter $$
create procedure ej1()
BEGIN
	SELECT  LEFT(propietarios.nompropietario, locate(' ',propietarios.nompropietario)-1) AS 'Nombre',
    substring(propietarios.nompropietario,
			  locate(' ',propietarios.nompropietario)+1, 
			  locate(' ', substring(propietarios.nompropietario,locate(' ',propietarios.nompropietario)+1))-1) AS 'Apellido 1'
	FROM propietarios;
END $$
delimiter ;

call ej1();

/*2. Para la BD empresaclase, prepara un procedimiento que devuelva la contraseña inicial de un empleado. Esta será:
* La primera y la última letra de su nombre+
* La 2ª y 3ª letras de su primer apellido +
* La letra central de su 2º apellido o la z en caso de que no tenga segundo apellido + 
* el último número de su dni sin la letra.*/
use empresaclase;

drop procedure if exists ej2;
delimiter $$
create procedure ej2(in empleado int, out contraseña char(6))
BEGIN
	SELECT empleados.nomem, empleados.ape1em, empleados.ape2em, empleados.dniem, 
    concat(left(empleados.nomem, 1), right(empleados.nomem, 1)),
    substring(empleados.ape1em, 2, 2),
    ifnull(substring(ape2em, (length(ape2em) div 2)+1, 1), 'z'),
    substring(dniem, length(empleados.dniem)-1, 1)
	FROM empleados;
END $$
delimiter ;

select *
from empleados

/*3. Dado el código de un empleado, muestra cuando termina el periodo de formación de un empleado (6 meses y dos semanas desde la fecha de ingreso). El formato debe ser:
día ? del mes ?? del año ????.*/