SELECT 
    CASE 
        WHEN d.nm_social IS NOT NULL THEN 'Nome Social do paciente: ' || UPPER(d.nm_social)
        ELSE 'Nome Completo do paciente: ' || UPPER(a.nm_paciente)
    END AS NM_PACIENTE,
    a.dt_nascimento AS dataNasc,
    a.DT_NASCIMENTO,
    a.NR_ATENDIMENTO,
    a.NR_CPF,
    a.NR_IDENTIDADE
FROM 
    ATENDIMENTO_PACIENTE_V a
LEFT JOIN 
    pessoa_fisica d ON a.cd_pessoa_fisica = d.cd_pessoa_fisica
WHERE 
    NR_ATENDIMENTO = :NR_ATENDIMENTO