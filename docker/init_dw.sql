CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS dw_gold;

COMMENT ON SCHEMA raw IS 'Camada de dados brutos ingeridos via pipelines ELT';
COMMENT ON SCHEMA staging IS 'Camada de preparo, padronizacao e limpeza intermediaria';
COMMENT ON SCHEMA dw_gold IS 'Camada analitica final contendo dimensoes e fatos governadas via dbt';
