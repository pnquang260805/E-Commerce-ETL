import os

from airflow import DAG, task
from airflow.providers.apache.spark.operators.spark_submit import SparkSubmitOperator
from datetime import datetime, timedelta
from dotenv import load_dotenv

load_dotenv()

MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY")
MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY")


default_args = {
    "owner": "airflow",
    "depends_on_past": False,
    "email": ["your_email@example.com"],
    "email_on_failure": False,
    "email_on_retry": False,
    "retries": 1,
    "retry_delay": timedelta(minutes=5),
    "start_date": datetime(2025, 4, 13),
}

with DAG(
    dag_id="etl_dag",
    default_args=default_args,
    schedule_interval="@daily",
    catchup=False,
    description="A simple DAG to run a PySpark job using SparkSubmitOperator",
) as dag:
    ebay_job = SparkSubmitOperator(
        task_id="ebay-id",
        application="/opt/app/src/job/ebay_job.py",
        conn_id="etl_project",
        conf={
            "spark.master": "spark://spark-master:7077",
            "spark.jars": "/opt/spark/jars/clickhouse-jdbc-0.7.1.jar, /opt/spark/jars/httpclient5-5.4.4.jar, /opt/spark/jars/httpcore5-5.3.jar, /opt/spark/jars/httpcore5-h2-5.3.jar    "
        },
        verbose=True,
    )

    ebay_job
