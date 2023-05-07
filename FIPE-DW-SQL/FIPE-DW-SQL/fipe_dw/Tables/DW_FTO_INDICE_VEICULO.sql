﻿CREATE TABLE [fipe_dw].[DW_FTO_INDICE_VEICULO] (
    [COD_MES_REFERENCIA]          INT           NOT NULL,
    [COD_TIPO_VEICULO]            TINYINT       NOT NULL,
    [QTD_LICENCIAMENTO_NACIONAL]  INT           NOT NULL,
    [QTD_LICENCIAMENTO_IMPORTADO] INT           NOT NULL,
    [QTD_PRODUCAO]                INT           NOT NULL,
    [QTD_EXPORTACAO]              INT           NOT NULL,
    [DTA_INCLUSAO]                DATETIME2 (2) CONSTRAINT [DF_DW_FTO_INDICE_VEICULO_DTA_INCLUSAO] DEFAULT (getdate()) NULL,
    [DTA_ATUALIZACAO]             DATETIME2 (2) NULL,
    [DTA_REFERENCIA]              AS            (CONVERT([date],CONVERT([varchar](8),concat([COD_MES_REFERENCIA],'01')))),
    CONSTRAINT [PK_DW_FTO_INDICE_VEICULO] PRIMARY KEY CLUSTERED ([COD_MES_REFERENCIA] ASC, [COD_TIPO_VEICULO] ASC),
    CONSTRAINT [FK_DW_FTO_INDICE_VEICULO_TEMPO_MENSAL] FOREIGN KEY ([COD_MES_REFERENCIA]) REFERENCES [fipe_dw].[DW_DIM_TEMPO_MENSAL] ([COD_MES_REFERENCIA])
);

