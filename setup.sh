#!/usr/bin/env bash
set -e

echo "=========================================="
echo "   CONFIGURAÇÃO AUTOMÁTICA DO PROJETO     "
echo "=========================================="

command -v python3 >/dev/null 2>&1 || { echo "Erro: python3 não está instalado."; exit 1; }
command -v docker >/dev/null 2>&1 || { echo "Erro: docker não está instalado."; exit 1; }

if [ ! -d ".venv" ]; then
    echo "==> Criando ambiente virtual Python (.venv)..."
    python3 -m venv .venv
fi

echo "==> Instalando/atualizando bibliotecas do requirements.txt..."
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

echo "==> Subindo banco PostgreSQL no Docker..."
docker compose up -d

echo "=========================================="
echo " INSTALAÇÃO E SETUP CONCLUÍDOS COM SUCESSO"
echo " Execute: ./run_pipeline.sh                "
echo "=========================================="
