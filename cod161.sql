SELECT
    A.nr_atendimento,
    A.cd_pessoa_fisica,
    A.nm_paciente AS nome,
    A.dt_internacao AS dataEntrada,
    A.dt_nascimento AS dataNasc,
    A.DS_SETOR_LEITO AS leito,
    A.ds_convenio AS convenio,
    A.ds_anos AS idade,
    A.nr_identidade AS rg,
    A.nr_cpf AS cpf,
    A.nr_cartao_nac_sus AS cardSUS,
    A.cd_usuario_convenio AS carteira,
    A.nr_telefone_celular AS fone,
    A.ds_endereco AS endereco,
    A.ds_bairro AS bairro,
    A.cd_cep AS cep,
    UPPER(B.ds_municipio) AS cidade,
    A.nm_medico AS profissional,
    SUS.ds_carater_internacao as carater,
    PAI.nm_contato AS nomePai,
    MAE.nm_contato AS nomeMae,
    RESP.nm_contato AS nomeResp,
    RESP.nr_cpf AS cpfResp,
    RESP.nr_telefone AS foneResp,
    obter_cargo_PF(MED.cd_pessoa_fisica, 'D') especialidade
FROM
    atendimento_paciente_v A
LEFT JOIN
    compl_pessoa_fisica B ON A.cd_pessoa_fisica = B.cd_pessoa_fisica
     AND B.IE_TIPO_COMPLEMENTO IN (1)
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
    medico MED ON A.nr_crm = MED.nr_crm
lEFT JOIN
    sus_carater_internacao SUS on A.IE_CARATER_INTER_SUS = SUS.cd_carater_internacao
WHERE 
    NR_ATENDIMENTO = :NR_ATENDIMENTO