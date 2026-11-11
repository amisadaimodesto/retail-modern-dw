import random
from datetime import datetime, timedelta
import pandas as pd
from faker import Faker
from sqlalchemy import create_engine, text

fake = Faker("pt_BR")
random.seed(42)
Faker.seed(42)

DB_URL = "postgresql://dw_admin:dw_secure_password123@localhost:5432/retail_dw"
engine = create_engine(DB_URL)

def gerar_lojas(qtd=20):
    estados_regioes = [
        ("SP", "São Paulo", "Sudeste"),
        ("RJ", "Rio de Janeiro", "Sudeste"),
        ("MG", "Belo Horizonte", "Sudeste"),
        ("PR", "Curitiba", "Sul"),
        ("RS", "Porto Alegre", "Sul"),
        ("BA", "Salvador", "Nordeste"),
        ("DF", "Brasília", "Centro-Oeste"),
        ("GO", "Goiânia", "Centro-Oeste")
    ]
    lojas = []
    for i in range(1, qtd + 1):
        uf, cidade, regiao = random.choice(estados_regioes)
        lojas.append({
            "id_loja": i,
            "nome_loja": f"Loja {cidade} #{i}",
            "cidade": cidade,
            "estado": uf,
            "regiao": regiao,
            "data_inauguracao": fake.date_between(start_date="-5y", end_date="-1y"),
            "criado_em": datetime.now()
        })
    return pd.DataFrame(lojas)

def gerar_produtos(qtd=30):
    categorias = {
        "Eletrônicos": (300.0, 3500.0, 0.25),
        "Móveis": (150.0, 1800.0, 0.35),
        "Vestuário": (30.0, 250.0, 0.45),
        "Alimentos": (5.0, 80.0, 0.20),
        "Informática": (100.0, 4200.0, 0.22)
    }
    produtos = []
    for i in range(1, qtd + 1):
        cat = random.choice(list(categorias.keys()))
        preco_min, preco_max, margem = categorias[cat]
        preco = round(random.uniform(preco_min, preco_max), 2)
        custo = round(preco * (1.0 - margem), 2)
        produtos.append({
            "id_produto": i,
            "nome_produto": f"Produto {cat} Ref-{i:03d}",
            "categoria": cat,
            "custo_padrao": custo,
            "preco_tabela": preco,
            "criado_em": datetime.now()
        })
    return pd.DataFrame(produtos)

def gerar_clientes(qtd=300):
    clientes = []
    for i in range(1, qtd + 1):
        clientes.append({
            "id_cliente": i,
            "nome_cliente": fake.name(),
            "cpf": fake.cpf(),
            "email": fake.free_email(),
            "cidade": fake.city(),
            "estado": fake.state_abbr(),
            "data_registro": fake.date_between(start_date="-3y", end_date="today"),
            "criado_em": datetime.now()
        })
    return pd.DataFrame(clientes)

def gerar_vendas(df_lojas, df_produtos, df_clientes, qtd=5000):
    ids_lojas = df_lojas["id_loja"].tolist()
    ids_produtos = df_produtos["id_produto"].tolist()
    dict_precos = dict(zip(df_produtos["id_produto"], df_produtos["preco_tabela"]))
    dict_custos = dict(zip(df_produtos["id_produto"], df_produtos["custo_padrao"]))
    ids_clientes = df_clientes["id_cliente"].tolist()

    data_base = datetime(2026, 1, 1)
    transacoes = []
    for i in range(1, qtd + 1):
        id_prod = random.choice(ids_produtos)
        qtd_itens = random.randint(1, 5)
        preco = dict_precos[id_prod]
        custo = dict_custos[id_prod]
        desconto_pct = random.choice([0.0, 0.0, 0.05, 0.10, 0.15])
        
        valor_bruto = round(preco * qtd_itens, 2)
        valor_desconto = round(valor_bruto * desconto_pct, 2)
        valor_liquido = round(valor_bruto - valor_desconto, 2)
        custo_total = round(custo * qtd_itens, 2)
        
        data_transacao = data_base + timedelta(days=random.randint(0, 310), hours=random.randint(8, 21), minutes=random.randint(0, 59))
        
        transacoes.append({
            "id_transacao": f"TX-{i:06d}",
            "id_loja": random.choice(ids_lojas),
            "id_cliente": random.choice(ids_clientes),
            "id_produto": id_prod,
            "quantidade": qtd_itens,
            "preco_unitario": preco,
            "desconto_aplicado": valor_desconto,
            "valor_liquido": valor_liquido,
            "custo_total": custo_total,
            "data_transacao": data_transacao,
            "status_pagamento": random.choice(["APROVADO", "APROVADO", "APROVADO", "CANCELADO"])
        })
    
    duplicadas = random.choices(transacoes, k=50)
    transacoes.extend(duplicadas)
    
    return pd.DataFrame(transacoes)

def run():
    print("--- INICIANDO INGESTAO NA CAMADA RAW ---")
    df_lojas = gerar_lojas()
    df_produtos = gerar_produtos()
    df_clientes = gerar_clientes()
    df_vendas = gerar_vendas(df_lojas, df_produtos, df_clientes)

    with engine.begin() as conn:
        print("Truncando tabelas existentes na camada raw...")
        conn.execute(text("TRUNCATE TABLE raw.vendas, raw.clientes, raw.produtos, raw.lojas;"))

        print("Carregando raw.lojas...")
        df_lojas.to_sql("lojas", conn, schema="raw", if_exists="append", index=False)
        print("Carregando raw.produtos...")
        df_produtos.to_sql("produtos", conn, schema="raw", if_exists="append", index=False)
        print("Carregando raw.clientes...")
        df_clientes.to_sql("clientes", conn, schema="raw", if_exists="append", index=False)
        print("Carregando raw.vendas...")
        df_vendas.to_sql("vendas", conn, schema="raw", if_exists="append", index=False)

    print("--- INGESTAO CONCLUIDA COM SUCESSO ---")

if __name__ == "__main__":
    run()
