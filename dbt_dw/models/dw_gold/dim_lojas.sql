WITH source AS (
    SELECT * FROM {{ ref('stg_lojas') }}
)
SELECT
    MD5(CAST(id_loja AS TEXT)) AS sk_loja,
    id_loja AS nk_loja,
    nome_loja,
    cidade,
    estado,
    regiao,
    data_inauguracao,
    criado_em AS data_carga
FROM source
