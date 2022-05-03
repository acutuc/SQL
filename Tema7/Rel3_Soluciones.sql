use bdalmacen;

/*1. Preparar un procedimiento almacenado que utilizando cursores, obtenga un catálogo de productos con el siguiente formato:
	Productos de: Nombre y descripción de categoría
		Código		Descripción		Precio unidad		Existencias
		--------------------------------------------------------------------------------------------
		Codproducto	descripcion		preciounitariio		SI/NO
		….
	Productos de: Nombre y descripción de categoría
		Código		Descripción		Precio unidad		Existencias
		--------------------------------------------------------------------------------------------
		Codproducto	descripcion		preciounitariio		SI/NO
		….
*/
drop procedure if exists EJER_7_3_1;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_1()
BEGIN

DECLARE	nomcat, nomcataux varchar(30);
DECLARE descat varchar(100);
DECLARE codprod int;
DECLARE desprod varchar(50);
DECLARE precio decimal(12,2);
DECLARE existencias char(2);

DECLARE final bit default 0;
	
DECLARE curCatalogo CURSOR 
	FOR select categorias.Nomcategoria, categorias.descripcion, 
            productos.codproducto, productos.descripcion, productos.preciounidad,
            case
                when stock > 0 then 'SI'
                when stock = 0 then 'NO'
            END 
        from categorias join productos on productos.codcategoria = categorias.codcategoria
        order by categorias.Nomcategoria, productos.descripcion;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curCatalogo;
FETCH FROM curCatalogo INTO nomcat,descat,codprod, desprod,precio, existencias;
SET nomcataux='';
WHILE final = 0 DO
BEGIN
	IF (nomcataux <> nomcat) THEN
	BEGIN
		INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('Productos de: ', nomcat, ' --- ', descat));
        INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('Ref. prod          Descripcion             Precio        Existencias'));
		SET nomcataux = nomcat;
	END;
    END IF;
    INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('  ',codprod, '            ', desprod, '            ', precio, '      ',
                existencias));
	FETCH FROM curCatalogo INTO nomcat,descat,codprod, desprod,precio, existencias;
END;
END WHILE;
CLOSE curCatalogo;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No existen productos';
end if;
drop table if exists listado;

END $$
DELIMITER ;

call EJER_7_3_1();


/*2. Prepara un procedimiento almacenado que, mediante el uso de cursores, obtenga un listado de productos pedidos con el siguiente formato:
	Producto: Descripción (código)  ------- Pedidos: pedidos
	-------------------------------------------------------------------------
	Fecha pedido			cantidad pedida
	Fecha pedido			cantidad pedida
	…
	Producto: Descripción (código)  ------- Pedidos: pedidos
	-------------------------------------------------------------------------
	Fecha pedido			cantidad pedida
	Fecha pedido			cantidad pedida
	…
*/
drop procedure if exists EJER_7_3_2;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_2()
BEGIN

DECLARE	cantped int;
DECLARE fechaped date;
DECLARE codprod int;
DECLARE desprod, desprodaux varchar(50);
DECLARE numpedidos int;

DECLARE final bit default 0;
	
DECLARE curPedidos CURSOR 
	FOR select productos.codproducto, productos.descripcion, productos.pedidos,
	            (SELECT sum(cantidad) from pedidos where codproducto = productos.codproducto),
            pedidos.fecpedido, pedidos.cantidad
        from productos  join pedidos on productos.codproducto = pedidos.codproducto
        where fecentrega is null or fecentrega >= curdate()
        order by productos.descripcion;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
OPEN curPedidos;
FETCH FROM curPedidos INTO codprod, desprod,numpedidos, fechaped, cantped;
SET desprodaux='';
WHILE final = 0 DO
BEGIN
	IF (desprodaux <> desprod) THEN
	BEGIN
		INSERT INTO listado 
            -- (descripcion) 
        VALUES 
            (CONCAT('Producto: ', desprod, '(', codprod,')'));
        
		SET desprodaux = desprod;
	END;
    END IF;
    INSERT INTO listado 
            (descripcion) 
        VALUES 
            (CONCAT('  ',fechaped, '            ', cantped));
	FETCH FROM curPedidos INTO codprod, desprod,numpedidos, fechaped, cantped;
