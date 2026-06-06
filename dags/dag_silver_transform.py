from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator

from datetime import datetime

from src.execute_sql import execute_sql_file

with DAG(
    dag_id="etl_silver_transform",
    start_date=datetime(2025, 1, 1),
    schedule="30 6 * * *",
    catchup=False,
    max_active_runs=1,
    tags=["silver", "transform"]
) as dag:

    start = EmptyOperator(
        task_id="start"
    )

    transform_usuarios = PythonOperator(
        task_id="transform_usuarios",
        python_callable=execute_sql_file,
        op_args=["sql/raw_to_silver_usuarios.sql"]
    )

    transform_posts = PythonOperator(
        task_id="transform_posts",
        python_callable=execute_sql_file,
        op_args=["sql/raw_to_silver_posts.sql"]
    )

    end = EmptyOperator(
        task_id="end"
    )

    start >> [transform_usuarios, transform_posts] >> end