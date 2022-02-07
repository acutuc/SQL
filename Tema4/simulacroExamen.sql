/*ESQUEMA RELACIONAL:

categorias (pk(codcat), nomcat)
articulos (pk(codart), nomart, codcat*, preciobase, precioventa)
eventos (pk(codeven), nomeven)
promociones (pk(codpromo, codeven*), fecinipromo, fecfinpromo,nompromocion)
tiendas (pk(codtienda),nomtienda)
franquicias (pk(codfranquicia), direccion, codtienda*)
propias (pk(codpropia), direccion, codtienda*)
catalogospromos (pk([codpromo,codeven]*, codarticulo*), precioartpromo)
promocionentienda (pk([codpromo, codeven]*, codtienda*), observaciones)
*/
-- b) Genera el código para la implementación del esquema relacional anterior en MySQL Server:
/********************************************************/
create database if not exists promociones;
use promociones;

drop table if exists categorias;
create table if not exists categorias
(
	codcat int,
    descat varchar(30),
    constraint pk_categorias primary key (codcat)
);
drop table if exists articulos;
create table if not exists articulos
(
	codart int,
    codcat int,
    desart varchar(30),
    preciobase decimal (5,2),
    precioventa decimal (5,2),
    constraint pk_articulos primary key (codart),
    constraint fk_articulos_categorias foreign key (codcat) references categorias (codcat)
		on delete no action on update cascade
);

drop table if exists eventos;
create table if not exists eventos
(
	codevento int,
    desevento varchar(30),
    constraint pk_eventos primary key (codevento)
);

drop table if exists promociones;
create table if not exists promociones
(
	codpromo int,
    codevento int,
    nompromo varchar(30),
    fecinipromo date,
    duracion tinyint unsigned,
    constraint pk_promociones primary key (codpromo, codevento),
    constraint fk_promociones_eventos foreign key (codevento) references eventos (codevento)
		on delete no action on update no action -- último punto de los requisitos
);

drop table if exists catalogopromos;
create table if not exists catalogopromos
(
	codpromo int,
    codevento int,
    codarticulo int,
    precioenpromo decimal(5,2),
    constraint pk_catalogospromos primary key (codpromo, codevento, codarticulo),
    constraint fk_catalogospromos_articulos foreign key (codarticulo) references articulos (codart)
		on delete no action on update cascade,
	constraint fk_catalogospromos_promociones foreign key (codpromo, codevento) references promociones (codpromo, codevento)
		on delete no action on update cascade
);


/*** OPCIÓN C PARA JERARQUÍAS ***/

drop table if exists tiendas;
create table if not exists tiendas
(
    codtienda int,
    nomtienda int,
    tipotienda enum('P,F'), -- char(1), -- atributo discriminador. Tomará el valor f para franquicia o p para propia. Habrá que implementar un trigger asociado
    dirfranquicia varchar(100), 
    nifpropia char(15),   
    constraint pk_tiendas primary key (codtienda)
);

/*** FIN OPCIÓN C PARA JERARQUÍAS ***/

/*** OPCIÓN A PARA JERARQUÍAS ***/

drop table if exists tiendas;
create table if not exists tiendas
(
	codtienda int,
    nomtienda int,
    constraint pk_tiendas primary key (codtienda)
);

drop table if exists franquicias;
create table if not exists franquicias
(
	codfranquicia int,
    codtienda int,
    dirfranquicia varchar(100),
    constraint pk_franquicias primary key (codfranquicia),
    constraint fk_franquicias_tiendas foreign key (codtienda) references tiendas (codtienda)
		on delete cascade on update cascade -- penúltimo punto de los requisitos
);

drop table if exists propias;
create table if not exists propias
(
	codpropia int,
    codtienda int,
    nifpropia char(15),
    constraint pk_propias primary key (codpropia),
    constraint fk_propias_tiendas foreign key (codtienda) references tiendas (codtienda)
		on delete cascade on update cascade -- penúltimo punto de los requisitos
);

/*** FIN OPCIÓN A PARA JERARQUÍAS ***/


drop table if exists promosentiendas;
create table if not exists promosentiendas -- relación "se aplica a"
(
	codpromo int,
    codevento int,
    codtienda int,
    observaciones text,
    constraint pk_promosentiendas primary key (codpromo, codevento, codtienda),
    constraint fk_promosentiendas_tiendas foreign key (codtienda) references tiendas (codtienda)
		on delete no action on update cascade,
	constraint fk_promosentiendas_promociones foreign key (codpromo, codevento) references promociones (codpromo, codevento)
		on delete no action on update cascade
);


/*****************************************/

/***MODIFICAR RELACIÓN N:M POR DOS RELACIONES 1:n**/


alter table catalogopromos
    drop primary key,
	add column codcatalogopromos int not null auto_increment,
    
    add constraint pk_catalogopromos primary key (codcatalogopromos);
    
    
/* MODIFICAR LA RELACIÓN DÉBIL ==> YA NO ES DÉBIL *****/

-- ELIMINAR LA PRIMARY KEY DE PROMOCIONES. PARA ELLO:
-- ELIMINAR LA FORE3IGN KEY FK_CATALOGOSPROMOS_PROMOCIONES
-- ELIMIAR LA PRIMARY KEY DE PROMOCIONES
-- AÑADIR LA PRIMARI KEY DE PROMOCIONES
-- AÑADIR LA FOREIGN KEY DE FK_CATALOGOSPROMOS_PROMOCIONES

/* SI LA TABLA EVENTOS DESAPARECE */

-- ELIMINAR LA FOREIGN KEY FK_PROMOPIONES_EVENTOS
 -- ELIMINAR LA PRIMARY KEY DE PROMOCIONES. PARA ELLO:
-- ELIMINAR LA FORE3IGN KEY FK_CATALOGOSPROMOS_PROMOCIONES

-- ELIMIAR LA PRIMARY KEY DE PROMOCIONES

-- AÑADIR LA PRIMARI KEY DE PROMOCIONES
-- AÑADIR LA FOREIGN KEY DE FK_CATALOGOSPROMOS_PROMOCIONES
-- DROP COLUMNA codevento
-- eliminar tabla eventos