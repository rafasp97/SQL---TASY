SELECT 
    UPPER(A.nm_paciente) AS nome,
    B.ie_tipo_complemento,
    A.nr_cpf AS cpf,
    A.dt_nascimento AS dataNasc,
    UPPER(obter_compl_pf(A.cd_pessoa_fisica, 1, 'E')) AS residencia,
    B.ds_bairro AS bairro,
    UPPER(B.ds_municipio) AS cidade,
    B.sg_estado AS uf,
    B.cd_cep AS cep,
    UPPER(obter_compl_pf(C.cd_pessoa_fisica, 1, 'PAIS')) AS pais,
    UPPER(obter_valor_dominio(5, C.ie_estado_civil)) AS estado_civil,
    UPPER(obter_naturalidade_pf(A.cd_pessoa_fisica, 'M')) AS naturalidade,
    UPPER(obter_naturalidade_pf(A.cd_pessoa_fisica, 'UF')) AS naturalidade_uf,
    NAC.ds_nacionalidade AS naciondalide,
    C.nr_telefone_celular AS telefone,
    A.nr_identidade AS rg,
    C.ds_orgao_emissor_ci AS emissor,
    C.nr_cartao_nac_sus AS cns,
    A.dt_internacao AS data_internacao,
    A.ds_idade AS idade,
    UPPER(SUBSTR(A.DS_SEXO, 1, 1)) AS sexo,
    COR.ds_cor_pele AS cor,
    REL.ds_religiao AS religiao,
    PROF.ds_profissao AS profissao,
    UPPER(PAI.nm_contato) AS nomePai,
    UPPER(MAE.nm_contato) AS nomeMae,
    UPPER(RESP.nm_contato) AS nomeResp,
    CASE
        WHEN B.nr_seq_parentesco = 1 THEN 'IRMÃ(O)'
        WHEN B.nr_seq_parentesco = 2 THEN 'AMIGO'
        WHEN B.nr_seq_parentesco = 3 THEN 'TIO(A)'
        WHEN B.nr_seq_parentesco = 4 THEN 'PRIMO(A)'
        WHEN B.nr_seq_parentesco = 5 THEN 'AVÔ(Ó)'
        WHEN B.nr_seq_parentesco = 6 THEN 'MÃE'
        WHEN B.nr_seq_parentesco = 7 THEN 'PAI'
        WHEN B.nr_seq_parentesco = 8 THEN 'SOBRINHO(A)'
        WHEN B.nr_seq_parentesco = 9 THEN 'CUNHADO(A)'
        WHEN B.nr_seq_parentesco = 10 THEN 'CÔNJUGE/COMPANHEIRA(O)'
        ELSE null
    END AS grau,
    UPPER(obter_compl_pf(RESP.cd_pessoa_fisica, 3, 'E')) AS enderecoResp,
    RESP.nr_telefone AS telefoneResp,
    RESP.ds_municipio AS cidadeResp,
    RESP.sg_estado AS UfResp,
    CASE
        WHEN RESP.nr_cpf is null THEN RESP.nr_identidade
        ELSE RESP.nr_cpf
    END AS docResp,
    CASE
        WHEN RESP.nr_cpf is null THEN 'Registro Geral'
        ELSE 'CPF'
    END AS tipoDocResp,
    A.nr_atendimento AS fia,
    UPPER(A.nm_unidade_basica) AS unidade,
    A.ds_carater_inter_sus AS tipoQuarto,
    REGEXP_REPLACE(A.cd_unidade_basica, '[^A-Za-z]', '') AS quarto,
    REGEXP_REPLACE(A.cd_unidade_basica, '[^0-9]', '') AS leito,
    obter_conv_pf_atend(A.cd_pessoa_fisica, 'D') AS convenio,
    A.cd_usuario_convenio as carteira
FROM 
    atendimento_paciente_v A
LEFT JOIN
    compl_pessoa_fisica B ON A.cd_pessoa_fisica = B.cd_pessoa_fisica
LEFT JOIN
    pessoa_fisica C ON A.cd_pessoa_fisica = C.cd_pessoa_fisica
LEFT JOIN
    compl_pessoa_fisica PAI ON A.cd_pessoa_fisica = PAI.cd_pessoa_fisica
    AND PAI.IE_TIPO_COMPLEMENTO IN (4)
LEFT JOIN
    compl_pessoa_fisica MAE ON A.cd_pessoa_fisica = MAE.cd_pessoa_fisica
    AND MAE.IE_TIPO_COMPLEMENTO IN (5)
LEFT JOIN
    compl_pessoa_fisica RESP ON A.cd_pessoa_fisica = RESP.cd_pessoa_fisica
    AND RESP.IE_TIPO_COMPLEMENTO IN (3)
LEFT JOIN
    nacionalidade NAC ON C.cd_nacionalidade = NAC.cd_nacionalidade
LEFT JOIN
    cor_pele COR ON C.nr_seq_cor_pele = COR.nr_sequencia
LEFT JOIN
    religiao REL ON C.cd_religiao = REL.cd_religiao
LEFT JOIN
    profissao PROF ON C.cd_ult_profissao = PROF.cd_profissao
WHERE     
    A.nr_atendimento = :nr_atendimento
AND     
    B.ie_tipo_complemento = 1