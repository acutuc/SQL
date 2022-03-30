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
drop procedure if exists ej_6;
delimiter $$ 
create procedure ej_6()
BEGIN
	SELECT empleados.numem as 'NumEmpleado', concat(empleados.nomem, ' ', empleados.ape1em, ' ', ifnull(empleados.ape2em, ' ')) as 'NombreEmpleado', (empleados.salarem + empleados.comisem) as 'Salario'
    FROM empleados
    WHERE empleados.salarem+empleados.comisem > 300000
    ORDER BY empleados.numem desc;
END $$
delimiter ;
call ej_6;

/*7. Obtener los números de los departamentos en los que haya algún empleado cuya comisión supere al 20% de su salario.*/
drop procedure if exists ej_7;
delimiter $$ 
create procedure ej_7()
BEGIN
	SELECT empleados.numde as 'Departamento'
    FROM empleados
    WHERE empleados.comisem > empleados.salarem * 0.20
    GROUP BY empleados.numde;
END $$
delimiter ;
call ej_7;

/*8. Hallar por orden alfabético los nombres de los empleados tales que si se les da una gratificación de 100 u.m.
por hijo el total de esta gratificación no supere a la décima parte del salario.*/
drop procedure if exists ej_8;
delimiter $$ 
create procedure ej_8()
BEGIN
	SELECT empleados.nomem as 'NombreEmpleado'
    FROM empleados
    WHERE 100 * empleados.numhiem <= empleados.salarem/10
    ORDER BY empleados.nomem asc;
END $$
delimiter ;
call ej_8;

/*9. Llamaremos presupuesto medio mensual de un depto. al resultado de dividir su presupuesto anual por 12. 
Supongamos que se decide aumentar los presupuestos medios de todos los deptos en un 10% a partir del mes de octubre inclusive.
Para los deptos. cuyo presupuesto mensual anterior a octubre es de más de 500.000 u.m.
Hallar por orden alfabético el nombre de departamento y su presupuesto anual total después del incremento.*/
drop procedure if exists ej_9;
delimiter $$
create procedure ej_9()
BEGIN
	SELECT departamentos.nomde as 'Departamento', (departamentos.presude/12)*(9 + 1.1 * 3) as 'PresupuestoIncrementado'
    FROM departamentos
    WHERE (departamentos.presude / 12) * 9 = 500000
    ORDER BY departamentos.presude;
END $$
delimiter ;
call ej_9;

/*10. Suponiendo que en los próximos tres años el coste de vida va a aumentar un 6% anual y que se suben los salarios en la misma proporción.
Hallar para los empleados con más de cuatro hijos, su nombre y sueldo anual, actual y para cada uno de los próximos tres años,
clasificados por orden alfabético*/
drop procedure if exists ej_10;
delimiter $$
create procedure ej_10()
BEGIN
	SELECT concat(empleados.nomem, ' ', empleados.ape1em, ' ', ifnull(empleados.ape2em, ' ')) as 'NombreEmpleado', empleados.salarem*12 as 'SalarioAnualActual', (empleados.salarem*12)*1.06 as 'SalarioAnualEn1año', (empleados.salarem*12)*1.12 as 'SalarioAnualEn2años', (empleados.salarem*12)*1.18 as 'SalarioAnualEn3Años'
    FROM empleados
    WHERE empleados.numhiem > 4
    ORDER BY empleados.nomem;
END $$
delimiter ;
call ej_10;

