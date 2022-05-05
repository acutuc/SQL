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

delimiter $$
drop procedure if exists ExamU7G1 $$
create procedure ExamU7G1 (
	in mesini int,
    in mesfin int)
begin
	-- call ExamU7G1(1,6);
	declare nomCliente, nomClienteAux, nomClienteAnterior varchar(100) default '';
    declare codigoCliente, codigoClienteAux int default 0;
    declare mesVenta, mesVentaAux varchar(12) default '';
    declare nombreArticulo varchar(100) default '';
    declare numVentas, cantVenta, sumCantVentas int default 0;
    declare precVenta, sumPrecVentas decimal(7,2) default 0;
    declare mediaVentaEmpresa decimal(7,2) default 0;
    declare puntosRegalados int default 0;
    
    declare primeraIteracion boolean default true;
    declare finalcursor boolean default false;
    
    declare curClientes cursor for
						select clientes.codcli, concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes.ape2cli),
								monthname(ventas.fecventa), articulos.nomart, detalleventa.cant, detalleventa.precioventa
						from ventas join clientes on ventas.codcli=clientes.codcli
							join detalleventa on ventas.codventa = detalleventa.codventa
								join articulos on detalleventa.refart = articulos.refart
						where month(ventas.fecventa)  between 1 and 6 --  mesini and mesfin
-- 							and year(ventas.fecventa) = year(curdate())
						order by concat_ws(' ', clientes.nomcli, clientes.ape1cli, clientes.ape2cli), 
							month(ventas.fecventa);
	
    declare continue handler FOR SQLSTATE '02000' 
				SET finalcursor = true;
/*	declare exit handler FOR sqlexception
				begin
					rollback;
                    close curClientes;
                end;
*/ -- 	start transaction;
    
    drop table if exists listado;
	create temporary table listado
		(descripcion varchar(200));
    
	open curClientes;
    fetch next from curClientes into codigoCliente, nomCliente, mesVenta, nombreArticulo, cantVenta, precVenta;
    
    INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('COMPRAS DE CLIENTES DE: ',  
					upper(monthname(convert(concat('2020/',mesini,'/1'),date))), ' A ', 
                     upper(monthname(convert(concat('2020/',mesfin,'/1'),date)))
					)
			),
            ('--------------------------------------------------------------------------------------------------------------');
        
    while not finalcursor do
    begin
		if nomCliente <> nomClienteAux then
        begin
			if primeraIteracion = false then
			begin
				if sumCantVentas/numVentas >= mediaVentaEmpresa then
                begin
					set puntosRegalados = 5;
                    update clientes
					set ptosacumulados = ptosacumulados + 5
                    where codcli = codigoClienteAux;
                    
				end;
                else
					set puntosRegalados = 0;
                end if;
				INSERT INTO listado 
					-- (descripcion) 
				VALUES
					('--------------------------------------------------------------------------------------------------------------'),
					(concat_ws(' ', 'Media de ', nomClienteAux, ' en ', mesVentaAux, ':       ',	
							sumCantVentas/numVentas),'------',   puntosRegalados),
					('--------------------------------------------------------------------------------------------------------------');
				set primeraIteracion = false;
                set numVentas = 0;
                set sumCantVentas = 0;
                set SumPrecVentas = 0;
                set codigoClienteAux = codigoCliente;
			end;
            else
				set primeraIteracion = false;
			end if;
			INSERT INTO listado 
            -- (descripcion) 
			VALUES
				(concat('CLIENTE: ', nomCliente)),
				('--------------------------------------------------------------------------------------------------------------');
			set nomClienteAux = nomCliente;
            set mesVentaAux = ''; -- inicializo la variable
        end;
        end if;
    
		if mesVenta <> mesVentaAux then
        
        begin
			if not primeraIteracion and mesVentaAux <> '' then
			begin
				if sumCantVentas/numVentas >= mediaVentaEmpresa then
                begin
					set puntosRegalados = 5;
                    update clientes
					set ptosacumulados = ptosacumulados + 5
                    where codcli =  codigoClienteAux;
                    
				end;
                else
					set puntosRegalados = 0;
                end if;
				INSERT INTO listado 
					-- (descripcion) 
				VALUES
					('--------------------------------------------------------------------------------------------------------------'),
					(concat_ws(' ', 'Media de ', nomClienteAux, ' en ', mesVentaAux, ':       ',	
							sumCantVentas/numVentas),'------', puntosRegalados),
					('--------------------------------------------------------------------------------------------------------------');
				set primeraIteracion = false;
                set numVentas = 0;
                set sumCantVentas = 0;
                set SumPrecVentas = 0;
                set codigoClienteAux = codigoCliente;
			end;
			end if;
            
			INSERT INTO listado 
            -- (descripcion) 
			VALUES
				(upper(mesVenta)),
                ('ArtÃƒÂ­culo               			-	            	Unidades compradas                     			Precio de compra');

			set mesVentaAux = mesVenta;
            -- calculo la media de unidades vendidas por venta en la empresa en ese mes:
			set mediaVentaEmpresa = (select sum(cant)/count(*) 
							from detalleventa join ventas on detalleventa.codventa = ventas.codventa
							where month(ventas.fecventa) = mesVenta
-- 								and year(ventas.fecventa) = year(curdate()
							);
		end;
        end if;
        
        INSERT INTO listado 
            -- (descripcion) 
		VALUES
				(concat(nombreArticulo, '               ',cantVenta,'                   ', precVenta));

		set numVentas = numVentas+1;
        set sumCantVentas = sumCantVentas + cantVenta;
        
		fetch next from curClientes into codigoCliente, nomCliente, mesVenta, nombreArticulo, cantVenta, precVenta;
    end;
    end while;
    
    close curClientes;
    if (select count(*) from listado) > 0 then
    begin
		if sumCantVentas/numVentas >= mediaVentaEmpresa then
		begin
			set puntosRegalados = 5;
			update clientes
			set ptosacumulados = ptosacumulados + 5
			where codcli = codigoClienteAux;
		end;
        end if;
		INSERT INTO listado 
		-- (descripcion) 
		VALUES
			('--------------------------------------------------------------------------------------------------------------'),
			(concat_ws(' ', 'Media de ', nomClienteAux, ' en ', mesVentaAux, ':       ',	
					sumCantVentas/numVentas), puntosRegalados),
			('--------------------------------------------------------------------------------------------------------------');
		select * from listado;
	end;
    else
		select CONCAT('No existen ventas entre los meses ',
					   monthname(convert(concat('2020/',mesini,'/1'),date)), ' y ', 
					   monthname(convert(concat('2020/',mesfin,'/1'),date))
					 );
	end if;
	drop table if exists listado;
--     commit;
    
end $$
delimiter ;