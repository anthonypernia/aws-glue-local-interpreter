<div>
<div><h1>Local Docker container to develop in AWS glue</h1>

<p>With this container, you can run Spark code with Python or Scala and use <b>AWS Glue</b> context and AWS libraries</p>
<p>For example, You can do the following:</p>
<ul>
<li>Create DynamicFrame</li>
<li>Read and write in S3</li>
<li>Read tables in Athena</li>
<li>Use AWS Services</li>
<li>Etc</li>
</ul>
</div>
<div>
<p>Tested in:</p>
<ul>
<li>AMD64</li>
<li>ARM64</li>
</ul>
<p>Based on AWS official documentation <a href="https://docs.aws.amazon.com/glue/latest/dg/aws-glue-programming-etl-libraries.html#develop-local-python" rel="noreferrer"  target="_blank">Development local python</a></p>
</div>
<div>
<h3>Docker image in DockerHub:
<a href="https://hub.docker.com/r/anthonypernia/aws-glue-local-interpreter" rel="noreferrer"  target="_blank">aws-glue-local-interpreter</a></h3>
</div>
<div>
<h2>Requirements:</h2>
<ul>
<li>Aws-cli
  <ul>
  <li>MacOS : <pre><code>brew install awscli</code></pre></li>
  <li>Ubuntu : <pre><code>sudo apt-get install awscli</code></pre></li>
  <li>Windows : <a href="https://docs.aws.amazon.com/es_es/cli/latest/userguide/install-cliv2-windows.html" rel="noreferrer"  target="_blank">AWS docs</a></li>
  </ul>
  </li>
<li>You must have AWS credentials in the path: <code>~/.aws</code> </li>
</ul>

<h3>There must be two files:</h3>
<ul>
<li>config</li>
<li>credentials</li>
</ul>

<h3>Examples:</h3>

<li><code>~/.aws/config</code></li>
<pre><code>[default]
region = us-east-1
output = json
</code></pre>

<li><code>~/.aws/credentials</code></li>
<pre><code>aws_access_key_id = XXXXXXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXX
</code></pre>
<p>If you would like to check the access to S3:</p>
<pre><code>aws s3 ls
</code></pre>
<p>You should get a list of buckets in S3.</>
</div>
<div>
<h2>How to use:</h2>
<ul>
<li>By bash command</li>
<li>With  docker-compose</li>
</ul>

<p>Both using:<p> 
<a href="https://hub.docker.com/r/anthonypernia/aws-glue-local-interpreter" rel="noreferrer"  target="_blank">anthonypernia/aws-glue-local-interpreter</a>

</div>
<div>
<h3>Bash command</h3>
<pre><code>docker run  -p 8888:8888 -v ~/.aws:/root/.aws --name aws-glue-local-interpreter  anthonypernia/aws-glue-local-interpreter
</code></pre>

<p>It will create the container was-glue-local-interpreter and a volume to share path <code> ~/.aws</code> in <code>/root/.aws</code> to use the same credentials</p>
</div>
<div>
<h3>Docker-compose</h3>

<p>Must have a file name:</p>
<ul><li>docker-compose.yml</li></ul>

<p>With this content</p>
<pre><code>version: '3'
services:
  aws-glue-local-interpreter:
    image: "anthonypernia/aws-glue-local-interpreter"
    volumes:
      - ~/.aws:/root/.aws
      - ~/aws-glue-developments:/root/developments ##(OPTIONAL)
    ports:
      - "8888:8888"
</code></pre>
<p>Then, you need to use:</p>
<pre><code>docker-compose up
</code></pre>

<p>You can add another volume where the script will be stored and edited locally and executed in the container. in this case, the folder "aws-glue-developments" is used.</p>

