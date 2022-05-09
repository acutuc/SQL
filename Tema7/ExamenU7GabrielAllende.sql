-- Exámen T7 Gabriel Allende.

use GBDgestionaTests;

delimiter $$
drop procedure if exists examenU7 $$
create procedure examenU7 (in curso char(6))
begin

	declare cursoMateria char(6) DEFAULT '0';
	declare nombreMateria, nombreMateriaAux, descripTest varchar(60) DEFAULT '';
    declare cantPreguntasTest, diasDesdePublicacion int DEFAULT 0;
    declare respuestaValida char(1) DEFAULT '0';
    declare fechaPublicacion datetime DEFAULT '1000-01-01';
    declare mediaPreguntas decimal(4,2) DEFAULT 0;
    declare mediaDiasPublicacion decimal(4,2) DEFAULT 0;
    
    declare primeraIteracion boolean default true;
    declare finalcursor boolean default false;
    
    declare cursorMaterias cursor for
						SELECT materias.cursomateria, materias.nommateria, tests.descrip, count(preguntas.resvalida), datediff(curdate(), tests.fecpublic)
						FROM materias JOIN tests on materias.codmateria = tests.codmateria JOIN preguntas on tests.codtest = preguntas.codtest
						GROUP BY materias.cursomateria, materias.nommateria, tests.descrip, datediff(curdate(), tests.fecpublic);
	
    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' 
				SET finalcursor = true;
    
    drop table if exists listado;
	create temporary table listado
		(descripcion varchar(200));
    
	open cursorMaterias;
    FETCH NEXT FROM cursorMaterias INTO cursoMateria, nombreMateria, descripTest, respuestaValida, fechaPublicacion;
    
    INSERT INTO listado 
        VALUES 
            (concat('MATERIAS DEL CURSO'), curso),
            ('--------------------------------------------------------------------------------------------------------------');
        
    while not finalcursor do
    begin
		if nombreMateria <> nombreMateriaAux then
        begin
			if primeraIteracion = false then
			begin
                set mediaPreguntas = count(preguntas.resvalida)/preguntas.resvalida;
                set mediaDiasPublicacion = fechaPublicacion/datediff(curdate(), tests.fecpublic);
			end;
			else
					set mediaPreguntas = 0;
                    set mediaDiasPublicacion = 0;
			end if;
			end;
				INSERT INTO listado 
					-- (descripcion) 
				VALUES
					('--------------------------------------------------------------------------------------------------------------'),
					(concat_ws(' ', 'Media de ', nombreMateriaAux, ':       ',mediaPreguntas), '            ', mediaDiasPublicacion),
					('--------------------------------------------------------------------------------------------------------------');
				set primeraIteracion = false;
                set mediaPreguntas = 0;
                set fechaPublicacion = '0';
                set nombreMateriaAux = nombreMateria;
            else
				set primeraIteracion = false;
			end if;
			INSERT INTO listado 
            -- (descripcion) 
			VALUES
				(concat('MATERIA: ', nombreMateria)),
                ('Test             Núm. preguntas test               días desde la publicación'),
				('--------------------------------------------------------------------------------------------------------------');
			set nombreMateriaAux = nombreMateria;
            
            
			INSERT INTO listado
			VALUES
				(concat(descripTest, '                 ', mediaPreguntas, '                     ', mediaDiasPublicacion));
                
                set descripTest = '';
                set mediaPreguntas = 0;
                set mediaDiasPublicacion = 0;
                FETCH NEXT FROM cursorMaterias INTO cursoMateria, nombreMateria, descripTest, respuestaValida, fechaPublicacion;
        end;
	end while;
	close cursorMaterias;
        set mediaPreguntas = count(preguntas.resvalida)/preguntas.resvalida;
		set mediaDiasPublicacion = fechaPublicacion/datediff(curdate(), tests.fecpublic);
		INSERT INTO listado 
		-- (descripcion) 
		VALUES
			('--------------------------------------------------------------------------------------------------------------'),
			(concat_ws(' ', 'Media de ', nomClienteAux, ' en ', mesVentaAux, ':       ',	
					sumCantVentas/numVentas), puntosRegalados),
			('--------------------------------------------------------------------------------------------------------------');
		SELECT *
        FROM listado
	end;
		SELECT CONCAT('No existen cursos en ', curso);
        
    drop table if exists listado;
end $$
delimiter ;

CALL examenU7 ('1ESO');