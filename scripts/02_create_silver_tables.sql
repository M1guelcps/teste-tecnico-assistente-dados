CREATE TABLE silver_usuarios (
    user_id INTEGER PRIMARY KEY,
    nome_completo VARCHAR(100),
    email VARCHAR(250),
    cidade VARCHAR(255),
    empresa VARCHAR(255),
    dominio_email VARCHAR(100),
    dt_processamento TIMESTAMP
);

CREATE TABLE silver_posts (
    post_id INTEGER,
    user_id INTEGER,
    titulo TEXT,
    conteudo VARCHAR(500),
    dt_processamento TIMESTAMP,
    qtd_palavras_titulo INTEGER
    
);