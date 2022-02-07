create database ejpizarra;
use ejpizarra; 

/*comentario ajajajajajj
sigue siendo comentario
cierro comentario*/

-- comentario en una sola línea

create table tabla1
(
	codt1 int not null,
    dest1 varchar(20) not null default 'descripcion de campo',
    constraint pk_tabla1 primary key (codt1)
);

create table tabla2
(
	codt2 int not null,
    dest2 varchar(20) not null default 'descripcion de campo',
    codt1 int null, 
    constraint pk_tabla2 primary key (codt2),
    constraint fk_tabla2_tabla1 foreign key (codt1) references tabla1 (codt1)
    /*no action no permite borrar un campo de una tabla que pertenece a otra
    cascade permite borrar el campo de una tabla que pertenezca a otra, a la que también lo borraría
    set null permite borrar un campo de una tabla que pertenezca a otra, y en la segunda lo pondría a null*/
		on delete no action on update cascade    -- esto viene asi por defecto si no lo escribiese
);

create table tabla3
(
	codt1 int not null,
    codt2 int not null,
    fechaRel2 date,
    constraint pk_tabla3 primary key (codt1, codt2),
    constraint fk_tabla3_tabla1 foreign key (codt1) references tabla1 (codt1)
		on delete no action on update cascade,
	constraint fk_tabla3_tabla2 foreign key (codt2) references tabla2 (codt2)
		on delete no action on update cascade
);