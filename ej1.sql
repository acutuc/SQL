create database ej1;
use ej1;

/*
ESQUEMA RELACIONAL:
centros (pk(numce), nomce, dirce)
deptos(pk(numce*, numde), presupuesto, [deptodepen, centrodepen]*)
empleados(pk(numem), extelefon, fecnacim, fecingreso, salario, comision, numhijos, nombemp, [numce, numde]*)
dirigir(pk(numem*, [numce, numde]*, fecinidir), fecfindir)
*/

create table if not exists centros
(
numce int not null
nomce varchar(30) not null,
dirce varchar(200) not null,
	constraint pk_numce primary key (numce)
);

create table if not exists  deptos
(
numce int not null,
numde int not null,
presupuesto decimal(8,2) not null,
deptodepen int not null,
centrodepen int not null,
	constraint pk_numce_numde primary key (numce, numde)
);

create table if not exists  empleados
(
numem int not null,
extelefon int,
fecnacim date,
fecingreso date,
salario decimal(6,2) not null,
comision decimal(6,2),
numhijos int,
nombemp varchar(100) not null,
numce int not null,
numde int not null,
	constraint pk_numem primary key (numem)
);

create table if not exists  dirigir
(
numem int not null,
numce int not null,
numde int not null,
fecinidir date not null,
fecfindir date not null,

pk(numem*, [numce, numde]*, fecinidir), fecfinidir)
);

/*
create table if not exists centros
(
numce int,
nomce varchar(60) not null,
dirce varchar(120),
	constraint pk_centros primary key (numce)
);

create table if not exists  deptos
(
numde int,
numce int,
nomde varchar(60) not null,
presude decimal(10,2),
	constraint pk_deptos primary key (numde, numce),
	constraint fk_deptos_centros foreign key (numce)
		references centros(numce)
			on delete no action on update cascade
);

create table if not exists  empleados
(
numem int,
numce int,
numde int ,
extelefon char(3) null,
fecnacim date null,
fecingreso date not null,
salario decimal(7,2),
comision decimal(4,2),
numhijos tinyint unsigned,
nombemp varchar(20) not null,
ape1 varchar(20) not null,
ape2 varchar(20) null,
	constraint
);

create table if not exists dirigir
	numem int,
    numde int,
    numce int,
    fecinidir date,
    fecfindir date,
    pk(numem*, [numce, numde]*, fecinidir), fecfindir)
*/