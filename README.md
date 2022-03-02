## Local Docker container to develop in AWS glue

With this container, you can run Python code and use **AWS Glue** context and AWS libraries. 
For example: 
* Create DynamicFrame
* Read and write in S3
* Read tables in Athena
* Etc.

 Docker image in DockerHub: [anthonyperniah/aws-glue-local-interpreter](https://hub.docker.com/r/anthonyperniah/aws-glue-local-interpreter)


#### Requirements:

- Aws-cli
  - MacOS : ```brew install awscli```
  - Ubuntu : ```sudo apt-get install awscli```
  - Windows : [AWS docs](https://docs.aws.amazon.com/es_es/cli/latest/userguide/install-cliv2-windows.html)
- You must have AWS credentials in the path: **~/.aws**


Must be two files:
* ***config*** 
* ***credentials***

*Examples*:

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
To check access to S3:
````
aws s3 ls
````

You should get a list of buckets in S3.

How to use:
- By bash command
- Using **docker-compose**


***Both using [anthonyperniah/aws-glue-local-interpreter](https://hub.docker.com/r/anthonyperniah/aws-glue-local-interpreter)***
#### - Bash command

````sh
docker run  -p 8888:8888 -v ~/.aws:/root/.aws --name aws-glue-local-interpreter  anthonyperniah/aws-glue-local-interpreter
````

Will create the container **aws-glue-local-interpreter** and create a volume to share path **~/.aws** in **/root/.aws** to use the same credentials

### - Docker-compose

Must have a file name:
* **docker-compose.yml**

With this content:
````yml
version: '3'

services:
  aws-glue-local-interpreter:
    image: "anthonyperniah/aws-glue-local-interpreter"
    volumes:
      - ~/.aws:/root/.aws
      - ~/aws-glue-developments:/root/developments ##(OPTIONAL)
    ports:
      - "8888:8888"
````
Then use:
````bash
docker-compose up
````
You can add another volume where the script will be stored and edited locally and executed in the container. in this case, it is used "aws-glue-developments" folder.

When the container is running, go to :
- localhost:8888
or
- **{serverIP}**:8888

#### Accessing s3
Create a notebook and run the code:
```python
from pyspark import SparkContext
from awsglue.context import GlueContext
###Creating a glue context
glueContext = GlueContext(SparkContext.getOrCreate()) 
### Read s3 and create dynamic frame
inputDF = glueContext.create_dynamic_frame_from_options(connection_type = "s3", connection_options = {"paths": ["s3://awsglue-datasets/examples/us-legislators/all/memberships.json"]}, format = "json")
inputDF.toDF().show()
```



Tested in architectures:
- AMD64
- ARM64v8