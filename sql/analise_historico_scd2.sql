-- Auditoria SCD Tipo 2: Histórico de Alterações de Preço e Status de Vigência
SELECT 
    id_produto,
    nome_produto,
    preco_tabela,
    custo_padrao,
    dbt_valid_from,
    COALESCE(TO_CHAR(dbt_valid_to, 'YYYY-MM-DD HH24:MI:SS'), 'VIGENTE') AS status_registro
FROM dw_gold.snap_produtos_scd2
ORDER BY id_produto, dbt_valid_from;
