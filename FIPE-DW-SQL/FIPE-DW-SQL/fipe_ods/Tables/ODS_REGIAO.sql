CREATE TABLE [fipe_ods].[ODS_REGIAO] (
    [COD_REGIAO]   TINYINT       NOT NULL,
    [NME_REGIAO]   VARCHAR (20)  NULL,
    [SGL_REGIAO]   VARCHAR (2)   NULL,
    [DTA_INCLUSAO] DATETIME2 (2) CONSTRAINT [DF_ODS_REGIAO] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ODS_REGIAO_UF] PRIMARY KEY CLUSTERED ([COD_REGIAO] ASC)
);

/*
insert into fipe_ods.ODS_REGIAO
(
COD_REGIAO
, NME_REGIAO
, SGL_REGIAO
, DTA_INCLUSAO
)
values
 (1, 'Norte'		, 'N'	, GETDATE())
, (2, 'Nordeste'	, 'NE'	, GETDATE())
, (3, 'Sudeste'		, 'SE'	, GETDATE())
, (4, 'Sul'			, 'S'	, GETDATE())
, (5, 'Centro-Oeste', 'CE'	, GETDATE())
*/