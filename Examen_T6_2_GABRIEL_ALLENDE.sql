-- Ej1.

-- Añadimos los datos solicitados en el ejercicio para realizar las pruebas correspondientes.
-- INSERT INTO GBDturRural2015.caracteristicasdecasas
-- (codcasa, codcaracter, tiene, observaciones)
-- VALUES ('1', '1', b'1', b'');
-- INSERT INTO GBDturRural2015.caracteristicasdecasas
-- (codcasa, codcaracter, tiene)
-- VALUES (2, b'1', b'1');

drop procedure if exists ej1;
delimiter $$
create procedure ej1(in zona int, in caracteristica int)
BEGIN
	SELECT casas.nomcasa, preciobase
    FROM casas JOIN caracteristicasdecasas on casas.codcasa = caracteristicasdecasas.codcasa
    WHERE casas.codzona = zona and caracteristicasdecasas.codcaracter = caracteristica
    ORDER BY casas.preciobase desc;
END $$
delimiter ;
call ej1(1, 1);

-- Ej2.
SELECT ifnull(casas.nomcasa, 'CASA SIN NOMBRE'), ifnull(caracteristicas.nomcaracter, 'CASA CARACTERÍSTICA')
FROM casas RIGHT JOIN caracteristicasdecasas on casas.codcasa = caracteristicasdecasas.codcasa
	RIGHT JOIN caracteristicas on caracteristicasdecasas.codcaracter = caracteristicas.numcaracter;

-- Ej3.
drop procedure if exists ej3;
delimiter $$
create procedure ej3(in tipocasa int)
BEGIN
	SELECT zonas.nomzona, casas.nomcasa, concat('de ', casas.minpersonas,' a ', casas.maxpersonas,' personas.')
    FROM casas JOIN zonas on casas.codzona = zonas.numzona
    WHERE casas.codtipocasa = tipocasa;
END $$
delimiter ;
call ej3(1);

-- Ej4.
drop procedure if exists ej4;
delimiter $$
create procedure ej4()
BEGIN
	SELECT zonas.nomzona as 'Nombre Zona', round(avg(casas.m2), 2) as 'Media m2'
    FROM casas JOIN zonas on casas.codzona = zonas.numzona
    GROUP BY zonas.nomzona;
END $$
delimiter ;
call ej4();

-- Ej5.
drop procedure if exists ej5;
delimiter $$
create procedure ej5(in numcasa int, out reservas int)
BEGIN
	SELECT count(reservas.codcasa) into reservas
    FROM reservas
    WHERE reservas.codcasa = numcasa
    GROUP BY reservas.codcasa;
END $$
delimiter ;
call ej5(1,@reservas);
select @reservas;

-- Ej6.
drop procedure if exists ej6;
delimiter $$
create procedure ej6(in numcasa int, out reservas int, out cantidaddias tinyint)
BEGIN
	SELECT count(reservas.codcasa) into reservas
    FROM reservas
    WHERE reservas.codcasa = numcasa
    GROUP BY reservas.codcasa;
    
    SELECT sum(reservas.numdiasestancia) into cantidaddias
    FROM reservas
    WHERE reservas.codcasa = numcasa
    GROUP BY reservas.codcasa;
END $$
delimiter ;
call ej6(1,@reservas, @cantidaddias);
select @reservas, @cantidaddias;

-- Ej7.
drop procedure if exists ej7;
delimiter $$
create procedure ej7()
BEGIN
-- Faltan substring, locate, etc... para separar nombres y apellidos en columnas diferentes.
	SELECT propietarios.nompropietario as 'Nombre Propietario', count(casas.codcasa) as 'Cantidad Casas'
    FROM propietarios LEFT JOIN casas on propietarios.codpropietario = casas.codpropi
    GROUP BY propietarios.nompropietario
    HAVING count(casas.codcasa) > 1;
END $$
delimiter ;
call ej7();