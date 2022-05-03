-- unidad 7 Relacion 2 de ejercicios

-- Ejercicio 1
  
  drop procedure IF exists ej1;
  delimiter $$
  CREATE procedure ej1()
  BEGIN
  DECLARE nombreEmp varchar(20);
  DECLARE salario decimal(7, 2);
  DECLARE finCursor boolean default false;
  DECLARE cursorSueldo cursor for 
            SELECT nomem, salarem
						FROM empleados;
  DECLARE continue handler for sqlstate '02000' set finCursor = true;
  CREATE TEMPORARY TABLE tablaTemporal(nombre varchar(20), descripcion varchar(100));
  OPEN cursorSueldo;
  FETCH FROM cursorSueldo INTO nombreEmp, salario;
	WHILE finCursor = false do
		BEGIN
			CASE
					WHEN (salario < 800 ) THEN 
                    INSERT INTO tablaTemporal (nombre, descripcion)
                    VALUES (nombreEmp, concat('cobra ',salario, ' asi que está en el grupo de menos de 800e' ));
                    WHEN (salario between 800 and 1000) THEN
                    INSERT INTO tablaTemporal (nombre, descripcion)
                    VALUES (nombreEmp, concat('cobra ',salario, ' asi que está en el grupo de 800 a 1000e' ));
                    WHEN (salario between 1000 and 1200) THEN
                    INSERT INTO tablaTemporal (nombre, descripcion)
                    VALUES (nombreEmp, concat('cobra ',salario, ' asi que está en el grupo de 1000 a 1200e' ));
                    WHEN (salario between 1200 and 1500) THEN
                    INSERT INTO tablaTemporal (nombre, descripcion)
                    VALUES (nombreEmp, concat('cobra ',salario, ' asi que está en el grupo de 1200 a 1500e' ));
                    WHEN (salario between 1500 and 1800) THEN
                    INSERT INTO tablaTemporal (nombre, descripcion)
                    VALUES (nombreEmp, concat('cobra ',salario, ' asi que está en el grupo de 1500 a 1800e' ));
                    ELSE
                    INSERT INTO tablaTemporal (nombre, descripcion)
                    VALUES (nombreEmp, concat('cobra ',salario, ' asi que está en el grupo de más de 1800e' ));
            END CASE;
            FETCH FROM cursorSueldo INTO nombreEmp, salario;
        END;
	END WHILE;
    CLOSE cursorSueldo;
    IF  (SELECT count(*) FROM tablaTemporal) > 0 THEN
			SELECT *
			FROM tablaTemporal;
        ELSE
			SELECT 'Error';
    END IF;
  END$$
  delimiter ;
call ej1();


-- Ejercicio 2

  drop procedure IF exists ej_7_2_2;
  delimiter $$
  CREATE procedure ej_7_2_2()
  BEGIN
  DECLARE numeroEmp int;
  DECLARE comision decimal(7, 2);
  DECLARE finCursor boolean default false;
  DECLARE cursorComision  cursor
						for SELECT numem, comisem
						FROM empleados
						where IFnull(comisem, 0) = 0;
  DECLARE continue handler for sqlstate '02000' set finCursor = true;
  drop table IF exists resultado_7_2_2;
  CREATE table resultado_7_2_2(
  descripcion varchar(100)
  );
  OPEN cursorComision;
  FETCH FROM cursorComision INTO numeroEmp, comision;
	WHILE finCursor = false do
		BEGIN
			IF (IFnull(comision, 0) = 0) THEN
            INSERT INTO resultado_7_2_2 (descripcion)
            VALUES (concat('El empleado ', numeroEmp, ' no tiene comision'));
            END IF;
            FETCH FROM cursorComision INTO numeroEmp, comision;
        END;
	END WHILE;
    CLOSE cursorComision;
    IF  (SELECT count(*) FROM resultado_7_2_2) > 0 THEN
			SELECT *
			FROM resultado_7_2_2;
        ELSE
			SELECT 'Todos los empleados tienen comision';
    END IF;
  END$$
  delimiter ;
  call ej_7_2_2();
  
  
-- Ejercicio 3
  
  drop procedure IF exists ej_7_2_3;
  delimiter $$
  CREATE procedure ej_7_2_3()
  BEGIN
  DECLARE numeroEmp int;
  DECLARE nombreDep varchar(60);
  DECLARE auxNomDep varchar(60) default '';
  DECLARE finCursor boolean default false;
  DECLARE cursorComisDep  cursor
						for SELECT numem, nomde
						FROM empleados
						join departamentos on empleados.numde = departamentos.numde
						where IFnull(comisem, 0) = 0
						order by nomde;
  DECLARE continue handler for sqlstate '02000' set finCursor = true;
  drop table IF exists resultado_7_2_3;
  CREATE table resultado_7_2_3(
  descripcion varchar(100)
  );
  OPEN cursorComisDep;
  FETCH FROM cursorComisDep INTO numeroEmp, nombreDep;
	WHILE finCursor = false do
		BEGIN
			IF(auxNomDep <> nombreDep) THEN
				BEGIN
					INSERT INTO resultado_7_2_3 (descripcion)
					VALUES (concat('Departamento: ', nombreDep));
                    set auxNomDep = nombreDep;
                    -- FETCH FROM cursorComisDep INTO numeroEmp, nombreDep;
                END;    
            END IF;
				INSERT INTO resultado_7_2_3 (descripcion)
				VALUES (concat('El empleado ', numeroEmp, ' no tiene comision'));
                FETCH FROM cursorComisDep INTO numeroEmp, nombreDep;
        END;
	END WHILE;
    CLOSE cursorComisDep;
    IF  (SELECT count(*) FROM resultado_7_2_3) > 0 THEN
			SELECT *
			FROM resultado_7_2_3;
        ELSE
			SELECT 'Todos los empleados tienen comision';
    END IF;
  END$$
  delimiter ;
  
  call ej_7_2_3();
  
  -- Ejercicio 9
  