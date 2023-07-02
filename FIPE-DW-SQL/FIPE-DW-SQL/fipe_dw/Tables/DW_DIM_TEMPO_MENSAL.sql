CREATE TABLE [fipe_dw].[DW_DIM_TEMPO_MENSAL] (
    [COD_ANO_MES]             INT           NOT NULL,
    [COD_MES_REFERENCIA_FIPE] INT           NULL,
    [NUM_MES]                 AS            (CONVERT([int],right([COD_ANO_MES],(2)))),
    [NUM_ANO]                 AS            (left([COD_ANO_MES],(4))),
    [NME_MES]                 AS            (datename(month,concat([COD_ANO_MES],'01'))),
    [NME_MES_CURTO]           AS            (left(datename(month,concat([COD_ANO_MES],'01')),(3))),
    [NME_MES_ANO]             AS            (concat(left(datename(month,concat([COD_ANO_MES],'01')),(3)),'/',left([COD_ANO_MES],(4)))),
    [NME_MES_ANO_LONGO]       AS            (concat(datename(month,concat([COD_ANO_MES],'01')),'/',left([COD_ANO_MES],(4)))),
    [NUM_TRIMESTRE]           AS            (datename(quarter,TRY_CAST(concat(left([COD_ANO_MES],(4)),'-',CONVERT([int],right([COD_ANO_MES],(2))),'-01') AS [date]))),
    [NME_TRIMESTRE]           AS            (concat(datename(quarter,TRY_CAST(concat(left([COD_ANO_MES],(4)),'-',CONVERT([int],right([COD_ANO_MES],(2))),'-01') AS [date])),'º Trimestre')),
    [NME_TRIMESTRE_LONGO]     AS            (concat(datename(quarter,TRY_CAST(concat(left([COD_ANO_MES],(4)),'-',CONVERT([int],right([COD_ANO_MES],(2))),'-01') AS [date])),'º Trimestre de ',left([COD_ANO_MES],(4)))),
    [NUM_SEMESTRE]            AS            (case when datepart(month,CONVERT([int],right([COD_ANO_MES],(2))))<(7) then (1) else (2) end),
    [NME_SEMESTRE]            AS            (concat(case when datepart(month,CONVERT([int],right([COD_ANO_MES],(2))))<(7) then (1) else (2) end,'º Semestre')),
    [NME_SEMESTRE_LONGO]      AS            (concat(case when datepart(month,CONVERT([int],right([COD_ANO_MES],(2))))<(7) then (1) else (2) end,'º Semestre de ',left([COD_ANO_MES],(4)))),
    [DTA_INCLUSAO]            DATETIME2 (2) CONSTRAINT [DF_DIM_TEMPO_MENSAL_DTA_INCLUSAO] DEFAULT (getdate()) NULL,
    [DTA_ATUALIZACAO]         DATETIME2 (2) NULL,
    [FLG_ATIVO]               BIT           CONSTRAINT [DF_DIM_TEMPO_MENSAL_FLG_ATIVO] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_DW_DIM_TEMPO_MENSAL] PRIMARY KEY CLUSTERED ([COD_ANO_MES] ASC)
);


GO

