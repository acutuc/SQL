/*1. Hallar el salario medio para cada grupo de empleados con igual comisión y para los que no la tengan,
pero solo nos interesan aquellos grupos de comisión en los que haya más de un empelado.*/
SELECT empleados.comisem as 'Comisión', count(empleados.numem) as 'CantidadEmpleados', avg(empleados.salarem) as 'SalarioMedioGrupo'
FROM empleados
GROUP BY empleados.comisem
HAVING count(empleados.numem) > 1;

/*2. Para cada extensión telefónica, hallar cuantos empleados la usan y el salario medio de éstos.
Solo nos interesan aquellos grupos en los que hay entre 1 y 3 empleados.*/
SELECT empleados.extelem as 'ExtensiónTelefónica', count(empleados.numem) as 'CantidadEmpleados', avg(empleados.salarem) as 'SalarioMedio'
FROM empleados
GROUP BY empleados.extelem
HAVING count(empleados.numem) between 1 and 3;

-- use ventapromoscompleta
/*3. Prepara un procedimiento que, dada un código de promoción obtenga un listado con el nombre de las categorías
que tienen al menos dos productos incluidos en dicha promoción.*/
drop procedure if exists ej3_7;
delimiter $$
create procedure ej3_7(in codigoPromocion varchar(60))
BEGIN
	SELECT nomcat
	FROM categorias JOIN articulos 
		ON categorias.codcat = articulos.codcat
		JOIN catalogospromos 
			ON articulos.refart = catalogospromos.refart
	WHERE catalogospromos.codpromo = 1
	GROUP BY nomcat
	HAVING count(*) > 1;
END $$
delimiter ;

/*4. Prepara un procedimiento que, dado un precio,
obtenga un listado con el nombre de las categorías en las que el precio  medio de sus productos supera a dicho precio.*/
drop procedure if exists ej4_7;
delimiter $$
create procedure ej4_7()
BEGIN
	SELECT nomcat, avg(precioventa)
	FROM categorias JOIN articulos 
		ON categorias.codcat = articulos.codcat
	GROUP BY nomcat
	HAVING avg(precioventa) > 3;
END $$
delimiter ;
    
/*5. Prepara un procedimiento que muestre el importe total de las ventas por meses de un año dado.*/
drop procedure if exists ej5_7;
delimiter $$
create procedure ej5_7(in anio year)
BEGIN
	SELECT sum(detalleventa.cant * detalleventa.precioventa) as 'Importe Total Ventas', monthname(fecventa) as 'Mes'
    FROM detalleventa JOIN ventas ON detalleventa.codventa = ventas.codventa
    WHERE anio = year(ventas.fecventa)
    GROUP BY monthname(ventas.fecventa);
END $$
delimiter ;
call ej5_7(2012);

/*6. Como el ejercicio anterior, pero ahora solo nos interesa mostrar aquellos meses en los que se ha superado a la media del año.*/
drop procedure if exists ej6_7;
delimiter $$
create procedure ej6_7(in anio year)
BEGIN
	SELECT sum(detalleventa.cant * detalleventa.precioventa) as 'Importe Total Ventas', monthname(fecventa) as 'Mes'
    FROM detalleventa JOIN ventas ON detalleventa.codventa = ventas.codventa
    WHERE anio = year(ventas.fecventa)
    GROUP BY monthname(ventas.fecventa)
    HAVING sum(detalleventa.precioventa * detalleventa.cant) > (SELECT avg(detalleventa.precioventa * detalleventa.cant)
																FROM ventas JOIN detalleventa
																	ON ventas.codventa = detalleventa.codventa
																WHERE year(fecventa) = anio);
END $$
delimiter ;
call ej6_7(2012);