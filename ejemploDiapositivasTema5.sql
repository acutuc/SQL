start transaction;
	insert into facturas
	(codfact, fecha, codcli)
	values
	(399,'2021/9/2', 12);
													-- INSERCIÓN DE DATOS
	insert into detallefact
	(codfact, codprod, cant)
	values
	(399,12,5),
	(399,8,2);
    -- AQUI TERMINA LA PRIMERA DIAPOSITIVA.
    
    update productos
    set stock = stock -5
    where codprod = 12;
													-- MODIFICACIÓN DE DATOS
    update productos
    set stock = stock -2
    where codprod = 8;
    -- AQUI TERMINA LA SEGUNDA DIAPOSITIVA.
    
    update productos
	set stock = stock + 5
	where codprod = 12;
    
	update productos
	set stock = stock + 2
	where codprod = 8;
													-- ELIMINACIÓN DE DATOS
	delete from detallefact
	where codfact = 399;
    
	delete from facturas
	where codfact = 399;
	-- AQUI TERMINA LA TERCERA DIAPOSITIVA.
    
	commit; -- rollback;