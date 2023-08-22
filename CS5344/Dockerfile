FROM ubuntu:20.04

WORKDIR /home

COPY ./* ./

ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV SPARK_HOME="/opt/spark"
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:/usr/local/scala/bin:/usr/local/maven/bin:$PATH"
ENV PYSPARK_PYTHON="/usr/bin/python3"

SHELL ["/bin/bash", "-c"]


RUN set -x; apt-get update \
    && apt-get -y install wget python3 python3-pip openjdk-8-jre-headless \
    && wget -qO- "https://downloads.lightbend.com/scala/2.12.4/scala-2.12.4.tgz" | tar xvz \
    && mv scala-2.12.4 /usr/local/scala \
    && wget -qO- "https://archive.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz" | tar xvz \
    && mv apache-maven-3.5.2 /usr/local/maven \
#    && wget -qO- "https://archive.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz" | tar xvz \
    && tar xvf spark-2.2.1-bin-hadoop2.7.tgz \
    && mv spark-2.2.1-bin-hadoop2.7 /opt/spark \
    && echo "start-master.sh" >> ~/.bashrc \
    && echo "start-slave.sh spark://\$HOSTNAME:8888" >> ~/.bashrc \
    && echo "jupyter notebook --ip 0.0.0.0 --port 5344 --no-browser --NotebookApp.token='' --NotebookApp.password='' --allow-root &> /dev/null &" >> ~/.bashrc \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && pip install --no-cache-dir findspark pyspark==2.2.1 pyarrow notebook pandas \