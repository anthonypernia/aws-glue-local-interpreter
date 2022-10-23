### Anthony Pernia @anthonyperniah
##from ubuntu
FROM ubuntu:latest
WORKDIR /root/
##setting the localzone
ENV TZ=America/Argentina/Buenos_Aires
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN ln -s /usr/bin/dpkg-split /usr/sbin/dpkg-split
RUN ln -s /usr/bin/dpkg-deb /usr/sbin/dpkg-deb
RUN ln -s /bin/tar /usr/sbin/tar
##install python and pip
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y python3-pip 
RUN apt-get install -y python3-dev 
RUN apt-get install -y python3-venv
RUN apt-get install -y python3-setuptools
## install dependencies , git , zip, wget, java , jdk, jre
RUN apt-get install -y git
RUN apt-get install -y zip
RUN apt-get install -y unzip
RUN apt-get install -y wget
RUN apt-get install -y awscli
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk
RUN apt-get install -y software-properties-common
#Python dependencies with pip
RUN pip3 install --upgrade pip
RUN pip3 install --upgrade setuptools
RUN pip3 install --upgrade virtualenv
## clone aws libs, download & install maven and spark
RUN git clone https://github.com/awslabs/aws-glue-libs.git
RUN wget https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-common/apache-maven-3.6.0-bin.tar.gz
RUN wget https://aws-glue-etl-artifacts.s3.amazonaws.com/glue-3.0/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz
RUN tar -xvf apache-maven-3.6.0-bin.tar.gz
RUN tar -xvf spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz
RUN mv apache-maven-3.6.0 /opt/apache-maven-3.6.0
RUN rm -rf apache-maven-3.6.0-bin.tar.gz
RUN rm -rf spark-3.1.1-amzn-0-bin-3.2.1-amzn-3.tgz
### setting environment variables
ENV MAVEN_HOME=/opt/apache-maven-3.6.0
ENV M2_HOME=/opt/apache-maven-3.6.0
ENV PATH=${M2_HOME}/bin:${PATH}
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV SPARK_HOME=/root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3
ENV PATH=${SPARK_HOME}/bin:${PATH}
ENV PYSPARK_PYTHON_DRIVER=python3
ENV PYSPARK_PYTHON=python3
## installing aws libs
RUN chmod -R 770 /root/aws-glue-libs/bin/*
RUN bash /root/aws-glue-libs/bin/glue-setup.sh 
RUN cd /root/aws-glue-libs/ && zip -r awsglue.zip awsglue
RUN cp /root/aws-glue-libs/awsglue.zip /root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/python/lib/
### setting environment variables 2
ENV PYTHONPATH=/root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/python/lib/awsglue.zip:/root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/python/lib/pyspark.zip:/root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/python/lib/py4j-0.10.9-src.zip:/root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/python
### moving jars to spark
RUN cp /root/aws-glue-libs/jarsv1/* /root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/jars/
###########solving compatibility problem with jars
RUN cd /root/spark-3.1.1-amzn-0-bin-3.2.1-amzn-3/jars/ && wget https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.2.0/hadoop-aws-3.2.0.jar
###remove folders inutil
RUN rm -rf /root/aws-glue-libs
### requirements
COPY requirements.txt /root/requirements.txt
RUN pip3 install -r /root/requirements.txt
RUN pip3 install --upgrade awscli
#### setting notebook folder
RUN mkdir /root/developments/
WORKDIR /root/developments/
### starting jupyter to all ips
CMD [ "jupyter-notebook", "--ip", "*", "--allow-root", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''", "--NotebookApp.port=8888" ]