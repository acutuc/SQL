-- Exámen Tema 8. Gabriel Allende.
use GBDgestionaTests;

/*Ej. 1*/
-- TABLA --> preguntas
-- OPERACIÓN --> UPDATE
-- TIPO --> AFTER
delimiter $$
DROP TRIGGER IF EXISTS ejercicio1 $$
CREATE TRIGGER ejercicio1
	AFTER UPDATE ON preguntas
FOR EACH ROW
BEGIN
    IF  NEW.textopreg = (SELECT textopreg FROM preguntas WHERE codtest = NEW.codtest) OR 
		OLD.textopreg = (SELECT textopreg FROM preguntas WHERE codtest = NEW.codtest)
			THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede añadir el test. La pregunta ya existe.';
	END IF;
END $$
delimiter ;

/*Ej. 2*/
CREATE INDEX ejercicio2
	ON tests (codmateria, unidadtest);
    
-- Probamos
SELECT codmateria 
FROM tests USE INDEX (ejercicio2)
WHERE codmateria = 1 AND unidadtest = 1
ORDER BY codmateria;

/*Al hacer operaciones sobre las tablas en las que hacen referencia algún índice, éstos se adaptan
al tipo de operación; si es un INSERT, el índice se adapta según el atributo al que hicimos referencia
ordenándolo automáticamente, si es un DELETE, se quita de la tabla y se reposicionan las demás filas... etc*/

/*Ej. 3*/
/*CREAMOS EL PROCEDIMIENTO*/
DROP PROCEDURE IF EXISTS ej3;
delimiter $$
CREATE PROCEDURE ej3()
BEGIN
	UPDATE matriculas
    SET nota = ((SELECT count(*) 
				FROM tests JOIN matriculas ON tests.codmateria = matriculas.codmateria
					JOIN alumnos ON matriculas.numexped = alumnos.numexped
				WHERE ((SELECT count(*) 
						FROM tests JOIN matriculas ON tests.codmateria = matriculas.codmateria
							JOIN alumnos ON matriculas.numexped = alumnos.numexped) > 10)))+1;
END $$
delimiter ;

-- CREAMOS EL EVENTO.
delimiter $$
CREATE EVENT ejercicio3
ON SCHEDULE
	EVERY 1 QUARTER
    STARTS '2021-09-16 00:00:00' -- Empieza en el inicio del curso actual, en septiembre (2021/09/16)
    ENDS '2022-06-21 00:00:00' -- Termina al final del curso actual, en junio (2022/06/21)
DO
	BEGIN
		 CALL ej3(); -- LLAMA AL PROCEDIMIENTO CREADO ANTERIORMENTE.
    END $$
delimiter ;

/*Ej. 4*/
-- TABLA --> preguntas
-- OPERACIÓN --> UPDATE
-- TIPO --> AFTER
delimiter $$
DROP TRIGGER IF EXISTS ejercicio4 $$
CREATE TRIGGER ejercicio4
	AFTER UPDATE ON preguntas
FOR EACH ROW
BEGIN
    IF  NEW.resa = (SELECT resa FROM preguntas WHERE codtest = NEW.codtest) OR 
		NEW.resb = (SELECT resb FROM preguntas WHERE codtest = NEW.codtest) OR
        NEW.resc = (SELECT resc FROM preguntas WHERE codtest = NEW.codtest)
			THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No pueden haber dos respuestas iguales';
	END IF;
END $$
delimiter ;

/*Ej. 5*/
delimiter $$
DROP TRIGGER IF EXISTS ejercicio5 $$
CREATE TRIGGER ejercicio5
AFTER UPDATE ON alumnos
FOR EACH ROW
BEGIN
	SET numrepeticion = 0;
    IF
	numrepeticion < (SELECT count(*)
					FROM alumnos JOIN matriculas ON alumnos.numexped = matriculas.numexped
                    WHERE OLD.numexped = NEW.numexped)
		THEN
INSERT INTO matriculas
(numexped, codmateria, nota)
VALUES
(numeroexped, codmateria, nota);

