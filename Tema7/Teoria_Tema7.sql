/*Teoría Tema 7. */
show variables; -- nos enseña todas las variables de sistemas que existen

show variables like '%innodb%'; -- ejemplo con el operador like, para buscar variables relacionadas con innoDB.

/* max_user_connections nos dice la cantidad máxima de usuarios que pueden estar conectados a la vez en nuestro server.
Si está a 0 es ilimitado*/

-- set global max_user_connections = 5; -- con la etiqueta global, modifica los datos de la configuración del sistema.

-- las variables de sesión no se declaran, se identifican porque comienzan con el símbolo '@' delante.

-- las variables locales se declaran 'DECLARE ...' y se les asigna valor con el SET 'SET nomvariable = ...'



/*TABLAS TEMPORALES*/

create temporary table probando (codtabla int primary key, destabla varchar(100));
-- las tablas temporales dejan de existir cuando la base de datos se desconecta. ES TEMPORAL.
insert into probando (select numcaracter, nomcaracter
					from caracteristicas);
                    
                    
-- CALL llama a los procedimiento.
-- RETURN devuelve un tipo de dato de una función
/* IF condicion then
	BEGIN
		.
        .
        .
	END;
    END IF
    ELSE
		IF condicion then
        BEGIN
        .
        .
        .
        END;
	END IF*/
    
-- CASE es el switch de java
/*ej*/
SELECT nomem, ape1em,
	CASE numhiem
		WHEN 0 THEN 'CERO HIJOS'
		WHEN 1 THEN 'UN HIJO'
		WHEN 2 THEN 'DOS HIJOS'
		WHEN 3 THEN 'TRES HIJOS'
		WHEN 4 THEN 'CUATRO HIJOS'
		WHEN 5 THEN 'CINCO HIJOS'
		ELSE 'Más de cinco hijos'
    END AS NumHijos
FROM empleados;

-- otra forma de usar CASE:
SELECT numem, nomem, ape1em, ape2em,
	CASE
		WHEN numhiem = 0 THEN 'CERO HIJOS'
        WHEN numhiem <= 3 THEN 'ENTRE 1 y 3 HIJOS'
		ELSE 'MAS DE TRES HIJOS'
	END AS NUM_HIJOS
FROM empleados;

-- REPEAT. Son bucles
REPEAT
BEGIN
	UPDATE productos
	SET precio_unidad = precio_unidad*2
END
UNTIL (SELECT avg(precio_unidad) FROM productos) >=100
END REPEAT;

-- WHILE.
WHILE (SELECT avg(precio_unidad) FROM productos) <100 DO
BEGIN
	UPDATE productos
	SET precio_unidad = precio_unidad*2
END
END WHILE

-- CURSORES
/*Declaración del cursor:
		DECLARE nom_cursor CURSOR FOR sentencia_select;
Para poder trabajar con el cursor tendremos que abrirlo (llenar la estructura con las filas y columnas del mismo):
		OPEN nom_cursor;
Para posicionarnos en la siguiente fila del cursor y utilizar los datos de cada celda (valor de columna):
		FETCH nom_cursor INTO variable1, variable2, …;
	Nota.- Tendremos que utilizar una variable para cada columna del cursor, del mismo 	tipo y en el mismo orden que  en la declaración.
Al finalizar de trabajar con el cursor tendremos que cerrarlo:
		CLOSE nom_cursor;
Los cursores se recorren dentro de bucles (REPEAT o WHILE).
Cuando llegamos al final de un cursor e intentamos posicionarnos en la siguiente fila, se produce un WARNING (SQLSTATE 02000), así que utilizaremos un manejador de error para este código y poder salir del bucle.*/
delimiter $$
drop procedure if exists pruebaCursor;
create procedure pruebaCursor()
BEGIN
	DECLARE curDeptos CURSOR FOR
		SELECT numde, nomde, presude, nomce
		FROM departamentos JOIN centros on departamentos.numce = centros.numce
        ORDER BY nomce;
        
	DECLARE numDepto int DEFAULT 0;
    DECLARE nomDepto, nomCentro, nomCentroAux varchar(100) DEFAULT ''; -- nomCentroAux es la variable auxiliar.
    DECLARE presuDepto decimal(12,2) DEFAULT 0.00;
    
    DECLARE fin_cursor BOOLEAN DEFAULT 0;
    
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
		-- BEGIN
			SET fin_cursor = 1;
        -- END
		create temporary table listado	-- creamos una tabla temporal
        (filalistado varchar(500);
	OPEN curDeptos;
		FETCH curDeptos INTO numDepto, nomDepto, presuDepto, nomCentro;
        WHILE fin_cursor = 0 DO
			BEGIN
				IF nomCentro <> nomCentroAux THEN -- distinto de
                BEGIN
					INSERT INTO listado
					VALUES
					(concat('centro de trabajo: ', nomCentro));
					INSERT INTO listado
					VALUES
					('num.depto		nombre		presupuesto');
					INSERT INTO listado
					VALUES
					(concat(numDepto, '		', nomDepto, ' 		', presuDepto);
					SET nomCentroAux = nomcentro;
                END;
					/*aquí va todo el código que quiera hacer con éstos campos
					...
					...*/
            END;
            END WHILE;
        FETCH curDeptos INTO numDepto, nomDepto, presuDepto, nomCentro;
        END;
        END WHILE;
	CLOSE curDeptos;
    SELECT *
    FROM listado; -- ésta es la tabla temporal declarada arriba.
    DROP TABLE listado; -- eliminamos la tabla.
END $$
delimiter ;