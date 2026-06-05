INSERT INTO silver_posts (post_id, user_id, title, body, dt_processamento,qtd_palavras_titulo, conteudo)
    SELECT
        id AS post_id,
        user_id,
        title AS titulo,
        SUBSTRING(REPLACE(body, E'\n', ' ') FROM 1 FOR 500) AS conteudo,
        CURRENT_TIMESTAMP AS dt_processamento,
        LENGTH(title) - LENGTH(REPLACE(title, ' ', '')) + 1 AS qtd_palavras_titulo
    FROM raw_posts;