SELECT 
    c.ie_tipo_complemento,
    a.cd_pessoa_fisica,
    CASE 
        WHEN d.nm_social IS NOT NULL THEN 'Nome Social do paciente: ' || UPPER(d.nm_social)
        ELSE 'Nome Completo do paciente: ' || UPPER(a.nm_paciente)
    END AS nome,
    a.dt_nascimento AS dataNasc,
    a.nr_cpf AS cpf,
    CASE   
        WHEN c.nm_contato IS NULL THEN '_____________________________________________'
        ELSE UPPER(c.nm_contato)
    END AS nomeResp,
    CASE
        WHEN c.nr_cpf IS NULL THEN '______________________'
        ELSE c.nr_cpf
    END AS cpfResp,
    CASE
        WHEN c.nr_seq_parentesco = 1 THEN 'IRMÃ(O)'
        WHEN c.nr_seq_parentesco = 2 THEN 'AMIGO'
        WHEN c.nr_seq_parentesco = 3 THEN 'TIO(A)'
        WHEN c.nr_seq_parentesco = 4 THEN 'PRIMO(A)'
        WHEN c.nr_seq_parentesco = 5 THEN 'AVÔ(Ó)'
        WHEN c.nr_seq_parentesco = 6 THEN 'MÃE'
        WHEN c.nr_seq_parentesco = 7 THEN 'PAI'
        WHEN c.nr_seq_parentesco = 8 THEN 'SOBRINHO(A)'
        WHEN c.nr_seq_parentesco = 9 THEN 'CUNHADO(A)'
        WHEN c.nr_seq_parentesco = 10 THEN 'CÔNJUGE/COMPANHEIRA(O)'
        ELSE '___________________'
    END AS grau,
    TO_CHAR(SYSDATE, 'dd') || ' de ' || TO_CHAR(SYSDATE, 'FMMonth') || ' de ' || TO_CHAR(SYSDATE, 'YYYY') AS data,
    TO_CHAR(SYSDATE, 'HH24:MI') AS hora
FROM
    atendimento_paciente_v a
JOIN compl_pessoa_fisica c ON a.cd_pessoa_fisica = c.cd_pessoa_fisica
LEFT JOIN 
    pessoa_fisica d ON a.cd_pessoa_fisica = d.cd_pessoa_fisica
WHERE
    nr_atendimento = :nr_atendimento
    AND c.ie_tipo_complemento = (
        SELECT MAX(c2.ie_tipo_complemento)
        FROM compl_pessoa_fisica c2
        WHERE c2.cd_pessoa_fisica = a.cd_pessoa_fisica
          AND ((c2.ie_tipo_complemento = 1 AND c2.nr_cpf IS NULL)
               OR (c2.ie_tipo_complemento = 3 AND a.nr_cpf != c2.nr_cpf))
    )