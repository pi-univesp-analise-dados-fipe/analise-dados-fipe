﻿CREATE TABLE [fipe_ods].[ODS_MARCA] (
    [COD_MARCA]				[int]			NOT NULL,
	[NME_MARCA]				[varchar]  (30)	NULL,
    [COD_TIPO_VEICULO]		[int]			NULL,
    [DTA_INCLUSAO]          [DATETIME2] (2) NULL,
    [DTA_ATUALIZACAO]       [DATETIME2] (2) NULL,
	CONSTRAINT PK_ODS_MARCA PRIMARY KEY (COD_MARCA)
);
GO

ALTER TABLE [fipe_ods].[ODS_MARCA] 
    ADD CONSTRAINT [DF_ODS_MARCA_DTA_INCLUSAO] DEFAULT (GETDATE()) FOR DTA_INCLUSAO