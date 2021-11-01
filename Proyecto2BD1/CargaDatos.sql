use proyecto2bd1;

insert into pais(nombre_pais) select distinct pais from temporal;

insert into region(nombre_region, id_pais)select distinct region, id_pais from temporal,pais where pais.nombre_pais = temporal.pais;

insert into departamento(nombre_departamento, id_region)select distinct depto, id_region from temporal, region, pais where region.nombre_region = temporal.region and pais.nombre_pais = temporal.pais and region.id_pais = pais.id_pais order by depto;

insert into municipio(nombre_municipio, id_departamento)select distinct municipio, id_departamento from temporal, departamento, region, pais where departamento.nombre_departamento = temporal.depto and region.nombre_region = temporal.region and pais.nombre_pais = temporal.pais and departamento.id_region = region.id_region;

insert into sexo(nombre_sexo) select distinct sexo from temporal;

insert into raza(nombre_raza) select distinct raza from temporal;

insert into eleccion(nombre_eleccion, anio) select distinct nombre_eleccion, anio_eleccion from temporal;

insert into partido(partido, nombre_partido) select distinct partido, nombre_partido from temporal;

ALTER TABLE temporal ADD id_municipio integer;
update temporal, municipio, departamento, region, pais set temporal.id_municipio = municipio.id_municipio
where temporal.municipio = municipio.nombre_municipio
and temporal.depto = departamento.nombre_departamento
and temporal.region = region.nombre_region
and temporal.pais = pais.nombre_pais
and municipio.id_departamento = departamento.id_departamento
and departamento.id_region = region.id_region
and region.id_pais = pais.id_pais;

ALTER TABLE temporal ADD id_sexo integer;
update temporal, sexo set temporal.id_sexo = sexo.id_sexo where temporal.sexo = sexo.nombre_sexo;

ALTER TABLE temporal ADD  id_raza integer;
update temporal, raza set temporal.id_raza = raza.id_raza where temporal.raza = raza.nombre_raza;

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