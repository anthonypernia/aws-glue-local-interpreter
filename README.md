## Contenedor para desarrollo local con AWS GLUE

Contenedor que emula el interprete de spark de **AWS Glue**, contiene todas las librerias y ademas permite conexion con todos los otros servicios, como S3 o tablas del Glue catalog.

- En DockerHub: ***anthonyperniah/aws-glue-local-interpreter***


#### Requisitos:

Para usar las credenciales de AWS, es necesario tenerlas alojadas en la ruta :

- **~/.aws**

En esa ruta deberia existir dos archivos, uno con nombre ***config*** y otro con nombre ***credentials***

*Ejemplos*:

**config**
```bash
[default]
region = us-east-1
output = json
```
**credentials**
```bash
aws_access_key_id = XXXXXXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXX
```
Para verificar que se accede a AWS, se puede ejecutar el comando:
(Teniendo el cli de aws instalado):
````
aws s3 ls
````
Deberia tener la respuesta con todos los buckets en S3.

Luego de esa verificacion, para usar el contenedor, puede ser de dos formas:
- Ejecucion directa por bash
- Usando **docker-compose**


### Mediante ejecucion directa por bash

*(Las imagenes estan en el DockerHub)*

````sh
docker run  -p 8888:8888 -v ~/.aws:/root/.aws --name aws-glue-local-interpreter  anthonyperniah/aws-glue-local-interpreter
````

Esto creara el contenedor, lo llamara **aws-glue-local-interpreter** y creara un volumen para compartir la ruta ***~/.aws*** en la ruta ***/root/.aws*** del usuario ***root***, lo cual permitira usar las mismas credenciales.

### Mediante docker compose
Dentro del repo esta el archivo para usar con docker compose:

*(Se puede ejecutar con la imagen que esta en DockerHub o con el archivo Dockerfile que esta en el repositorio)*
````yml
version: '3'

services:
  aws-glue-local-interpreter:
    ##build:
    ##  context: .
    ##  dockerfile: Dockerfile
    image: "anthonyperniah/aws-glue-local-interpreter:latest"
    volumes:
      - ~/.aws:/root/.aws
    ports:
      - "8888:8888"
````
El comando para crear el contenedor con el docker-compose es:
````bash
docker-compose up --build
````
Ademas de esto se puede agregar otro volumen donde se almacenaran y editaran los scripts en local y se pueden ejecutar en el contenedor.

Cuando el contenedor este corriendo, se dirige a la ruta:
- localhost:8888
Ó si esta en un servidor local remoto:
- {serveIP}:8888

Crear un notebook nuevo y ejecutar el siguiente comando:
```python
from pyspark import SparkContext
from awsglue.context import GlueContext

glueContext = GlueContext(SparkContext.getOrCreate()) 

inputDF = glueContext.create_dynamic_frame_from_options(connection_type = "s3", connection_options = {"paths": ["s3://awsglue-datasets/examples/us-legislators/all/memberships.json"]}, format = "json")
inputDF.toDF().show()
```