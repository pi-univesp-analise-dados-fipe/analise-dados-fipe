﻿--[fipe_dw].[SP_DW_FTO_INDICE_VEICULO] @cod_ano_mes = 202212
CREATE PROCEDURE [fipe_dw].[SP_DW_FTO_INDICE_VEICULO]
	@COD_ANO_MES INT = NULL
--	@FLG_REPROCESSAMENTO BIT 
AS
BEGIN
	DECLARE @DTA_EXECUCAO DATETIME2(2) = GETDATE()
	-- IF @COD_MES_REFERENCIA IS NULL AND @FLG_REPROCESSAMENTO = 0 
	-- 	SET @COD_MES_REFERENCIA =  (SELECT MAX(COD_ANO_MES) FROM fipe_dw.DW_DIM_TEMPO_MENSAL)
	
			SELECT ods.cod_ano_mes,
		CASE 
					WHEN TPO_VEICULO = 'AUTOMÓVEIS'			THEN 1
					WHEN TPO_VEICULO = 'ÔNIBUS'				THEN 4
					WHEN TPO_VEICULO = 'CAMINHÕES'			THEN 3
					WHEN TPO_VEICULO = 'COMERCIAIS LEVES'	THEN 1
				END COD_TIPO_VEICULO,
				QTD_LICENCIAMENTO_NACIONAL,  
				QTD_LICENCIAMENTO_IMPORTADO, 
				QTD_PRODUCAO, 
				QTD_EXPORTACAO
		 INTO #DW_FTO_INDICE_VEICULO
		FROM [FIPE_STG].STG_INDICE_VEICULO STA
		inner join 	fipe_ods.ods_mes_referencia ods
		on 	CONCAT(	'20', SUBSTRING(STA.DSC_MES, 5, 2)) = ods.num_ano
			and SUBSTRING(DSC_MES, 1, 3) = SUBSTRING(ods.nme_mes_referencia, 1, 3)
		WHERE	/* carrega os dados do mes passado como parametro ou todos os meses se estiver nulo*/
		ods.cod_ano_mes = @COD_ANO_MES OR @COD_ANO_MES  IS NULL
		
		CREATE CLUSTERED INDEX IXC_DW_FTO_INDICE_VEICULO 
			ON #DW_FTO_INDICE_VEICULO (cod_ano_mes,COD_TIPO_VEICULO)

	MERGE INTO fipe_dw.DW_FTO_INDICE_VEICULO WITH (TABLOCK) AS DESTINO
		USING (													
			SELECT 
					COD_ANO_MES,
					COD_TIPO_VEICULO					,
					SUM(QTD_LICENCIAMENTO_NACIONAL)		QTD_LICENCIAMENTO_NACIONAL,	  
					SUM(QTD_LICENCIAMENTO_IMPORTADO)	QTD_LICENCIAMENTO_IMPORTADO, 
					SUM(QTD_PRODUCAO)					QTD_PRODUCAO, 
					SUM(QTD_EXPORTACAO)					QTD_EXPORTACAO
			FROM #DW_FTO_INDICE_VEICULO
			GROUP BY
					COD_ANO_MES					,
					COD_TIPO_VEICULO

		) AS ORIGEM
	ON 
		(
			DESTINO.COD_ANO_MES			= ORIGEM.COD_ANO_MES		AND		 
			DESTINO.COD_TIPO_VEICULO	= ORIGEM.COD_TIPO_VEICULO				 
		)
	WHEN NOT MATCHED THEN
		INSERT
			(	
				 COD_ANO_MES
				,COD_TIPO_VEICULO
				,QTD_LICENCIAMENTO_NACIONAL
				,QTD_LICENCIAMENTO_IMPORTADO
				,QTD_PRODUCAO
				,QTD_EXPORTACAO
				,DTA_INCLUSAO
			)	
			VALUES
			(	
				 ORIGEM.cod_ano_mes
				,ORIGEM.COD_TIPO_VEICULO
				,ORIGEM.QTD_LICENCIAMENTO_NACIONAL
				,ORIGEM.QTD_LICENCIAMENTO_IMPORTADO
				,ORIGEM.QTD_PRODUCAO
				,ORIGEM.QTD_EXPORTACAO
				,@DTA_EXECUCAO
			)																					
	WHEN MATCHED AND
	(    
		(ORIGEM.QTD_LICENCIAMENTO_NACIONAL	<>	DESTINO.QTD_LICENCIAMENTO_NACIONAL	OR	(ORIGEM.QTD_LICENCIAMENTO_NACIONAL	IS NULL AND DESTINO.QTD_LICENCIAMENTO_NACIONAL		IS NOT NULL)	OR	(ORIGEM.QTD_LICENCIAMENTO_NACIONAL	IS NOT NULL AND DESTINO.QTD_LICENCIAMENTO_NACIONAL	IS NULL))	OR
		(ORIGEM.QTD_LICENCIAMENTO_IMPORTADO	<>	DESTINO.QTD_LICENCIAMENTO_IMPORTADO	OR	(ORIGEM.QTD_LICENCIAMENTO_IMPORTADO	IS NULL AND DESTINO.QTD_LICENCIAMENTO_IMPORTADO	IS NOT NULL)	OR	(ORIGEM.QTD_LICENCIAMENTO_IMPORTADO	IS NOT NULL AND DESTINO.QTD_LICENCIAMENTO_IMPORTADO	IS NULL))	OR 
		(ORIGEM.QTD_PRODUCAO				<>	DESTINO.QTD_PRODUCAO				OR	(ORIGEM.QTD_PRODUCAO				IS NULL AND DESTINO.QTD_PRODUCAO				IS NOT NULL)	OR	(ORIGEM.QTD_PRODUCAO				IS NOT NULL AND DESTINO.QTD_PRODUCAO				IS NULL))	OR
		(ORIGEM.QTD_EXPORTACAO				<>	DESTINO.QTD_EXPORTACAO				OR	(ORIGEM.QTD_EXPORTACAO				IS NULL AND DESTINO.QTD_EXPORTACAO				IS NOT NULL)	OR	(ORIGEM.QTD_EXPORTACAO				IS NOT NULL AND DESTINO.QTD_EXPORTACAO				IS NULL))	
		
	)
	THEN UPDATE
		SET
			DESTINO.QTD_LICENCIAMENTO_NACIONAL	= 	ORIGEM.QTD_LICENCIAMENTO_NACIONAL	,
			DESTINO.QTD_LICENCIAMENTO_IMPORTADO	= 	ORIGEM.QTD_LICENCIAMENTO_IMPORTADO	,
			DESTINO.QTD_PRODUCAO				= 	ORIGEM.QTD_PRODUCAO				,
			DESTINO.QTD_EXPORTACAO				= 	ORIGEM.QTD_EXPORTACAO				,
			DESTINO.DTA_ATUALIZACAO				=	@DTA_EXECUCAO 						
	;	
END