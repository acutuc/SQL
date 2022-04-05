use GBDgestionaTests;

/*1. Obtener el número de alumnos matriculados en cada materia y la nota media de la materia*/
SELECT materias.nommateria as 'Materia', count(alumnos.numexped) as 'Cantidad de alumnos', round(avg(matriculas.nota),2) as 'Nota media'
FROM alumnos join matriculas on alumnos.numexped = matriculas.numexped
	join materias on matriculas.codmateria = materias.codmateria
GROUP BY materias.nommateria;