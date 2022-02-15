/*1. Obtener todos los datos de todos los empleados.*/
select * 
from empleados;

/*2. Obtener la extensión telefónica de “Juan López”.*/
select empleados.extelem 
from empleados
where nomem = 'Juan' and ape1em = 'López'; -- equivale a lo siguiente:
-- where concat(empleados.nomem, ' ', empleados.ape1em) = 'Juan López';
-- where concat_ws(' ', empleados.nomem, empleados.ape1em) = 'Juan López';

/*3. Obtener el nombre completo de los empleados que tienen más de un hijo.*/
select empleados.nomem, empleados.ape1em, empleados.ape2em -- , empleados.numhiem
from empleados
where numhiem > 1;
-- si quisiéramos aquellos empleados con menos de 1 hijo
-- e interpretamos que los que el campo numhiem es nulo
-- es como si no tuvieran hijos:
select empleados.nomem, empleados.ape1em, empleados.ape2em, 
	empleados.numhiem as 'número Hijos', ifnull(numhiem,0) as conversión
from empleados
-- where numhiem <1;
where numhiem is null or numhiem <1;
-- where ifnull(numhiem,0) < 1;

/*4. Obtener el nombre completo de los empleados que tienen más de un hijo.*/

select CONCAT(nomem, ' ',ape1em, ' ',ape2em) as nomcompleto_concat_null_sin_tratar,
		CONCAT(nomem, ' ',
			  ape1em, ' ',
			 ifnull(ape2em,'')
			) as nomcompleto_concat_null_tratados, 
        concat_ws(' ', nomem, ape1em, ape2em) as nomcompleto_concat_ws
from empleados
-- where numhiem >= 1 and numhiem <= 3;
where numhiem between 1 and 3; -- es más eficiente
-- where ifnull(numhiem,0) not between 1 and 3; -- nos quedamos con todos los que el numhiem esté fuera del rango (1,3)
-- where ifnull(numhiem,0) <1 or numhiem >3;

/*5. Obtener el nombre completo y en una sola columna de los empleados sin comisión.*/
select CONCAT(nomem, ' ',
			  ape1em, ' ',
			 ifnull(ape2em, '') 
		) as nombreCompleto, comisem
from empleados

-- where comisem is null or comisem =0;
where ifnull(comisem,0) = 0;

/*6. Obtener la dirección del centro de trabajo “Sede Central”.*/
select dirce
from centros
-- where centros.nomce = ' SEDE CENTRAL';
-- El anterior no obtiene resultados porque los nombres
-- de centro tienen espacios en blanco
-- para quitar los espacios usamos ltrim y rtrim:
-- where rtrim(ltrim(centros.nomce)) = 'Sede Central';
where lower(trim(nomce)) = 'sede central';


-- Pregunta ==> ¿una sentencia select llevará from siempre?
-- Respuesta==> cuando queremos obtener algo de una bd si, pero SELECT (sola) puede ser como la función 'System.out.println()' de java
select 3*56 +(SELECT ifnull(comisem,0) from empleados where numem =110) as resultado;

/* Estas funciones deben usarse en el insert,
para asegurarnos que los datos son introducidos
sin espacios antes o después de la cadena */


insert into centros
(numce, nomce, dirce)
values
(40, rtrim(ltrim('  centro nuevo  ')), 
	ltrim(rtrim('   C/ Pepe Sánchez   ')));

/* ejercicio propuesto:
En la tabla centros existen centros cuyo nombre y
dirección contienen espacios en blanco a la izq. y/o
derecha de la cadena. Modifícalos */

update centros
set nomce = ltrim(rtrim(nomce)), 
	-- o también nomce = rtrim(ltrim(nomce))
	dirce = ltrim(rtrim(dirce))  
    -- o también dirce = rtrim(ltrim(dirce))
;

/*7. Obtener el nombre de los departamentos que tienen más de 6000 € de presupuesto.*/

select nomde
from departamentos
where presude > 6000;

/*8. Obtener el nombre de los departamentos que tienen de presupuesto 6000 € o más.*/