<p>When the container is running, go to :</p>
<li>http://localhost:8888/</li>
or
<li>{serverIP}:8888</li>
</p>
<p>And you should see a Jupyter notebook running.</p>
</div>
<div>
<h3>Creating GlueContext and SparkContext</h3>
<p>Create a notebook and run the code:</p>
<pre><code>from pyspark import SparkContext
from awsglue.context import GlueContext
from pyspark.sql import SQLContext
</code>
<code>
def get_gluecontext() -> GlueContext:
    """Get the glue context
    Returns:
        GlueContext: Glue context
    """    
    sc = SparkContext.getOrCreate()
    return GlueContext(sc)
</code>
<code>
def get_spark_context() -> SparkContext:
    """Get the spark context
    Returns:
        SparkContext: Spark context
    """    
    return SparkContext.getOrCreate()
</code>
<code>
def get_spark_sql_context(sparkContext: SparkContext) -> SQLContext:
    """Get the spark sql context
    Args:
        sparkContext (SparkContext): Spark context
    Returns:
        SQLContext: Spark sql context
    """    
    return SQLContext(sparkContext)
</code>
<code>
glueContext: GlueContext = get_gluecontext()
sparkContext: SparkContext = get_spark_context()
sqlContext: SQLContext = get_spark_sql_context(sparkContext)
</code></pre>
<img src="https://github.com/anthonypernia/aws-glue-local-interpreter/blob/main/assets/gluecontext.png?raw=true" alt="GlueContext">
<img src="https://github.com/anthonypernia/aws-glue-local-interpreter/blob/main/assets/sparkcontext.png?raw=true" alt="SparkContext">
<img src="https://github.com/anthonypernia/aws-glue-local-interpreter/blob/main/assets/sparksqlcontext.png?raw=true" alt="SparkSQLContext">
<h3>Creating DynamicFrame and DataFrame</h3>
<p>After creating the contexts:</p>
<pre><code>from awsglue.dynamicframe import DynamicFrame
from pyspark.sql import DataFrame
</code>
<code>
def create_df_from_path(glueContext: GlueContext, path: str, format_file: str) -> DynamicFrame:
    """Create a dataframe from a path
    Args:
        glueContext (GlueContext): Glue context
        path (str): Path to read
        format_file (str): Format of the file
    Returns:
        DynamicFrame: DynamicFrame
    """    
    return glueContext.create_dynamic_frame_from_options(connection_type = "s3", connection_options = {"paths": [path]}, format = format_file)
</code>
<code>
def create_spark_df_from_path(sqlContext: SQLContext, path: str, format_file: str) -> DataFrame:
    """Create a spark dataframe from a path
    Args:
        sqlContext (SQLContext): Spark sql context
        path (str): Path to read
        format_file (str): Format of the file
    Returns:
        DataFrame: Spark dataframe
    """    
    return sqlContext.read.format(format_file).load(path)
</code>
<code>
path: str = "s3://awsglue-datasets/examples/us-legislators/all/memberships.json"
format_file: str = "json"
</code><code>
df: DynamicFrame = create_df_from_path(glueContext, path, format_file)
</code><code>
spark_df: DataFrame = create_spark_df_from_path(sqlContext, path, format_file)
</code></pre>
<img src="https://github.com/anthonypernia/aws-glue-local-interpreter/blob/main/assets/dynamicframe.png?raw=true" alt="DynamicFrame">
<img src="https://github.com/anthonypernia/aws-glue-local-interpreter/blob/main/assets/dataframe.png?raw=true" alt="DataFrame">
<h3>Write data in S3</h3>
<pre><code>def write_spark_df(df: DataFrame, bucket: str, key: str) -> None:
    """Write a dataframe to S3 in parquet format
    Args:
        df (DataFrame): Dataframe to write
        bucket (str): S3 bucket
        key (str): S3 key
    """    
    df.write.parquet(f"s3://{bucket}/{key}", mode="overwrite")
</code>
<code>
bucket: str = "example-bucket-demo-aws"
key: str = "test-folder-output"
write_spark_df(spark_df, bucket, key)
</code></pre>
<img src="https://github.com/anthonypernia/aws-glue-local-interpreter/blob/main/assets/aws.png?raw=true" alt="AWS console - data that was written">
</div>
</div>
