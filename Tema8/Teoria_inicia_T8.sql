-- Teoría Tema 8.

-- DISPARADORES (TRIGGERS)
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
    if date_add(fecnacim, interval 16 year) > curdate() then
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