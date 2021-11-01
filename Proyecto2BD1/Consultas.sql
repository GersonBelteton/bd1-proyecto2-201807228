use proyecto2bd1;

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