/*1. Prepara un procedimiento que muestre un listado con el nombre de los empleados y una columna en la que se indique si el empleado gana: 
menos de 800 € 
entre 800 y 1000 € 
entre 1000 y 1200 €   
entre 1200 y 1500 € 
entre 1500 y 1800 € 
más de 1800 €*/
drop procedure if exists ej1;
delimiter $$
create procedure ej1()
BEGIN
    DECLARE nomEm, ape1Em, ape2Em varchar(50) DEFAULT '';
    DECLARE salarEm decimal(10,2) DEFAULT 0;
    DECLARE fin_cursor boolean DEFAULT 0; 
    DECLARE cursorEj1 CURSOR FOR
		SELECT empleados.nomem, empleados.ape1em, empleados.salarem
		FROM empleados;
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000'
		BEGIN
			SET fin_cursor = 0;
        END;
	
    CREATE TEMPORARY TABLE tablaTEMP (nombreCompleto varchar(100), detalles varchar(500));
    
    OPEN cursorEj1;
    
    FETCH cursorEj1 INTO nomEm, ape1Em, salarEm; -- Primera línea
    
    WHILE fin_cursor = 0 DO
		BEGIN
			CASE
				WHEN (salarEm < 800) THEN
                INSERT INTO tablaTEMP
                VALUES (concat(nomEm, ' ',ape1Em, ' ', ifnull(ape2Em, '')), concat(' tiene de salario ', salarEm, '€, por lo que pertenece al primer grupo'));
                
                WHEN (salarEm between 800 and 1000) THEN
                INSERT INTO tablaTEMP
                VALUES (concat(nomEm, ' ',ape1Em, ' ', ifnull(ape2Em, '')), concat(' tiene de salario ', salarEm, '€, por lo que pertenece al segundo grupo'));
                
				WHEN (salarEm between 1000 and 1200) THEN
                INSERT INTO tablaTEMP
                VALUES (concat(nomEm, ' ',ape1Em, ' ', ifnull(ape2Em, '')), concat(' tiene de salario ', salarEm, '€, por lo que pertenece al tercer grupo'));
                
				WHEN (salarEm between 1200 and 1500) THEN
                INSERT INTO tablaTEMP
                VALUES (concat(nomEm, ' ',ape1Em, ' ', ifnull(ape2Em, '')), concat(' tiene de salario ', salarEm, '€, por lo que pertenece al cuarto grupo'));
                
				WHEN (salarEm between 1500 and 1800) THEN
                INSERT INTO tablaTEMP
                VALUES (concat(nomEm, ' ',ape1Em, ' ', ifnull(ape2Em, '')), concat(' tiene de salario ', salarEm, '€, por lo que pertenece al quinto grupo'));
                
				ELSE
                INSERT INTO tablaTEMP
                VALUES (concat(nomEm, ' ',ape1Em, ' ', ifnull(ape2Em, '')), concat(' tiene de salario ', salarEm, '€, por lo que pertenece al sexto grupo'));
			END CASE;
			FETCH cursorEj1 INTO nomEm, ape1Em, salarEm; -- Siguiente línea
		END;
	END WHILE; -- Termina el bucle, ya no hay más registros
					 
    CLOSE cursorEj1; 
    
    SELECT *
    FROM tablaTEMP; 
    
    DROP TABLE tablaTEMP; 
    
END $$
delimiter ;

drop table tablaTEMP;
call ej1();

/*2. Preparar un procedimiento almacenado que utilizando cursores, obtenga un listado de los empleados sin comisión con el siguiente formato:
	“El empleado NUMEROEMPLEADO no tiene comisión”*/
drop procedure if exists EJER_7_3_2;
delimiter $$
CREATE PROCEDURE EJER_7_3_2()
BEGIN
DECLARE numeroem int;
DECLARE fincursor bit default 0;
DECLARE curEmple CURSOR 
	FOR SELECT numem
	FROM empleados
	-- WHERE comisem is null or comisem =0;
    WHERE ifnull(comisem,0)=0;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' 
				SET fincursor = 1;


drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));

OPEN curEmple;
FETCH FROM curEmple INTO numeroem;

WHILE fincursor = 0 DO
BEGIN
	
	INSERT INTO listado (descripcion)
    values (CONCAT('El empleado ', numeroem,' no tiene comisión'));

	FETCH FROM curEmple INTO numeroem;
