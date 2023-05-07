CREATE TABLE [fipe_stg].[STG_INDICE_VEICULO] (
    [DSC_MES]                     NVARCHAR (10)  NULL,
    [QTD_LICENCIAMENTO]           INT            NULL,
    [QTD_LICENCIAMENTO_NACIONAL]  INT            NULL,
    [QTD_LICENCIAMENTO_IMPORTADO] INT            NULL,
    [QTD_PRODUCAO]                INT            NULL,
    [QTD_EXPORTACAO]              INT            NULL,
    [TPO_VEICULO]                 NVARCHAR (255) NULL
);


GO
CREATE CLUSTERED INDEX [IXC_STG_INDICE_VEICULO]
    ON [fipe_stg].[STG_INDICE_VEICULO]([DSC_MES] ASC, [TPO_VEICULO] ASC);

