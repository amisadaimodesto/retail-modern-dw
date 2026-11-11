-- Relatório Executivo: Faturamento e Rentabilidade Regional por Categoria
SELECT 
    regiao,
    categoria,
    SUM(total_pedidos) AS total_pedidos,
    SUM(total_itens_vendidos) AS total_itens_vendidos,
    ROUND(SUM(faturamento_liquido), 2) AS receita_liquida_total,
    ROUND(SUM(lucro_bruto_total), 2) AS lucro_bruto_total,
    ROUND((SUM(lucro_bruto_total) / NULLIF(SUM(faturamento_liquido), 0)) * 100, 2) AS margem_bruta_real_pct
FROM dw_gold.dm_vendas_mensal_categoria
GROUP BY regiao, categoria
ORDER BY receita_liquida_total DESC;
