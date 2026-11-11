WITH source AS (
    SELECT * FROM {{ source('raw', 'clientes') }}
)
SELECT
    id_cliente,
    TRIM(nome_cliente) AS nome_cliente,
    cpf,
    LOWER(TRIM(email)) AS email,
    TRIM(cidade) AS cidade,
    UPPER(TRIM(estado)) AS estado,
    CAST(data_registro AS DATE) AS data_registro,
    criado_em
FROM source
