-- drop procedure if exists muestraEmpleados;
delimiter $$
drop procedure if exists muestraEmpleados $$
create procedure muestraEmpleados
	(in depto int, in fecha date)
begin
	select *
    from empleados
    where numde = depto
		and fecinem <= fecha;
    -- sentencia
    -- sentencia
end $$
delimiter ;

call muestraEmpleados(121, '1990/1/1')