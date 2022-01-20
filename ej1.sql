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
    (numce int,
     nomce varchar(60) not null,
     dirce varchar(120),
    constraint pk_centros primary key (numce)
    );
create table if not exists deptos
    (numde int,
     numce int,
     nomde varchar(60) not null,
     presude decimal (10,2),
    constraint pk_deptos primary key (numde, numce),
    constraint fk_deptos_centros foreign key (numce)
        references centros(numce) 
            on delete no action on update cascade
    );
create table if not exists empleados
    (numem int,
     numde int,
     numce int,
     extelem char(3) null,
     fecnaem date null,
     fecinem date not null,
     salarem decimal (7,2),
     comisem decimal (4,2),
     numhiem tinyint unsigned,
     nomem varchar(20) not null,
     ape1em varchar(20) not null,
     ape2em varchar(20) null,
    constraint pk_empleados primary key (numem),
    constraint fk_empleados_deptos foreign key (numde, numce)
        references deptos (numde, numce)
            on delete no action on update cascade
    );
create table if not exists dirigir
    (numemdir int, -- wejfskjfsjkdf
     numde int,
     numce int,
     fecinidir date,
     fecfindir date null,
    constraint pk_dirigir primary key (numemdir, numde, numce, fecinidir),
    constraint fk_dirigir_empleados foreign key (numemdir)
        references empleados (numem) on delete no action on update cascade,
    constraint fk_dirigir_deptos foreign key (numde, numce)
        references deptos (numde, numce) on delete no action on update cascade
    );

/*  DESPUES DE EJECUTAR DESCUBRIMOS QUE NOS FALTA REPRESENTAR
    LA RELACIÓN DEP (deptos a deptos) */

    ALTER TABLE deptos
        add column deptodepen int,
        add column centrodepen int,
        add constraint fk_deptos_deptos foreign key (deptodepen, centrodepen)
            references deptos (numde, numce)
                on delete no action on update cascade;