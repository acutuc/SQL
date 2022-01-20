create database if not exists ejmuseo;
use ejmuseo;

/*ESQUEMA RELACIONAL:
en la relacion 1-N en el lado de la N va como clave foránea la clave primaria del lado 1.
en la relacion N-M van como clave foránea las claves primarias de las dos tablas relacionadas.
en una jerarquía disjunta, los hijos pueden ser UNA u OTRA cosa, nunca los dos a la vez.
*/

create table if not exists artistas
    (codartista int unsigned, -- int(4)
     nomartista varchar(60),
     biografia text,
	 edad tinyint unsigned, -- int(1)
	 fecnacim date,
    constraint pk_artistas primary key (codartista)
    );
create table if not exists tipobras
    (codtipobra int unsigned,
     destipobra varchar(20),
    constraint pk_tipobras primary key (codtipobra)
    );
create table if not exists estilos
    (codestilo int unsigned,
     nomestilo varchar(20),
     desestilo varchar(250),
    constraint pk_estilos primary key (codestilo)
    );

create table if not exists salas
    (codsala int unsigned,
     nomsala varchar(20),
    constraint pk_salas primary key (codsala)
    );

create table if not exists obras
    (codobra int unsigned,
     nomobra varchar(20),
     desobra varchar(100),
     feccreacion date null,
     fecadquisicion date null,
     valoracion decimal (12,2) unsigned,
     codestilo int unsigned,
     codtipobra int unsigned,
     codubicacion int unsigned, -- sala en la que está
    constraint pk_obras primary key (codobra),
    constraint fk_obras_tipobras foreign key (codtipobra)
        references tipobras(codtipobra) 
        on delete no action on update cascade,
    constraint fk_obras_estilos  foreign key (codestilo)
        references estilos(codestilo) 
        on delete no action on update cascade,
    constraint fk_obras_salas foreign key (codubicacion)
        references salas(codsala) 
        on delete no action on update cascade
    );
alter table obras add column codartista int unsigned,
	add constraint fk_obras_artistas foreign key (codartista)
		references artistas(codartista) 
        on delete no action on update cascade;
create table if not exists empleados
    (codemple int unsigned,
     nomemle varchar(20),
     ape1emple varchar(20),
     ape2emple varchar(20) null,
     fecincorp date,
	 tlfempleado char(12),
     numsegsoc char(15),
    constraint pk_empleados primary key (codemple)
    );
create table if not exists seguridad
    (codsegur int unsigned,
     codemple int unsigned,
	 codsala int unsigned,
     observaciones varchar(200),
    constraint pk_seguridad primary key (codsegur),
    constraint fk_seguridad_empleados foreign key (codemple)
        references empleados (codemple) on delete no action on update cascade,
	constraint fk_seguridad_salas foreign key (codsala)
        references salas (codsala) on delete no action on update cascade
    );
create table if not exists restauradores
    (codrestaurador int unsigned,
     codemple int unsigned,
     especialidad varchar(60),
    constraint pk_restauradores primary key (codrestaurador),
    constraint fk_restauradores_empleados foreign key (codemple)
        references empleados (codemple) on delete no action on update cascade
    );
drop table if exists restauraciones;
create table if not exists restauraciones
    (codrestaurador int unsigned,
     codobra int unsigned,
     fecinirestauracion date,
     fecfinrestauracion date null,
	 observaciones text,
    constraint pk_restauraciones primary key 
		(codrestaurador,codobra, fecinirestauracion),
    constraint fk_restestilosestilosauraciones_restauradores foreign key (codrestaurador)
        references restauradores (codrestaurador) on delete no action on update cascade,
    constraint fk_restauraciones_obras foreign key (codobra)
        references obras (codobra) on delete no action on update cascade
    
    );

/* HACER EL DIAGRAMA DESDE LA VENTANA PRINCIPAL DE WORKBENCH
    DATA - MODELING - CREATE EER MODEL FROM EXISTING DATABASE */

