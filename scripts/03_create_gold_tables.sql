CREATE TABLE gold_metricas_usuario (
    user_id INTEGER PRIMARY KEY,
    nome_usuario VARCHAR(100),
    cidade VARCHAR(255),
    empresa VARCHAR(255),
    total_posts INTEGER,
    media_palavras_titulo FLOAT,
    primeiro_post_titulo TEXT,
    dt_processamento TIMESTAMP
);