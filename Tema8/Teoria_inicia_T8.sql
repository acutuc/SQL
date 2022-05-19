-- Teoría Tema 8.

-- TRIGGERS
Es un procedimiento almacenado que se lanza automáticamente cuando sucede algo.
Las instrucciones para las que se puede preparar un disparador son aquellas que modifican datos,
por tanto serán UPDATE, INSERT o DELETE. El disparador quedará asociado a una de estas
instrucciones sobre una tabla concreta.
También tenemos que indicar si queremos que se lance el disparador antes (BEFORE) o después
(AFTER) que la instrucción a la que se asocia.
Podremos tener hasta 6 disparadores asociados a cada tabla, pero todos deben ser diferentes.

delimiter $$
CREATE TRIGGER nombre_triger {BEFORE|AFTER}{INSERT|DELETE|UPDATE}
ON nombre_tabla -- tabla con la que está asociada el disparador.
FOR EACH ROW
begin
	-- ej
    if date_add(new.fecnacim, interval 16 year) > curdate() then
    -- no contratar (no hacer el insert)
    SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'El empleado no tiene la edad apropiada';
end $$
delimiter ;

-- EVENTOS
Un Evento es un trigger temporal, se lanza en un momento determinado de tiempo.

-- procedimiento: domicilaciones(); supongamos que tenemos este procedure creado previamente.
delimiter $$
CREATE EVENT nombre_evento
on nombre_tabla
	every 1 day
    starts '2022-05-10 02:00:00' -- empieza en esta fecha
    ends '2022-05-10 02:00:00' + interval 1 year -- termina justo en un año
do
	begin
		 call domiciliaciones();
    end $$
delimiter ;


-- INDICES
use empresaclase;
CREATE UNIQUE INDEX dniempleado -- nombre del índice. El tipo de índice es opcional.
	ON empleados (dniem); -- tabla y campo O campos sobre los que actuará el índice.
-- --------------------------------------------------------------------
CREATE INDEX buscanombre
	ON empleados (ape1em(4), ape2em(4), nomem(3)); -- El número del paréntesis indica la cantidad de caracteres (desde el principio) que nos devuelve el índice.

SHOW INDEX FROM empleados; -- ver los índices

EXPLAIN SELECT nomem -- EXPLAIN nos da información general de la tabla.
FROM empleados USE INDEX (buscanombre)
WHERE ape1em LIKE '%tort%' AND ape2em LIKE '%per%'
ORDER BY ape1em;

EXPLAIN SELECT *
FROM empleados
WHERE dniem = '27000001q';


-- TRANSACCIONES
START TRANSACTION;
INSERT INTO centros
(numce, nomce, dirce)
VALUES
(100, 'Prueba Transacción', 'Dirección prueba transacción');
COMMIT;