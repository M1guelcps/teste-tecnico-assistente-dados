from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator
from datetime import datetime

from src.extract_api import extract_usuarios, extract_posts

with DAG(
    dag_id="etl_raw_extract",
    start_date=datetime(2025, 1, 1),
    schedule="0 6 * * *",
    catchup=False,
    max_active_runs=1,
    tags=["raw", "extract", "api"]
) as dag:

    start = EmptyOperator(task_id="start")

    task_extract_usuarios = PythonOperator(
        task_id="extract_usuarios",
        python_callable=extract_usuarios
    )

    task_extract_posts = PythonOperator(
        task_id="extract_posts",
        python_callable=extract_posts
    )

    end = EmptyOperator(task_id="end")

    start >> [task_extract_usuarios, task_extract_posts] >> end