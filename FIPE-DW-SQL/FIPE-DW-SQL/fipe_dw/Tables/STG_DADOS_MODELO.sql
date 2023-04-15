﻿CREATE TABLE [fipe_stg].[STG_DADOS_MODELO] (
    [COD_MES_REFERENCIA]   INT           NULL,
    [COD_MODELO]           INT           NULL,
    [COD_MARCA]            INT           NULL,
    [COD_TIPO_VEICULO]     INT           NULL,
    [COD_TIPO_COMBUSTIVEL] INT           NULL,
    [NUM_ANO_MODELO]       CHAR (4)      NULL,
    [COD_FIPE]             VARCHAR (10)  NULL,
    [VLR_MODELO]           VARCHAR (16)  NULL,
    [DTA_INCLUSAO]         DATETIME2 (2) CONSTRAINT [DF_STG_DADOS_MODELO_DTA_INCLUSAO] DEFAULT (getdate()) NULL
);




GO
CREATE CLUSTERED INDEX [IXC_STG_DADOS_MODELO]
    ON [fipe_stg].[STG_DADOS_MODELO]([COD_MES_REFERENCIA] ASC, [COD_MODELO] ASC, [NUM_ANO_MODELO] ASC);