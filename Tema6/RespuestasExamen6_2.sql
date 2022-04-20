/*Ej1. Obtén los apellidos y el nombre de los clientes que solicitaron proyectos el año pasado y no se aprobaron (el campo aprobado será 1 en los proyectos aprobados). Queremos que se muestren en una sola columna, Primero apellidos y después nombre y con coma entre los apellidos y el nombre.
Sabemos que el segundo apellido puede contener nulos. Queremos evitar que quede un espacio en blanco entre el primer apellido y el nombre cuando no hay segundo apellido.*/
SELECT concat(ape1cli, ifnull(concat(' ', ape2cli),''),', ', nomcli)
FROM clientes JOIN proyectos ON clientes.numcli = proyectos.numcli
WHERE proyectos.aprobado = 0 and year(fecpresupuesto) = year(curdate())-1;

/*Ej2. Sabemos que hay empleados con nombre de usuario que no cumplen con nuestro patrón. Obtén un listado con los números de empleados cuyo usuario no cumple con el patrón: tener 6 o más caracteres, incluir algún número y empezar por una letra que se debe repetir 2 o 3 veces.*/
SELECT *
FROM empleados
WHERE userem  not regexp '[0-9]' or userem not regexp '^[a-z]{2,3}' or length(userem)<6;

/*Ej3. Prepara una rutina que devuelva el número de colaboradores y el número de empleados que han participado en un proyecto dado.*/
drop procedure if exists ej3;
delimiter $$
create procedure ej3(in proyecto int, out empleados int, out colaboradores int)
BEGIN
	SELECT  count(distinct tecnicosenproyectos.numtec), count(distinct colaboradoresenproyectos.numcol) into empleados, colaboradores
	FROM proyectos
    LEFT JOIN colaboradoresenproyectos on proyectos.numproyecto = colaboradoresenproyectos.numproyecto
    LEFT JOIN tecnicosenproyectos on proyectos.numproyecto = tecnicosenproyectos.numproyecto
	WHERE proyectos.numproyecto = proyecto;
END $$
delimiter ;
call ej3(1, @emple,@colabora);
select @emple,@colabora;

/*Ej4. Nos interesa tener disponible los siguientes datos para poder hacer operaciones con ellos. Los datos que necesitamos son código, nombre, y apellidos (en columnas separadas) de los empleados que nunca han dirigido un proyecto o bien no están dirigiendo un proyecto en la actualidad.*/
CREATE VIEW ej4
AS
	SELECT empleados.numem, empleados.nomem, empleados.ape1em, empleados.ape2em
	FROM empleados JOIN tecnicos on empleados.numem = tecnicos.numem
	WHERE tecnicos.numtec not in (SELECT director 
									FROM proyectos)
	UNION
	SELECT empleados.numem, empleados.nomem, empleados.ape1em, empleados.ape2em
	FROM empleados JOIN tecnicos on empleados.numem = tecnicos.numem
	WHERE tecnicos.numtec not in (SELECT director 
									FROM proyectos 
									WHERE fecfinproy > curdate());
SELECT * from ej4;

/*Ej5. Prepara una función que, dado un número de técnico y un código de proyecto devuelva el número de semanas que ha trabajado dicho técnico en el proyecto.*/
drop function if exists ej5;
delimiter $$
create function ej5(tecnico int, proyecto int)
returns int
deterministic
BEGIN

	RETURN (SELECT sum(datediff(fecfintrabajo, fecinitrabajo)/7)
		FROM tecnicosenproyectos
		WHERE numproyecto= proyecto and numtec = tecnico
        );
END $$
delimiter ;

SELECT ej5(1,1);

/*Ej6. Prepara un procedimiento que obtenga el número de proyectos presupuestados de cada actividad (descripción de la actividad) y el número de proyectos llevados a cabo (campo aprobado será 1).
Además queremos que, si no se ha presupuestado ningún proyecto de una actividad, se muestre dicha actividad y tanto el número de proyectos presupuestados como llevados a cabo será 0.*/
drop procedure if exists ej6;
delimiter $$
create procedure ej6()
BEGIN
	SELECT actividades.nomactividad, count(numproyecto), (SELECT count(*) 
													  FROM proyectos as p 
                                                      WHERE p.codactividad = actividades.codactividad
														and p.aprobado = 1)
	FROM actividades LEFT JOIN proyectos on actividades.codactividad = proyectos.codactividad
	GROUP BY actividades.nomactividad;
END $$
delimiter ;

call ej6();

/*Ej7. Cada proyecto tiene una fecha de inicio de proyecto (cuando comienza a desarrollarse), una duración prevista (en días) y una fecha de fin real de proyecto. Obtén un listado de proyectos que han terminado en el tiempo previsto.
Queremos mostrar el número de proyecto, el director de proyecto (nombre y apellidos), el número de personal previsto (personal_prev), el número de técnicos y el número de colaboradores.*/
SELECT numproyecto, concat(ape1em, ifnull(concat(' ', ape2em),''),', ', nomem) as director,
	personal_prev,
    (SELECT count(*) FROM tecnicosenproyectos WHERE tecnicosenproyectos.numproyecto = proyectos.numproyecto) as tecnicos,
	(SELECT count(*) FROM colaboradoresenproyectos WHERE colaboradoresenproyectos.numproyecto = proyectos.numproyecto) as colaboradores
FROM proyectos JOIN tecnicos on proyectos.director = tecnicos.numtec 
	JOIN empleados on tecnicos.numem = empleados.numem
WHERE fecfinproy >= date_add(feciniproy, interval duracionprevista day);

/*Ej8. Cada proyecto tiene un número previsto de personas necesarias (personal_prev).
Obtén para cada proyecto que no haya superado en su ejecución al personal previsto (es decir, el número de técnicos y de colaboradores que han trabajado en el mismo no supera al número previsto) el número de técnicos y de colaboradores.*/
SELECT numproyecto, personal_prev, (SELECT count(*) FROM tecnicosenproyectos WHERE numproyecto = proyectos.numproyecto) as tecnicos,
	(SELECT count(*) FROM colaboradoresenproyectos WHERE numproyecto = proyectos.numproyecto) as colaboradores
FROM proyectos
WHERE personal_prev >= ((SELECT count(*) FROM tecnicosenproyectos WHERE numproyecto = proyectos.numproyecto)
						+
						(SELECT count(*) FROM colaboradoresenproyectos WHERE numproyecto = proyectos.numproyecto));