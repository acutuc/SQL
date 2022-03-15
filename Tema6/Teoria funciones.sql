/**
Obtener el codigo y la descripcion de los tests de la materia 1
**/

select codtest, descrip
from tests
where codmateria = 1;


select * from materias;
/**
Obtener el codigo y la descripcion de los tests de la materia Matemáticas
**/

select codtest, descrip, materias.codmateria
from tests join materias on tests.codmateria = materias.codmateria
where materias.nommateria = 'Matemáticas';


/**
Obtener el codigo, la descripcion de los tests y el texto de cada pregunta
de la materia Matemáticas
**/

select tests.codtest, tests.descrip, preguntas.numpreg, preguntas.textopreg,
	preguntas.resa, preguntas.resb, preguntas.resc, preguntas.resvalida 
	
from tests join materias on tests.codmateria = materias.codmateria
	join preguntas on preguntas.codtest = tests.codtest
where materias.nommateria = 'Matemáticas';


/**
Obtener las preguntas, las posibles respuestas y la respuesta válida
de los tests de la materia Matemáticas
**/

select preguntas.numpreg, preguntas.textopreg,
	preguntas.resa, preguntas.resb, preguntas.resc, preguntas.resvalida
	
from tests join materias on tests.codmateria = materias.codmateria
	join preguntas on preguntas.codtest = tests.codtest
where materias.nommateria = 'Matemáticas';


/**
Obtener las respuestas de los alumnos, las preguntas, las posibles respuestas y la respuesta válida
de los tests de la materia Matemáticas
**/

select preguntas.codtest, preguntas.numpreg, preguntas.textopreg,
	preguntas.resa, preguntas.resb, preguntas.resc, preguntas.resvalida,
    respuestas.numrepeticion, respuestas.respuesta
	
from tests join materias on tests.codmateria = materias.codmateria
	join preguntas on preguntas.codtest = tests.codtest
			left join respuestas on
				preguntas.codtest = respuestas.codtest and preguntas.numpreg = respuestas.numpreg
where materias.nommateria = 'Matemáticas'
order by preguntas.codtest;

/*****************************************************/
/*Funciones en MySQL:
1. Funciones de usuario --> Una rutina precompilada que devuelve un valor (no es void).
2. Funciones del sistema --> curdate(), ifnull()... (MIRAR EN w3schools.com las funciones del sistema)
3. Funciones de agregado

1 y 2 --> Se pueden anidar, usar en cualquier parte de una sentencia SQL.
3 --> No se puede anidar y no se puede usar en la cláusula "where".

/******************  FUNCIONES DE AGREGADO ************/
/****   
COUNT ==> CUENTA FILAS  ==> COUNT(*) || COUNT(numalumno)  || COUNT(distinct numalumno)
SUM	==> SUMA  ==> SUM(nombre_columna_dominio_numerico)
AVG ==> MEDIA ARITMÉTICA ==>  AVG(nombre_columna_dominio_numerico)
MAX ==> VALOR MÁXIMO ==>  MAX(nombre_columna_dominio_numerico)
MIN ==> VALOR MÍNIMO  ==>  MIN(nombre_columna_dominio_numerico)

ESTÁN ASOCIADAS A LA AGRUPACIÓN ==> CUANDO AGRUPAMOS, NORMALMENTE PRETENDEMOS
OBTENER UN RESULTADO ASOCIADO A DICHO CAMPO
***/
select count(numem), count(*), count(extelem), count(distinct extelem),
sum(numem), max(numem), min(numem), avg(numem)
from empleados;

select count(numem)
from empleados
where numde = 100;

/*Funciones de agregado con group by*/
select nomde, count(extelem), count(distinct extelem), (numem), sum(salarem), avg(salarem), max(salarem), min(salarem)
from empleados join departamentos on empleados.numde = departamentons.numde
group by empleados.numde;


/** Obtener el número de alumnos matriculados en cada materia  y la nota media de la materia **/

select materias.nommateria, count(*) as número_alumnos, avg(matriculas.nota) as nota_media,
	numexped
from materias join matriculas on materias.codmateria = matriculas.codmateria
group by materias.nommateria;

/** Obtener el número de alumnos matriculados en cada materia, la nota media de la materia 
	y el numero de expediente de los alumnos **/

/* OJO!! ESTA CONSULTA NO TIENE SENTIDO ==> DA ERROR 

CUANDO AGRUPAMOS SOLO PODEMOS OBTENER RESULTADOS PARA EL GRUPO, NUNCA PARA VALORES INDIVIDUALES
*/
select materias.nommateria, count(*) as número_alumnos, avg(matriculas.nota) as nota_media,
	numexped
from materias join matriculas on materias.codmateria = matriculas.codmateria
group by materias.nommateria;


/** obtener el número de preguntas de cada test */
select tests.descrip, count(*) as numeroPreguntas
from tests join preguntas on tests.codtest = preguntas.codtest
group by tests.descrip;



/** obtener el número de tests que ha realizado el alumno 1 */

select alumnos.numexped, count(distinct respuestas.codtest)
from alumnos join respuestas on alumnos.numexped = respuestas.numexped
where respuestas.numexped = 1
group by alumnos.numexped;

select * 
from respuestas
where numexped = 1;





/** para la base de datos empresaclase, obtener el numero de departamentos
que utilizan cada extensión telefónica */

use empresaclase;

select empleados.extelem, count(*), count(empleados.numde), count(distinct empleados.numde)
from empleados 
group by empleados.extelem;

/*** para comprobar ==>  */

select empleados.extelem as extension, numde as depto, numem as empleado
from empleados 
order by extelem;