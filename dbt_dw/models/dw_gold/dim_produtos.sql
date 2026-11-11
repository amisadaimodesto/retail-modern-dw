WITH source AS (
    SELECT * FROM {{ ref('stg_produtos') }}
)
SELECT
    MD5(CAST(id_produto AS TEXT)) AS sk_produto,
    id_produto AS nk_produto,
    nome_produto,
    categoria,
    custo_padrao,
    preco_tabela,
    ROUND(preco_tabela - custo_padrao, 2) AS margem_unitaria_estimada,
    ROUND(((preco_tabela - custo_padrao) / NULLIF(preco_tabela, 0)) * 100, 2) AS margem_percentual_estimada,
    criado_em AS data_carga
FROM source
