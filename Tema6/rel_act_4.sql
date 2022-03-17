/*1. Obtener por orden alfabético el nombre y los sueldos de los empleados con más de tres hijos. (Lorena)*/
drop procedure if exists ej_1;
delimiter $$
create procedure ej_1()
BEGIN
	SELECT concat(empleados.nomem, ' ', empleados.ape1em, ' ', ifnull(empleados.ape2em, ' ')) as 'Empleado', empleados.salarem as 'Salario'
    FROM empleados
    WHERE empleados.numhiem > 3
    ORDER BY empleados.nomem;
END $$
delimiter ; 
call ej_1();

/*2. *Obtener la comisión, el departamento y el nombre de los empleados cuyo salario es inferior a 190.000 u.m.,
clasificados por departamentos en orden creciente y por comisión en orden decreciente dentro de cada departamento.*/
drop procedure if exists ej_2;
delimiter $$
create procedure ej_2()
BEGIN
	SELECT departamentos.nomde as 'Departamento', empleados.nomem as 'Empleado', empleados.comisem as 'Comisión'
    FROM departamentos JOIN empleados ON departamentos.numde = empleados.numde
		 JOIN dirigir ON dirigir.numdepto = departamentos.numde
    WHERE empleados.salarem < 190000
    ORDER BY empleados.numde asc, empleados.comisem desc;
END $$
delimiter ;
call ej_2;

/*3. Hallar por orden alfabético los nombres de los deptos cuyo director lo es en funciones y no en propiedad.*/
drop procedure if exists ;
delimiter $$ 
create procedure ej_3()
BEGIN
	SELECT
    FROM
    WHERE
END $$
delimiter ;
call ej_3;

/*4. Obtener un listín telefónico de los empleados del departamento 121 incluyendo el nombre del empleado, número de empleado y extensión telefónica.
Ordenar alfabéticamente */
drop procedure if exists ej_4;
delimiter $$ 
create procedure ej_4()
BEGIN
	SELECT empleados.numem as 'NúmeroEmpleado', empleados.nomem as 'Empleados', departamentos.nomde as 'Departamentos', empleados.extelem as 'ExtensiónTelefónica'
    FROM empleados JOIN departamentos ON empleados.numde = departamentos.numde
    WHERE empleados.numde = 121
    ORDER BY empleados.nomem asc;
END $$
delimiter ;
call ej_4;

/*5. Hallar la comisión, nombre y salario de los empleados con más de tres hijos, clasificados por comisión y dentro de comisión por orden alfabético.*/
drop procedure if exists ej_5;
delimiter $$ 
create procedure ej_5()
BEGIN
	SELECT empleados.nomem as 'Empleados', empleados.salarem as 'Salario', empleados.comisem as 'Comisión'
    FROM empleados
    WHERE empleados.numhiem > 3
    ORDER BY empleados.comisem desc, empleados.nomem desc;
END $$
delimiter ;
call ej_5;

/*6. Hallar por orden de número de empleado, el nombre y salario total (salario más comisión) de los empleados cuyo salario total supere las 300.000 u.m. mensuales.*/
drop procedure if exists ;
delimiter $$ 
create procedure
BEGIN
	SELECT
    FROM
    WHERE
END $$
delimiter ;
call ;

/*7. Obtener los números de los departamentos en los que haya algún empleado cuya comisión supere al 20% de su salario.*/
drop procedure if exists ;
delimiter $$ 
create procedure
BEGIN
	SELECT
    FROM
    WHERE
END $$
delimiter ;
call ;

/*8. Hallar por orden alfabético los nombres de los empleados tales que si se les da una gratificación de 100 u.m.
por hijo el total de esta gratificación no supere a la décima parte del salario.*/

/*9. Llamaremos presupuesto medio mensual de un depto. al resultado de dividir su presupuesto anual por 12. 
Supongamos que se decide aumentar los presupuestos medios de todos los deptos en un 10% a partir del mes de octubre inclusive.
Para los deptos. cuyo presupuesto mensual anterior a octubre es de más de 500.000 u.m.
Hallar por orden alfabético el nombre de departamento y su presupuesto anual total después del incremento.*/

