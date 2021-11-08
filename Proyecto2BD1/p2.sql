use proyecto2bd1;

drop table conteovoto;
drop table sexo;
drop table raza;
drop table eleccionpartido;
drop table eleccion;
drop table partido;
drop table municipio;
drop table departamento;
drop table region;
drop table pais;
drop table temporal;

select count(*) from conteovoto;
select count(*) from sexo;
select count(*) from raza;
select count(*) from eleccionpartido;
select count(*) from eleccion;
select count(*) from partido;
select count(*) from municipio;
select count(*) from departamento;
select count(*) from region;
select count(*) from pais;
select count(*) from temporal;

create table temporal(
    nombre_eleccion varchar(30) not null,
    anio_eleccion integer not null,
    pais varchar(50) not null,
    region varchar(50) not null,
    depto varchar(50) not null,
    municipio varchar(50) not null,
    partido varchar(30)not null,
    nombre_partido varchar(50) not null,
    sexo varchar(16) not null,
    raza varchar(16) not null,
    analfabetos integer not null,
    alfabetos integer not null,
    primaria integer not null,
    nivel_medio integer not null,
    universitarios integer not null

);


create table pais(
    id_pais integer auto_increment primary key,
    nombre_pais varchar(30) not null
);


create table sexo(
    id_sexo integer auto_increment primary key,
    nombre_sexo varchar(16) not null
);

create table region(
    id_region integer auto_increment primary key,
    nombre_region varchar(30),
    id_pais integer,
    constraint fk_pais
    foreign key(id_pais)
    references pais(id_pais)
);


create table raza(
    id_raza integer auto_increment primary key,
    nombre_raza varchar(30) not null
);

create table partido(
    id_partido integer auto_increment primary key,
    partido varchar(30),
    nombre_partido varchar(30)
);


create table eleccion(
    id_eleccion integer auto_increment primary key,
    nombre_eleccion varchar(30),
    anio integer
);


create table departamento(
    id_departamento integer auto_increment primary key,
    nombre_departamento varchar(30),
    id_region integer,
    constraint fk_region
    foreign key(id_region)
    references region(id_region)

);


create table municipio(
    id_municipio integer auto_increment primary key,
    nombre_municipio varchar(50),
    id_departamento integer,
    constraint fk_departamento
    foreign key(id_departamento)
    references departamento(id_departamento)
);

create table eleccionpartido(
    id_eleccionpartido integer auto_increment primary key,
    id_eleccion integer,
    id_partido integer,
    constraint fk_eleccion
    foreign key (id_eleccion)
    references eleccion(id_eleccion),
    constraint fk_partido
    foreign key (id_partido)
    references partido(id_partido)
);

create table conteovoto(
    id_conteovoto integer auto_increment primary key,
    alfabetos integer,
    analfabetos integer,
    primaria integer,
    nivel_medio integer,
    universitarios integer,
    id_raza integer,
    id_sexo integer,
    id_municipio integer,
    id_eleccionpartido integer,
    constraint fk_raza
    foreign key(id_raza)
    references raza(id_raza),
    constraint fk_sexo 
    foreign key (id_sexo)
    references sexo(id_sexo),
    constraint fk_municipio
    foreign key (id_municipio)
    references municipio(id_municipio),
    constraint fk_eleccionpartido
    foreign key(id_eleccionpartido)
    references eleccionpartido(id_eleccionpartido)
);
select count(*) from temporal;



-- ----------------------------------------------------------carga de datos


insert into pais(nombre_pais) select distinct pais from temporal;

insert into region(nombre_region, id_pais)select distinct region, id_pais from temporal,pais where pais.nombre_pais = temporal.pais;

insert into departamento(nombre_departamento, id_region)select distinct depto, id_region from temporal, region, pais where region.nombre_region = temporal.region and pais.nombre_pais = temporal.pais and region.id_pais = pais.id_pais order by depto;