/* APARTADO A ==> VAMOS A CAMBIAR LA RELACIÓN VIGILAN
POR UNA RELACIÓN N:M:P ==>
	GUARDAREMOS EL CÓDIGO DE SALA, EL CÓDIGO DE EMEA
	DO DE SEGURIDAD Y EL CÓDIGO DE TURNO (TENDREMOS
	UNA NUEVA TABLA DE TURNOS (codturno, descripcion, horaini, horafin)
	SABREMOS LA FECHA INICIO Y FECHA FIN DE VIGILANCIA
*/

create table turnos
	(codturno int unsigned,
	 descripcion varchar(80),
	 horaini time,
	 horafin time,
	 constraint pk_turnos primary key
		(codturno)
	);


create table vigilar
(
	codsala int unsigned,
	codsegur int unsigned,
	codturno int unsigned,
	fecini	date,
	fecfin date,
	constraint pk_vigilar primary key
		(codsala, codsegur,codturno,fecini),
	constraint fk_vigilar_seguridad 
		foreign key (codsegur)
        references seguridad (codsegur) 
		on delete no action on update cascade,
    constraint fk_vigilar_salas foreign key (codsala)
        references salas (codsala) 
		on delete no action on update cascade,
	constraint fk_vigilar_turnos foreign key (codturno)
        references turnos (codturno) 
		on delete no action on update cascade
);

/* inserción de datos ==> pendiente hasta unidad 4*/

alter table seguridad
	drop foreign key fk_seguridad_sala,
	drop column codsala;

/* APARTADO B ==> CAMBIAR EL NOMBRE DE UNA CLAVE 
   FORANEA: CONSULTA EJERCICIO_5_1_2 */

alter table restauradores
	drop foreign key fk_restauradores_empleados,
	add constraint fk_restaurador_emple foreign key (codemple)
        references empleados (codemple) on delete no action on update cascade;



/* APARTADO C ==> PROPUESTO EN CLASE */
/* LOS EMPLEADOS PERTENECEN A UN DEPTO */

create table deptos
	(numdepto int,
	 nomdepto varchar(20),
	 constraint pk_deptos primary key (numdepto)
	);

alter table empleados
	add column numdepto int,
	add constraint fk_empleados_deptos 
		foreign key (numdepto) references deptos(numdepto) on delete no action
			on update cascade;
            

/*** CAMBIOS EN FOREIGN KEY  ****/

/* A. Queremos que si se elimina un empleado, 
	  se elimine el 
	  restaurador/vigilante relacionado
*/

alter table restauradores
	drop foreign key fk_restaurador_emple,
	add constraint fk_restauradores_empleados 
		foreign key (codemple) references empleados (codemple) 
			on delete cascade on update cascade;

alter table seguridad
	drop foreign key fk_restauradores_seguridad,
	add constraint fk_restauradores_seguridad 
		foreign key (codemple) references empleados (codemple) 
			on delete cascade on update cascade;


/* B. No vamos a permitir que se modifique 
	el código de estilo
	  de una obra, en todo caso se le asignará el valor nulo
*/


alter table obras
 	 -- drop foreign key fk_obras_estilos_new,
	drop foreign key fk_obras_estilos,
	add constraint fk_obras_estilos foreign key (codestilo)
		references estilos(codestilo)
		on delete no action
		on update SET NULL;

/* C. Vamos a permitir que se eliminen artistas, en este caso
	  las obras se quedarán sin autor
*/

alter table obras
	drop foreign key fk_obras_artistas,
	add constraint fk_obras_artistas foreign key (codartista)
		references artistas(codartista)
			on delete set null on update cascade;

/* D. Vamos a permitir que se eliminen artistas, en este caso
	  las obras se quedarán sin autor, pero, una vez que demos
	de alta una obra, el código de artista no podrá cambiar
*/

alter table obras
	drop foreign key fk_obras_artistas,
	add constraint fk_obras_artistas foreign key (codartista)
		references artistas(codartista)
			on delete set null on update no action;

