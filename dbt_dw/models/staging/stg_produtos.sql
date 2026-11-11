WITH source AS (
    SELECT * FROM {{ source('raw', 'produtos') }}
)
SELECT
    id_produto,
    TRIM(nome_produto) AS nome_produto,
    TRIM(categoria) AS categoria,
    CAST(custo_padrao AS NUMERIC(12, 2)) AS custo_padrao,
    CAST(preco_tabela AS NUMERIC(12, 2)) AS preco_tabela,
    criado_em
FROM source