/*10. Suponiendo que en los próximos tres años el coste de vida va a aumentar un 6% anual y que se suben los salarios en la misma proporción.
Hallar para los empleados con más de cuatro hijos, su nombre y sueldo anual, actual y para cada uno de los próximos tres años,
clasificados por orden alfabético*/

/*11. Hallar por orden de número de empleado, el nombre y salario total (salario más comisión) de los empleados cuyo salario total supera al salario mínimo en 300.000 u.m. mensuales. */

/*12. Se desea hacer un regalo de un 1% del salario a los empleados en el día de su onomástica.
Hallar por orden alfabético, los nombres y cuantía de los regalos en u.m. para los que celebren su santo el día de San Honorio*/

/*13. Obtener por orden alfabético los nombres y los salarios de los empleados del depto. 111 que tienen comisión,
si hay alguno de ellos cuya comisión supere al 15% de su salario.*/

/*14. En la fiesta de Reyes se desea organizar un espectáculo para los hijos de los empleados, que se representará en dos días diferentes.
El primer día asistirán los empleados cuyo apellido empiece por las letras desde la “A” hasta la “L”, ambas inclusive.
El segundo día se darán invitaciones para el resto. A cada empleado se le asignarán tantas invitaciones como hijos tenga y dos más.
Además en la fiesta se entregará a cada empleado un obsequio por hijo.
Obtener una lista por orden alfabético de los nombres a quienes hay que invitar el primer día de la representación,
incluyendo también cuantas invitaciones corresponden a cada nombre y cuantos regalos hay que preparar para él. */

/*15. Hallar los nombres de los empleados que no tienen comisión,
clasificados de manera que aparezcan primero aquellos cuyos nombres son más cortos.*/

/*16. Hallar cuántos departamentos hay y el presupuesto anual medio de ellos.*/

/*17. Hallar el salario medio de los empleados cuyo salario no supera en más de un 20% al salario mínimo de los empleados que tienen algún hijo y su salario medio por hijo es mayor que 100.000 u.m.*/

/*18. Hallar la diferencia entre el salario más alto y el más bajo */

/*19. Hallar el número medio de hijos por empleado para todos los empleados que no tienen más de dos hijos*/

/*20. Hallar el salario medio para cada grupo de empleados con igual comisión y para los que no la tengan (Javi/Gabriel).*/
drop procedure if exists ej_20;
delimiter $$
create procedure ej_20()
BEGIN
	SELECT ifnull(empleados.comisem, 0) as ‘Comisión’, avg(empleados.salarem) as ‘SalarioMedio’
    	FROM empleados
    	GROUP BY ifnull(empleados.comisem, 0);
END $$
delimiter ;
call ej_20;

/*21. Para cada extensión telefónica, hallar cuantos empleados la usan y el salario medio de éstos.*/

/*22. Para los departamentos cuyo salario medio supera al de la empresa, hallar cuantas extensiones telefónicas tienen.*/

/*23. Hallar el máximo valor de la suma de los salarios de los departamentos.*/

/*24. Hallar por orden alfabético, los nombres de los empleados que son directores en funciones.*/

/*25. A los empleados que son directores en funciones se les asignará una gratificación del 5% de su salario.
Hallar por orden alfabético, los nombres de estos empleados y la gratificación correspondiente a cada uno.*/

/*26. Borrar de la tabla EMPLEADOS a los empleados cuyo salario (sin incluir la comisión) supere al salario medio de los empleados de su departamento. */

/*27. Disminuir en la tabla EMPLEADOS un 5% el salario de los empleados que superan el 50% del salario máximo de su departamento.*/

/*28. Crear una vista en la que aparezcan todos los datos de los empleados que cumplen 65 años de edad este año.*/