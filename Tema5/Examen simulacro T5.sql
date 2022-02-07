/*Graba la reserva que el cliente 520 ha hecho hoy con nosotros: ha reservado la casa 315 desde el 5 de agosto y durante una semana.
Ha pagado  a cuenta 100€. Sabemos que hay 3500 reservas en nuestra base de datos.*/
-- P1.
insert into reservas
(codreserva, codcliente, codcasa, fecreserva, pagocuenta, feciniestancia, numdiaestancia)
values
(3501, 520, 315, '2021/2/7', 100, '2021/8/5', 7)

/*La casa 350 ha estado de reformas, se ha incorporado una barbacoa (característica 17),
A/A (característica 3) y calefacción (característica 5).*/
-- P2.
update caracteristicasdecasas
set tiene = 1
where codcasa = 350 and {codcaracter = 17 or codcaracter = 3 or codcaracter = 5};

/*Hoy han anulado la reserva 2450, como se han cumplido los plazos, se ha procedido a devolver el pago a cuenta que eran 200€.
(Suponed que hay 225 devoluciones)*/
-- P3.
start transaction
update reservas
set fecanulacion = '2022/2/07' -- curdate() DEVUELVE HORA ACTUAL
where codreserva = 2450;

insert into devoluciones
(numdevol, codreserva, importedevol)
values
(226, 2450, 200);
commit;

/*Hace unos días dimos de alta al propietario 520 con dos casas que dimos de alta como la 5640 y 5641.
Por un desacuerdo de dicho propietario con nuestra empresa,
este ha decidido darse de baja de nuestra plataforma y no quiere que mantengamos sus datos.
Haz las operaciones oportunas y explica en que circunstancias podemos hacer esto.*/
-- P4.
-- Si estuviese on delete cascade, se podría borrar todo solo borrando la casa. En este caso no lo haremos.
start transaction;
delete from caracteristicasdecasa
where codcasa = 5640 or codcasa = 5641;

delete from casas
where codcasa = 5640 or codcasa = 5651;
delete from propietarios
where codpropietario = 520;
commit;

/*Dimos de alta hace unos días la casa 5789 de la que nos faltaban datos que nos acaban de facilitar.
Estos datos son los siguientes:  3 dormitorios, 200 m2 y con capacidad desde 4 a 8 personas.*/
-- P5.
update casas
set numhabit = 3,
m2 = 200,
minpersonas = 4, 
maxpersonas = 8
where codcasa = 5789;