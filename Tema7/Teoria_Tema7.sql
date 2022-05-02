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
/*

*/
/*Centro de trabajo: Relaciones con clientes
	DEPTO	NOMBRE	PRESUDE
    110		DIR C.	15000
    112		...		...
    131		...		...
Centro de trabajo: Sede central
	DEPTO	NOMBRE	PRESUDE
    ...		...		...
    ...		...		...
					TOTAL: ...
				
    */
drop procedure if exists pruebaCursor;
delimiter $$
create procedure pruebaCursor()
BEGIN
	-- Orden de declaración: Variables, cursor y manejador
    -- VARIABLES
    DECLARE numdepto int DEFAULT 0; 
    DECLARE nomdepto, nomcentro, nomcentroaux varchar(100) DEFAULT '';
    DECLARE presupuesto decimal(12,2) DEFAULT 0.00;
    DECLARE suma_presupuestos decimal(12,2) DEFAULT 0.00;
    DECLARE primera_fila int DEFAULT 1;  
    DECLARE fin_cursor boolean DEFAULT 0; 
    
    -- CURSOR
    DECLARE cursorDeptos CURSOR FOR
		SELECT numde, nomde, presude, nomce
		FROM departamentos JOIN centros ON departamentos.numce = centros.numce
		ORDER BY nomce;
    
    -- MANEJADOR DE ERRORES
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' -- IndexOutOfBounds
		BEGIN
			SET fin_cursor = 1;
        END;
	
    CREATE TEMPORARY TABLE listado (filarecorrida varchar(500)); -- Crea la tabla temporal
    
    OPEN cursorDeptos; -- Abre el cursor
    
    FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro; -- Primera línea
    
    WHILE fin_cursor = 0 DO -- Mientras no se acaben los registros
		BEGIN

			IF nomcentro <> nomcentroaux THEN -- Cuando el nombre cambie, cabecera nueva
				BEGIN
                
					IF NOT primera_fila THEN --  Si es la primera cabecera, no añade el total
						BEGIN
							INSERT INTO listado -- Pone el total del centro
							VALUES
								(concat('TOTAL PRESUPUESTO:             ',suma_presupuestos));
							SET suma_presupuestos = 0; -- Y pone lo pone a 0 para el siguiente
						END;
					END IF;
                
					INSERT INTO listado -- Cabecera de cada centro
					VALUES 						 
						(concat('Centro de trabajo: ', nomcentro)),
						('Nº Departamento		Nombre				Presupesto');
					
					SET nomcentroaux = nomcentro;
                    SET primera_fila = 0; -- Primera fila a false
				END;
			END IF;
			-- --------------------------------------------------------
			SET suma_presupuestos = suma_presupuestos + presupuesto; -- Cada depto suma su presupuesto al total
			INSERT INTO listado
            VALUES 
				(concat(numdepto, '	',nomdepto, '			', presupuesto)); -- Añade los datos del depto
        
			FETCH cursorDeptos INTO numdepto, nomdepto, presupuesto, nomcentro; -- Siguiente línea
        END;
	END WHILE; -- Termina el bucle, ya no hay más registros
    
	INSERT INTO listado -- E inserta el presupuesto total del último depto
	VALUES
		(concat('TOTAL PRESUPUESTO:             ',suma_presupuestos));
					 
    CLOSE cursorDeptos; -- Cierra el cursor
    
    
    SELECT * FROM listado; -- Enseña el listado
    
    DROP TABLE listado; -- 
    
END $$
delimiter ;


call pruebaCursor();