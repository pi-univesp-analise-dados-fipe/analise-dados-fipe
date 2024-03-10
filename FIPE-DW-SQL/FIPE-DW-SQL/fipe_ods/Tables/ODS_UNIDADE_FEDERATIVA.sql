CREATE TABLE [fipe_ods].[ODS_UNIDADE_FEDERATIVA] (
    [COD_UF]           SMALLINT      NOT NULL,
	[NME_UF]           VARCHAR (30)  NULL,
    [SGL_UF]           VARCHAR (2)   NULL,
    [COD_REGIAO]       TINYINT       NULL,
    [DTA_INCLUSAO]     DATETIME2 (2) CONSTRAINT [DF_ODS_UNIDADE_FEDERATIVA] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ODS_UNIDADE_FEDERATIVA] PRIMARY KEY CLUSTERED ([COD_UF] ASC)
);

/*
INSERT INTO [fipe_ods].[ODS_UNIDADE_FEDERATIVA] 
(
COD_UF
, NME_UF
, SGL_UF
, COD_REGIAO
)
VALUES
(11, 	'Rondônia'				, 'RO',	1),
(12, 	'Acre'					, 'AC',	1),
(13, 	'Amazonas'				, 'AM',	1),
(14, 	'Roraima'				, 'RR',	1),
(15, 	'Pará'					, 'PA',	1),
(16, 	'Amapá'					, 'AP',	1),
(17, 	'Tocantins'				, 'TO',	1),
(21, 	'Maranhão'				, 'MA',	2),
(22, 	'Piauí'					, 'PI',	2),
(23, 	'Ceará'					, 'CE',	2),
(24, 	'Rio Grande do Norte'	, 'RN',	2),
(25, 	'Paraíba'				, 'PB',	2),
(26, 	'Pernambuco'			, 'PE',	2),
(27, 	'Alagoas'				, 'AL',	2),
(28, 	'Sergipe'				, 'SE',	2),
(29, 	'Bahia'					, 'BA',	2),
(31, 	'Minas Gerais'			, 'MG',	3),
(32, 	'Espírito Santo'		, 'ES',	3),
(33, 	'Rio de Janeiro'		, 'RJ',	3),
(35, 	'São Paulo'				, 'SP',	3),
(41, 	'Paraná'				, 'PR',	4),
(42, 	'Santa Catarina'		, 'SC',	4),
(43, 	'Rio Grande do Sul'		, 'RS',	4),
(50, 	'Mato Grosso do Sul'	, 'MS',	5),
(51, 	'Mato Grosso'			, 'MT',	5),
(52, 	'Goiás'					, 'GO',	5),
(53, 	'Distrito Federal'		, 'DF',	5)
*/