
CREATE TABLE [fipe_ods].[ODS_MES_REFERENCIA] (
    [COD_MES_REFERENCIA] INT           NOT NULL,
    [NME_MES_REFERENCIA] VARCHAR (20)  NULL,
    [DTA_INCLUSAO]       DATETIME2 (2) CONSTRAINT [DF_ODS_MES_REFERENCIA_DTA_INCLUSAO] DEFAULT (getdate()) NULL,
    [DTA_ATUALIZACAO]    DATETIME2 (2) NULL,
    [NME_MES]            AS            (reverse(parsename(replace(reverse(ltrim(rtrim([NME_MES_REFERENCIA]))),'/','.'),(1)))),
    [NUM_ANO]            AS            (reverse(parsename(replace(reverse(ltrim(rtrim([NME_MES_REFERENCIA]))),'/','.'),(2)))),
    [NUM_MES]            AS            (case reverse(parsename(replace(reverse(ltrim(rtrim([NME_MES_REFERENCIA]))),'/','.'),(1))) when 'janeiro' then (1) when 'fevereiro' then (2) when 'março' then (3) when 'abril' then (4) when 'maio' then (5) when 'junho' then (6) when 'julho' then (7) when 'agosto' then (8) when 'setembro' then (9) when 'outubro' then (10) when 'novembro' then (11) when 'dezembro' then (12)  end),
    [COD_ANO_MES]        AS            (concat(reverse(parsename(replace(reverse(ltrim(rtrim([NME_MES_REFERENCIA]))),'/','.'),(2))),right('0'+CONVERT([varchar](2),case reverse(parsename(replace(reverse(ltrim(rtrim([NME_MES_REFERENCIA]))),'/','.'),(1))) when 'janeiro' then (1) when 'fevereiro' then (2) when 'março' then (3) when 'abril' then (4) when 'maio' then (5) when 'junho' then (6) when 'julho' then (7) when 'agosto' then (8) when 'setembro' then (9) when 'outubro' then (10) when 'novembro' then (11) when 'dezembro' then (12)  end),(2)))),
    CONSTRAINT [PK_ODS_MES_REFERENCIA] PRIMARY KEY CLUSTERED ([COD_MES_REFERENCIA] ASC)
);




GO
