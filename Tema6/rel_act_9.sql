-- Gabriel Allende

-- Para la base de datos empresa_clase:

use empresaclase;

/*1. Queremos obtener un listado en el que se muestren los nombres de departamento 
y el número de empleados de cada uno. Ten en cuenta que algunos departamentos no 
tienen empleados, queremos que se muestren también estos departamentos sin empleados. 
En este caso, el número de empleados se mostrará como null.*/
drop procedure if exists ej1;
delimiter $$
create procedure ej1()
BEGIN
	SELECT departamentos.nomde as 'Departamento', sum(empleados.numem) as 'Empleados'
    FROM empleados RIGHT JOIN departamentos ON empleados.numde = departamentos.numde
    GROUP BY empleados.numde;
delimiter ;
call ej1();

/*2. Queremos averiguar si tenemos algún departamento sin dirección, para ello 
queremos mostrar el nombre de cada departamento y el nombre del director actual, 
para aquellos departamentos que en la actualidad no tengan director, queremos 
mostrar el nombre del departamento y el nombre de la dirección como null.*/
drop procedure if exists ej2;
delimiter $$
create procedure ej2()
BEGIN
	SELECT departamentos.nomde as 'Departamento', empleados.nomem as 'Director'
	FROM departamentos LEFT JOIN dirigir on departamentos.numde = dirigir.numdepto
						LEFT JOIN empleados ON dirigir.numempdirec = empleados.numem;
END $$
delimiter ;
call ej2();


-- Para la base de datos turRural:

use GBDturRural2015;

/*3. Queremos saber el código de las reservas hechas y anuladas este año, el 
código de casa reservada, la fecha de inicio de estancia y la duración de 
la misma. También queremos que se muestre el importe de la devolución en 
aquellas que hayan producido dicha devolución.*/
drop procedure if exists ej3;
delimiter $$
create procedure ej3()
BEGIN
	SELECT reservas.codreserva as 'Resreva', reservas.feciniestancia as 'Fecha inicio', 
		reservas.numdiasestancia as 'Duración' , devoluciones.importedevol as 'Devolución por cancelación (€)'
    FROM casas JOIN reservas ON casas.codcasa = reservas.codcasa
				LEFT JOIN devoluciones ON reservas.codreserva = devoluciones.codreserva;                
END $$
delimiter ;
call ej3();

/*4. Queremos mostrar un listado de todas las casas de la zona 1 en el que se 
muestre el nombre de casa y el número de reservas que se han hecho para cada 
casa. Si una casa nunca se ha reservado, deberá aparecer en el listado.*/
drop procedure if exists ej4;
delimiter $$
create procedure ej4()
BEGIN
	SELECT casas.nomcasa as 'Casa', count(reservas.codreserva) as 'Número de reservas'
    FROM casas LEFT JOIN reservas ON casas.codcasa = reservas.codcasa
    WHERE codzona = 1
    GROUP BY casas.nomcasa;
END $$
delimiter ;
call ej4();

/*5. Queremos elaborar un listado de casas en el que se muestre el nombre de zona 
y el nombre de la casa. Ten en cuenta que de algunas zonas no tenemos todavía 
ninguna casa en el sistema, queremos que se muestren estas zonas también.*/
drop procedure if exists ej5;
delimiter $$
create procedure ej5()
BEGIN
	SELECT zonas.nomzona as 'Zona', casas.nomcasa as 'Casa'
    FROM zonas LEFT JOIN casas ON zonas.numzona = casas.codzona;
END $$
delimiter ;
call ej5();

-- Para la base de datos Promociones:

use ventapromoscompleta;

/*6. Queremos mostrar un listado de productos organizados por categorías y el número
 de unidades vendidas. Ten en cuenta que algunos productos no se han vendido, en 
 cuyo caso el número de unidades vendidas se mostrará como null.*/
 drop procedure if exists ej6;
delimiter $$
create procedure ej6()
BEGIN
	SELECT categorias.nomcat as 'Categoría', articulos.nomart as 'Artículo', sum(detalleventa.cant) as 'Nº ventas'
    FROM categorias JOIN articulos ON categorias.codcat = articulos.codcat
				LEFT JOIN detalleventa on articulos.refart = detalleventa.refart    
    GROUP BY detalleventa.refart
    ORDER BY categorias.nomcat;
END $$
delimiter ;
call ej6();
 
/*7. Dada una promoción determinada, queremos que se muestre el número de productos 
que hay en cada categoría incluidos en dicha promoción. Ten en cuenta que hay algunas
 promociones que no incluyen productos de todas las categorías, en cuyo caso debe 
 aparecer la categoría y el número de productos como null.*/ 
drop procedure if exists ej7;
delimiter $$
create procedure ej7(in promocion int)
BEGIN
	SELECT categorias.nomcat as 'Categoría', count(distinct(catalogospromos.refart)) as 'Nº productos en promoción'
	/*FROM catalogospromos RIGHT JOIN articulos ON catalogospromos.refart = articulos.refart
						RIGHT JOIN categorias ON articulos.codcat = categorias.codcat*/
	FROM categorias LEFT JOIN articulos ON categorias.codcat = articulos.codcat
					 LEFT JOIN catalogospromos ON articulos.refart = catalogospromos.refart                     
    WHERE catalogospromos.codpromo = promocion
	GROUP BY categorias.nomcat;
END $$
delimiter ;
call ej7(1);