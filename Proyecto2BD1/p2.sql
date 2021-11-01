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

create table temporal(
    nombre_eleccion varchar(30) not null,
    anio_eleccion integer not null,
    pais varchar(30) not null,
    region varchar(30) not null,
    depto varchar(30) not null,
    municipio varchar(30) not null,
    partido varchar(30)not null,
    nombre_partido varchar(30) not null,
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
    nombre_municipio varchar(30),
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

insert into sexo(nombre_sexo) select distinct sexo from temporal;

insert into raza(nombre_raza) select distinct raza from temporal;

insert into eleccion(nombre_eleccion, anio) select distinct nombre_eleccion, anio_eleccion from temporal;

insert into partido(partido, nombre_partido) select distinct partido, nombre_partido from temporal;

insert into eleccionpartido(id_eleccion, id_partido) select distinct id_eleccion, id_partido from eleccion,partido;


insert into conteovoto(alfabetos,analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido)
select  alfabetos, analfabetos, primaria, nivel_medio, universitarios, id_raza, id_sexo, id_municipio, id_eleccionpartido 
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

select * from conteovoto;
select * from pais;
