INSERT INTO silver_usuarios (
    user_id,
    nome_completo,
    email,
    cidade,
    empresa,
    dominio_email,
    dt_processamento)

    SELECT
        id AS user_id,
        name AS nome_completo,
        email,
        address_city AS cidade,
        company_name AS empresa,
        SUBSTRING(email FROM POSITION('@' IN email) + 1) AS dominio_email,
        CURRENT_TIMESTAMP AS dt_processamento
    FROM raw_usuarios;