END;
END WHILE;
CLOSE curEmple;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'NO EXISTEN EMPLEADOS SIN COMISIÓN';
end if;
drop table if exists listado;
END $$
delimiter ;

call EJER_7_3_2();


/*3. Prepara un procedimiento almacenado que obtenga el listado del apartado anterior pero, esta vez, organizado por departamentos. El formato será:
	Departamento: Nombre departamento
		El empleado NUMEROEMPLEADO no tiene comisión
		El empleado NUMEROEMPLEADO no tiene comisión
		….
	Departamento: Nombre departamento
		El empleado NUMEROEMPLEADO no tiene comisión
		….*/
drop procedure if exists EJER_7_3_3;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_3()
BEGIN
-- call EJER_7_3_3();
DECLARE numeroem int;
DECLARE	nomdepto, nomdeaux varchar(60);
DECLARE final bit default 0;	

DECLARE curEmple CURSOR 
	FOR SELECT numem, nomde
	FROM empleados join departamentos on departamentos.numde = empleados.numde
	WHERE empleados.comisem is null or empleados.comisem =0
	ORDER BY departamentos.nomde;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curEmple;
FETCH FROM curEmple INTO numeroem,nomdepto;
SET nomdeaux='';
WHILE final = 0 DO
BEGIN
	IF (nomdeaux <> nomdepto) THEN
	BEGIN
		INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('Departamento: ', nomdepto));
		SET nomdeaux = nomdepto;
	END;
    END IF;
    INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('    El empleado ',numeroem, ' no tiene comisión'));
	FETCH FROM curEmple INTO numeroem, nomdepto;
END;
END WHILE;
CLOSE curEmple;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'NO EXISTEN EMPLEADOS SIN COMISIÓN';
end if;
drop table if exists listado;

END $$
DELIMITER ;

        
/*4. Prepara un procedimiento almacenado que, mediante el uso de cursores, incremente en un 2% el salario de los empleados que no tengan comisión y de aquellos que tengan un número de hijos por encima de la media.*/
drop procedure if exists EJER_7_3_4;
delimiter $$
CREATE PROCEDURE EJER_7_4()
BEGIN
  select numem, salarem 
  from empleados where ifnull(comisem,0)=0
 		OR numhiem > (select avg(numhiem) from empleados);

  select numem, salarem 
  from empleados where ifnull(comisem,0)=0
		OR numhiem > (select avg(numhiem) from empleados);

DECLARE final bit default 0;
DECLARE numeroem, cont int;
DECLARE curEmple CURSOR
	FOR SELECT numem
	FROM empleados
	WHERE comisem is null OR comisem =0 -- ifnull(comiem,0)=0
		OR numhiem > (select avg(numhiem) from empleados);

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' 
	SET final = 1;

set cont = 0;
OPEN curEmple;
FETCH FROM curEmple INTO numeroem;

WHILE (final = FALSE) DO -- NOT final DO
BEGIN
	UPDATE empleados
	SET salarem = salarem*1.02
	WHERE numem = numeroem;
    set cont = cont +1;
 	FETCH FROM curEmple INTO numeroem;
END;
END WHILE;	
CLOSE curEmple;

SELECT CONCAT('Se ha incrementado el salario de ', cont, ' empleados');
END $$
delimiter ;

call EJER_7_3_4();


/*5. Prepara un procedimiento almacenado que, mediante el uso de cursores, modifique, incrementando o decrementando, según se desee en cada caso la comisión de los empleados en un tanto por ciento que se pasará, junto con la intención de incrementar o decrementar, por parámetos.*/
drop procedure if exists EJER_7_3_5;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_5
(	accion bit,
	porcentaje decimal
)
BEGIN
DECLARE numeroem, cont int;
DECLARE final bit default 0;

DECLARE curEmple CURSOR
	FOR SELECT numem
	FROM empleados;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

set cont = 0;
OPEN curEmple;
FETCH FROM curEmple INTO numeroem;
-- WHILE not final DO
WHILE final = 0 DO
BEGIN
	IF (accion = 1) THEN
		UPDATE empleados
		SET salarem = salarem + salarem*porcentaje/100
		WHERE numem = numeroem;
	ELSE 
		UPDATE empleados
		SET salarem = salarem - salarem*porcentaje/100
		WHERE numem = numeroem;
    END IF;
    set cont = cont +1;
	FETCH FROM curEmple INTO numeroem;
