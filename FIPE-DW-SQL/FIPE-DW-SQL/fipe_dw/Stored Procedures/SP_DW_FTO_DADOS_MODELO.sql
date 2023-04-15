﻿CREATE PROCEDURE [fipe_dw].[SP_DW_FTO_DADOS_MODELO]
AS
BEGIN
	DECLARE @DTA_EXECUCAO DATETIME2(2) = GETDATE()
	MERGE INTO fipe_dw.DW_FTO_DADOS_MODELO  WITH (TABLOCK) AS DESTINO
		USING (											
			SELECT 
				 COD_MES_REFERENCIA
				,COD_MODELO
				,COD_TIPO_VEICULO
				,COD_TIPO_COMBUSTIVEL
				,NUM_ANO_MODELO
				,VLR_MODELO
			FROM fipe_ods.ODS_DADOS_MODELO DM (NOLOCK)
		) AS ORIGEM
	ON 
		(
			DESTINO.[COD_MES_REFERENCIA] 	= ORIGEM.[COD_MES_REFERENCIA] 	AND 
			DESTINO.[COD_MODELO] 			= ORIGEM.[COD_MODELO] 			AND 
			DESTINO.[NUM_ANO_MODELO]		= ORIGEM.[NUM_ANO_MODELO]		
		)
	WHEN NOT MATCHED THEN
		INSERT
			(	
				  COD_MES_REFERENCIA
				, COD_MODELO
				, COD_TIPO_VEICULO
				, COD_TIPO_COMBUSTIVEL
				, NUM_ANO_MODELO
				, VLR_MODELO
				, DTA_INCLUSAO
			)	
			VALUES
			(	
				  ORIGEM.COD_MES_REFERENCIA
				, ORIGEM.COD_MODELO
				, ORIGEM.COD_TIPO_VEICULO
				, ORIGEM.COD_TIPO_COMBUSTIVEL
				, ORIGEM.NUM_ANO_MODELO
				, ORIGEM.VLR_MODELO
				, @DTA_EXECUCAO
			)																					
	WHEN MATCHED AND
	(    
		(ORIGEM.COD_TIPO_VEICULO		<>	DESTINO.COD_TIPO_VEICULO		OR	(ORIGEM.COD_TIPO_VEICULO		IS NULL AND DESTINO.COD_TIPO_VEICULO		IS NOT NULL)	OR	(ORIGEM.COD_TIPO_VEICULO		IS NOT NULL AND DESTINO.COD_TIPO_VEICULO		IS NULL))	OR
		(ORIGEM.COD_TIPO_COMBUSTIVEL	<>	DESTINO.COD_TIPO_COMBUSTIVEL	OR	(ORIGEM.COD_TIPO_COMBUSTIVEL	IS NULL AND DESTINO.COD_TIPO_COMBUSTIVEL	IS NOT NULL)	OR	(ORIGEM.COD_TIPO_COMBUSTIVEL	IS NOT NULL AND DESTINO.COD_TIPO_COMBUSTIVEL	IS NULL))	OR 
		(ORIGEM.VLR_MODELO				<>	DESTINO.VLR_MODELO				OR	(ORIGEM.VLR_MODELO				IS NULL AND DESTINO.VLR_MODELO				IS NOT NULL)	OR	(ORIGEM.VLR_MODELO				IS NOT NULL AND DESTINO.VLR_MODELO				IS NULL))	
	)
	THEN UPDATE
		SET
			DESTINO.COD_TIPO_VEICULO	=	ORIGEM.COD_TIPO_VEICULO		,
			DESTINO.COD_TIPO_COMBUSTIVEL=	ORIGEM.COD_TIPO_COMBUSTIVEL	,
			DESTINO.VLR_MODELO			=	ORIGEM.VLR_MODELO			,	
			DESTINO.DTA_ATUALIZACAO		=	@DTA_EXECUCAO 
	;	
END