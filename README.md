# docker-airflow with orcal client

## Informations

* Based on python:2.7.12 official Image
* Install [Docker](https://www.docker.com/)
* Install [Docker Compose](https://docs.docker.com/compose/install/)
* Following the Airflow release from [Python Package Index](https://pypi.python.org/pypi/airflow)

## Build
* If your airflow task needs to access the oracle DB, you shluld download the oracle client basic and sdk from oracle site. Put instantclient-basic-linux.x64-12.1.0.2.0.zip and instantclient-sdk-linux.x64-12.1.0.2.0.zip under ~/docker-airflow/orcle folder.

* If you need to install [Extra Packages](http://pythonhosted.org/airflow/installation.html#extra-package), edit the Dockerfile and add other options.

        cd ~/docker-airflow
        docker build --rm -t wth/airflow .

# Usage

Start the stack (mysql, rabbitmq, airflow-webserver, airflow-scheduler airflow-flower & airflow-worker) :

        cd ~/docker-airflow
        docker-compose up -d

Check [Airflow Documentation](http://pythonhosted.org/airflow/)

## UI Links

- Airflow: [localhost:8080](http://localhost:8080/)
- Flower: [localhost:5555](http://localhost:5555/)
- RabbitMQ: [localhost:15672](http://localhost:15672/)


