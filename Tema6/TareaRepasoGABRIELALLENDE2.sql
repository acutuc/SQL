/*Obtener el número de alumnos matriculados en cada materia, la nota media de la materia
y el número de expediente con la nota más alta en la materia*/
SELECT  matriculas.codmateria as 'Código de la materia', count(matriculas.numexped) as 'Cantidad de alumnos matriculados', round(avg(matriculas.nota), 2)
		as 'Nota media de la materia', 
			(SELECT m.numexped
			FROM matriculas as m
            WHERE m.nota = max(matriculas.nota) AND m.codmateria = matriculas.codmateria) as 'Nota más alta'
FROM matriculas join materias on matriculas.codmateria= materias.codmateria
GROUP BY matriculas.codmateria;