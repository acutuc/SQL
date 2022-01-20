create database if not exists ejmuseo;
use ejmuseo;

/*ESQUEMA RELACIONAL:
en la relacion 1-N en el lado de la N va como clave foránea la clave primaria del lado 1.
en la relacion N-M van como clave foránea las claves primarias de las dos tablas relacionadas.
en una jerarquía disjunta, los hijos pueden ser UNA u OTRA cosa, nunca los dos a la vez.
*/

create table if not exists artistas
(
codartista int unsigned,
nomartista varchar(60),
biografia text,
edad tinyint unsigned,
fecnacim date,
constraint pk_artistas primary key(codartista)
);

create table if not exists tipoobras
(
codtipoobra int unsigned,
destipoobra varchar(20),
constraint pk_tipoobras primary key (codtipoobra)
);

create table if not exists estilo
(
codestilo int unsigned,

);

create table if not exists salas
(
codsala int unsigned,
nomsala varchar(20),
constraint pk_salas primary key (codsala)
);

create table if not exists obras
(
codobra int unsigned,
nomobra varchar(20),
desobra varchar(100),
feccreacion date null,
fecadquisicion date null,
valoracion decimal (12,2) unsigned,
codestilo int unsigned,
codtipoobra int unsigned,
codubicacion int unsigned, -- sala en la que se encuentra
constraint pk_obras primary key (codobra),
constraint fk_obras_tipoobras foreign key (
);