CREATE TABLE silver_usuarios (
    usuario_id INTEGER,
    nome VARCHAR(255),
    username VARCHAR(255),
    email VARCHAR(255),
    data_carga TIMESTAMP
);

CREATE TABLE silver_posts (
    post_id INTEGER,
    usuario_id INTEGER,
    titulo TEXT,
    conteudo TEXT,
    data_carga TIMESTAMP
);