/*11. Hallar por orden de número de empleado, el nombre y salario total (salario más comisión) de los empleados cuyo salario total supera al salario mínimo en 300.000 u.m. mensuales. */
drop procedure if exists ej_11;
delimiter $$
create procedure ej_11()
BEGIN
	SELECT empleados.nomem, concat(empleados.nomem, ' ', empleados.ape1em ' ', ifnull(empleados.ape2em, ' ')) as 'NombreEmpleado', (empleados.salarem + empleados.comisem) as 'SalarioTotal'
    FROM empleados
    WHERE empleados.salarem + empleados.comisem > min(empleados.salarem
    ORDER BY empleados.nomem;
END $$
delimiter ;
call ej_11;

/*12. Se desea hacer un regalo de un 1% del salario a los empleados en el día de su onomástica.
Hallar por orden alfabético, los nombres y cuantía de los regalos en u.m. para los que celebren su santo el día de San Honorio*/
drop procedure if exists ej_12;
delimiter $$
create procedure ej_12()
BEGIN
	SELECT empleados.nomem as 'NombreEmpleado', empleados.salarem*1.01 as 'SalarioConBonus'
	FROM empleados
   	WHERE empleados.nomem = 'Honorio'
    ORDER BY empleados.nomem;
END $$
delimiter ;
call ej_12();

/*13. Obtener por orden alfabético los nombres y los salarios de los empleados del depto. 111 que tienen comisión,
si hay alguno de ellos cuya comisión supere al 15% de su salario.*/
drop procedure if exists ej_13;
delimiter $$
create procedure ej_13()
BEGIN
	SELECT nomem, salarem
	FROM empleados
    WHERE numde = 111 and ifnull(comisem,0) > salarem*0.15
	ORDER BY numem;
END $$
delimiter ;
call ej_13();

/*14. En la fiesta de Reyes se desea organizar un espectáculo para los hijos de los empleados, que se representará en dos días diferentes.
El primer día asistirán los empleados cuyo apellido empiece por las letras desde la “A” hasta la “L”, ambas inclusive.
El segundo día se darán invitaciones para el resto. A cada empleado se le asignarán tantas invitaciones como hijos tenga y dos más.
Además en la fiesta se entregará a cada empleado un obsequio por hijo.
Obtener una lista por orden alfabético de los nombres a quienes hay que invitar el primer día de la representación,
incluyendo también cuantas invitaciones corresponden a cada nombre y cuantos regalos hay que preparar para él. */
drop procedure if exists ej_14;
delimiter $$
create procedure ej_14()
BEGIN

DROP VIEW if exists FIESTA;
CREATE VIEW FIESTA
AS 

	-- DIA 1
	SELECT 'DIA 1' as 'Día Fiesta', concat_ws(' ', ape1em, ape2em) as Apellidos, nomem as 'Nombre', 
		(numhiem +2) as 'Invitaciones', numhiem as 'Regalos'
	FROM empleados
    WHERE -- ifnull(numhiem, 0) > 0
		-- and substring(ape1em, 1, 1) < 'M'
        ape1em LIKE ('M%');
	
    
UNION

    -- DIA 2
    SELECT 'DIA 2' as 'Día Fiesta', concat_ws(' ', ape1em, ape2em) as Apellidos, nomem as 'Nombre', 
		(numhiem +2) as 'Invitaciones', numhiem as 'Regalos'
	FROM empleados
    WHERE ifnull(numhiem, 0) > 0
		and substring(ape1em, 1, 1) >= 'M';
    
   SELECT *
	FROM FIESTA
	ORDER BY 'Día Fiesta', Apellidos;
    
END $$

delimiter ;
call ej_14;

/*15. Hallar los nombres de los empleados que no tienen comisión,
clasificados de manera que aparezcan primero aquellos cuyos nombres son más cortos.*/
drop procedure if exists ej_15;
delimiter $$
create procedure ej_15()
BEGIN
	SELECT nomem, comisem
	FROM empleados
    WHERE comisem is null or comisem = 0
	ORDER BY length(nomem) asc;
END $$
delimiter ;
call ej_15;

/*16. Hallar cuántos departamentos hay y el presupuesto anual medio de ellos.*/
drop procedure if exists ej_16;
delimiter $$
create procedure ej_16()
BEGIN
	SELECT count(numde) as 'Num Deptos', avg(presude) as 'Presupuesto medio'
	FROM departamentos;
END $$
delimiter ;
call ej_16;

/*17. Hallar el salario medio de los empleados cuyo salario no supera en más de un 20% al salario mínimo de los empleados que tienen algún hijo y su salario medio por hijo es mayor que 100.000 u.m.*/
drop procedure if exists ej_17;
delimiter $$
create procedure ej_17()
BEGIN
	SELECT avg(salarem) as 'Sal. medio'
	FROM empleados
    WHERE salarem < ((select min(salarem) 
						from empleados 
						where numhiem > 0 and salarem*12/numhiem) * 1.2);
END $$
delimiter ;
call ej_17;

/*18. Hallar la diferencia entre el salario más alto y el más bajo */
drop procedure if exists ej_18;
delimiter $$
create procedure ej_18()
BEGIN
	SELECT (max(salarem)-min(salarem)) as 'Diferencia'
	FROM empleados;
END $$
delimiter ;
call ej_18;

/*19. Hallar el número medio de hijos por empleado para todos los empleados que no tienen más de dos hijos*/
drop procedure if exists ej_19;
delimiter $$
create procedure ej_19()
BEGIN
	SELECT avg(numhiem)
	FROM empleados
    WHERE numhiem <= 2;
END $$
delimiter ;
call ej_19;


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
drop procedure if exists ej_21;
delimiter $$
create procedure ej_21()
BEGIN
	SELECT extelem, count(numem), avg(salarem)
	FROM empleados
    GROUP BY extelem
    ORDER BY extelem;
END $$
delimiter ;
call ej_21;

/*22. Para los departamentos cuyo salario medio supera al de la empresa, hallar cuantas extensiones telefónicas tienen.*/
drop procedure if exists ej_22;
delimiter $$
create procedure ej_22()
BEGIN
	SELECT departamentos.numde, count(distinct empleados.extelem)
	FROM departamentos join empleados on empleados.numde = departamentos.numde                          
	GROUP BY empleados.numde
    HAVING avg(empleados.salarem) > (select avg(empleados.salarem) from empleados);
END $$
delimiter ;
call ej_22;

/*23. Hallar el máximo valor de la suma de los salarios de los departamentos.*/
drop procedure if exists ej_23;
delimiter $$
create procedure ej_23()
BEGIN
	SELECT
	FROM
    WHERE
END $$
delimiter ;
call ej_23;

/*24. Hallar por orden alfabético, los nombres de los empleados que son directores en funciones.*/

/*25. A los empleados que son directores en funciones se les asignará una gratificación del 5% de su salario.
Hallar por orden alfabético, los nombres de estos empleados y la gratificación correspondiente a cada uno.*/

/*26. Borrar de la tabla EMPLEADOS a los empleados cuyo salario (sin incluir la comisión) supere al salario medio de los empleados de su departamento. */

/*27. Disminuir en la tabla EMPLEADOS un 5% el salario de los empleados que superan el 50% del salario máximo de su departamento.*/

/*28. Crear una vista en la que aparezcan todos los datos de los empleados que cumplen 65 años de edad este año.*/
drop procedure if exists ej_28;
delimiter $$
create procedure ej_28()
BEGIN
	SELECT empleados.*
	FROM empleados
   	WHERE (year(curdate()) - year(empleados.fecnaem)) = 65;
END $$
delimiter ;
call ej_28();