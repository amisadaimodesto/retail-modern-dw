WITH source AS (
    SELECT * FROM {{ ref('stg_clientes') }}
)
SELECT
    MD5(CAST(id_cliente AS TEXT)) AS sk_cliente,
    id_cliente AS nk_cliente,
    nome_cliente,
    cpf,
    email,
    cidade,
    estado,
    data_registro,
    criado_em AS data_carga
FROM source
