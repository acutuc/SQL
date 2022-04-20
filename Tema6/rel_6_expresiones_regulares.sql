/* SOLUCIONES RELACIÓN 4.8 ==> EXPRESIONES REGULARES */
/* Sabiendo que en la extensión de teléfono que utilizan los empleados, 
el primer dígito corresponde con el edificio, el segundo con la planta y el tercero con la puerta. 
Busca aquellos empleados que trabajan en la misma planta 
(aunque sea en edificios diferentes) que el empleado 120.
*/
select *
from empleados
where extelem rlike concat( '^.',
								(select substring(extelem, 2,1)
								from empleados
								where numem = 120));
select *
from empleados
where substring(extelem, 2,1) =
								(select substring(extelem, 2,1)
								from empleados
								where numem = 120);
                                
                                
/*
Sabiendo que los dos primeros dígitos del código postal se corresponden con la provincia y 
los 3 siguientes a la población dentro de esa provincia. 
Busca los clientes (todos sus datos) de las 9 primeras poblaciones de la provincia de 
Málaga (29001 a 29009).
*/

select *
from clientes
where codpostalcli rlike '^2900[1-9]';
-- where codpostalcli rlike '^290{2}[1-9]$';
-- where codpostalcli rlike '^290{2}[^0]';


/*
Sabiendo que los dos primeros dígitos del código postal se corresponden con la provincia 
y los 3 siguientes a la población dentro de esa provincia. 
Busca los clientes (todos sus datos) de las 20 primeras poblaciones de la provincia 
de Málaga (29001 a 29020).
*/
select *
from clientes
-- where codpostalcli rlike '^290(10|[[01]1-9]|20)';
where codpostalcli rlike '^290([12]0|[01][1-9])';
-- where codpostalcli rlike '^290[012][01]'; OJO ==> esta expresión daría por válida la cadena 29021

/*Queremos encontrar clientes con direcciones de correo válidas, 
para ello queremos buscar aquellos clientes cuya dirección de email 
contiene una “@”, y termina en un símbolo punto (.) seguido de “com”, “es”, “eu” o “net”.
*/
-- OJO ==> USAMOS EL CARÁCTER DE ESCAPE PARA QUE NO INTERPRETE EL PUNTO COMO CUALQUIER CARÁCTER SINO COMO UN PUNTO
-- CARACTER DE ESCAPE ==> \\

select *
from clientes

where correoelectronico rlike '@[a-z]*\\.(com|net|es|eu|it)$';

/*
Queremos encontrar ahora aquellos clientes que no cumplan con la expresión regular anterior.
*/
-- OJO ==> USAMOS EL CARÁCTER DE ESCAPE PARA QUE NO INTERPRETE EL PUNTO COMO CUALQUIER CARÁCTER SINO COMO UN PUNTO
-- CARACTER DE ESCAPE ==> \\
select *
from clientes
where not correoelectronico rlike '@[a-z]*\\.(com|net|es|eu)$';