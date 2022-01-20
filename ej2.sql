/*Dado el siguiente diagrama E/R, obtener el Esquema Relacional correspondiente e implementarlo
en el SGBD MySQL Server.
La base de datos que se quiere desarrollar servirá para gestionar los datos de una UNIVERSIDAD./*
/*
PROFESORES:
numprof
despacho
fecnacim
fecingreso
sueldo
nomprof
ape1prof
ape2prof

DEPTOS:
numdepto
presupuesto
nomdepto
ubicacion

ASIGNATURAS:
numasig
nomasig
cursoasig

IMPARTEN:
anioacad
grupo
*/
create database ej2;
use ej2;

create table if not exists asignaturas
    (numasig int,
     nomasig varchar(20),
     cursoasig char(5),
     constraint pk_asignaturas primary key (numasig)
    );
create table if not exists deptos
    (numde int,
     nomde varchar(60),
     presude decimal (10,2),
     ubicado char(4),
    constraint pk_deptos primary key (numde)
    );
create table if not exists profesores
    (numprof int,
     numde int,
     fecnaprof date null,
     fecinprof date,
     sueldoprof decimal (7,2),
     nomprof varchar(20),
     ape1prof varchar(20),
     ape2prof varchar(20) null,
     numjefe int,
    constraint pk_profesores primary key (numprof),
    constraint fk_profesores_deptos foreign key (numde)
        references deptos (numde)
            on delete no action on update cascade,
    constraint fk_profesores_profesores foreign key (numjefe)
        references profesores (numprof)
            on delete no action on update cascade
    );
create table if not exists impartir
    (numprof int,
     numasig int,
     anioacad char(9),
     grupo char(5),
    constraint pk_impartir primary key (numprof, numasig,anioacad),
    constraint fk_impartir_profesores foreign key (numprof)
        references profesores (numprof) on delete no action on update cascade,
    constraint fk_impartir_asignaturas foreign key (numasig)
        references asignaturas (numasig) on delete no action on update cascade
    );
/* ejemplo de clase==> ¿y si no me hubiera dado cuenta de que el año académico forma parte de la clave y lo quiero añadir?
 eliminamos la tabla y la creamos con esas caracterísitcas para hacerlo:*/
drop table if exists impartir;
create table if not exists impartir
    (numprof int,
     numasig int,
     anioacad char(9),
     grupo char(5),
    constraint pk_impartir primary key (numprof, numasig),
    constraint fk_impartir_profesores foreign key (numprof)
        references profesores (numprof) on delete no action on update cascade,
    constraint fk_impartir_asignaturas foreign key (numasig)
        references asignaturas (numasig) on delete no action on update cascade
    );
-- Ahora modificamos la restricción de clave primaria: (eliminamos y la volvemos a crear)
alter table impartir
		drop primary key,
        add constraint pk_impartir primary key (numprof, numasig, anioacad);