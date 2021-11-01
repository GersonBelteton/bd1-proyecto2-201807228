# bd1-proyecto2-201807228

## Entidad Relación

<div align="center">
    <img src="https://res.cloudinary.com/dst1u4bij/image/upload/v1635745493/ER_zmdr4e.png" width="500">

</div>

<div align="center">
    <img src="https://res.cloudinary.com/dst1u4bij/image/upload/v1635745510/ER2_me1km9.png" width="500">

</div>

## Normalización

### 1FN

Se aplicó la primera forma normal al separar al momento de ingresar los datos en la tabla temporal, cada registro es único y no existe mas de un dato de un mismo campo en un registro de ninguna tabla, ademóas que se eliminó las columnas repetidas que se obtuvieron en el archivo de entrada.

### 2FN

Se aplicó la segunda forma normal al separar en distintas tablas y asignar una clave identificadora a cada tabla, de esta manera cada campo no identificador dependen únicamente de su clave identificadora. Sin embargo, esto no ocurria en la tabla temporal, pues no existía una clave identificadora como tal y cada campo podía depender de muchos otros.

### 3FN

Se aplicó la tercera forma normal por ejemplo en el caso de los paises, regiones, departamentos y municipios, ya que existía una relación transitiva entre cada una, por lo que se usaron tablas separadas y se relacionaron por medio de llaves foraneas.



