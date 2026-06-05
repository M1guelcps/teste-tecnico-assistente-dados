INSERT INTO gold_metricas_usuario (
    user_id,
    nome_usuario,
    cidade,
    empresa,
    total_posts,
    media_palavras_titulo,
    primeiro_post_titulo,
    dt_processamento
)
WITH primeiro_post AS (
    SELECT
        user_id,
        titulo,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY post_id
        ) AS rn
    FROM silver_posts
),
metricas AS (
    SELECT
        user_id,
        COUNT(*) AS total_posts,
        AVG(qtd_palavras_titulo) AS media_palavras_titulo
    FROM silver_posts
    GROUP BY user_id
)
SELECT
    u.user_id,
    u.nome_completo AS nome_usuario,
    u.cidade,
    u.empresa,
    m.total_posts,
    m.media_palavras_titulo,
    p.titulo AS primeiro_post_titulo,
    CURRENT_TIMESTAMP AS dt_processamento
FROM silver_usuarios u
JOIN metricas m
    ON u.user_id = m.user_id
JOIN primeiro_post p
    ON u.user_id = p.user_id
WHERE p.rn = 1;