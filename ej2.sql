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

DEPTOS:
numdepto
presupuesto
nomdepto
ubicacion

ASIGNATURAS:
numasigna
nomasigna
curso

IMPARTEN:
anioacad
grupo
*/
create database ej2;
use ej2;

create table if not exists profesores
(
numprof int not null,
despacho int,
fecnacim date,
fecingreso date,
sueldo decimal(6,2),
nomprof varchar(70),
	constraint pk_numprof primary key (numprof)
);

create table if not exists deptos
(
numdepto int not null,
presupuesto decimal(7,2),
nomdepto varchar(20),
ubicacion varchar(50),
);

/*
create table if not exists asignaturas
(
numasig int,
nomasig varchar(20),
cursoasig char(5),
	constraint pk_asignaturas primary key (numasig)
);

create table if not exists profesores
(
numprof int,
numde int,
despacho int,
fecnacim date null,
fecingreso date,
sueldo decimal(6,2),
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

create table if not exists deptos
(
numdepto int,
presupuesto decimal(10,2),
nomdepto varchar(60),
ubicacion char(4),
	constraint pk_deptos primary key (numde)
);

create table if not exists impartir
(
numprof int,
numasig int,
anioacad char(9),
grupo char(5),
	constraint pk_impartir primary key (numprof, numasig, anioacad),
    constraint fk_impartir_profesores foreign key (numprof)
		references profesores (numprof) on delete no action on update cascade,
	contraint fk_impartir_asignaturas foreign key (numasig)
		references asignaturas (numasig) on delete no action on update cascade
);
*/