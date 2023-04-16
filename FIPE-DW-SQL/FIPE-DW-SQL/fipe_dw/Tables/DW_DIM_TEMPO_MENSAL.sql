CREATE TABLE [fipe_dw].[DW_DIM_TEMPO_MENSAL] (
    [COD_MES_REFERENCIA]  INT           NOT NULL,
    [NUM_MES]             INT           NULL,
    [NME_MES_CURTO]       CHAR (3)      NULL,
    [NME_MES]             VARCHAR (10)  NULL,
    [NUM_ANO]             SMALLINT      NULL,
    [NME_MES_ANO_LONGO]   VARCHAR (20)  NULL,
    [NME_MES_ANO]         AS            (concat([NME_MES_CURTO],'/',[NUM_ANO])),
    [NUM_TRIMESTRE]       AS            (datename(quarter,TRY_CAST(concat([NUM_ANO],'-',[NUM_MES],'-01') AS [date]))),
    [NME_TRIMESTRE]       AS            (concat(datename(quarter,TRY_CAST(concat([NUM_ANO],'-',[NUM_MES],'-01') AS [date])),'º Trimestre')),
    [NME_TRIMESTRE_LONGO] AS            (concat(datename(quarter,TRY_CAST(concat([NUM_ANO],'-',[NUM_MES],'-01') AS [date])),'º Trimestre de ',[NUM_ANO])),
    [NUM_SEMESTRE]        AS            (case when datepart(month,[NUM_MES])<(7) then (1) else (2) end),
    [NME_SEMESTRE]        AS            (concat(case when datepart(month,[NUM_MES])<(7) then (1) else (2) end,'º Semestre')),
    [NME_SEMESTRE_LONGO]  AS            (concat(case when datepart(month,[NUM_MES])<(7) then (1) else (2) end,'º Semestre de ',[NUM_ANO])),
    [DTA_INCLUSAO]        DATETIME2 (2) CONSTRAINT [DF_DIM_TEMPO_MENSAL_DTA_INCLUSAO] DEFAULT (getdate()) NULL,
    [DTA_ATUALIZACAO]     DATETIME2 (2) NULL,
    [FLG_ATIVO]           BIT           CONSTRAINT [DF_DIM_TEMPO_MENSAL_FLG_ATIVO] DEFAULT ((0)) NULL,
    [NUM_ANO_MES]         AS            (CONVERT([int],concat([NUM_ANO],case when [NUM_MES]<(10) then concat('0',CONVERT([varchar](4),[NUM_MES])) else CONVERT([varchar](4),[NUM_MES]) end))),
    CONSTRAINT [PK_DW_DIM_TEMPO] PRIMARY KEY CLUSTERED ([COD_MES_REFERENCIA] ASC)
);




GO

GO
 
