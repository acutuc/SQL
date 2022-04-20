/*En la BD Promociones, un artículo tendrá un precio diferente cada día según esté promocionado (precio del artículo en promoción. tabla catalogospromos) o no (su precio será el que aparece en la tabla articulos, campo precioventa).

Las promociones tienen una duración determinada (desde promociones.fechiinipromo hasta la fecha de finalización (promociones.fechainipromo+promociones.duracion) y no todos los artículos se encuentran adscritos a todas las promociones (solo los que tienen un registro en la tabla catalogospromos para un promoción determinada. En ese caso su precio en los días que dure la promoción será el precio que aparece en catalogospromos.
Por tanto, para buscar el precio de un artículo a día de hoy (curdate()), habrá que comprobar si hay alguna promoción hoy y si el artículo está incluido en la promoción, en ese caso su precio será el de la promoción (catalogospromos), sin embargo, si hoy no hay promoción o el artículo que buscamos no está incluido en la promoción, su precio será el de la tabla articulos (precioventa). 
Esto es complicado si lo tenemos que hacer cada vez que necesitamos saber el precio a día de hoy de un artículo. 
Sería muy útil tener esta información de forma rápida, preparada. Por tanto se pide:
Crear una vista en la que podamos tener todos los datos de los artículos, pero, en lugar del precioventa, se pide el precioactual y éste será:
a) El precioventa de la tabla articulos (si el artículo no está en promoción hoy).
b) El precioartpromo de la tabla catalogospromos (si el artículo se encuentra en la promoción de hoy).

PISTAS: 
* Tendrás que usar funciones de fecha para saber si hoy (curdate()) está incluido dentro del periodo de una promoción en la tabla promociones (fecinipromo y fecinipromo+duración).
* Tendrás que usar la UNION ya que necesitas unir los datos de los artículos promocionados a los datos de los artículos no promocionados.
* Puede que te sea útil algún operador que trabaja con conjuntos de resultados como some, any, all o in.*/
use ventapromoscompleta

CREATE VIEW ejClase (Productos, Precio) as 
	SELECT articulos.refart, articulos.precioventa
    FROM articulos
    WHERE articulos.refart not in (SELECT catalogospromos.refart
									FROM catalogospromos JOIN promociones ON catalogospromos.codpromo = promociones.codpromo
									WHERE curdate() between promociones.fecinipromo and promociones.fecinipromo+promociones.duracionpromo)
    
    UNION
    
    SELECT catalogospromos.refart, catalogospromos.precioartpromo
    FROM catalogospromos JOIN promociones ON catalogospromos.codpromo = promociones.codpromo
    WHERE curdate() between promociones.fecinipromo and promociones.fecinipromo+promociones.duracionpromo;
    

SELECT *
FROM ejClase


drop view ejClase