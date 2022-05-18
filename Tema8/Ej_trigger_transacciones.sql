use empresaclase;
drop trigger compruebaedad;
delimiter $$
create trigger mayoredad 
	before insert on empleados
for each row

/**
new ==> nuevos valores
new.

old ==> null

*/

begin
	if date_add(new.fecnaem, interval 16 year)>curdate() then
		signal sqlstate '45000' set message_text='No cumple criterio de edad';
	end if;
	
end $$
delimiter ;

/*** otro ejemplo de trigger ==> en la base de datos de promociones, comprobamos que dos promociones no se solapen */
use gestVentaPromos;

delimiter $$
drop trigger if exists compruebaFechaPromo $$
create trigger compruebaFechaPromo
	before insert on promociones
for each row
begin
	if exists(select count(*)
			  from promociones 
			  where new.fecinipromo between fecinipromo
				and date_add(fecinipromo, interval duracionpromo day)) then
		signal sqlstate '45000' set message_text = 'Se solapan las promociones';
	end if;

end $$
delimiter ;

insert into promociones
(codpromo,despromo,fecinipromo,duracionpromo)
values
(8, 'segunda promocion de primavera 2016',
	'2016/4/15', 45);


/*** PROCEDIMIENTO PARA AÑADIR UN DEPARTAMENTO NUEVO PARA EL QUE HEMOS CONTRATADO UN EMPLEADO NUEVO TAMBIÉN ***/
use gbdturrural2015;
/* VERSIÓN SIN TRANSACCIONES */
delimiter $$
create procedure insertanuevodir
 (in extension char(3),
	fechanacimiento date,
	fechaini date,
	salario decimal(7,2),
	comision decimal(7,2),
	numhijos tinyint(3),
	nomempleado varchar(20),
	apellido1 varchar(20),
	apellido2 varchar(20),
	dni char(9),
	userempleado char(12),
	
	numcentro int,
	presupuesto decimal(10,2),
	deptosdepen int,
	nomdeptos varchar(60))

begin
	/*Zona de declaración.*/
	DECLARE codempleado,coddepto int;
	
    /*Zona de código.*/
/* A. Buscamos último empleado + 1 */
	select ifnull(max(numem)+1,1) into codempleado 
	from empleados;
/* B. Buscamos último depto + 1  */	
	select ifnull(max(numde)+1,1) into coddepto
	from departamentos;	
/* C. Insertamos el nuevo depto */
	insert into departamentos
		(numde,numce,presude,depende,nomde)
	values
		(coddepto,
		numcentro,
		abs(presupuesto),
		deptosdepen,
		nomdeptos);
/* D. Insertamos el nuevo empleado (que será el nuevo director) */
	insert into empleados
		(numem,numde,extelem,fecnaem,fecinemp,salarem,comisem,numhiem,nomem,ape1em,ape2em,dniem,userem,passem)
	values
		(codempleado,
		coddepto,
		extension,
		fechanacimiento,
		fechaini,
		abs(salario),
		abs(comision),
		abs(numhijos),
		nomempleado,
		apellido1,
		apellido2,
		dni,
		userempleado);
/* E. Insertamos el registro de dirección del depto. */
	insert into dirigir
		(numdepto,numempdirec,fecinidir,fecfindir,tipodir)
	values
		(coddepto,codempleado,curdate(),date_add(curdate(),interval 1 year),'F');
end $$
delimiter ;

/** VERSIÓN CON TRANSACCIONES  **/
/*
TENDREMOS:
	* Una transacción explícita => la creamos nosotros con start transaction
    * Una transacción implícita en la ejecución de cada sentencia SQL
		==> durante la ejecución de cada operación sql habrá dos transacciones (explícita + implicita de la operación sql)
*/
delimiter $$
create procedure insertanuevodir
 (in extension char(3),
	fechanacimiento date,
	fechaini date,
	salario decimal(7,2),
	comision decimal(7,2),
	numhijos tinyint(3),
	nomempleado varchar(20),
	apellido1 varchar(20),
	apellido2 varchar(20),
	dni char(9),
	userempleado char(12),
	
	numcentro int,
	presupuesto decimal(10,2),
	deptosdepen int,
	nomdeptos varchar(60))
begin
	/*Zona de declaración.*/
	DECLARE codempleado,coddepto int;
	-- declare exit handler for sqlstate '45000'
	declare exit handler for sqlexception
		rollback;   -- si se produjera el error 45000 ==> se cerraríamos la transacción explícita que abrimos con start transaction
					-- rollback cierra las transacciones deshaciendo todos los cambios que se han producido mientras estamos dentro de la transacción
	/*Zona de código.*/

	start transaction;  -- comienza una transacción explícita
/* A. Buscamos último empleado + 1 */
	select ifnull(max(numem)+1,1) into codempleado -- empieza una transacción implícita al comenzar una sentencia sql 
	from empleados; -- la transacción implícita a la sentencia sql termina aquí, cuando termina la sentencia sql que la abrió