END;
END WHILE;
CLOSE curEmple;

IF accion = 1 then
    SELECT CONCAT('Se ha incrementado el salario de ', cont, ' empleados');
else
    SELECT CONCAT('Se ha decrementado el salario de ', cont, ' empleados');
end if;

END $$
DELIMITER ;

call EJER_7_3_5(1,5);


/*6. Los empleados de nuestra base de datos se conectarán al sistema utilizando un nombre de usuario y una contraseña que quedarán almacenadas en la tabla empleados. Añade dichos campos (nomuserem y contrasem).
Inicialmente tanto el nombre de usuario como la contraseña serán el nombre y el primer apellido (sin espacios en blanco). Prepara un procedimiento almacenado que, mediante el uso de cursores inicalize todos los nombres de usuario y contraseñas.*/
DROP PROCEDURE IF EXISTS EJER_7_3_6;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_6()
BEGIN
DECLARE nombreem, apellido1em VARCHAR(20);
DECLARE numeroem int;
DECLARE final bit default 0;
	 
DECLARE curEmple CURSOR
	FOR SELECT numem,nomem, ape1em
	FROM empleados;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

OPEN curEmple;
FETCH FROM curEmple INTO numeroem, nombreem, apellido1em;

WHILE not final DO
BEGIN
	UPDATE empleados
	SET userem = LEFT(concat(nombreem,apellido1em),12),
		passem = LEFT(concat(nombreem,apellido1em),12)
	WHERE numem = numeroem;
	FETCH NEXT FROM curEmple INTO numeroem, nombreem, apellido1em;
END;
END WHILE;	
CLOSE curEmple;

END $$
DELIMITER ;

CALL EJER_7_3_6();


/*7. Prepara un procedimiento almacenado que iguale todas las contraseñas al nombre de usuario.*/
DROP PROCEDURE IF EXISTS EJER_7_3_7;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_7()
BEGIN
DECLARE final BIT DEFAULT 0;
DECLARE numeroem INT;
DECLARE nomuserem VARCHAR(12);

DECLARE curEmple CURSOR
	FOR SELECT numem, nomuserem
	FROM empleados;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;
OPEN curEmple;

FETCH FROM curEmple INTO numeroem, nomuserem;

WHILE (final = 0) DO
BEGIN
	UPDATE empleados
	SET passem = nomuserem
	WHERE numem = numeroem;	
	FETCH FROM curEmple INTO numeroem, nomuserem;
END;
END WHILE;
CLOSE curEmple;

END $$
DELIMITER ;

CALL EJER_7_3_7();


/*8. Cuando damos de alta un nuevo empleado habrá que asignarle un nombre de usuario y contraseña al nuevo usuario.
Prepara un procedimiento que busque que no exista ese nombre de usuario, en caso afirmativo se almacenará el usuario y la contraseña elegidas, caso contrario mostrará un mensaje por pantalla indicando que el nombre de usuario ya existe para que busquemos otro.*/
drop procedure if exists EJER_7_3_8;
delimiter $$
CREATE PROCEDURE EJER_7_3_8(
	vnumde INT,
	vnomem VARCHAR(20),
	vape1em VARCHAR(20),
	vape2em VARCHAR(20),
	vfecnaem DATETIME,
	vfecinem DATETIME,
	vsalarem DECIMAL,
	vnumhiem SMALLINT,
	vuserem VARCHAR(15),
	vpassem VARCHAR(15)
)
BEGIN

-- call EJER_6_8(100,'pepe','gomez','gomez','1989-12-1',curdate(),1200,0,'pepe','pepe');

DECLARE nuevoem int;
DECLARE texto varchar(100) default '';

DECLARE miCur CURSOR FOR
	SELECT userem from empleados;

DECLARE CONTINUE HANDLER FOR sqlstate '02000'
	BEGIN
		set finalcursor = true;
    END;

DECLARE EXIT HANDLER FOR sqlstate '45000'
	BEGIN
		SELECT Concat('Hay un error en los datos. Compruebe los datos y vuelva a intentarlo: ', texto);
        rollback;
	END;

