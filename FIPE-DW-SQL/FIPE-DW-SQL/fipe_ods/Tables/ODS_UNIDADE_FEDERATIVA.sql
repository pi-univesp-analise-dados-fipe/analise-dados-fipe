﻿CREATE TABLE [fipe_ods].[ODS_UNIDADE_FEDERATIVA] (
    [COD_UF]           SMALLINT      NOT NULL,
    [SGL_UF]           VARCHAR (2)   NULL,
    [SGL_ISO3166_2]    VARCHAR (5)   NULL,
    [NME_UF]           VARCHAR (30)  NULL,
    [DSC_URL_WEBSITE]  VARCHAR (50)  NULL,
    [DSC_URL_BANDEIRA] VARCHAR (250) NULL,
    [COD_REGIAO]       TINYINT       NULL,
    [DTA_INCLUSAO]     DATETIME2 (2) CONSTRAINT [DF_ODS_UNIDADE_FEDERATIVA] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_ODS_UNIDADE_FEDERATIVA] PRIMARY KEY CLUSTERED ([COD_UF] ASC)
);

