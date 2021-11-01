use proyecto2bd1;


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