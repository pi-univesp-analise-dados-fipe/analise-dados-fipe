﻿CREATE TABLE [fipe_ods].[ODS_DADOS_MODELO](
	[COD_MES_REFERENCIA]	[int] NULL,
	[COD_MODELO]			[int] NULL,
	[COD_MARCA]				[int] NULL,
	[COD_TIPO_VEICULO]		[int] NULL,
	[COD_TIPO_COMBUSTIVEL]	[int] NULL,
	[NUM_ANO_MODELO]		[int] NULL,
	[VLR_MODELO]			[money]	NULL,
	[DTA_INCLUSAO]			[datetime2](2) NULL,
	[DTA_ATUALIZACAO]		[datetime2](2) NULL, 
	CONSTRAINT FK_ODS_DADOS_MODELO_MODELO FOREIGN KEY (COD_MARCA) REFERENCES fipe_ods.ODS_MARCA (COD_MARCA), 
	CONSTRAINT FK_ODS_DADOS_MODELO_MARCA FOREIGN KEY (COD_MODELO) REFERENCES fipe_ods.ODS_MODELO (COD_MODELO), 
	CONSTRAINT FK_ODS_DADOS_MODELO_REFERENCIA FOREIGN KEY (COD_MES_REFERENCIA) REFERENCES fipe_ods.ODS_MES_REFERENCIA ([COD_MES_REFERENCIA])
)
GO
CREATE CLUSTERED INDEX [IXC_ODS_DADOS_MODELO]
    ON [fipe_ods].[ODS_DADOS_MODELO]([COD_MES_REFERENCIA] ASC, [COD_MODELO] ASC, [NUM_ANO_MODELO] ASC);
GO
ALTER TABLE [fipe_ods].[ODS_DADOS_MODELO] 
	ADD  CONSTRAINT [DF_ODS_DADOS_MODELO_DTA_INCLUSAO]  DEFAULT (getdate()) FOR [DTA_INCLUSAO]
GO