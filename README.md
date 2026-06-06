---

# Orquestração com Apache Airflow

O pipeline foi estruturado utilizando Apache Airflow para orquestrar as etapas de extração, transformação e agregação dos dados seguindo a arquitetura RAW → SILVER → GOLD.

## DAG 1 - Extração RAW

**Arquivo:** `dags/dag_raw_extract.py`

### Objetivo

Extrair os dados da API e carregá-los nas tabelas da camada RAW.

### Configuração

```python
dag_id = 'etl_raw_extract'
schedule_interval = '0 6 * * *'
catchup = False
max_active_runs = 1
```

### Fluxo

```text
start
   │
   ├── extract_usuarios
   │
   └── extract_posts
   │
end
```

### Tasks

| Task             | Função                                           |
| ---------------- | ------------------------------------------------ |
| start            | Início da execução                               |
| extract_usuarios | Extrai usuários da API e carrega em raw_usuarios |
| extract_posts    | Extrai posts da API e carrega em raw_posts       |
| end              | Finalização da DAG                               |

---

## DAG 2 - Transformação SILVER

**Arquivo:** `dags/dag_silver_transform.py`

### Objetivo

Transformar os dados da camada RAW para a camada SILVER.

### Configuração

```python
dag_id = 'etl_silver_transform'
schedule_interval = '30 6 * * *'
catchup = False
max_active_runs = 1
```

### Fluxo

```text
start
   │
   ├── transform_usuarios
   │
   └── transform_posts
   │
end
```

### Tasks

| Task               | Função                             |
| ------------------ | ---------------------------------- |
| start              | Início da execução                 |
| transform_usuarios | Executa raw_to_silver_usuarios.sql |
| transform_posts    | Executa raw_to_silver_posts.sql    |
| end                | Finalização da DAG                 |

---

## DAG 3 - Agregação GOLD

**Arquivo:** `dags/dag_gold_aggregate.py`

### Objetivo

Gerar métricas analíticas consolidadas na camada GOLD.

### Configuração

```python
dag_id = 'etl_gold_aggregate'
schedule_interval = '0 7 * * *'
catchup = False
max_active_runs = 1
```

### Fluxo

```text
start
   │
create_metricas_usuario
   │
end
```

### Tasks

| Task                    | Função                              |
| ----------------------- | ----------------------------------- |
| start                   | Início da execução                  |
| create_metricas_usuario | Executa silver_to_gold_metricas.sql |
| end                     | Finalização da DAG                  |

---

# Data Quality

Foram implementadas consultas SQL para validação da qualidade dos dados após as transformações.

Os scripts estão localizados em:

```text
scripts/data_quality/
```

## Verificação de E-mails Inválidos

**Arquivo:** `check_usuarios_email.sql`

### Objetivo

Identificar usuários sem e-mail ou com formato inválido.

### Query

```sql
SELECT *
FROM silver_usuarios
WHERE email IS NULL
   OR email NOT LIKE '%@%';
```

### Resultado Esperado

```text
0 registros
```

---

## Verificação de Posts Duplicados

**Arquivo:** `check_posts_duplicados.sql`

### Objetivo

Garantir a unicidade dos posts na camada Silver.

### Query

```sql
SELECT
    post_id,
    COUNT(*) AS qtd
FROM silver_posts
GROUP BY post_id
HAVING COUNT(*) > 1;
```

### Resultado Esperado

```text
0 registros
```

---

## Verificação de Contagem de Registros

**Arquivo:** `check_contagem_registros.sql`

### Objetivo

Validar que nenhuma transformação perdeu registros entre as camadas.

### Query

```sql
SELECT 'raw_usuarios' AS tabela, COUNT(*) AS qtd
FROM raw_usuarios

UNION ALL

SELECT 'silver_usuarios', COUNT(*)
FROM silver_usuarios

UNION ALL

SELECT 'raw_posts', COUNT(*)
FROM raw_posts

UNION ALL

SELECT 'silver_posts', COUNT(*)
FROM silver_posts;
```

### Resultado Esperado

| Tabela          | Quantidade |
| --------------- | ---------- |
| raw_usuarios    | 10         |
| silver_usuarios | 10         |
| raw_posts       | 100        |
| silver_posts    | 100        |

---

# Arquitetura do Pipeline

```text
API JSONPlaceholder
        │
        ▼
┌─────────────────┐
│   RAW Layer     │
├─────────────────┤
│ raw_usuarios    │
│ raw_posts       │
└─────────────────┘
        │
        ▼
┌─────────────────┐
│  SILVER Layer   │
├─────────────────┤
│ silver_usuarios │
│ silver_posts    │
└─────────────────┘
        │
        ▼
┌──────────────────────┐
│      GOLD Layer      │
├──────────────────────┤
│ gold_metricas_usuario│
└──────────────────────┘
```

Acredito que no final do texto pelo menos, eu escreva com as minhas palavras.
Obviamente o teste teve auxílio de IA para correção e resumo para o README.md, eu não possuo experiência
profissional em uma empresa, apenas em projetos pessoais acadêmicos, mas ainda assim
gosto de me desafiar e abraçar as oportunidades.

Eu conheço sobre algumas arquiteturas, e nesse projeto vi que o ideal seria a medalhão, que justamente traz
os conceitos de RAW, silver e Gold.

Mas acredito que consegui absorver a ideia do teste, que seria criar uma rotina
para a pipeline, usamos Airflow para orquestrar a rotina, python para extrair os dados da api,
e formatação do json, ou outro tipo de dado, e query's para transformação das informações no
banco de dados.

Desde já agradeço imensamente pela oportunidade de participar do teste.
