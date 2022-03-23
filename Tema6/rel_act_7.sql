/*1. Hallar el salario medio para cada grupo de empleados con igual comisión y para los que no la tengan,
pero solo nos interesan aquellos grupos de comisión en los que haya más de un empelado.*/
SELECT empleados.comisem as 'Comisión', count(empleados.numem) as 'CantidadEmpleados', avg(empleados.salarem) as 'SalarioMedioGrupo'
FROM empleados
GROUP BY empleados.comisem
HAVING count(empleados.numem) > 1;

/*2. Para cada extensión telefónica, hallar cuantos empleados la usan y el salario medio de éstos.
Solo nos interesan aquellos grupos en los que hay entre 1 y 3 empleados.*/
SELECT empleados.extelem as 'ExtensiónTelefónica', count(empleados.numem) as 'CantidadEmpleados', empleados.salarem as 'SalarioMedio'
FROM empleados
GROUP BY empleados.extelem
HAVING count(empleados.numem) between 1 and 3;

/*3. Prepara un procedimiento que, dada un código de promoción obtenga un listado con el nombre de las categorías
que tienen al menos dos productos incluidos en dicha promoción.*/
drop procedure if exists ej3_7;
delimiter $$
create procedure ej3_7(in codigoPromocion varchar(60))
BEGIN
	SELECT