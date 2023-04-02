




CREATE   PROCEDURE [FIPE_DW].[SP_UPDATE_FLG_ATIVO]
	@COD_MES_REFERENCIA INT  = NULL
 AS
 BEGIN 
	DECLARE @DTA_EXECUCAO DATETIME2(2) = GETDATE()

	IF @COD_MES_REFERENCIA IS NULL 
		SET @COD_MES_REFERENCIA = (SELECT MAX(COD_MES_REFERENCIA) FROM FIPE_DW.DW_DIM_TEMPO_MENSAL)
    		
	----------------------------------------------------------------------------------------------------------
	-- ATUALIZA FLG_ATIVO DA DIMENSÃO DIM MODELO
	----------------------------------------------------------------------------------------------------------
	
	UPDATE FIPE_DW.DW_DIM_MODELO			SET	FLG_ATIVO = 0	WHERE FLG_ATIVO IS NULL

	UPDATE D SET FLG_ATIVO = 1 FROM fipe_dw.DW_DIM_MODELO  D INNER JOIN FIPE_DW.DW_FTO_DADOS_MODELO		F	(NOLOCK)ON D.COD_MODELO = F.COD_MODELO
	WHERE D.FLG_ATIVO = 0 AND F.COD_MES_REFERENCIA = @COD_MES_REFERENCIA

	----------------------------------------------------------------------------------------------------------
	-- ATUALIZA FLG_ATIVO DA DIMENSÃO DIM TEMPO MENSAL
	----------------------------------------------------------------------------------------------------------
	
	UPDATE FIPE_DW.DW_DIM_TEMPO_MENSAL		SET	FLG_ATIVO = 0	WHERE FLG_ATIVO IS NULL

	UPDATE D SET FLG_ATIVO = 1 FROM fipe_dw.DW_DIM_TEMPO_MENSAL  D INNER JOIN FIPE_DW.DW_FTO_DADOS_MODELO	F	(NOLOCK)ON D.COD_MES_REFERENCIA = F.COD_MES_REFERENCIA
	WHERE D.FLG_ATIVO = 0 AND F.COD_MES_REFERENCIA = @COD_MES_REFERENCIA

	----------------------------------------------------------------------------------------------------------
	-- ATUALIZA FLG_ATIVO DA DIMENSÃO DIM TIPO COMBUSTIVEL
	----------------------------------------------------------------------------------------------------------
	
	UPDATE FIPE_DW.DW_DIM_TIPO_COMBUSTIVEL	SET	FLG_ATIVO = 0	WHERE FLG_ATIVO IS NULL

	UPDATE D SET FLG_ATIVO = 1 FROM fipe_dw.DW_DIM_TIPO_COMBUSTIVEL  D INNER JOIN FIPE_DW.DW_FTO_DADOS_MODELO		F	(NOLOCK)ON D.COD_TIPO_COMBUSTIVEL = F.COD_TIPO_COMBUSTIVEL
	WHERE D.FLG_ATIVO = 0 AND F.COD_MES_REFERENCIA = @COD_MES_REFERENCIA

	----------------------------------------------------------------------------------------------------------
	-- ATUALIZA FLG_ATIVO DA DIMENSÃO DIM TIPO MODELO
	----------------------------------------------------------------------------------------------------------	

	UPDATE FIPE_DW.DW_DIM_TIPO_VEICULO		SET	FLG_ATIVO = 0	WHERE FLG_ATIVO IS NULL
	
	UPDATE D SET FLG_ATIVO = 1 FROM fipe_dw.DW_DIM_TIPO_VEICULO  D INNER JOIN FIPE_DW.DW_FTO_DADOS_MODELO		F	(NOLOCK)ON D.COD_TIPO_VEICULO = F.COD_TIPO_VEICULO
	WHERE D.FLG_ATIVO = 0 AND F.COD_MES_REFERENCIA = @COD_MES_REFERENCIA

END