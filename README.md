# Explicação das Queries SQL

## Camada Silver - Usuários

A tabela `silver_usuarios` é responsável por armazenar os dados de usuários já tratados e padronizados a partir da camada RAW.

### Query

```sql
INSERT INTO silver_usuarios (
    user_id,
    nome_completo,
    email,
    cidade,
    empresa,
    dominio_email,
    dt_processamento
)
SELECT
    id AS user_id,
    name AS nome_completo,
    email,
    address_city AS cidade,
    company_name AS empresa,
    SUBSTRING(email FROM POSITION('@' IN email) + 1) AS dominio_email,
    CURRENT_TIMESTAMP AS dt_processamento
FROM raw_usuarios;
```

### Transformações realizadas

#### Renomeação de colunas

As colunas da API foram convertidas para nomes padronizados em português:

| RAW          | SILVER        |
| ------------ | ------------- |
| id           | user_id       |
| name         | nome_completo |
| address_city | cidade        |
| company_name | empresa       |

#### Extração do domínio do e-mail

A função abaixo extrai apenas a parte do domínio do endereço de e-mail:

```sql
SUBSTRING(email FROM POSITION('@' IN email) + 1)
```

Exemplo:

| Email                                               | Domínio        |
| --------------------------------------------------- | -------------- |
| [joao@gmail.com](mailto:joao@gmail.com)             | gmail.com      |
| [maria@empresa.com.br](mailto:maria@empresa.com.br) | empresa.com.br |

Essa informação pode ser utilizada posteriormente para análises por provedor de e-mail ou empresa.

#### Data de processamento

```sql
CURRENT_TIMESTAMP
```

Registra a data e hora em que o dado foi processado pela camada Silver.

---

## Camada Silver - Posts

A tabela `silver_posts` contém os posts já tratados para consumo analítico.

### Query

```sql
INSERT INTO silver_posts (
    post_id,
    user_id,
    titulo,
    conteudo,
    dt_processamento,
    qtd_palavras_titulo
)
SELECT
    id AS post_id,
    user_id,
    title AS titulo,
    SUBSTRING(REPLACE(body, E'\n', ' ') FROM 1 FOR 500) AS conteudo,
    CURRENT_TIMESTAMP AS dt_processamento,
    LENGTH(title) - LENGTH(REPLACE(title, ' ', '')) + 1 AS qtd_palavras_titulo
FROM raw_posts;
```

### Transformações realizadas

#### Renomeação do título

```sql
title AS titulo
```

Padroniza o nome da coluna para português.

#### Remoção de quebras de linha

```sql
REPLACE(body, E'\n', ' ')
```

Substitui caracteres de quebra de linha por espaços em branco.

Exemplo:

Antes:

```text
Primeira linha
Segunda linha
```

Depois:

```text
Primeira linha Segunda linha
```

#### Limitação do conteúdo para 500 caracteres

```sql
SUBSTRING(... FROM 1 FOR 500)
```

Mantém apenas os primeiros 500 caracteres do texto.

Objetivos:

* Padronização dos registros.
* Redução de armazenamento.
* Melhoria de performance em consultas analíticas.

#### Quantidade de palavras do título

```sql
LENGTH(title) - LENGTH(REPLACE(title, ' ', '')) + 1
```

Calcula a quantidade de palavras presentes no título.

Exemplo:

Título:

```text
meu primeiro post
```

Quantidade de espaços:

```text
2
```

Quantidade de palavras:

```text
2 + 1 = 3
```

#### Data de processamento

```sql
CURRENT_TIMESTAMP
```

Armazena o momento em que o registro foi processado pela camada Silver.

---

## Camada Gold - Métricas por Usuário

A camada Gold possui dados agregados voltados para análise e tomada de decisão.

### Objetivos

* Calcular quantidade total de posts por usuário.
* Calcular média de palavras dos títulos.
* Identificar o primeiro post de cada usuário.
* Consolidar informações de usuários e posts em uma única visão analítica.

### Técnicas utilizadas

#### CTE (Common Table Expression)

Utilizada para organizar etapas intermediárias da consulta e melhorar a legibilidade.

#### Window Function

```sql
ROW_NUMBER() OVER (
    PARTITION BY user_id
    ORDER BY post_id
)
```

Numera os posts de cada usuário individualmente.

Isso permite identificar qual foi o primeiro post publicado.

#### Agregações

```sql
COUNT(*)
AVG(qtd_palavras_titulo)
```

Calculam respectivamente:

* Quantidade total de posts.
* Média de palavras utilizadas nos títulos.

#### JOIN

```sql
JOIN silver_usuarios
JOIN silver_posts
```

Combina informações cadastrais dos usuários com suas métricas de postagem.

### Resultado Final

A tabela `gold_metricas_usuario` fornece uma visão consolidada contendo:

* Dados do usuário.
* Cidade.
* Empresa.
* Quantidade de posts.
* Média de palavras dos títulos.
* Primeiro post publicado.
* Data de processamento.

Essa camada é otimizada para consumo analítico e construção de dashboards.