select nomde
from departamentos
where presude >= 6000;
-- para obtener aquellos cuyo presupuesto sea distinto a 6000:
select nomde
from departamentos
where presude <> 6000;

/*9. Obtener el nombre completo y en una sola columna de los empleados que llevan trabajando en nuestra empresa más de 1 año.
(Añade filas nuevas para poder comprobar que tu consulta funciona).*/
select CONCAT(nomem, ' ',
			  ape1em, ' ',
			 ifnull(ape2em,'')
		) -- , fecinem
from empleados
where fecinem <= '2021/2/14';
-- where fecinem <= date_sub(curdate(), interval 1 year);
-- where fecinem <= subdate(curdate(), interval 1 year);
-- where fecinem <= adddate(curdate(), interval -1 year);
-- where fecinem <= date_add(curdate(), interval -1 year);


/*10. Obtener el nombre completo y en una sola columna de los empleados que llevan trabajando en nuestra empresa entre 1 y tres años.
(Añade filas nuevas para poder comprobar que tu consulta funciona).*/
select CONCAT(nomem, ' ',
			  ape1em, ' ',
			 ifnull(ape2em,'')
		)
from empleados
-- where fecinem >= '2018/2/14' and fecinem <= '2021/2/14';
-- where fecinem between '2018/2/14' and '2021/2/14';
where fecinem between date_sub(curdate(), interval 3 year) 
				and date_sub(curdate(), interval 1 year);
                
/*11. Prepara un procedimiento almacenado que ejecute la consulta del apartado 1 y otro que ejecute la del apartado 5.*/
delimiter $$
create procedure muestraDatosEmpleados
	()
begin
	select *
    from empleados;
end $$
delimiter ;

delimiter $$
create procedure muestraNombreCompleto
	()
begin
	select CONCAT(nomem, ' ', ape1em, ' ', 
			 ifnull(ape2em, '') ) 
    from empleados
    where comisem is null or comisem = 0;
end $$
delimiter ;


/*12. Prepara un procedimiento almacenado que ejecute la consulta del apartado 2 de forma que nos sirva para averiguar la extensión del empleado que deseemos en cada caso.*/
delimiter $$
create procedure obtenerExtelem
	(in nomem varchar(20), in ape1em varchar(20), in ape2em varchar(20))
begin
    select empleados.extelem 
	from empleados
    where nomem = nombre and ape1em = apellido1;
end $$
delimiter ;

/*13. Prepara un procedimiento almacenado que ejecute la consulta del apartado 3 y otro para la del apartado 4 de forma que nos sirva para averiguar el nombre de aquellos que tengan el número de hijos que deseemos en cada caso.*/
create procedure miau
	(in hijosmin int)
begin
/*14. Prepara un procedimiento almacenado que, dado el nombre de un centro de trabajo, nos devuelva su dirección.*/

/*15. Prepara un procedimiento almacenado que ejecute la consulta del apartado 7 de forma que nos sirva para averiguar, dada una cantidad,
el nombre de los departamentos que tienen un presupuesto superior a dicha cantidad.*/

/*16. Prepara un procedimiento almacenado que ejecute la consulta del apartado 8 de forma que nos sirva para averiguar, dada una cantidad,
el nombre de los departamentos que tienen un presupuesto igual o superior a dicha cantidad.*/

/*17. Prepara un procedimiento almacenado que ejecute la consulta del apartado 9 de forma que nos sirva para averiguar, dada una fecha,
el nombre completo y en una sola columna de los empleados que llevan trabajando con nosotros desde esa fecha.*/

/*18. Prepara un procedimiento almacenado que ejecute la consulta del apartado 10 de forma que nos sirva para averiguar, dadas dos fechas,
el nombre completo y en una sola columna de los empleados que comenzaron a trabajar con nosotros en el periodo de tiempo comprendido entre esas dos fechas.*/

/*19. Prepara un procedimiento almacenado que ejecute la consulta del apartado 10 de forma que nos sirva para averiguar, dadas dos fechas,
el nombre completo y en una sola columna de los empleados que comenzaron a trabajar con nosotros fuera del periodo de tiempo comprendido entre esas dos fechas.*/