start transaction;

	IF (SELECT COUNT(*) FROM empleados
		WHERE userem = vuserem)>0 then
	BEGIN
		SET texto = 'El usuario ya existe elija otro';
		signal sqlstate '45000' set message_text = 'El Usuario ya existe';
	END;
	END IF;
	IF (SELECT COUNT(*) FROM departamentos
		WHERE numde = vnumde)=0 then
	BEGIN
		SET texto = 'El departamento no existe';
		signal sqlstate '45000' set message_text = 'El depto no existe';
	END;
	END IF;

	/* versión con cursor:
	open miCur;
	fetch micur into usuario;
	WHILE finalcursor do
	begin
		if usuario = vuserem then
			
		fetch micur into usuario;
	end;
	end while;

	*/
	SELECT max(numem)+1 INTO nuevoem 
	FROM empleados;

	INSERT empleados
	(numem,numde,extelem,fecnaem,fecinem,salarem,comisem,numhiem,
		nomem,ape1em,ape2em,userem,passem)
	VALUES
	(nuevoem,vnumde,null,vfecnaem,vfecinem,vsalarem,null,vnumhiem,
		vnomem,vape1em,vape2em,vuserem,vpassem);
commit;
end $$
delimiter ;

call EJER_7_3_8(100,'pepe','gomez','gomez','1989-12-1',curdate(),1200,0,'pepe','pepe');


/*9. Prepara un procedimiento almacenado como el del apartado 2, pero, ahora, consigue que aparezcan todos los empleados, con o sin comisión:
	Departamento: Nombre departamento
		Empleados sin comisión:
			Nº Empleado		Apellidos y nombre
			….
		Empleados con comisión
			Nº Empleado		Apellidos y nombre		Comisión
			. . .
	Departamento: Nombre departamento
		El empleado NUMEROEMPLEADO no tiene comisión
		Empleados sin comisión:
			Nº Empleado		Apellidos y nombre
			….
		Empleados con comisión
			Nº Empleado		Apellidos y nombre		Comisión
*/
drop procedure if exists EJER_7_3_9;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_9()
BEGIN

DECLARE numeroem int;
declare comision decimal(10,2);
declare sincomis, concomis smallint;
DECLARE nombre varchar(100);
DECLARE	nomdepto, nomdeaux varchar(60);
DECLARE final bit default 0;
	
DECLARE curEmple CURSOR 
	FOR SELECT empleados.numem, departamentos.nomde, 
        ifnull(empleados.comisem,0), concat(empleados.nomem, 
            empleados.ape1em, ifnull(empleados.ape2em,''))
	FROM empleados join departamentos on departamentos.numde = empleados.numde
	ORDER BY departamentos.nomde, ifnull(empleados.comisem,0);

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curEmple;
FETCH FROM curEmple INTO numeroem,nomdepto, comision, nombre;
SET nomdeaux='';
WHILE final = 0 DO
BEGIN
	IF (nomdeaux <> nomdepto) THEN
	BEGIN
		INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('Departamento: ', nomdepto));
		SET nomdeaux = nomdepto;
        SET sincomis = 0;
		SET concomis = 0;
	END;
    END IF;

    IF comision =0 and sincomis = 0 then
	BEGIN
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            ('Empleados sin comisión:');
		SET sincomis = 1;
	END;
    end if;

    IF comision >0 and concomis = 0 then
	BEGIN
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            ('Empleados con comisión:');
		SET concomis = 1;
	END;
    end if;

    if comision = 0 then
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('    ',numeroem, ' -- ', nombre));
	ELSE
        INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('    ',numeroem, ' -- ', nombre, ' --- COMISION: ', comision));
    END IF;
	FETCH FROM curEmple INTO numeroem, nomdepto, comision, nombre;
END;
END WHILE;
CLOSE curEmple;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'NO EXISTEN EMPLEADOS';
end if;
drop table if exists listado;

END $$
DELIMITER ;

call EJER_7_3_9();


/*10. Prepara un procedimiento almacenado que, dado un número de departamento, obtenga un listado con el nombre del director de dicho departamento y el nombre de los departamentos que dependan de él y el de sus directores.
En caso de que no exista ningún departamento que dependa del departamento dado, mostrar su director y un mensaje indicando que no existen departamentos dependientes.*/
drop procedure if exists EJER_7_3_10; 
DELIMITER $$
create procedure EJER_7_3_10
(
numdepto int
)
BEGIN
DECLARE director, nomdirdep VARCHAR(70);
DECLARE nomdepto VARCHAR(60);
DECLARE final bit default 0;
	 
