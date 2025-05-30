# https://viblo.asia/p/dung-apache-airflow-phien-ban-cuc-nhe-localexecutor-voi-docker-compose-x7Z4DAjPJnX#_dung-apache-airflow-bang-docker-compose-1
ARG AIRFLOW_IMAGE_NAME
FROM ${AIRFLOW_IMAGE_NAME}

ENV AIRFLOW_HOME=/opt/airflow
WORKDIR $AIRFLOW_HOME

USER root
RUN apt-get update -qq && apt-get install vim -qqq && apt-get install -y python3-pip

ENV JAVA_HOME=/home/jdk-11.0.2
ENV JARS_FOLDER=/opt/spark/jars

ENV PATH="${JAVA_HOME}/bin/:${PATH}"

COPY ../docker-requirements/airflow.requirements.txt .


RUN DOWNLOAD_URL="https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz" \
    && TMP_DIR="$(mktemp -d)" \
    && curl -fL "${DOWNLOAD_URL}" --output "${TMP_DIR}/openjdk-11.0.2_linux-x64_bin.tar.gz" \
    && mkdir -p "${JAVA_HOME}" \
    && tar xzf "${TMP_DIR}/openjdk-11.0.2_linux-x64_bin.tar.gz" -C "${JAVA_HOME}" --strip-components=1 \
    && rm -rf "${TMP_DIR}" \
    && java --version

RUN mkdir /opt/spark && \
    mkdir ${JARS_FOLDER} && \
    curl -fL "https://repo1.maven.org/maven2/com/amazonaws/aws-java-sdk-bundle/1.12.780/aws-java-sdk-bundle-1.12.780.jar" --output "${JARS_FOLDER}/aws-java-sdk-bundle-1.12.780.jar" && \
    curl -fL "https://repo1.maven.org/maven2/org/apache/hadoop/hadoop-aws/3.3.1/hadoop-aws-3.3.1.jar" --output "${JARS_FOLDER}/hadoop-aws-3.3.1.jar" && \
    curl -fL "https://repo1.maven.org/maven2/com/clickhouse/clickhouse-jdbc/0.7.1/clickhouse-jdbc-0.7.1.jar" --output "${JARS_FOLDER}/clickhouse-jdbc-0.7.1.jar" && \
    curl -fL "https://repo1.maven.org/maven2/org/apache/httpcomponents/client5/httpclient5/5.4.4/httpclient5-5.4.4.jar" --output "${JARS_FOLDER}/httpclient5-5.4.4.jar" && \
    curl -fL "https://repo1.maven.org/maven2/org/apache/httpcomponents/core5/httpcore5/5.3/httpcore5-5.3.jar" --output "${JARS_FOLDER}/httpcore5-5.3.jar" && \
    curl -fL "https://repo1.maven.org/maven2/org/apache/httpcomponents/core5/httpcore5-h2/5.3/httpcore5-h2-5.3.jar" --output "${JARS_FOLDER}/httpcore5-h2-5.3.jar"

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --no-cache-dir -r airflow.requirements.txt

USER airflow