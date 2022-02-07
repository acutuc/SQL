/*** P1. ESQUEMA RELACIONAL */
/*
sujetos (PK(codsujeto), nomsujeto, ape1sujeto,ape2sujeto,dni,dirpostal,email,tlfcontacto)
clientela(PK(codcli), codsujeto*, estadocivil)
abogados(PK(codabogado), codsujeto*,numcolegiado)
tiposcasos(PK(cottipocaso),desTipoCaso)
casos(PK(codcaso,codtipocaso*),descaso,codcli*,presupuesto)
AbogadosenCasos(PK[[codcaso,codtipocaso]*,codabogado,fecinicio], numdias)
*/

/** P2. IMPLEMENTACIÓN EN MYSQOL **/

create database bufete_exam_u4_2021_g1;
use bufete_exam_u4_2021_g1;
-- sujetos (PK(codsujeto), nomsujeto, ape1sujeto,ape2sujeto,dni,dirpostal,email,tlfcontacto)
create table sujetos
(
	codsujeto int,
    nomsujeto varchar(20),
    ape1sujeto varchar(20),
    ape2sujeto varchar(20),
    dni char(9),
    dirpostal varchar(100),
    email varchar(50), -- unique,
    constraint pk_sujetos primary key (codsujeto),
    constraint email_unico unique (email)
);
-- clientela(PK(codcli), codsujeto*, estadocivil)
create table clientela
(
	codcli int,
    codsujeto int,
    estadocivil enum('S','C','D','V'),
    constraint pk_clientela primary key (codcli),
    constraint fk_clientela_sujetos foreign key (codsujeto) references sujetos(codsujeto)
		on delete no action on update cascade
);
-- abogados(PK(codabogado), codsujeto*,numcolegiado)
create table abogados
(
	codabogado int,
    codsujeto int,
    numcolegiado char(8),
    constraint pk_abogados primary key (codabogado),
    constraint fk_abogados_sujetos foreign key (codsujeto) references sujetos(codsujeto)
		on delete no action on update no action -- pedido en el enunciado
);
-- tiposcasos(PK(cottipocaso),desTipoCaso)
 create table tiposcasos
(
	codtipocaso int,
    destipocaso varchar(40),
	constraint pk_tiposcasos primary key (codtipocaso)
);
-- casos(PK(codcaso,codtipocaso*),descaso,codcli*,presupuesto)
create table casos
(
	codcaso int,
    codtipocaso int,
    descaso varchar(200),
    codcli int,
    presupuesto double(7,2) unsigned,
	constraint pk_casos primary key (codcaso,codtipocaso),
    constraint fk_casos_tiposcasos foreign key (codtipocaso) references tiposcasos(codtipocaso)
		on delete no action on update cascade,
	constraint fk_casos_clientela foreign key (codcli) references clientela(codcli)
		on delete cascade on update cascade -- pedido en el enunciado
);
-- abogadosenCasos(PK[[codcaso,codtipocaso]*,codabogado,fecinicio], numdias)

create table abogadosencasos
(
	codcaso int,
    codtipocaso int,
    codabogado int,
    fecinicio date,
    numdias tinyint unsigned, -- también int(1) unsigned
	constraint pk_abogadosencasos primary key (codcaso,codtipocaso,codabogado, fecinicio),
    constraint fk_abogadosencasos_casos foreign key (codcaso,codtipocaso) references casos(codcaso,codtipocaso)
		on delete no action on update cascade,
	constraint fk_abogadosencasos_abogado foreign key (codabogado) references abogados(codabogado)
		on delete no action on update cascade 
);

/** P3. MODIFICACIÓN DE ESTRUCTURA **/

/** TENEMOS QUE ELIMINAR LA TABLA TIPOSCASOS, PARA ELLO HAY QUE HACER PRIMERO LO SIGUIENTE */

alter table abogadosencasos
	drop foreign key fk_abogadosencasos_casos,
    drop primary key;

alter table casos
 	drop primary key,
    add column tipocaso set('Civil','Penal', 'Laboral','Admin', 'Familia') after codcaso,
    drop foreign key fk_casos_tiposcasos;
    
-- Actualización de datos en casos y abogadosen casos: (PENDIENTE HASTA UNIDAD 6-7 )
-- 1. que no se repita la primary key nueva que será solo codcaso
-- 2. Asignación a la nueva columna tipocaso con los tipos de casos de la tabla tiposCaso
-- 3. Actualización en abogadosencasos con el nuevo codcaso que hemos hecho en 1.

drop table tiposcasos;
alter table casos
	drop column codtipocaso,
    add constraint pk_casos_new primary key (codcaso);
    
alter table abogadosencasos
	add constraint pk_abogadosencasos_new primary key (codcaso,codabogado,fecinicio),
    add constraint fk_abogadosencasos_casos_new foreign key (codcaso) references casos(codcaso)
		on delete no action on update cascade,
    drop column codtipocaso;