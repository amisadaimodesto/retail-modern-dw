#!/usr/bin/env bash
set -e

echo "=========================================="
echo " [1/5] INICIANDO INGESTAO NA CAMADA RAW   "
echo "=========================================="
python -m src.ingest_raw

cd dbt_dw

echo "=========================================="
echo " [2/5] TESTANDO INTEGRIDADE DAS FONTES    "
echo "=========================================="
dbt test --select source:raw --profiles-dir .

echo "=========================================="
echo " [3/5] COMPILANDO STAGING E DW_GOLD       "
echo "=========================================="
dbt run --profiles-dir .

echo "=========================================="
echo " [4/5] PROCESSANDO HISTORICO (SCD TIPO 2) "
echo "=========================================="
dbt snapshot --profiles-dir .

echo "=========================================="
echo " [5/5] EXECUTANDO TESTES ANALITICOS       "
echo "=========================================="
dbt test --select dw_gold --profiles-dir .

echo "=========================================="
echo " ESTEIRA ELT/DW CONCLUIDA COM SUCESSO!    "
echo "=========================================="
