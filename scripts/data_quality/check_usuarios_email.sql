
SELECT *
FROM silver_usuarios
WHERE email IS NULL
   OR email NOT LIKE '%@%';