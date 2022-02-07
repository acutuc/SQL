create database if not exists ej3;
use ej3;
create table if not exists productos
    (refprod int,
     desprod varchar(60),
     preciobase decimal (10,2),
     precioventa decimal (10,2),
    constraint pk_productos primary key (refprod)
    );
create table if not exists ventas
    (codventa int,
     fecventa date,
     cliente varchar(60),
    constraint pk_ventas primary key (codventa)
    );
create table if not exists ln_ventas
    (codventa int,
     refprod int,
     cantidad int,
    constraint pk_ln_ventas primary key (codventa, refprod),
    constraint fk_ln_ventas_ventas foreign key (codventa)
        references ventas (codventa) on delete no action on update cascade,
    constraint fk_ln_ventas_productos foreign key (refprod)
        references productos (refprod) on delete no action on update cascade
    );

create table categorias
(codcat int,
 nomcat varchar(20),
 descripcion varchar(100),
 constraint pk_categorias primary key (codcat)
);

alter table productos
	add column codcat int after refprod,
	add constraint fk_prod_categorias foreign key (codcat)
		references categorias(codcat) 
			on delete no action on update cascade;

alter table ln_ventas
	drop constraint fk_ln_ventas_productos;

alter table productos
	drop primary key,
    add constraint pk_productos primary key(refprod,codcat);

alter table ln_ventas
 	add column codcat int,
    drop index fk_ln_ventas_productos,
	add constraint fk_lnventas_productos foreign key (refprod, codcat)	
 		references productos (refprod, codcat)
 			on delete no action on update cascade,
	drop constraint fk_ln_ventas_ventas,
    
    drop primary key,
	add constraint pk_ln_ventas primary key (refprod, codcat, codventa),
    add constraint fk_lnventas_ventas foreign key (codventa)	
		references ventas (codventa)
			on delete no action on update cascade;


/** MAS EJEMPLOS DE MODIFICACIÓN DE DATOS: */
alter table productos
	drop column preciobase,
	drop column precioventa;
alter table productos
	add column precio decimal(10,2);

alter table productos
	add column preciobase decimal(10,2) after desprod,
	change column precio precioventa decimal(10,2)
		after preciobase;

alter table ln_ventas
	add column precioventa decimal(10,2);

create table historicoprecios
	(codproducto int,
	fechacambio date,
	preciobaseanterior decimal(10,2),
	constraint pk_historicoprecios primary key 
		(codproducto, fechacambio),
	constraint fk_historicoprecios_productos foreign key 
		(codproducto) references productos(refprod)
			on delete cascade on update cascade);