insert into municipio(nombre_municipio, id_departamento)select distinct municipio, id_departamento from temporal, departamento, region, pais where departamento.nombre_departamento = temporal.depto and region.nombre_region = temporal.region and pais.nombre_pais = temporal.pais and departamento.id_region = region.id_region;

ALTER TABLE temporal ADD id_municipio integer;
update temporal, municipio, departamento, region, pais set temporal.id_municipio = municipio.id_municipio
where temporal.municipio = municipio.nombre_municipio
and temporal.depto = departamento.nombre_departamento
and temporal.region = region.nombre_region
and temporal.pais = pais.nombre_pais
and municipio.id_departamento = departamento.id_departamento
and departamento.id_region = region.id_region
and region.id_pais = pais.id_pais;

ALTER TABLE temporal
ADD id_sexo integer;
insert into sexo(nombre_sexo) select distinct sexo from temporal;
update temporal, sexo set temporal.id_sexo = sexo.id_sexo where temporal.sexo = sexo.nombre_sexo;

ALTER TABLE temporal
ADD  id_raza integer;
insert into raza(nombre_raza) select distinct raza from temporal;
update temporal, raza set temporal.id_raza = raza.id_raza where temporal.raza = raza.nombre_raza;



insert into eleccion(nombre_eleccion, anio) select distinct nombre_eleccion, anio_eleccion from temporal;

insert into partido(partido, nombre_partido) select distinct partido, nombre_partido from temporal;



ALTER TABLE temporal ADD id_eleccionpartido integer;
insert into eleccionpartido(id_eleccion, id_partido) select distinct id_eleccion, id_partido from eleccion,partido;
update temporal, eleccion, partido, eleccionpartido set temporal.id_eleccionpartido = eleccionpartido.id_eleccionpartido
where temporal.partido = partido.partido
and temporal.anio_eleccion = eleccion.anio
and partido.id_partido = eleccionpartido.id_partido
and eleccion.id_eleccion = eleccionpartido.id_eleccion;

insert into conteovoto(alfabetos,analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido)
select  distinct alfabetos, analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido 
from temporal;


insert into conteovoto(alfabetos,analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido)
select   alfabetos, analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido 
from temporal, raza, sexo, municipio, eleccionpartido, eleccion, partido, departamento, region, pais
where temporal.raza = raza.nombre_raza 
and temporal.sexo = sexo.nombre_sexo 
and temporal.municipio = municipio.nombre_municipio 
and temporal.depto = departamento.nombre_departamento
and temporal.region = region.nombre_region
and temporal.pais = pais.nombre_pais
and municipio.id_departamento = departamento.id_departamento
and departamento.id_region = region.id_region
and region.id_pais = pais.id_pais
and temporal.anio_eleccion = eleccion.anio
and eleccion.id_eleccion = eleccionpartido.id_eleccion 
and temporal.partido = partido.partido 
and partido.id_partido = eleccionpartido.id_partido; 


select   alfabetos, analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido 
from temporal inner join raza on temporal.raza = raza.nombre_raza
inner join sexo on temporal.sexo = sexo.nombre_sexo
inner join municipio on temporal.municipio = municipio.nombre_municipio
inner join departamento on municipio.id_departamento = departamento.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join eleccion on temporal.anio_eleccion = eleccion.anio
inner join partido on temporal.partido = partido.partido
inner join eleccionpartido on eleccionpartido.id_eleccion = eleccion.id_eleccion

insert into conteovoto(alfabetos,analfabetos, primaria, nivel_medio, universitarios)
select  distinct alfabetos, analfabetos, primaria, nivel_medio, universitarios
from temporal;

update conteovoto set id_raza = 
(select id_raza from raza, temporal 
where temporal.raza = raza.nombre_raza 
and temporal.alfabetos = conteovoto.alfabetos
and temporal.analfabetos = conteovoto.analfabetos
and temporal.primaria = conteovoto.primaria
and temporal.nivel_medio = conteovoto.nivel_medio
and temporal.universitarios = conteovoto.universitarios);

