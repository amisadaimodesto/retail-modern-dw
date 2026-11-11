WITH vendas AS (
    SELECT * FROM {{ ref('stg_vendas') }}
),
lojas AS (
    SELECT sk_loja, nk_loja FROM {{ ref('dim_lojas') }}
),
clientes AS (
    SELECT sk_cliente, nk_cliente FROM {{ ref('dim_clientes') }}
),
produtos AS (
    SELECT sk_produto, nk_produto FROM {{ ref('dim_produtos') }}
)
SELECT
    MD5(CAST(v.id_transacao AS TEXT)) AS sk_venda,
    v.id_transacao AS nk_transacao,
    TO_CHAR(v.data_venda, 'YYYYMMDD')::INT AS id_tempo,
    l.sk_loja,
    c.sk_cliente,
    p.sk_produto,
    v.quantidade,
    v.preco_unitario,
    ROUND(v.quantidade * v.preco_unitario, 2) AS valor_bruto,
    v.desconto_aplicado,
    v.valor_liquido,
    v.custo_total,
    ROUND(v.valor_liquido - v.custo_total, 2) AS margem_bruta_lucro,
    v.status_pagamento,
    v.data_transacao
FROM vendas v
LEFT JOIN lojas l ON v.id_loja = l.nk_loja
LEFT JOIN clientes c ON v.id_cliente = c.nk_cliente
LEFT JOIN produtos p ON v.id_produto = p.nk_produto
