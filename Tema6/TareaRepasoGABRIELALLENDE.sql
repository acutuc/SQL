/*Obtener el número de materias matriculadas de cada alumno/a*/

SELECT alumnos.numexped as 'Código del alumno', concat(alumnos.nomalum, ' ', alumnos.ape1alum, ' ', ifnull(alumnos.ape2alum, '')) as 'Nombre del alumno',
		count(materias.codmateria) as 'Número de materias'
FROM alumnos join matriculas on alumnos.numexped = matriculas.numexped
	join materias on matriculas.codmateria = materias.codmateria
GROUP BY alumnos.numexped;