DECLARE deptosdep CURSOR
	FOR select departamentos.nomde, 
            CONCAT(empleados.ape1em, IFNULL(CONCAT(' ', empleados.ape2em),''), ', ', nomem)
        from departamentos join dirigir on departamentos.numde = dirigir.numdepto
            join empleados on dirigir.numempdirec = empleados.numem
        where depende = numdepto and (fecfindir is null or fecfindir >= curdate());

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(200));

SELECT CONCAT(empleados.ape1em, IFNULL(CONCAT(' ', empleados.ape2em),''), ', ', nomem) INTO director
FROM dirigir JOIN empleados ON empleados.numem = dirigir.numempdirec
WHERE dirigir.numdepto = numdepto and (fecfindir is null or fecfindir >= curdate());

INSERT INTO listado
    (descripcion)
VALUES
    (CONCAT('DIRECTOR: ', director));

OPEN deptosdep;
FETCH FROM deptosdep INTO nomdepto, nomdirdep;

IF found_rows() is null THEN -- devuelve el número de filas rdel cursor con el que estoy trabajando
begin
/*    INSERT INTO listado
        (descripcion)
    VALUES
        (CONCAT('NO HAY DEPARTAMENTOS QUE DEPENDAN DEL DEPTO ',numdepto));
*/
end;
ELSE
BEGIN
	INSERT INTO listado
        (descripcion)
    VALUES
        ('DEPARTAMENTOS DEPENDIENTES:' );

	WHILE not final DO
	BEGIN
        INSERT INTO listado
            (descripcion)
        VALUES
            (CONCAT('  DEPTO: ', nomdepto, ' --- DIRECTOR: ', nomdirdep));
		
		FETCH FROM deptosdep INTO nomdepto, nomdirdep;
	END;
    END WHILE;
END;
END IF;
CLOSE deptosdep;

select * from listado;

drop table if exists listado;
END $$
DELIMITER ;

CALL EJER_7_3_10(121);


/*11. Obtener un listado con el nombre de los centros de trabajo, los departamentos que dependen de él y el número de trabajadores en cada uno de ellos:
Centro de trabajo: Nº y Nombre de centro
Departamentos:
	Nº y Nombre de departamento == >  X empleados
	…
Centro de trabajo: Nº y Nombre de centro
Departamentos:
	Nº y Nombre de departamento == >  X empleados
	…
…
*/
DROP PROCEDURE IF EXISTS EJER_7_3_11;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_11()
BEGIN
DECLARE numcentro, numdepto, numeroemple int;
DECLARE nomcentro, nomceaux, nomdepto varchar(60) DEFAULT '';
DECLARE final bit DEFAULT 0;
	
DECLARE curCentros CURSOR
	FOR SELECT centros.numce, centros.nomce, departamentos.numde, departamentos.nomde,
        (SELECT count(*) from empleados where numde = departamentos.numde)
	FROM departamentos inner join centros on centros.numce = departamentos.numce 
	ORDER BY centros.numce;

/*	FOR SELECT centros.numce, centros.nomce, departamentos.numde, departamentos.nomde, count(*) 
	FROM departamentos inner join centros on centros.numce = departamentos.numce 
		inner join empleados on departamentos.numde = empleados.numde
	GROUP BY centros.numce, departamentos.numde;
*/ 
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));

OPEN curCentros;
FETCH FROM curCentros INTO numcentro,nomcentro,numdepto,nomdepto, numeroemple;

WHILE not final DO
BEGIN
	IF (nomceaux <> nomcentro) THEN
	BEGIN
        INSERT INTO listado
            (descripcion)
        VALUES
            (CONCAT('Centro de trabajo: ', numcentro, ' ==> ', nomcentro));
		
		INSERT INTO listado
        VALUES
		('Departamentos: ');
		SET nomceaux = nomcentro;
	END;
    END IF;
    INSERT INTO listado
        -- (descripcion)
    VALUES
        (CONCAT('   ', numdepto, ' - ', nomdepto, ' ==> ', numeroemple, ' empleados'));
		
	FETCH FROM curCentros INTO numcentro,nomcentro,numdepto,nomdepto, numeroemple;
END;	
END WHILE;

CLOSE curCentros;

select * from listado;

drop table if exists listado;

END $$
DELIMITER ;

CALL EJER_7_3_11();