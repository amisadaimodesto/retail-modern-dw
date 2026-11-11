{% snapshot snap_produtos_scd2 %}

{{
    config(
        target_schema='dw_gold',
        unique_key='id_produto',
        strategy='check',
        check_cols=['custo_padrao', 'preco_tabela', 'categoria']
    )
}}

SELECT
    id_produto,
    nome_produto,
    categoria,
    custo_padrao,
    preco_tabela
FROM {{ source('raw', 'produtos') }}

{% endsnapshot %}
