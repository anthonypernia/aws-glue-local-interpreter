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
<pre><code>
[default]
region = us-east-1
output = json
</code></pre>

<li><code>~/.aws/credentials</code></li>
<pre><code>
aws_access_key_id = XXXXXXXXXXXXXXXXXXXXXXXX
aws_secret_access_key = XXXXXXXXXXXXXXXXXXXXXXXX
</code></pre>
<p>If you would like to check the access to S3:</p>
<pre><code>
aws s3 ls
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
<a href="https://hub.docker.com/r/anthonyperniah/aws-glue-local-interpreter" rel="noreferrer"  target="_blank">anthonyperniah/aws-glue-local-interpreter</a>

</div>
<div>
<h3>Bash command</h3>
<pre><code>
docker run  -p 8888:8888 -v ~/.aws:/root/.aws --name aws-glue-local-interpreter  anthonyperniah/aws-glue-local-interpreter
</code></pre>

<p>It will create the container was-glue-local-interpreter and a volume to share path <code> ~/.aws</code> in <code>/root/.aws</code> to use the same credentials</p>
</div>
<div>
<h3>Docker-compose</h3>

<p>Must have a file name:</p>
<ul><li>docker-compose.yml</li></ul>

<p>With this content</p>
<pre><code>
version: '3'
services:
  aws-glue-local-interpreter:
    image: "anthonyperniah/aws-glue-local-interpreter"
    volumes:
      - ~/.aws:/root/.aws
      - ~/aws-glue-developments:/root/developments ##(OPTIONAL)
    ports:
      - "8888:8888"
</code></pre>
<p>Then, you need to use:</p>
<pre><code>
docker-compose up
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
<h3>Accessing to s3:</h3>
<p>Create a notebook and run the code:</p>
<pre><code>
from pyspark import SparkContext
from awsglue.context import GlueContext
glueContext = GlueContext(SparkContext.getOrCreate()) 
inputDF = glueContext.create_dynamic_frame_from_options(connection_type = "s3", connection_options = {"paths": ["s3://awsglue-datasets/examples/us-legislators/all/memberships.json"]}, format = "json")
inputDF.toDF().show()
</code></pre>
</div>
</div>
