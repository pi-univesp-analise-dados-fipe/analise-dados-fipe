﻿
CREATE   PROCEDURE [fipe_ods].[SP_ODS_MARCA] 
AS
BEGIN
	DECLARE @DTA_EXECUCAO DATETIME2(2) = GETDATE()
	MERGE INTO fipe_ods.ODS_MARCA WITH (TABLOCK) AS DESTINO
		USING (											
			SELECT DISTINCT
				   COD_MARCA
				 , NME_MARCA
				 , COD_TIPO_VEICULO
			FROM  fipe_stg.STG_MARCA (NOLOCK)
			   ) AS ORIGEM
	ON 
		(
			DESTINO.COD_MARCA	=	ORIGEM.COD_MARCA
		)
	WHEN NOT MATCHED THEN
		INSERT
			(	
				COD_MARCA,
				NME_MARCA,
				COD_TIPO_VEICULO, 
				DTA_INCLUSAO
			)	
			VALUES
			(	
				ORIGEM.COD_MARCA,
				ORIGEM.NME_MARCA,
				ORIGEM.COD_TIPO_VEICULO,
				@DTA_EXECUCAO
			)																					
	WHEN MATCHED AND
	(    
		(ORIGEM.NME_MARCA			<>	DESTINO.NME_MARCA			OR	(ORIGEM.NME_MARCA			IS NULL AND DESTINO.NME_MARCA			IS NOT NULL)	OR	(ORIGEM.NME_MARCA			IS NOT NULL AND DESTINO.NME_MARCA			IS NULL))	OR
		(ORIGEM.COD_TIPO_VEICULO	<>	DESTINO.COD_TIPO_VEICULO	OR	(ORIGEM.COD_TIPO_VEICULO	IS NULL AND DESTINO.COD_TIPO_VEICULO	IS NOT NULL)	OR	(ORIGEM.COD_TIPO_VEICULO	IS NOT NULL AND DESTINO.COD_TIPO_VEICULO	IS NULL))
	)
		THEN
		UPDATE SET
			DESTINO.NME_MARCA			= ORIGEM.NME_MARCA			,
			DESTINO.COD_TIPO_VEICULO	= ORIGEM.COD_TIPO_VEICULO	,
			DESTINO.DTA_ATUALIZACAO		= @DTA_EXECUCAO
	;	
END