/*

-- Script de criação de dimensão de tempo mensal (granularidade a nivel de mes)
SET LANGUAGE Portuguese

DROP TABLE IF EXISTS fipe_dw.DW_DIM_TEMPO_MENSAL
CREATE TABLE fipe_dw.DW_DIM_TEMPO_MENSAL (
    [NUM_ANO_MES]				INT				NOT NULL,
	[COD_MES_REFERENCIA_FIPE]	INT				NULL,
    [NUM_MES]					AS				CAST(RIGHT([NUM_ANO_MES], 2) AS INT) ,
	[NUM_ANO]					AS				LEFT([NUM_ANO_MES], 4),
    [NME_MES]					AS				DATENAME(MM, CONCAT([NUM_ANO_MES], '01')), 
	[NME_MES_CURTO]				AS				LEFT(DATENAME(MM, CONCAT([NUM_ANO_MES], '01')), 3),
    [NME_MES_ANO]				AS				(CONCAT(LEFT(DATENAME(MM, CONCAT([NUM_ANO_MES], '01')), 3),'/',LEFT([NUM_ANO_MES], 4))),
	[NME_MES_ANO_LONGO]			AS				(CONCAT(DATENAME(MM, CONCAT([NUM_ANO_MES], '01')),'/',LEFT([NUM_ANO_MES], 4))),
	[NUM_TRIMESTRE]				AS				(DATENAME(QUARTER,TRY_CAST(CONCAT(LEFT([NUM_ANO_MES], 4),'-',CAST(RIGHT([NUM_ANO_MES], 2) AS INT),'-01') AS [DATE]))),
    [NME_TRIMESTRE]				AS				(CONCAT(DATENAME(QUARTER,TRY_CAST(CONCAT(LEFT([NUM_ANO_MES], 4),'-',CAST(RIGHT([NUM_ANO_MES], 2) AS INT),'-01') AS [DATE])),'º Trimestre')),
    [NME_TRIMESTRE_LONGO]		AS				(CONCAT(DATENAME(QUARTER,TRY_CAST(CONCAT(LEFT([NUM_ANO_MES], 4),'-',CAST(RIGHT([NUM_ANO_MES], 2) AS INT),'-01') AS [DATE])),'º Trimestre de ',LEFT([NUM_ANO_MES], 4))),
    [NUM_SEMESTRE]				AS				(CASE WHEN DATEPART(MONTH,CAST(RIGHT([NUM_ANO_MES], 2) AS INT))<(7) THEN (1) ELSE (2) END),
    [NME_SEMESTRE]				AS				(CONCAT(CASE WHEN DATEPART(MONTH,CAST(RIGHT([NUM_ANO_MES], 2) AS INT))<(7) THEN (1) ELSE (2) END,'º Semestre')),
    [NME_SEMESTRE_LONGO]		AS				(CONCAT(CASE WHEN DATEPART(MONTH,CAST(RIGHT([NUM_ANO_MES], 2) AS INT))<(7) THEN (1) ELSE (2) END,'º Semestre de ',LEFT([NUM_ANO_MES], 4))),
    [DTA_INCLUSAO]				DATETIME2(2)	CONSTRAINT [DF_DIM_TEMPO_MENSAL_DTA_INCLUSAO] DEFAULT (GETDATE()) NULL,
    [DTA_ATUALIZACAO]			DATETIME2(2)	NULL,
    [FLG_ATIVO]					BIT				CONSTRAINT [DF_DIM_TEMPO_MENSAL_FLG_ATIVO] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_DW_DIM_TEMPO_MENSAL] PRIMARY KEY CLUSTERED ([NUM_ANO_MES] ASC)
);

DECLARE @DTA_INICIO DATE	= '2005-01-01', 
		@DTA_TERMINO DATE	= '2030-01-01',
		@DTA_REGISTRO DATE  
SET  @DTA_REGISTRO  = @DTA_INICIO

WHILE @DTA_REGISTRO   <= @DTA_TERMINO
BEGIN 
	INSERT INTO fipe_dw.DW_DIM_TEMPO_MENSAL
	(
	  NUM_ANO_MES
	)
	VALUES (
		CONCAT(YEAR(@DTA_REGISTRO), RIGHT('0' + CAST(MONTH(@DTA_REGISTRO) AS varchar(2)), 2)) /*add 0 em todos os campos e extrai os 2 ultimos caracteres da direita para esquerda*/
	)
	SET @DTA_REGISTRO = DATEADD(MM, 1, @DTA_REGISTRO)
END 
 select * from fipe_dw.DW_DIM_TEMPO_MENSAL





 

*/




 
