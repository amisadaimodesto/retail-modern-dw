WITH datas AS (
    SELECT generate_series(
        '2025-01-01'::DATE,
        '2026-12-31'::DATE,
        '1 day'::INTERVAL
    )::DATE AS data_dia
)
SELECT
    TO_CHAR(data_dia, 'YYYYMMDD')::INT AS id_tempo,
    data_dia,
    EXTRACT(YEAR FROM data_dia)::INT AS ano,
    EXTRACT(MONTH FROM data_dia)::INT AS mes,
    TO_CHAR(data_dia, 'TMMonth') AS nome_mes,
    EXTRACT(QUARTER FROM data_dia)::INT AS trimestre,
    EXTRACT(ISODOW FROM data_dia)::INT AS dia_semana,
    TO_CHAR(data_dia, 'TMDay') AS nome_dia_semana,
    CASE WHEN EXTRACT(ISODOW FROM data_dia) IN (6, 7) THEN TRUE ELSE FALSE END AS flag_fim_de_semana
FROM datas