select distinct partido.partido, eleccion.anio, id_eleccionpartido from eleccion, partido, eleccionpartido
where eleccionpartido.id_eleccion = eleccion.id_eleccion
and eleccionpartido.id_partido = partido.id_partido;

select distinct pais.nombre_pais, region.nombre_region, departamento.nombre_departamento, municipio.nombre_municipio
from departamento, region, pais, municipio 
where municipio.id_departamento = departamento.id_departamento
and departamento.id_region = region.id_region
and pais.id_pais = region.id_pais;
Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

select  distinct alfabetos, analfabetos, primaria, nivel_medio, universitarios
from temporal, raza, sexo,
(select distinct pais.nombre_pais, region.nombre_region, departamento.nombre_departamento, municipio.nombre_municipio
from departamento, region, pais, municipio 
where municipio.id_departamento = departamento.id_departamento
and departamento.id_region = region.id_region
and pais.id_pais = region.id_pais) ubicacion,
(select distinct partido.partido, eleccion.anio, id_eleccionpartido from eleccion, partido, eleccionpartido
where eleccionpartido.id_eleccion = eleccion.id_eleccion
and eleccionpartido.id_partido = partido.id_partido)ep
where temporal.raza = raza.nombre_raza
and temporal.sexo = sexo.nombre_sexo
and temporal.region = ubicacion.nombre_region
and temporal.depto = ubicacion.nombre_departamento
and temporal.municipio = ubicacion.nombre_municipio
and temporal.anio_eleccion = ep.anio
and temporal.partido = ep.partido;
-- ---------------------------CONSULTAS ------------------------------------------------------

-- 1
select a.nombre_eleccion, a.anio, a.nombre_pais, max(a.total),sum(a.total),max(a.total)*100/sum(a.total)as porcentaje
from (select  eleccion.nombre_eleccion, eleccion.anio, nombre_pais, partido,sum(alfabetos+analfabetos)as total
from  conteovoto inner join eleccionpartido  on conteovoto.id_eleccionpartido = eleccionpartido.id_eleccionpartido
inner join eleccion on eleccion.id_eleccion = eleccionpartido.id_eleccion
inner join partido on partido.id_partido = eleccionpartido.id_partido
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
group by nombre_pais, partido, nombre_eleccion,anio) as a
group by nombre_pais,nombre_eleccion,anio;

-- 2

select nombre_pais, nombre_departamento, sum(alfabetos+analfabetos)as total from conteovoto
inner join municipio on municipio.id_municipio = conteovoto.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join sexo on conteovoto.id_sexo = sexo.id_sexo
where nombre_sexo = 'mujeres'
group by nombre_pais, nombre_departamento
order by nombre_pais;


-- 4

select n.total,n.nombre_region, n.nombre_pais from
(
    select sum(analfabetos+alfabetos)as total, nombre_raza, nombre_region, nombre_pais from conteovoto
    inner join raza on conteovoto.id_raza = raza.id_raza
    inner join municipio on conteovoto.id_municipio = municipio.id_municipio
    inner join departamento on departamento.id_departamento = municipio.id_departamento
    inner join region on region.id_region = departamento.id_region
    inner join pais on pais.id_pais = region.id_pais
    group by nombre_raza,nombre_region,nombre_pais
    order by nombre_pais, nombre_raza, nombre_region

)as n
,
(select max(a.total)as total,a.nombre_region, a.nombre_pais from
(
    select sum(analfabetos+alfabetos)as total, max(alfabetos+analfabetos) as maximo, nombre_raza as nr1, nombre_region, nombre_pais from conteovoto
    inner join raza on conteovoto.id_raza = raza.id_raza
    inner join municipio on conteovoto.id_municipio = municipio.id_municipio
    inner join departamento on departamento.id_departamento = municipio.id_departamento
    inner join region on region.id_region = departamento.id_region
    inner join pais on pais.id_pais = region.id_pais
    group by nombre_raza,nombre_region,nombre_pais
    order by nombre_pais, nombre_raza, nombre_region

)as a
group by  nombre_pais,nombre_region)as m
where n.total = m.total and n.nombre_raza = 'INDIGENAS';