END;
END WHILE;
CLOSE curPedidos;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No existen productos pedidos';
end if;
drop table if exists listado;

END $$
DELIMITER ;

call EJER_7_3_2();


/*3. Prepara un procedimiento almacenado que, dado un código de producto, nos de el siguiente resultado para dicho producto:
	Nombre del producto:
	Proveedor: Empresa proveedora
	Contacto: Nombre de la persona de contacto
	Teléfono: Teléfono de contacto
	---------------------------------------------------------------------------------------
	Lista de pedidos de ese producto con la fecha del pedido, la cantidad pedida y la fecha prevista de 	entrega (si no se sabe que aparezca “SIN FECHA PREVISTA DE ENTREGA”)*/
drop procedure if exists EJER_7_3_3;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_3
(
    in codprod int
)
BEGIN

DECLARE desprod, nombreprov, contactoprov varchar(50);
DECLARE tlfprov char(9);
DECLARE fechaped, fechaent varchar(30);
DECLARE cantped int;

DECLARE final bit default 0;
	
DECLARE curPedidos CURSOR 
	FOR select  date_format(fecpedido,'%d/%m/%Y'), ifnull(date_format(fecentrega,'%d/%m/%Y'),'SIN FECHA PREVISTA DE ENTREGA'), cantidad
        from pedidos
        where codproducto = codprod
        order by fecpedido;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

SELECT productos.descripcion, proveedores.nomempresa, proveedores.nomcontacto, proveedores.telefono
    INTO desprod, nombreprov, contactoprov, tlfprov 
FROM productos join categorias on categorias.codcategoria = productos.codcategoria
    join proveedores on proveedores.codproveedor = categorias.codproveedor
where productos.codproducto =codprod;

drop table if exists listado;
create temporary table listado
    (descripcion varchar(100));
-- escribimos los datos del producto y proveedor
INSERT INTO listado 
   -- (descripcion) 
VALUES 
   (CONCAT('Nombre del producto: ', desprod)),
   (CONCAT('Proveedor: ', nombreprov)),
   (CONCAT('Contacto: ', contactoprov)),
   (CONCAT('Teléfono: ', tlfprov)),
   ('Pedidos: '),
   ('   Fecha pedido               Unidades Pedidas           Fecha entrega');
OPEN curPedidos;
FETCH FROM curPedidos INTO fechaped,fechaent,cantped;
        
WHILE final = 0 DO
BEGIN
-- insertamos las fechas de pedidos 
    INSERT INTO listado 
           -- (descripcion) 
        VALUES 
            (CONCAT('  ',fechaped, '                    ', 
                    cantped, '                       ', case fechaent
                                                            when null then 'SIN FECHA PREVISTA DE ENTREGA'
                                                            else fechaent
                                                        end));
	FETCH FROM curPedidos INTO fechaped,fechaent,cantped;
END;
END WHILE;
CLOSE curPedidos;

if (select count(*) from listado) = 6 then
    insert into listado values ('No existen pedidos para este producto');
end if;
select * from listado;
drop table if exists listado;

END $$
DELIMITER ;

call EJER_7_3_3(10);
call EJER_7_3_3(17);
call EJER_7_3_3(21);


/*4. Prepara un procedimiento almacenado que, dada una fecha, obtenga una lista de los productos pedidos hasta dicha fecha con la siguiente información:
Fecha máxima: fecha dada
Codproducto == > descripcion  ---  cantidad pedida ------- precio del pedido 
Codproducto == > descripciion ---  cantidad pedida ------- precio del pedido 
….
Total Precio ==== > total de todos los pedidos
Nota.- precio del pedido = cantidad pedida*preciounidad
	     total de todos los pedidos = suma de todos los precios de pedido
*/
DROP PROCEDURE IF EXISTS EJER_7_3_4;
DELIMITER $$
CREATE PROCEDURE EJER_7_3_4
(
    in fecha date
)
BEGIN

