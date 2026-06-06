from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.empty import EmptyOperator

from datetime import datetime, timedelta

from src.execute_sql import execute_sql_file

default_args = {
    "owner": "miguel",
    "retries": 1
}

with DAG(
    dag_id="etl_gold_aggregate",
    start_date=datetime(2025, 1, 1),
    schedule="0 7 * * *",
    catchup=False,
    max_active_runs=1,
    default_args=default_args,
    tags=["gold", "aggregate", "analytics"]
) as dag:

    start = EmptyOperator(
        task_id="start"
    )

    create_metricas_usuario = PythonOperator(
        task_id="create_metricas_usuario",
        python_callable=execute_sql_file,
        op_args=["sql/silver_to_gold_metricas.sql"]
    )

    end = EmptyOperator(
        task_id="end"
    )

    start >> create_metricas_usuario >> end