-- 6

select round((mujeres.total/tot.total*100),2)as mujeres, round((tot.total-mujeres.total)/tot.total*100,2)as hombres, mujeres.nombre_departamento from
(select n.total, n.nombre_departamento, n.nombre_sexo from
(select sum(universitarios)as total, sexo.nombre_sexo, departamento.nombre_departamento 
from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join sexo on sexo.id_sexo = conteovoto.id_sexo
group by sexo.nombre_sexo, departamento.nombre_departamento)as n,
(select max(a.total) as total,a.nombre_departamento from(
select sum(universitarios)as total, sexo.nombre_sexo, departamento.nombre_departamento from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join sexo on sexo.id_sexo = conteovoto.id_sexo
group by sexo.nombre_sexo, departamento.nombre_departamento
) as a
group by nombre_departamento)m
where n.total = m.total and n.nombre_sexo = 'mujeres' 
order by nombre_departamento) mujeres,
(select sum(universitarios)as total, departamento.nombre_departamento 
from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join sexo on sexo.id_sexo = conteovoto.id_sexo
group by departamento.nombre_departamento)as tot
where mujeres.nombre_departamento = tot.nombre_departamento;


-- 7

select nombre_pais, nombre_region, nombre_departamento, round(avg(alfabetos+analfabetos),2)as promedio from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
group by nombre_pais, nombre_region,nombre_departamento;

-- 8

select nombre_pais, sum(primaria) as primaria, sum(nivel_medio)as nivel_medio, sum(universitarios) as universidad
from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
group by nombre_pais;

-- 9

select round((n.total/m.total*100),2)as porcentaje, n.nombre_pais,n.nombre_raza from
(select nombre_pais, nombre_raza, sum(alfabetos+analfabetos)as total
from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join raza on raza.id_raza = conteovoto.id_raza
group by nombre_pais, nombre_raza
order by nombre_pais, nombre_raza)as n,
(select sum(a.total)as total, a.nombre_pais from
(select nombre_pais, nombre_raza, sum(alfabetos+analfabetos)as total
from conteovoto
inner join municipio on conteovoto.id_municipio = municipio.id_municipio
inner join departamento on departamento.id_departamento = municipio.id_departamento
inner join region on region.id_region = departamento.id_region
inner join pais on pais.id_pais = region.id_pais
inner join raza on raza.id_raza = conteovoto.id_raza
group by nombre_pais, nombre_raza
order by nombre_pais, nombre_raza) as a
group by nombre_pais)as m
where m.nombre_pais = n.nombre_pais;

-- 11

select sum(alfabetos)as total, nombre_sexo, nombre_raza from conteovoto
inner join sexo on conteovoto.id_sexo = sexo.id_sexo
inner join raza on conteovoto.id_raza = raza.id_raza
where nombre_sexo = 'mujeres' and nombre_raza = 'INDIGENAS'
group by nombre_sexo, nombre_raza;


-- --------------------------------------------------------------------------------------------------

select + MAX_EXECUTION_TIME(1000)  from conteovoto;
select * from conteovoto;
select * from pais;
select * from raza;
select * from sexo;
select * from temporal;
select * from municipio;
select * from region;
select * from partido;
show open tables where in_use>0;

select distinct  municipio from temporal where pais = "Costa Rica";
select distinct nombre_municipio from pais 
inner join  region on region.id_pais = pais.id_pais
inner join departamento on departamento.id_region = region.id_region
inner join municipio on municipio.id_departamento = departamento.id_departamento
where pais.nombre_pais = "Costa Rica";
show processlist;
kill 74;
SHOW ENGINE INNODB STATUS;

set innodb_lock_wait_timeout=100;
show variables like 'innodb_lock_wait_timeout';