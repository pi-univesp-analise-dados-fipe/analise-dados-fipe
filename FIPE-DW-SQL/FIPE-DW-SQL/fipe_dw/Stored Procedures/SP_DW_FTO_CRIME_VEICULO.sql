﻿
-- [fipe_dw].[SP_DW_FTO_CRIME_VEICULO] @COD_ANO_MES = 202212

CREATE PROCEDURE[fipe_dw].[SP_DW_FTO_CRIME_VEICULO]
	@COD_ANO_MES		INT = NULL
-- 	@FLG_REPROCESSAMENTO	BIT 
AS
BEGIN
	SET LANGUAGE Portuguese
	DECLARE @DTA_EXECUCAO DATETIME2(2) = GETDATE()
	--IF @COD_ANO_MES IS NULL -- AND @FLG_REPROCESSAMENTO = 0 
	--	SET @COD_ANO_MES =  (SELECT LEFT(FORMAT(DATEADD(MM, 1, CAST(CONCAT(MAX(COD_ANO_MES), '01') AS DATE)), 'yyyyMMdd'), 6) 
	--							FROM fipe_dw.DW_DIM_TEMPO_MENSAL WHERE FLG_ATIVO = 1 )

	DROP TABLE IF EXISTS #FTO_CRIME_VEICULO_PIVOT
	; WITH STG_ROUBO AS (
		SELECT UF.COD_UF, 
			UF.NME_UF, 
			TIPO_CRIME, 
			ANO, 
			MES, 
			QTD_OCORRENCIA 
			FROM fipe_stg.STG_INDICADOR_SEGURANCA SG
		INNER JOIN FIPE_ODS.ODS_UNIDADE_FEDERATIVA UF 
		ON SG.UF =  UF.NME_UF
		WHERE TIPO_CRIME IN ('Furto de veículo', 'Roubo de veículo')
	) SELECT 
		COD_UF, 
		ANO, 
		MES,
		[Furto de veículo]	QTD_FURTO, 
		[Roubo de veículo]	QTD_ROUBO
	INTO #FTO_CRIME_VEICULO_PIVOT
	FROM STG_ROUBO STG
	PIVOT(SUM(QTD_OCORRENCIA) FOR TIPO_CRIME IN ([Furto de veículo], [Roubo de veículo])) AS P
	
	CREATE CLUSTERED INDEX IXC_CRIME_VEICULO ON #FTO_CRIME_VEICULO_PIVOT (COD_UF, ANO, MES)
	
		;WITH SRC_FTO_CRIME_VEICULO AS (
				SELECT 
					STG.COD_UF, 
					CONCAT(STG.ANO, RIGHT('0' + CAST(MES.NUM_MES AS VARCHAR(2)), 2))COD_ANO_MES, 
					STG.QTD_FURTO, 
					STG.QTD_ROUBO
				FROM #FTO_CRIME_VEICULO_PIVOT STG
				INNER JOIN FIPE_ODS.ODS_MES_REFERENCIA (NOLOCK) MES
				ON STG.MES = MES.NME_MES AND 
					STG.ANO = MES.NUM_ANO
			)
			SELECT COD_UF, 
					COD_ANO_MES, 
					QTD_FURTO, 
					QTD_ROUBO		
				INTO #DW_FTO_CRIME_VEICULO
			FROM SRC_FTO_CRIME_VEICULO 
			WHERE COD_ANO_MES = @COD_ANO_MES OR @COD_ANO_MES IS NULL
	CREATE CLUSTERED INDEX IXC_DW_FTO_CRIME_VEICULO ON #DW_FTO_CRIME_VEICULO (COD_UF, COD_ANO_MES)

	MERGE INTO [fipe_dw].[DW_FTO_CRIME_VEICULO] WITH (TABLOCK) AS DESTINO
		USING (													
				SELECT COD_UF, 
					COD_ANO_MES, 
					QTD_FURTO, 
					QTD_ROUBO		
				FROM  #DW_FTO_CRIME_VEICULO
				WHERE COD_ANO_MES = @COD_ANO_MES OR @COD_ANO_MES IS NULL
			
		) AS ORIGEM
	ON 
		(
			DESTINO.COD_ANO_MES		= ORIGEM.COD_ANO_MES		AND		 
			DESTINO.COD_UF			= ORIGEM.COD_UF
		)
	WHEN NOT MATCHED THEN
		INSERT
			(	
				  COD_UF
				, COD_ANO_MES
				, QTD_FURTO
				, QTD_ROUBO
				, DTA_INCLUSAO
			)	
			VALUES
			(	
				 ORIGEM.COD_UF
				,ORIGEM.COD_ANO_MES
				,ORIGEM.QTD_FURTO
				,ORIGEM.QTD_ROUBO
				,@DTA_EXECUCAO
			)																					
	WHEN MATCHED AND
	(    
		(ORIGEM.QTD_FURTO	<>	DESTINO.QTD_FURTO	OR	(ORIGEM.QTD_FURTO	IS NULL AND DESTINO.QTD_FURTO	IS NOT NULL)	OR	(ORIGEM.QTD_FURTO	IS NOT NULL AND DESTINO.QTD_FURTO	IS NULL))	OR
		(ORIGEM.QTD_ROUBO	<>	DESTINO.QTD_ROUBO	OR	(ORIGEM.QTD_ROUBO	IS NULL AND DESTINO.QTD_ROUBO	IS NOT NULL)	OR	(ORIGEM.QTD_ROUBO	IS NOT NULL AND DESTINO.QTD_ROUBO	IS NULL))			
	)
	THEN UPDATE
		SET
			DESTINO.QTD_FURTO			= 	ORIGEM.QTD_FURTO	,
			DESTINO.QTD_ROUBO			= 	ORIGEM.QTD_ROUBO	,
			DESTINO.DTA_ATUALIZACAO		=	@DTA_EXECUCAO 						
	;	
END