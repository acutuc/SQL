-- Gabriel Allende.
/* PROPUESTO PARA 19 DE ABRIL:
Obtener un listado de clientes  (código de cliente, nombre y apellidos) 
y el importe de las ventas que han hecho dichos  clientes
Si un cliente no tiene ventras debe mostrrase
*/
SELECT clientes.codcli as 'Código cliente', concat_ws(' ',clientes.nomcli, clientes.ape1cli, clientes.ape2cli) as 'Nombre Cliente', ifnull(ventas.codventa, 0) as 'Código Venta'
	FROM clientes join ventas on ventas.codcli = clientes.codcli;
    
-- Solución de EVA:
SELECT clientes.codcli, concat_ws(' ', nomcli, ape1cli, ape2cli), sum(detalleventa.cant*detalleventa.precioventa)
FROM clientes left join ventas on clientes.codcli = ventas.codcli
	join detalleventa on ventas.codventa = detalleventa.codventa
GROUP BY clientes.codcli;