WITH source AS (
    SELECT * FROM {{ source('raw', 'lojas') }}
)
SELECT
    id_loja,
    TRIM(nome_loja) AS nome_loja,
    TRIM(cidade) AS cidade,
    UPPER(TRIM(estado)) AS estado,
    TRIM(regiao) AS regiao,
    CAST(data_inauguracao AS DATE) AS data_inauguracao,
    criado_em
FROM source