DECLARE codprod, unidades int;
DECLARE desprod VARCHAR(100);
DECLARE total, importe DECIMAL(12,2) DEFAULT 0;

DECLARE final BIT DEFAULT 0;
DECLARE curPedidos CURSOR
    FOR SELECT pedidos.codproducto, productos.descripcion, sum(pedidos.cantidad), sum(productos.preciounidad*pedidos.cantidad)
        FROM pedidos JOIN productos on productos.codproducto = pedidos.codproducto
        WHERE pedidos.fecpedido <= fecha
        GROUP BY pedidos.codproducto;
DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' BEGIN set final = 1; END;

DROP TEMPORARY TABLE IF EXISTS listado;
CREATE TEMPORARY TABLE listado (descripcion VARCHAR(200));

INSERT INTO listado VALUES (CONCAT('Pedidos hasta: ', date_format(fecha,'%d/%m/%Y')));
OPEN curPedidos;

FETCH FROM curPedidos INTO codprod, desprod, unidades, importe;

WHILE not final DO
BEGIN
    INSERT INTO listado VALUES
        (CONCAT('   ', codprod,' ==> ', desprod, ' ----- ', unidades, ' ----- ', importe,'€')); 
    set total = total + importe;
    FETCH FROM curPedidos INTO codprod, desprod, unidades, importe;
END;
END WHILE;
    IF (SELECT COUNT(*) FROM listado) > 1 THEN
        INSERT INTO listado VALUES
            ('---------------------------------------------------------'),
            (CONCAT('Precio Total de los pedidos: ', total, '€'));
    ELSE
        INSERT INTO listado VALUES
            ('---------------------------------------------------------'),
            ('NO EXISTEN PEDIDOS HASTA LA FECHA');

    END IF;
    CLOSE curPedidos;
    SELECT * FROM listado;
    DROP TABLE IF EXISTS listado;
    
END $$
DELIMITER ;

CALL EJER_6_4_4(CURDATE());
CALL EJER_6_4_4('2012-12-31');

/*5. Prepara un procedimiento almacenado “Pedidos masivos” que haga de forma automática un pedido de todos los productos cuyo stock esté por debajo de 5 unidades a fecha de hoy y por una cantidad de 5 unidades.
Nota.- Habrá que hacer la modificación oportuna en la tabla productos el campo “pedidos”.
*/
DROP PROCEDURE IF EXISTS PEDIDOSMASIVOS;
DELIMITER $$
CREATE PROCEDURE PEDIDOSMASIVOS()
BEGIN

DECLARE numpedidos, codprod, stockprod int;
DECLARE desprod VARCHAR(50);
DECLARE maxpedido int;

DECLARE final BIT DEFAULT 0;

DECLARE curProd CURSOR FOR
	SELECT codproducto, descripcion, stock, pedidos
	FROM productos
	WHERE stock <= 5;

DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET final = 1;

DROP TABLE IF EXISTS listado;
CREATE TEMPORARY TABLE listado (descripcion VARCHAR(200));

OPEN curProd;	
FETCH FROM curProd INTO codprod, desprod, stockprod, numpedidos;

WHILE not final DO
BEGIN
    SELECT MAX(codpedido) + 1 INTO maxpedido FROM pedidos;
	INSERT pedidos
		(codpedido, codproducto, fecpedido, fecentrega, cantidad)
	VALUES
		(maxpedido,
		 codprod, CURDATE(), null, 5);
	UPDATE productos
	SET pedidos = pedidos + 5
	WHERE codproducto = codprod;
    
    INSERT INTO listado
    VALUES
        (CONCAT('SE HA REALIZADO UN PEDIDO DE 5 UNIDADES DEL PRODUCTO ', codprod,
                ' (', desprod, ')'));

	FETCH FROM curProd INTO codprod, desprod, stockprod, numpedidos;
END;
END WHILE;

CLOSE curProd;

if (select count(*) from listado) > 0 then
    select * from listado;
else
    select 'No ha sido necesario realizar ningún pedido automático';
end if;
drop table if exists listado;

END $$
DELIMITER ;

CALL PEDIDOSMASIVOS();