/* B. Buscamos último depto + 1 */	
	select ifnull(max(numde)+1,1) into coddepto -- empieza una transacción implícita al comenzar una sentencia sql
	from departamentos;	 -- la transacción implícita a la sentencia sql termina aquí, cuando termina la sentencia sql que la abrió
/* C. Insertamos el nuevo depto. */
	insert into departamentos -- empieza una transacción implícita al comenzar una sentencia sql
		(numde,numce,presude,depende,nomde)
	values
		(coddepto,
		numcentro,
		abs(presupuesto),
		deptosdepen,
		nomdeptos);  -- la transacción implícita a la sentencia sql termina aquí, cuando termina la sentencia sql que la abrió
/* E. Insertamos el nuevo empleado (que será director) */
	insert into empleados  -- empieza una transacción implícita al comenzar una sentencia sql
		(numem,numde,extelem,fecnaem,fecinemp,salarem,comisem,numhiem,nomem,ape1em,ape2em,dniem,userem,passem)
	values
		(codempleado,
		coddepto,
		extension,
		fechanacimiento,
		fechaini,
		abs(salario),
		abs(comision),
		abs(numhijos),
		nomempleado,
		apellido1,
		apellido2,
		dni,
		userempleado);  -- la transacción implícita a la sentencia sql termina aquí, cuando termina la sentencia sql que la abrió
/* E. Añadimos la fila de dirección */
	insert into dirigir  -- empieza una transacción implícita al comenzar una sentencia sql
		(numdepto,numempdirec,fecinidir,fecfindir,tipodir)
	values
		(coddepto,codempleado,curdate(),date_add(curdate(),interval 1 year),'F'); 
        -- la transacción implícita a la sentencia sql termina aquí, cuando termina la sentencia sql que la abrió
commit; -- se cierra la transacción explícita que abrimos con start transaction
		-- commit cierra la transacción confirmando todos los cambios que se han producido mientras estamos dentro de la transacción
end $$
/* version mejorada con una sola transaccion */
/*
TENDREMOS:
	
    * Una transacción implícita en la ejecución de la primera sentencia SQL
	* termina con commit/rollback
*/

delimiter $$
create procedure insertanuevodir
 (in extension char(3),
	fechanacimiento date,
	fechaini date,
	salario decimal(7,2),
	comision decimal(7,2),
	numhijos tinyint(3),
	nomempleado varchar(20),
	apellido1 varchar(20),
	apellido2 varchar(20),
	dni char(9),
	userempleado char(12),
	
	numcentro int,
	presupuesto decimal(10,2),
	deptosdepen int,
	nomdeptos varchar(60))

begin
	/*Zona de declaración.*/
	DECLARE codempleado,coddepto int;
	declare exit handler for sqlstate '45000'
		begin
			rollback;
			set autocommit = 1; -- fin autocommit
		end;
	/*Zona de código.*/

	/*start transaction;*/
	set autocommit = 0; -- cambiar autocommit

	select ifnull(max(numem)+1,1) into codempleado -- empieza una transacción implícita
	from empleados; -- la transacción implícita no termina aquí, porque autocommit es 0
	
	select ifnull(max(numde)+1,1) into coddepto -- NO empieza ninguna transacción implícita, se mantiene la anterior
	from departamentos;	-- no se cierra la transacción implícita porque autocommit es 0
	
	insert into departamentos  -- NO empieza ninguna transacción implícita, se mantiene la anterior
		(numde,numce,presude,depende,nomde)
	values
		(coddepto,
		numcentro,
		abs(presupuesto),
		deptosdepen,
		nomdeptos); -- no se cierra la transacción implícita porque autocommit es 0

	insert into empleados -- NO empieza ninguna transacción implícita, se mantiene la anterior
		(numem,numde,extelem,fecnaem,fecinemp,salarem,comisem,numhiem,nomem,ape1em,ape2em,dniem,userem,passem)
	values
		(codempleado,
		coddepto,
		extension,
		fechanacimiento,
		fechaini,
		abs(salario),
		abs(comision),
		abs(numhijos),
		nomempleado,
		apellido1,
		apellido2,
		dni,
		userempleado); -- no se cierra la transacción implícita porque autocommit es 0

	insert into dirigir -- NO empieza ninguna transacción implícita, se mantiene la anterior
		(numdepto,numempdirec,fecinidir,fecfindir,tipodir)
	values
		(coddepto,codempleado,curdate(),date_add(curdate(),interval 1 year),'F'); 
		-- no se cierra la transacción implícita porque autocommit es 0
commit; -- Se cierra la transacción existente (solo tenemos abierta la transacción implícita)
set autocommit = 1; -- Si queremos, volvemos a poner autocommit a 1 para no modificar el modo de trabajar de MySQL
end $$