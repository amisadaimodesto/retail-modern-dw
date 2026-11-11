# Retail Modern Data Warehouse & Analytics Engineering

Pipeline ponta a ponta de Analytics Engineering e Modern Data Warehouse implementado com PostgreSQL em container Docker, Python para ingestão ELT sintética e `dbt-core` para modelagem dimensional, governança e testes automatizados.

---

## 🏛 Arquitetura e Fluxo de Dados

A arquitetura segue o paradigma ELT estruturado em schemas isolados no PostgreSQL:

1. **Camada Operacional / Raw (`raw`)**: Tabelas carregadas via Python (`src/ingest_raw.py`) simulando sistemas transacionais: `clientes`, `lojas`, `produtos` e `vendas` (com registros duplicados propositais para testes de qualidade).
2. **Camada de Staging (`staging`)**: Views no dbt que padronizam tipos de dados, aplicam limpeza cadastral e deduplicam transações por janela analítica (`ROW_NUMBER()`).
3. **Camada de Armazenamento Dimensional (`dw_gold`)**: Modelagem Star Schema estrita seguindo a metodologia Kimball:
   - `dim_clientes`: Chave substituta (MD5) e atributos do consumidor.
   - `dim_lojas`: Hierarquia regional e localização.
   - `dim_produtos`: Margens unitárias teóricas e categorização.
   - `dim_calendario`: Dimensão temporal com métricas de calendário civil e flags de fim de semana.
   - `fato_vendas`: Tabela de fatos com métricas transacionais de receita, desconto, custo e lucro bruto.
   - `snap_produtos_scd2`: Snapshot com rastreamento histórico de alterações de preços cadastrais (SCD Tipo 2).
   - `dm_vendas_mensal_categoria`: Datamart agregado para consumo de BI e dashboards executivos.

---

## 🛠 Stack Tecnológica

- **Banco de Dados**: PostgreSQL 16 (Docker Compose)
- **Transformação e Modelagem**: dbt-core 1.8.7 (`dbt-postgres` 1.8.2)
- **Ingestão e Geração de Dados**: Python 3.12, SQLAlchemy, Pandas, Faker
- **Controle de Versão**: Git
- **Ambiente de Execução**: Ubuntu 24.04 LTS (WSL2)

---

## 🚀 Como Executar o Projeto

### 1. Clonar o repositório e ativar o ambiente virtual

```bash
git clone <URL_DO_REPOSITORIO>
cd retail-modern-dw
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt