/**Obtener el número de preguntas de cada test.*/
SELECT preguntas.codtest as 'Test', count(preguntas.numpreg) as 'Cantidad Preguntas'
FROM preguntas
GROUP BY preguntas.codtest