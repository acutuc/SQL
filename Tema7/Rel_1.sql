/*UNIDAD 7. Relación 1*/


/*1. Crea un procedimiento que devuelva el año actual*/
drop procedure if exists ej1_u7_rel1;
delimiter $$
CREATE PROCEDURE ej1_u7_rel1(out anio int)
no sql
BEGIN
    SET anio = year(current_date);
END
$$
delimiter ;
CALL ej1_u7_rel1(@n);
SELECT @n;

/*2. Crea una función que devuelva el año actual.*/
delimiter $$
create function ej2_u7_rel1()

returns int
begin
    return year(current_date);

end
$$
delimiter ;
SELECT ej2_u7_rel1();
/*3. Crea un procedimiento que muestre las tres primeras letras de una cadena pasada como parámetro en mayúsculas.*/

/*4. Crea un procedimiento que devuelva una cadena formada por dos cadenas, pasadas como parámetros, concatenadas y en mayúsculas.*/

/*5. Crea una función que devuelva el valor de la hipotenusa de un triángulo a partir de los valores de sus lados.*/

/*6. Crea una función que devuelva 1 ó 0 en función de si un número es o no divisible por otro.*/

/*7. Crea una función que devuelva el día de la semana (lunes, martes, …) en función de un número de entrada (1: lunes, 2:martes, …).*/

/*8. Crea una función que devuelva el mayor de tres números que pasamos como parámetros.*/

/*9. Crea una función que diga si una palabra, que pasamos como parámetros, es palíndroma.*/

/*10. Crea un procedimiento  que muestre la suma de los primeros n números enteros, siendo n un parámetro de entrada

/*11. Prepara un procedimiento que muestre la suma de los términos 1/n con n entre 1 y m (1/2 + 1/3 + ¼ +…), siendo m un parámetro de entrada.*/

/*12. Crea una función que determine si un número es primo o no (devolverá 0 ó 1).*/

/*13. Crea una función que calcule la suma de los primeros m números primos empezando por el 1. Utiliza la función del apartado anterior.*/

/*14. Crea un procedimiento que almacene en una tabla (primos (id, numero)) los primeros números primos comprendidos entre 1 y m (m es parámetro de entrada).*/

/*15. Modifica el procedimiento anterior para que se almacene en un parámetro de salida el número de primos almacenados.*/
