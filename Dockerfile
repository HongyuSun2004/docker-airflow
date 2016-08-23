FROM python:2.7.12

######## Install Oracle Client ########

RUN mkdir -p /opt/oracle/instantclient_12_1 \
   && mkdir -p /usr/local/airflow \
   && ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime \
   && apt-get update && apt-get install -y apt-utils build-essential unzip python-dev libaio-dev

#### Download the oracle client basic and sdk from oracle site
# ADD oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip /opt/oracle/
# ADD oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip /opt/oracle/

RUN cd /opt/oracle && unzip instantclient-basic-linux.x64-12.1.0.2.0.zip \
   && unzip instantclient-sdk-linux.x64-12.1.0.2.0.zip \
   && cd /opt/oracle/instantclient_12_1 \
   && ln -s libclntsh.so.12.1 libclntsh.so \
   && ln -s libocci.so.12.1 libocci.so

ENV ORACLE_HOME /opt/oracle/instantclient_12_1
ENV LD_LIBRARY_PATH $ORACLE_HOME:$LD_LIBRARY_PATH
ENV PATH=$ORACLE_HOME:$PATH
ENV AIRFLOW_HOME /usr/local/airflow

RUN echo "/opt/oracle/instantclient_12_1" > /etc/ld.so.conf.d/oracle.conf && ldconfig 

RUN pip install requests && pip install retrying


######## Install airflow ########

RUN pip install airflow

RUN pip install airflow[all_dbs] \
   && pip install airflow[async] \
   && pip install airflow[celery] \
   && pip install airflow[crypto] \
   && pip install airflow[jdbc] \
   && pip install airflow[mysql] 

RUN pip install airflow[rabbitmq] \
   && pip install airflow[s3] \
   && pip install airflow[oracle] 
   

# ADD airflow/dags.tar.gz /usr/local/airflow/
ADD script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
ADD config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
   && chown -R airflow: ${AIRFLOW_HOME} \
   && chmod +x ${AIRFLOW_HOME}/entrypoint.sh

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}

#ENTRYPOINT ${AIRFLOW_HOME}/entrypoint.sh
CMD ["airflow", "webserver"]
