WITH source AS (
    SELECT * FROM {{ source('raw', 'vendas') }}
),
deduplicadas AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY id_transacao 
            ORDER BY data_transacao ASC
        ) AS row_num
    FROM source
)
SELECT
    id_transacao,
    id_loja,
    id_cliente,
    id_produto,
    quantidade,
    CAST(preco_unitario AS NUMERIC(12, 2)) AS preco_unitario,
    CAST(desconto_aplicado AS NUMERIC(12, 2)) AS desconto_aplicado,
    CAST(valor_liquido AS NUMERIC(12, 2)) AS valor_liquido,
    CAST(custo_total AS NUMERIC(12, 2)) AS custo_total,
    CAST(data_transacao AS TIMESTAMP) AS data_transacao,
    CAST(data_transacao AS DATE) AS data_venda,
    status_pagamento
FROM deduplicadas
WHERE row_num = 1
