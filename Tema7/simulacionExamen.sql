/*Nos han pedido que preparemos un procedimiento almacenado que, mediante el uso de cursores muestre un listado de clientes y las compras que han realizado por meses entre dos meses dados (usaremos el número de mes).
Además, a medida que vamos obteniendo los datos, para los clientes cuya media de artículos comprados supere a la media de la empresa para ese mes (media de artículos que se han comprado en la empresa en un mes) se les regalará 5 puntos.
Queremos asegurar que la operación se realice de manera íntegra y garantizando que al terminar, la base de datos quedará en buen estado.
El listado que queremos se mostraría para los meses ENERO (1) A MARZO (3) sería algo así:
COMPRAS  DE CLIENTES ENTRE ENERO Y MARZO:
-------------------------------------------------------------------------------------------------------------------------------------
CLIENTE: Nombre de cliente
-------------------------------------------------------------------------------------------------------------------------------------
ENERO:
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en ENERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
FEBRERO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en FEBRERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
MARZO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en MARZO:	Media unidades compradas*		puntos regalados**
-------------------------------------------------------------------------------------------------------------------------------------
CLIENTE: Nombre de cliente
------------------------------------------------------------------------------------------------------------
ENERO:
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en ENERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
FEBRERO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en FEBRERO:	Media unidades compradas*		puntos regalados**
----------------------------------------------------------------------------------------------------------------------------------
MARZO
Artículo					Unidades  compradas			Precio de compra
Nombre artítulo					x					x,xx
Nombre artítulo					x					x,xx
…..
-----------------------------------------------------------------------------------------------------------------------------------
Media de Nombre de cliente en MARZO:	Media unidades compradas*		puntos regalados**
……..
*/

use ventapromoscompleta;

drop procedure if exists SIMULACRO_EXAMEN_U7;
DELIMITER $$
CREATE PROCEDURE SIMULACRO_EXAMEN_U7()
BEGIN

-- CALL SIMULACRO_EXAMEN_U7;

DECLARE nombrecasa, nomcasaaux varchar(100) default '';
DECLARE nombrezona, nomzonaaux varchar(100) default '';
DECLARE nombrecaracteristica varchar(100) default '';
DECLARE metros, baños, habitaciones int default 0;
DECLARE preciocasa, preciototalzona decimal(9,2) default 0;
DECLARE primeraZona, primeraCasa boolean default 1;
DECLARE numcasaszona int default 0;


DECLARE DesCaracteristicas varchar(4000) default '';


DECLARE final bit default 0;

DECLARE curCasas CURSOR
	FOR SELECT nomcasa, m2, numbanios, numhabit, preciobase, nomzona, nomcaracter
	-- (select avg(preciobase) from casas as c where casas.codzona = c.codzona) as mediazona /* no es eficiente ya que se calcula la media de la zona de cada casa*/
		FROM casas join zonas on casas.codzona = zonas.numzona
			join caracteristicasdecasas on casas.codcasa = caracteristicasdecasas.codcasa
				join caracteristicas on caracteristicasdecasas.codcaracter = caracteristicas.numcaracter
		ORDER BY nomzona, nomcasa;


DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(4000));

OPEN curCasas;
FETCH FROM curCasas INTO nombrecasa, metros, baños, habitaciones, preciocasa, nombrezona, nombrecaracteristica;
-- WHILE not final DO
WHILE final = 0 DO
BEGIN
	
    IF nomzonaaux <> nombrezona THEN
		begin
		
			set nomzonaaux = nombrezona;
			IF (primeraZona = 1) THEN
				set primeraZona = 0;
			ELSE
				BEGIN
					INSERT INTO listado 
						(descripcion) 
					VALUES
						(concat('PRECIO MEDIO DE LA ZONA: ', preciototalzona/numcasaszona));
					set numcasaszona = 0;
				END;
			END IF;
    
			INSERT INTO listado 
				(descripcion) 
			VALUES 
				(concat('ZONA: ', nombrezona));
			set primeraCasa = 1;
			
			set preciototalzona = 0;
		end;
	END IF;
    
    
    if nomcasaaux <> nombrecasa then
	begin
		IF (primeraCasa = 1) THEN
			set primeraCasa = 0;
		ELSE 
			begin
				-- guardarmos los datos del anterior grupo
				INSERT INTO listado 
					(descripcion) 
				VALUES
					('CARACTERÍSTICAS:'),
					(DesCaracteristicas);
				set DesCaracteristicas= '';
			end;
		END IF;
    
		INSERT INTO listado 
            (descripcion) 
        VALUES 
            (concat('CASA: ', nombrecasa,' (METROS:', metros, ', BAÑOS: ', baños, ', HABIT: ',habitaciones, ')'));
		set preciototalzona = preciototalzona + preciocasa;
        set numcasaszona = numcasaszona + 1;
        set nomcasaaux = nombrecasa;
    end;
    end if;
    set DesCaracteristicas = concat(DesCaracteristicas, ', ', nombrecaracteristica);

	FETCH FROM curCasas INTO nombrecasa, metros, baños, habitaciones, preciocasa, nombrezona, nombrecaracteristica;
END;
END WHILE;
CLOSE curCasas;

if (select count(*) from listado) > 0 then
BEGIN
	INSERT INTO listado 
		(descripcion) 
	VALUES
		('CARACTERÍSTICAS:'),
		(DesCaracteristicas),
        (concat('PRECIO MEDIO DE LA ZONA: ', preciototalzona/numcasaszona));
	
    select * from listado;
END;
else
    select 'NO EXISTEN CASAS';
end if;
drop table if exists listado;
END $$
DELIMITER ;