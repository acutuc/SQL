-- queremos ejecutar diariamente un procedimiento ya creado que se llama domiciliaciones();

delimiter $$
create event llamaDomiciliaciones
on schedule
	every 1 day
    starts '2022/5/10 02:00:00'
    ends '2022/5/10 02:00:00' + interval 1 year
do
	begin
		call domiciliaciones();
    end $$
    
delimiter ;


use empresaclase;
-- queremos controlar que un empleado no sea menor de 16 años:
delimiter $$
create trigger compruebaEdad 
	before insert
    on empleados
for each row
begin
	if date_add(new.fecnaem,  interval 16 year) > curdate() then 
    
    -- no contratar (no hacer el insert)
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'El empleado no tiene la edad apropiada';
    end if;

end $$
delimiter ;