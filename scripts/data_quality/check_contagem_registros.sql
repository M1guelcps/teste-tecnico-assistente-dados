-- Compara quantidade de registros entre camadas

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