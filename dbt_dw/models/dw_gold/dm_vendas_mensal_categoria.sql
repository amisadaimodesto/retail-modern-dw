WITH fato AS (
    SELECT * FROM {{ ref('fato_vendas') }}
    WHERE status_pagamento = 'APROVADO'
),
tempo AS (
    SELECT * FROM {{ ref('dim_calendario') }}
),
lojas AS (
    SELECT * FROM {{ ref('dim_lojas') }}
),
produtos AS (
    SELECT * FROM {{ ref('dim_produtos') }}
)
SELECT
    t.ano,
    t.mes,
    t.nome_mes,
    l.regiao,
    l.estado,
    p.categoria,
    COUNT(DISTINCT f.nk_transacao) AS total_pedidos,
    SUM(f.quantidade) AS total_itens_vendidos,
    SUM(f.valor_bruto) AS faturamento_bruto,
    SUM(f.desconto_aplicado) AS total_descontos,
    SUM(f.valor_liquido) AS faturamento_liquido,
    SUM(f.custo_total) AS custo_total_mercadorias,
    SUM(f.margem_bruta_lucro) AS lucro_bruto_total,
    ROUND(
        (SUM(f.margem_bruta_lucro) / NULLIF(SUM(f.valor_liquido), 0)) * 100, 
        2
    ) AS margem_lucro_percentual,
    ROUND(
        SUM(f.valor_liquido) / NULLIF(COUNT(DISTINCT f.nk_transacao), 0), 
        2
    ) AS ticket_medio
FROM fato f
JOIN tempo t ON f.id_tempo = t.id_tempo
JOIN lojas l ON f.sk_loja = l.sk_loja
JOIN produtos p ON f.sk_produto = p.sk_produto
GROUP BY
    t.ano,
    t.mes,
    t.nome_mes,
    l.regiao,
    l.estado,
    p.categoria
