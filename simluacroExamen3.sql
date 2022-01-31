/*
empleados(PK(codempleado), nomempleado)
	cuidadores(PK(codcuidador),codemple*, descripcion)
	veterinarios(PK(codveter),codemple*, especialidad)
zonas (PK(codzona), nomzona)
recintos(PK(codrecinto, codzona), nomrecinto, codcuidador*)
ejemplares(PK(codejem), nomejem, clase, alimentacion, codveter*, codpadre*,codmadre*)
localizacionEjemplares(PK(coejem,[codrecinto,codzona]*),feciniestancia,fecfinestancia,observaciones)

*/

create database zoologico;
use zoologico;

create table if not exists empleados
(
	codempleado int,
    nomempleado varchar(30),
    ape1empleado varchar(20),
    ape2empleado varchar(20),
    constraint pk_empleados primary key (codempleado)
);

create table if not exists cuidadores
(
	codcuidador int,
    codemple int,
    descripcion varchar(200),
    constraint pk_cuidadores primary key (codcuidador),
    constraint fk_cuidadores_empleados foreign key (codempleado)
		references empleados(codempleado)
			on delete no action on update cascade
);

create table if not exists veterinarios
(
	codveter int,
    codemple int,
    especialidad varchar(30),
    constraint pk_veterinarios primary key (codveter),
    constraint fk_veterinarios_empleados foreign key (codempleado)
		references empleados(codempleado)
			on delete no action on update cascade
);

create table if not exists zonas
(
	codzona int,
    nomzona varchar(30),
    constraint pk_zonas primary key (codzona)
);

create table if not exists recintos
(
	codrecinto int,
    codzona int,
    nomrecinto varchar(20),
    codcuidador int,
    constraint pk_recintos primary key (codrecinto, codzona),
    constraint fk_recintos_zonas foreign key (codzona)
		references zonas(codzona)
			on delete no action on update cascade,
    constraint fk_recintos_cuidadores foreign key (codcuidador)
		references cuidadores(codcuidador)
			on delete no action on update cascade
);

create table if not exists ejemplares
(
	codejem int,
    nomejem varchar(20),
    clase enum('Peces', 'Anfibios', 'Reptiles', 'Aves', 'Mamíferos'),
    alimentacion set('H', 'C', 'I', 'F'),
    codveter int,
    codpadre int,
    codmadre int,
    constraint pk_ejemplares primary key (codejem),
    constraint nombre_unico unique (nomejem),
    constraint fk_ejemplares_veterinarios foreign key (codveter)
		references veterinarios(codveter)
			on delete no action on update cascade,
	constraint fk_ejemplares_ejempadre foreign key (codpadre)
		references ejemplares(codejem)
			on delete no action on update cascade,
	constraint fk_ejemplares_ejemmadre foreign key (codmadre)
		references ejemplares(codejem)
			on delete no action on update cascade
);

create table if not exists localizacionEjemplares
(
	codejem int,
    codrecinto int,
    codzona int,
    feciniestancia date,
    fecfinestancia date,
    observaciones varchar(100),
    constraint pk_localizacionEjemplares primary key (codejem, codrecinto, codzona, feciniestancia),
    constraint fk_localizacionEjemplares_ejemplares foreign key (codejem)
		references ejemplares(codejem)
			on delete no action on update no action, -- PEDIDO EN EL ENUNCIADO
	constraint fk_localizacionEjemplares_recintos foreign key (codrecinto, codzona)
		references recintos(codrecinto, codzona)
			on delete no action on update cascade
);

/* MODIFICACIÓN DE LA ESTRUCTURA */
/*P2.1*/
alter table empleados
	add column salarem decimal(6,2) unsigned not null default 900;

/*P2.2*/
alter table ejemplares
	add column edadejem tinyint unsigned,
    add column fecnacimejem datetime;
    
/*P2.3*/
alter table localizacionEjemplares
	drop foreign key fk_localizacionEjemplares_ejemplares,
	drop foreign key fk_localizacionEjemplares_recintos,
    drop primary key,
    add column codlocalizacion int auto_increment,
    add constraint pk_localizacionEjemplares_new primary key (codlocalizacion),
    add constraint fk_localizacionEjemplares_new_ejemplares_new foreign key (codejem)
		references ejemplares(codejem)
			on delete no action on update no action, -- PEDIDO EN EL ENUNCIADO
	add constraint fk_localizacionEjemplares_recintos_new foreign key (codrecinto, codzona)
		references recintos(codrecinto, codzona)
			on delete no action on update cascade