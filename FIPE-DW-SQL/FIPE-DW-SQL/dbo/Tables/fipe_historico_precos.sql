CREATE TABLE [dbo].[fipe_historico_precos] (
    [COD_HISTORICO]      NVARCHAR (50)   NULL,
    [COD_FIPE]           NVARCHAR (50)   NULL,
    [NME_MARCA]          NVARCHAR (50)   NULL,
    [NME_MODELO]         NVARCHAR (50)   NULL,
    [NUM_ANO_MODELO]     NVARCHAR (50)   NULL,
    [NUM_MES_REFERENCIA] NVARCHAR (50)   NULL,
    [NUM_ANO_REFERENCIA] NVARCHAR (50)   NULL,
    [VLR_MODELO]         DECIMAL (10, 2) NULL
);


GO
CREATE NONCLUSTERED INDEX [ix_01_tabela_fipe_historico_precos]
    ON [dbo].[fipe_historico_precos]([NUM_MES_REFERENCIA] ASC);


GO
CREATE CLUSTERED INDEX [ixc_tabela_fipe_historico_precos]
    ON [dbo].[fipe_historico_precos]([COD_HISTORICO] ASC);

