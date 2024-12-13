SELECT
    A.cd_pessoa_fisica,
    A.nm_paciente AS nome,
    B.ie_tipo_complemento,
    A.nr_cpf AS cpf,
    A.dt_nascimento AS dataNasc,
    obter_compl_pf(A.cd_pessoa_fisica, 1, 'E') AS residencia,
    B.ds_bairro AS bairro,
    B.ds_municipio AS cidade,
    B.sg_estado AS uf,
    B.cd_cep AS cep,
    obter_compl_pf(C.cd_pessoa_fisica, 1, 'PAIS') AS pais,
    obter_valor_dominio(5, C.ie_estado_civil) AS estado_civil,
    obter_naturalidade_pf(A.cd_pessoa_fisica, 'M') AS naturalidade,
    obter_naturalidade_pf(A.cd_pessoa_fisica, 'UF') AS naturalidade_uf,
    NAC.ds_nacionalidade AS naciondalide,
    CASE
        WHEN C.ie_grau_instrucao = 1 THEN 'Analfabeto(A)'
        WHEN C.ie_grau_instrucao = 11 THEN 'Não Alfabetizado(A)'
        WHEN C.ie_grau_instrucao = 10 THEN 'Ensino Primário'
        WHEN C.ie_grau_instrucao = 7 THEN 'Fundamental Incompleto'
        WHEN C.ie_grau_instrucao = 2 THEN 'Fundamental Completo'
        WHEN C.ie_grau_instrucao = 8 THEN 'Ensino Médio Incompleto'
        WHEN C.ie_grau_instrucao = 3 THEN 'Ensino Médio Completo'
        WHEN C.ie_grau_instrucao = 9 THEN 'Superior Incompleto'
        WHEN C.ie_grau_instrucao = 4 THEN 'Superior Completo'
        WHEN C.ie_grau_instrucao = 15 THEN 'Nível Técnico Completo'
        WHEN C.ie_grau_instrucao = 12 THEN 'Pós-graduação'
        WHEN C.ie_grau_instrucao = 5 THEN 'Mestre(A)'
        WHEN C.ie_grau_instrucao = 6 THEN 'Doutor(A)'
        WHEN C.ie_grau_instrucao = 13 THEN 'Ph.D'
        ELSE ''
    END AS escolaridade,
    C.nr_telefone_celular AS telefone,
    A.nr_identidade AS rg,
    C.ds_orgao_emissor_ci AS emissor,
    C.nr_cartao_nac_sus AS cns,
    A.dt_internacao AS data_internacao,
    A.ds_idade AS idade,
    SUBSTR(A.DS_SEXO, 1, 1) AS sexo,
    COR.ds_cor_pele AS cor,
    REL.ds_religiao AS religiao,
    obter_cargo_PF(c.cd_pessoa_fisica, 'D') AS profissao, -- CADASTRO SIMPLIFICADO DE PESSOAS
    PAI.nm_contato AS nomePai,
    MAE.nm_contato AS nomeMae,
    RESP.nm_contato AS nomeResp,
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
    obter_compl_pf(RESP.cd_pessoa_fisica, 3, 'E') AS enderecoResp,
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
    A.nm_unidade_basica AS unidade,
    CASE
        WHEN E.cd_tipo_acomodacao = 3 THEN 'ENFERMARIA'
        ELSE ''
    END AS tipoQuarto,
    REGEXP_REPLACE(A.cd_unidade_basica, '[^A-Za-z]', '') AS quarto,
    REGEXP_REPLACE(A.cd_unidade_basica, '[^0-9]', '') AS leito,
    CASE
        WHEN obter_conv_pf_atend(A.cd_pessoa_fisica, 'D') = 'SUS-Sistema Unico de Saude' THEN 'SUS'
        ELSE obter_conv_pf_atend(A.cd_pessoa_fisica, 'D')
    END AS convenio,
    A.cd_usuario_convenio AS carteira,
    D.dt_alta_interno AS dataAlta
FROM 
    atendimento_paciente_v A
LEFT JOIN
    compl_pessoa_fisica B ON A.cd_pessoa_fisica = B.cd_pessoa_fisica
LEFT JOIN
    pessoa_fisica C ON A.cd_pessoa_fisica = C.cd_pessoa_fisica
LEFT JOIN
    atendimento_paciente D ON A.nr_atendimento = D.nr_atendimento
LEFT JOIN
    atend_categoria_convenio E ON A.nr_atendimento = E.nr_atendimento
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
WHERE     
    A.nr_atendimento = :nr_atendimento
AND     
    B.ie_tipo_complemento = 1