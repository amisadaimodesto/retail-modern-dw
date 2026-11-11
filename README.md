# Retail Modern Data Warehouse & Analytics Engineering

<p align="left">
  <img src="https://img.shields.io/badge/PostgreSQL-16-336791?style=for-the-badge&logo=postgresql&logoColor=white" alt="PostgreSQL" />
  <img src="https://img.shields.io/badge/dbt_Core-1.8.7-FF694B?style=for-the-badge&logo=dbt&logoColor=white" alt="dbt" />
  <img src="https://img.shields.io/badge/Python-3.12-3776AB?style=for-the-badge&logo=python&logoColor=white" alt="Python" />
  <img src="https://img.shields.io/badge/Docker-Engine-2496ED?style=for-the-badge&logo=docker&logoColor=white" alt="Docker" />
  <img src="https://img.shields.io/badge/Ubuntu_24.04-WSL2-E95420?style=for-the-badge&logo=ubuntu&logoColor=white" alt="Ubuntu" />
  <img src="https://img.shields.io/badge/Git-VCS-F05032?style=for-the-badge&logo=git&logoColor=white" alt="Git" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License" />
</p>

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
git clone https://github.com/amisadaimodesto/retail-modern-dw
cd retail-modern-dw
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
