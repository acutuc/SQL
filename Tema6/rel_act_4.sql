/*20. Hallar el salario medio para cada grupo de empleados con igual comisión y para los que no la
tengan.*/
delimiter $$
drop procedure if exists ej_20;
create procedure ej_20()
BEGIN
	select avg(empleados.comisem) as 'Salario medio'
    from empleados
    where empleados.comisem is null or empleados.comisem = 0 or empleados.comisem
    group by empleados.comisem
END $$
delimiter ;

call ej_20;