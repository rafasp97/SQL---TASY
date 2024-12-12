SELECT
    c.ie_tipo_complemento,
    a.cd_pessoa_fisica,
    CASE 
        WHEN d.nm_social IS NOT NULL THEN 'de nome social ' || UPPER(d.nm_social)
        ELSE UPPER(a.nm_paciente)
    END AS nome,
    a.nr_cpf AS cpf,
    CASE
        WHEN a.nr_identidade IS NULL THEN '__________________'
        ELSE a.nr_identidade
    END AS rg,
    a.ds_endereco AS endereco,
    a.ds_bairro AS bairro,
    upper(c.ds_municipio) AS cidade,
    c.sg_estado AS uf,
    TO_CHAR(sysdate, 'dd') || ' de ' || TO_CHAR(sysdate, 'FMMonth') || ' de ' || TO_CHAR(sysdate, 'YYYY') AS data
FROM
    atendimento_paciente_v a
JOIN
    compl_pessoa_fisica c on a.cd_pessoa_fisica = c.cd_pessoa_fisica
LEFT JOIN 
    pessoa_fisica d ON a.cd_pessoa_fisica = d.cd_pessoa_fisica
WHERE
    nr_atendimento = :nr_atendimento
AND     
    c.ie_tipo_complemento = 1