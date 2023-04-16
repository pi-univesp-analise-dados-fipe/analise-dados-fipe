﻿CREATE TABLE [fipe_dw].[DW_FTO_DADOS_MODELO] (
    [COD_MES_REFERENCIA]   INT           NOT NULL,
    [COD_MODELO]           INT           NOT NULL,
    [COD_TIPO_VEICULO]     TINYINT       NOT NULL,
    [COD_TIPO_COMBUSTIVEL] TINYINT       NOT NULL,
    [NUM_ANO_MODELO]       CHAR (5)      NULL,
    [VLR_MODELO]           MONEY         NOT NULL,
    [DTA_INCLUSAO]         DATETIME2 (2) CONSTRAINT [DF_DW_FTO_DADOS_MODELO_DTA_INCLUSAO] DEFAULT (getdate()) NULL,
    [DTA_ATUALIZACAO]      DATETIME2 (2) NULL,
    CONSTRAINT [FK_DW_FTO_DADOS_MODELO_MODELO] FOREIGN KEY ([COD_MODELO]) REFERENCES [fipe_dw].[DW_DIM_MODELO] ([COD_MODELO]),
    CONSTRAINT [FK_DW_FTO_DADOS_MODELO_TEMPO_MENSAL] FOREIGN KEY ([COD_MES_REFERENCIA]) REFERENCES [fipe_dw].[DW_DIM_TEMPO_MENSAL] ([COD_MES_REFERENCIA]),
    CONSTRAINT [FK_DW_FTO_DADOS_MODELO_TIPO_COMBUSTIVEL] FOREIGN KEY ([COD_TIPO_COMBUSTIVEL]) REFERENCES [fipe_dw].[DW_DIM_TIPO_COMBUSTIVEL] ([COD_TIPO_COMBUSTIVEL]),
    CONSTRAINT [FK_DW_FTO_DADOS_MODELO_TIPO_VEICULO] FOREIGN KEY ([COD_TIPO_VEICULO]) REFERENCES [fipe_dw].[DW_DIM_TIPO_VEICULO] ([COD_TIPO_VEICULO])
);






GO
CREATE CLUSTERED INDEX IXC_DW_FTO_DADOS_MODELO ON  fipe_dw.DW_FTO_DADOS_MODELO (
	[COD_MES_REFERENCIA]	,
	[COD_MODELO]			,
	[NUM_ANO_MODELO]		
)
GO

