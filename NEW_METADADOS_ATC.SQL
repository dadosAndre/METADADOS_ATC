USE [EXPORT_REPORT]
GO
/****** Object:  StoredProcedure [dbo].[PROC_NEW_METADADOS_ATC]    Script Date: 17/04/2024 13:15:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[PROC_NEW_METADADOS_ATC] @DT DATE
AS
BEGIN

/* Autor: André Araujo
   Data: 17/04/2024
*/


DECLARE @DATA DATE = @DT

---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------- DISCAGEM -------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------
-- Discagem analítica: (Este é o DEPARA do BANCO é DIFERENTE do NOSSO)
    DROP TABLE IF EXISTS #DISCAGEM_CRF

SELECT
    'CARREFOUR'                                                                      AS [EMPRESA],
    A.Data,
    D.LOGIN,
	CASE WHEN A.TIPO_OCO <= 5 	                                                     THEN 1 ELSE 0 END AS [TENTATIVA],
    CASE WHEN A.TIPO_OCO <= 4                                                        THEN 1 ELSE 0 END AS [ALO],
    CASE WHEN B.DESCRICAO  IN('NS_Acao Ns','AP_Acordo Especial','AE_Alteracao De Endereco','AV_Alteracao De Vencimento',
	'BT_Balance to installment','Boleto - Segunda Via','CS_Cancelamento Seguro','CW_Carteira de Credores',
	'CD_Cliente Desligou','IP_CLIENTE_INFORMA_PAGAMENTO','CE_Clientes Em Sinistros Asm','CO_Conflito',
	'CC_Copia Do Contrato','DD_Desacordo Comercial','ED_Em Dia','ET_Estorno de Tarifas','EP_Excecao - Pendente de Aprovacao',
	'IC_Incluir Comentario','DT_Indice Datacort Vencimento','IA_Informacao de acordo','IF_Informacoes De Seguros',
	'NR_Nao Reconhece Cartao','NE_Nao Reconhece Compra' ,'PG_Pagamento Nao Processado - Clientes',
	'PN_Pagamento Nao Processado - Cobranca','FP_Parcele Facil','PR_Perda-Roubo - Com Seguro','PT_Promessa de Acordo',
	'PP_Promessa Pagamento','QA_Quitacao Acordo','RS_Reabilitacao Spc-Serasa','RB_Reembolso','SD_Sem Definicao',
	'SL_Solicitacao Cod Barras - Linha Digitavel','TA_Termo De Acordo Em Andamento','TQ_Termo De Acordo Quitado'
	,'TI_Transferencia De Ilha')                                                     THEN 1 ELSE 0 END AS [CPC],
    CASE WHEN B.DESCRICAO IN('AP_Acordo Especial','BT_Balance to installment','EP_Excecao - Pendente de Aprovacao',
	'FP_Parcele Facil','PT_Promessa de Acordo','PT_Promessa de Acordo','PP_Promessa Pagamento',
	'SD_Sem Definicao' )
																				 THEN 1 ELSE 0 END AS [CPC_NEGOCIAVEL],
    CASE WHEN B.DESCRICAO IN('NS_Acao Ns','AE_Alteracao De Endereco','AV_Alteracao De Vencimento',
	'SV_Boleto - Segunda Via','CS_Cancelamento Seguro','CW_Carteira de Credores','CD_Cliente Desligou',
	'IP_CLIENTE_INFORMA_PAGAMENTO','CE_Clientes Em Sinistros Asm','CO_Conflito','CC_Copia Do Contrato',
	'DD_Desacordo Comercial','ED_Em Dia','ET_Estorno de Tarifas','DT_Indice Datacort Vencimento',
	'IA_Informacao de acordo','IF_Informacoes De Seguros','NR_Nao Reconhece Cartao','NE_Nao Reconhece Compra',
	'PG_Pagamento Nao Processado - Clientes','PN_Pagamento Nao Processado - Cobranca','PR_Perda-Roubo - Com Seguro',
	'QA_Quitacao Acordo','RS_Reabilitacao Spc-Serasa','RB_Reembolso','SL_Solicitacao Cod Barras - Linha Digitavel',
	'TA_Termo De Acordo Em Andamento','TQ_Termo De Acordo Quitado','TI_Transferencia De Ilha')
																				     THEN 1 ELSE 0 END AS [CPC_N_NEGOCIAVEL],
   CASE WHEN B.DESCRICAO IN('AP_Acordo Especial','BT_Balance to installment','EP_Excecao - Pendente de Aprovacao'
	,'FP_Parcele Facil','PT_Promessa de Acordo','PP_Promessa Pagamento')
																					THEN 1 ELSE 0 END AS [SUCESSO],
    CASE WHEN B.ID_DISPOSITION = 794                                                 THEN 1 ELSE 0 END AS [RECUSA],
    0 AS [PAGAMENTO],
    CASE WHEN B.DESCRICAO = 'AE_Alteracao De Endereco'                               THEN 1 ELSE 0 END AS [AE],
    CASE WHEN B.DESCRICAO = 'AP_Acordo Especial'                                     THEN 1 ELSE 0 END AS [AP],
    0 AS [AT],
    CASE WHEN B.DESCRICAO = 'AV_Alteracao De Vencimento'                             THEN 1 ELSE 0 END AS [AV],
    CASE WHEN B.DESCRICAO = 'BT_Balance to installment'                              THEN 1 ELSE 0 END AS [BT],
    CASE WHEN B.DESCRICAO = 'CC_Copia Do Contrato'                                   THEN 1 ELSE 0 END AS [CC],
    CASE WHEN B.DESCRICAO = 'CD_Cliente Desligou'                                    THEN 1 ELSE 0 END AS [CD],
    CASE WHEN B.DESCRICAO = 'CE_Clientes Em Sinistros Asm'                           THEN 1 ELSE 0 END AS [CE],
    CASE WHEN B.DESCRICAO = 'CI_Clientes Em Sinistros Asm menor 100'                 THEN 1 ELSE 0 END AS [CI],
    CASE WHEN B.DESCRICAO = 'CN_Cliente Nao Localizado'                              THEN 1 ELSE 0 END AS [CN],
    CASE WHEN B.DESCRICAO = 'CO_Conflito'                                            THEN 1 ELSE 0 END AS [CO],
    CASE WHEN B.DESCRICAO = 'CS_Cancelamento Seguro'                                 THEN 1 ELSE 0 END AS [CS],
    CASE WHEN B.DESCRICAO = 'CT_Contato Com Terceiros'                               THEN 1 ELSE 0 END AS [CT],
    CASE WHEN B.DESCRICAO = 'CW_Carteira de Credores'                                THEN 1 ELSE 0 END AS [CW],
    CASE WHEN B.DESCRICAO = 'DD_Desacordo Comercial'                                 THEN 1 ELSE 0 END AS [DD],
    CASE WHEN B.DESCRICAO = 'DT_Indice Datacort Vencimento'                          THEN 1 ELSE 0 END AS [DT],
    CASE WHEN B.DESCRICAO = 'ED_Em Dia'                                              THEN 1 ELSE 0 END AS [ED],
    CASE WHEN B.DESCRICAO = 'EP_Excecao - Pendente de Aprovacao'                     THEN 1 ELSE 0 END AS [EP],
    CASE WHEN B.DESCRICAO = 'ET_Estorno de Tarifas'                                  THEN 1 ELSE 0 END AS [ET],
    CASE WHEN B.DESCRICAO = 'FA_Falecido - Pendente Confirmacao'                     THEN 1 ELSE 0 END AS [FA],
    CASE WHEN B.DESCRICAO = 'FP_Parcele Facil'                                       THEN 1 ELSE 0 END AS [FP],
    CASE WHEN B.DESCRICAO = 'FT_Falha na Telefonia'                                  THEN 1 ELSE 0 END AS [FT],
    CASE WHEN B.DESCRICAO = 'IA_Informacao de acordo'                                THEN 1 ELSE 0 END AS [IA],
    CASE WHEN B.DESCRICAO = 'IC_Incluir Comentario'                                  THEN 1 ELSE 0 END AS [IC],
    CASE WHEN B.DESCRICAO = 'IF_Informacoes De Seguros'                              THEN 1 ELSE 0 END AS [IF],
    CASE WHEN B.DESCRICAO = 'IN_Identificacao Positiva Nao Confere'                  THEN 1 ELSE 0 END AS [IN],
    CASE WHEN B.DESCRICAO = 'IP_CLIENTE_INFORMA_PAGAMENTO'                           THEN 1 ELSE 0 END AS [IP],
    CASE WHEN B.DESCRICAO = 'LC_Ligacao Caiu'                                        THEN 1 ELSE 0 END AS [LC],
    CASE WHEN B.DESCRICAO = 'NE_Nao Reconhece Compra'                                THEN 1 ELSE 0 END AS [NE],
    CASE WHEN B.DESCRICAO = 'NR_Nao Reconhece Cartao'                                THEN 1 ELSE 0 END AS [NR],
    CASE WHEN B.DESCRICAO = 'NS_Acao Ns'                                             THEN 1 ELSE 0 END AS [NS],
    CASE WHEN B.DESCRICAO = 'PG_Pagamento Nao Processado - Clientes'                 THEN 1 ELSE 0 END AS [PG],
    CASE WHEN B.DESCRICAO = 'PN_Pagamento Nao Processado - Cobranca'                 THEN 1 ELSE 0 END AS [PN],
    CASE WHEN B.DESCRICAO = 'PP_Promessa Pagamento'                                  THEN 1 ELSE 0 END AS [PP],
    CASE WHEN B.DESCRICAO =  'PR_Perda-Roubo - Com Seguro'                           THEN 1 ELSE 0 END AS [PR],
    CASE WHEN B.DESCRICAO = 'PT_Promessa de Acordo'                                  THEN 1 ELSE 0 END AS [PT],
    CASE WHEN B.DESCRICAO = 'QA_Quitacao Acordo'                                     THEN 1 ELSE 0 END AS [QA],
    CASE WHEN B.DESCRICAO = 'RB_Reembolso'                                           THEN 1 ELSE 0 END AS [RB],
    CASE WHEN B.DESCRICAO = 'Recado'                                                 THEN 1 ELSE 0 END AS [RE],
    CASE WHEN B.DESCRICAO = 'RG_Religar'                                             THEN 1 ELSE 0 END AS [RG],
    CASE WHEN B.DESCRICAO = 'RS_Reabilitacao Spc-Serasa'                             THEN 1 ELSE 0 END AS [RS],
    CASE WHEN B.DESCRICAO = 'SD_Sem Definicao'                                       THEN 1 ELSE 0 END AS [SD],
    0 AS [SF],
    CASE WHEN B.DESCRICAO = 'SL_Solicitacao Cod Barras - Linha Digitavel'            THEN 1 ELSE 0 END AS [SL],
    CASE WHEN B.DESCRICAO = 'SV_Boleto - Segunda Via'                                THEN 1 ELSE 0 END AS [SV],
    CASE WHEN B.DESCRICAO = 'TA_Termo De Acordo Em Andamento'                        THEN 1 ELSE 0 END AS [TA],
    CASE WHEN B.DESCRICAO = 'TI_Transferencia De Ilha'                               THEN 1 ELSE 0 END AS [TI],
    CASE WHEN B.DESCRICAO = 'TQ_Termo De Acordo Quitado'                             THEN 1 ELSE 0 END AS [TQ]
INTO #DISCAGEM_CRF
FROM ANALYTIC.dbo.OLOS_CALLDETAIL                   AS [A] WITH(NOLOCK)
--FROM WOCC34.DW.DBO.MIS_OLOS_CALLDATA_202404 AS [A]
	INNER JOIN ANALYTIC.dbo.OLOS_CONFIG_DISPOSITION AS [B] 
	ON A.DISPOSITIONID = B.ID_DISPOSITION
INNER JOIN ANALYTIC.dbo.OLOS_CONFIG_SERVICE         AS [C] 
ON A.CampaignId = C.ID_CAMPAIGNID AND C.EMPRESA = 'CARREFOUR'
	INNER JOIN ANALYTIC.DBO.OLOS_CONFIG_USERS       AS [D] 
	ON A.AgentId = D.ID_AGENTE
WHERE DATA = @DATA

-- Discagem agrupada:
DROP TABLE IF EXISTS #DISCAGEM_ATC_GROUP

SELECT
 EMPRESA                                                  AS [CARTEIRA]
,Data												      AS [DELETAR_Data]
,LOGIN												      AS [DELETAR_LOGIN]
,SUM(ALO)												  AS [contato]
,SUM(CPC)												  AS [cpc]
,SUM(CPC_NEGOCIAVEL)		                              AS [cpc_negociavel]
,SUM(CPC_N_NEGOCIAVEL)									  AS [cpc_n_negociavel]
,SUM(SUCESSO)											  AS [sucesso]
,SUM(RECUSA)											  AS [recusa]
,SUM(PAGAMENTO)                                           AS [pgtos]
,SUM(AE)                                                  AS [AE]
,SUM(AP)                                                  AS [AP]
,SUM([AT])                                                AS [AT]
,SUM(AV)                                                  AS [AV]
,SUM(BT)                                                  AS [BT]
,SUM(CC)                                                  AS [CC]
,SUM(CD)                                                  AS [CD]
,SUM(CE)                                                  AS [CE]
,SUM(CI)                                                  AS [CI]
,SUM(CN)                                                  AS [CN]
,SUM(CO)                                                  AS [CO]
,SUM(CS)                                                  AS [CS]
,SUM(CT)                                                  AS [CT]
,SUM(CW)                                                  AS [CW]
,SUM(DD)                                                  AS [DD]
,SUM(DT)                                                  AS [DT]
,SUM(ED)                                                  AS [ED]
,SUM(EP)                                                  AS [EP]
,SUM(ET)                                                  AS [ET]
,SUM(FA)                                                  AS [FA]
,SUM(FP)                                                  AS [FP]
,SUM(FT)                                                  AS [FT]
,SUM(IA)                                                  AS [IA]
,SUM(IC)                                                  AS [IC]
,SUM([IF])                                                AS [IF]
,SUM([IN])                                                AS [IN]
,SUM([IP])                                                AS [IP]
,SUM(LC)                                                  AS [LC]
,SUM(NE)                                                  AS [NE]
,SUM(NR)                                                  AS [NR]
,SUM(NS)                                                  AS [NS]
,SUM(PG)                                                  AS [PG]
,SUM(PN)                                                  AS [PN]
,SUM(PP)                                                  AS [PP]
,SUM(PR)                                                  AS [PR]
,SUM(PT)                                                  AS [PT]
,SUM(QA)                                                  AS [QA]
,SUM(RB)                                                  AS [RB]
,SUM(RE)                                                  AS [RE]
,SUM(RG)                                                  AS [RG]
,SUM(RS)                                                  AS [RS]
,SUM(SD)                                                  AS [SD]
,SUM(SF)                                                  AS [SF]
,SUM(SL)                                                  AS [SL]
,SUM(SV)                                                  AS [SV]
,SUM(TA)                                                  AS [TA]
,SUM(TI)                                                  AS [TI]
,SUM(TQ)                                                  AS [TQ]
		INTO #DISCAGEM_ATC_GROUP
	FROM #DISCAGEM_CRF
GROUP BY
EMPRESA
,Data	
,LOGIN	

--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------  TEMPOS  -----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
-- Tempos Carrefour ATC
DROP TABLE IF EXISTS #TEMPOS
 
SELECT
	A.EMPRESA
	,A.DATA                                                                                                                AS [data]
	,USUARIO												                                                               AS [matricula/login]
	,B.NOME													                                                               AS [operador]
	,NULL                                                                                                                  AS [matricula/login_supervisor]
	,A.SUPERVISOR											                                                               AS [supervisor]
	,C.DESCRICAO											                                                               AS [turno]
	,'PRESENCIAL'                                                                                                          AS [site_trab]
	,D.ESTRATEGIA                                                                                                          AS [organizacao]
	,D.ID                                                                                                                  AS [cod_camp]
	,D.ESTRATEGIA                                                                                                          AS [campanha]
	,DATEDIFF(SECOND,'00:00:00',FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(LOGADO,',','.')) * 3600/86400), 'HH:mm:ss'))  AS [tempo_log]                                        
	,DATEDIFF(SECOND, '00:00:00', A.LOGIN)                                                                                 AS [login_seg]
	,DATEDIFF(SECOND, '00:00:00', A.LOGOUT)                                                                                AS [logout_seg]
	,DATEDIFF(SECOND, '00:00:00',
	FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(DESLOGADO,',','.')) * 3600/86400), 'HH:mm:ss'))                         AS [tempo_ofiline]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(LOGADO,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [tempo_logado]
	,A.LOGIN                                                                                                               AS [login]
	,A.LOGOUT                                                                                                              AS [logout]															                       
	, FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(DESLOGADO,',','.')) * 3600/86400), 'HH:mm:ss')                        AS [ofiline]
	,NULL                                                                                                                  AS [ligacoes_recebidas]
	,NULL                                                                                                                  AS [qnt_atend_ate_20s]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(FALADO,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [tempo_falando]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(FALADO,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [tempo_chamada]
	,FORMAT(CONVERT(DATETIME,CONVERT(FLOAT,REPLACE(FALADO,',','.'))/E.CONTATO * 3600/86400),'HH:mm:ss')                    AS [tmo]
	,'00:30:00'                                                                                                            AS [tmc]
	,FORMAT(
       CONVERT(DATETIME,
	   (CONVERT(FLOAT,REPLACE(A.REUNIAO			     ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.ALMOCO				 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.LANCHE			 	 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.SAIDA_PARTICULAR     ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.BANHEIRO			 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.ATENDIMENTO_RECEPCAO ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.FEEDBACK			 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.TABULACAO			 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.SITEMA				 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.PAUSA_10			 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.PAUSA_20			 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.TREINAMENTO		     ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.CHAT				 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.LABORAL			     ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.ACORDO_EXCECAO	 	 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.MATRIZ				 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.FUNCAO_COMPATIVEL	 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.CHAMADA_MANUAL		 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.RH					 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.LIVRE				 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.NAO_PRONTO		 	 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.PREVIEW			     ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.SISTEMA_SANTANDER	 ,',','.'))
	   +CONVERT(FLOAT,REPLACE(A.BKO,',','.'))/86400*3600 )/86400*3600),'HH:mm:ss')                                         AS [total_pausa]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(SITEMA,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [defeito]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(FEEDBACK,',','.')) * 3600/86400), 'HH:mm:ss')                          AS [feedback]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(BANHEIRO,',','.')) * 3600/86400), 'HH:mm:ss')                          AS [particular]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(ALMOCO,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [almoco]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(PAUSA_20,',','.')) * 3600/86400), 'HH:mm:ss')                          AS [pausa_20]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(PAUSA_10,',','.')) * 3600/86400), 'HH:mm:ss')                          AS [pausa_10]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(REUNIAO,',','.')) * 3600/86400), 'HH:mm:ss')                           AS [reuniao]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(LABORAL,',','.')) * 3600/86400), 'HH:mm:ss')                           AS [ambulatorio]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(TREINAMENTO,',','.')) * 3600/86400), 'HH:mm:ss')                       AS [treinamento]
	,ISNULL(FORMAT(CONVERT(DATETIME, TRY_CONVERT(float,REPLACE(FEEDBACK +NR17 +TREINAMENTO,',','.')) * 3600/86400), 'HH:mm:ss')
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(NR17,',','.')) * 3600/86400), 'HH:mm:ss'))                             AS [pausa_produtiva]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(IMPRODUTIVAS,',','.')) * 3600/86400), 'HH:mm:ss')                      AS [pausa_improdutiva]
	,ISNULL(FORMAT(CONVERT(DATETIME, TRY_CONVERT(float,REPLACE(FALADO + TABULANDO,',','.')) * 3600/86400), 'HH:mm:ss'),
	 FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(FALADO,',','.')) * 3600/86400), 'HH:mm:ss'))                           AS [tempo_produtivo]
	,CONCAT(ROUND((CONVERT(FLOAT, REPLACE(FALADO, ',', '.')) / CONVERT(FLOAT, REPLACE(LOGADO, ',', '.'))) * 100,0),'%')    AS [% tempo_produtivo]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(OCIOSO,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [tempo_disponivel]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(OCIOSO,',','.')) * 3600/86400), 'HH:mm:ss')                            AS [tempo_ocioso]
	,FORMAT(CONVERT(DATETIME, CONVERT(float,REPLACE(TABULANDO,',','.')) * 3600/86400), 'HH:mm:ss')                         AS [tempo_tabulando]
	,LOGADO                                                                                                                AS [LOGADO_DELETAR]
		INTO #TEMPOS
	FROM EXPORT_REPORT.DBO.POWERBI_TEMPOS                                                                                  AS [A]
		INNER JOIN QUADRO_OPERACIONAL.DBO.QUADRO_FUNCIONARIOS                                                              AS [B]
		ON A.USUARIO = B.LG_OLOS							                                                               
	INNER JOIN QUADRO_OPERACIONAL.DBO.QUADRO_TURNO                                                                         AS [C]
	ON B.ID_TURNO = C.ID									                                                               
		INNER JOIN QUADRO_OPERACIONAL.DBO.QUADRO_ESTRATEGIA                                                                AS [D]
		ON B.ID_ESTRATEGIA = D.ID
	INNER JOIN #DISCAGEM_ATC_GROUP                                                                                         AS [E]
	ON A.USUARIO = E.DELETAR_LOGIN
WHERE A.DATA = @DATA
AND A.EMPRESA IN('CARREFOUR')


--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------  PAGAMENTOS  -------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #PAGAMENTOS

;WITH PAGAMENTOS
AS
(
SELECT
	 DT_PG
	,[USER_ID]          AS [LOGIN_OP]
	,COUNT([USER_ID])   AS [QTD]
	,'CARREFOUR'        AS [EMPRESA]
	FROM EXPORT_REPORT.DBO.CARREFOUR_PROMESSA AS [A] WITH(NOLOCK)
WHERE DT_PG = @DATA
GROUP BY
	DT_PG
	,[USER_ID]
)
SELECT 
	 * 
	   INTO #PAGAMENTOS
	 FROM PAGAMENTOS


-- ATUALIZAÇÃO DE PAGAMENTOS
UPDATE A
	SET A.pgtos = ISNULL(B.QTD,0)
	FROM #DISCAGEM_ATC_GROUP   AS [A]
		INNER JOIN #PAGAMENTOS AS [B]
		ON A.DELETAR_LOGIN = B.LOGIN_OP




--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------  QUADRO OPERACIONAL  -----------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #QUADRO_OPERACIONAL_CARREFOUR

;WITH QUADRO_OPERACIONAL
AS
(
SELECT
	 A.LG_OLOS                                        
	,CASE WHEN E.SUBGRUPO = 'BUCKET-1' THEN 'BKT_01'
	      WHEN E.SUBGRUPO = 'BUCKET-2' THEN 'BKT_02'
		  ELSE E.SUBGRUPO                              END [BUCKET]
	,D.MATRICULA                                       AS  [LOGIN_SUPERVISOR]
	,'WINOVER'                                         AS  [EPS]
	FROM QUADRO_OPERACIONAL.dbo.QUADRO_FUNCIONARIO_HISTORICO        AS [A]
		INNER JOIN QUADRO_OPERACIONAL.dbo.QUADRO_FUNCIONARIOS       AS [B]
		ON A.LG_OLOS = B.LG_OLOS							        
	INNER JOIN QUADRO_OPERACIONAL.dbo.QUADRO_CENTRO_CUSTO           AS [C]
	ON A.ID_CT_CUSTO = C.ID									        
	AND C.CENTRO_CUSTO LIKE '%CARREFOUR%'					        
		INNER JOIN QUADRO_OPERACIONAL.dbo.QUADRO_SUPERVISOR         AS [D]
		ON A.ID_SUPERVISOR = D.MATRICULA						    
	INNER JOIN QUADRO_OPERACIONAL.dbo.QUADRO_SUB_GRUPO_ESTRATEGIA   AS [E]
	ON A.SUB_GRUPO_CARTEIRA = E.ID
		INNER JOIN QUADRO_OPERACIONAL.dbo.QUADRO_STATUS_FUNCIONARIO AS [F]
		ON A.ID_STATUS = F.ID
		AND F.STATUS = 'ATIVO'
WHERE A.DATA = @DATA
)
SELECT 
	 * 
		INTO #QUADRO_OPERACIONAL_CARREFOUR
	 FROM QUADRO_OPERACIONAL


-- CONTIGÊNCIA:
UPDATE A
	SET A.BUCKET = 'BKT_01'
	FROM #QUADRO_OPERACIONAL_CARREFOUR AS [A]
WHERE BUCKET NOT IN('BKT_01','BKT_02')


-- LOGIN SUPERVISOR:
UPDATE A
	SET A.[matricula/login_supervisor] = B.LOGIN_SUPERVISOR
	FROM #TEMPOS AS [A]
		INNER JOIN #QUADRO_OPERACIONAL_CARREFOUR AS [B]
		ON A.[matricula/login] = B.LG_OLOS



--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------  SPIN E HIT HATE  --------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Mailing:
DROP TABLE IF EXISTS #MAILING_CARREFOUR_ATC

;WITH MAILING
AS
(
SELECT
	DISTINCT 
	CPF_CNPJ
	,CASE WHEN B.BUCKT IN('BUCKET1', 'BUCKET2')			THEN 'CARREFOUR'
		  WHEN B.BUCKT IN ('Bucket1_at', 'Bucket2_at')	THEN 'ATACADAO'
													    END [operacao2]
   ,0                                                   AS  [QTD_TOTAL]
   ,0                                                   AS  [TENTATIVA]
   ,0                                                   AS  [ALO]
	FROM MAILING.dbo.MAILING_CARREFOUR                  AS  [A]
	INNER JOIN ASSISTANT.DBO.FILA_CARREFOUR             AS  [B]
	ON A.SUB_SEGMENTO = B.CARTEIRA
WHERE DATA_IMPORTACAO = @DATA
)

SELECT
	*
		INTO #MAILING_CARREFOUR_ATC
	FROM MAILING


-- Discagem:
DROP TABLE IF EXISTS #DISCAGEM

;WITH DISCAGEM
AS
(
SELECT
	DOC                                                 AS [CPF]
	,COUNT(DOC)                                         AS [QTD]
	,SUM(CASE WHEN A.tipo_oco <= 5  THEN 1 ELSE 0 END)  AS [TENTATIVA]
	,SUM(CASE WHEN A.tipo_oco <= 4  THEN 1 ELSE 0 END)  AS [ALO]
	FROM ANALYTIC.dbo.OLOS_CALLDETAIL                   AS [A]	 WITH(NOLOCK)              	                  
	  INNER JOIN ANALYTIC.dbo.OLOS_CONFIG_SERVICE       AS [C]           
	  ON A.CampaignId = C.ID_CAMPAIGNID 
	  AND C.EMPRESA = 'CARREFOUR'
WHERE A.Data =  @DATA
GROUP BY DOC
)

SELECT 
	*
		INTO #DISCAGEM
	FROM DISCAGEM


-- Update Discagem:
UPDATE A
	SET A.QTD_TOTAL = B.QTD
	  , A.TENTATIVA = B.TENTATIVA
	  , A.ALO       = B.ALO
	FROM #MAILING_CARREFOUR_ATC AS [A]
		INNER JOIN #DISCAGEM    AS [B]
		ON CONVERT(BIGINT,A.CPF_CNPJ) = CONVERT(BIGINT,B.CPF)


-- Spin e Hit rate
DROP TABLE IF EXISTS #CALCULO

SELECT
	operacao2
	,SUM(QTD_TOTAL)                                    AS [QTD_TOTAL_LIG]
	,COUNT(operacao2)                                  AS [QTD_MAILING]
	,SUM(QTD_TOTAL) / COUNT(operacao2)                 AS [spin]
	,CONCAT(SUM(ALO)*100      /  SUM(TENTATIVA),'%')   AS [hit_rate]
		INTO #CALCULO
	FROM #MAILING_CARREFOUR_ATC
GROUP BY
	operacao2


--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------  TABELA FINAL  -----------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------

-- Delete evitar duplicidade:
DELETE FROM EXPORT_REPORT.DBO.TBL_METADADOS_ATC_NEW WHERE DATA = @DATA


-- Insert Tabela Fisica:
INSERT INTO EXPORT_REPORT.DBO.TBL_METADADOS_ATC_NEW

SELECT
	 A.data
	,A.[matricula/login]
	,A.operador
	,A.[matricula/login_supervisor]
	,A.supervisor
	,A.turno
	,A.site_trab
	,A.organizacao
	,A.cod_camp
	,A.campanha
	,A.tempo_log
	,A.login_seg
	,A.logout_seg
	,A.tempo_ofiline
	,A.tempo_logado
	,A.login
	,A.logout
	,A.ofiline
	,ISNULL(A.ligacoes_recebidas,0) AS [ligacoes_recebidas]
	,ISNULL(A.qnt_atend_ate_20s,0)  AS [qnt_atend_ate_20s]
	,A.tempo_falando
	,A.tempo_chamada
	,A.tmo
	,A.tmc
	,A.total_pausa
	,A.defeito
	,A.feedback
	,A.particular
	,A.almoco
	,A.pausa_20
	,A.pausa_10
	,A.reuniao
	,A.ambulatorio
	,A.treinamento
	,A.pausa_produtiva
	,A.pausa_improdutiva
	,A.tempo_produtivo
	,A.[% tempo_produtivo]
	,A.tempo_disponivel
	,B.contato
	,B.cpc
	,B.cpc_negociavel
	,B.cpc_n_negociavel
	,B.sucesso
	,B.recusa
	,B.pgtos
	,B.[AE]
	,B.[AP]
	,B.[AT]
	,B.[AV]
	,B.[BT]
	,B.[CC]
	,B.[CD]
	,B.[CE]
	,B.[CI]
	,B.[CN]
	,B.[CO]
	,B.[CS]
	,B.[CT]
	,B.[CW]
	,B.[DD]
	,B.[DT]
	,B.[ED]
	,B.[EP]
	,B.[ET]
	,B.[FA]
	,B.[FP]
	,B.[FT]
	,B.[IA]
	,B.[IC]
	,B.[IF]
	,B.[IN]
	,B.[IP]
	,B.[LC]
	,B.[NE]
	,B.[NR]
	,B.[NS]
	,B.[PG]
	,B.[PN]
	,B.[PP]
	,B.[PR]
	,B.[PT]
	,B.[QA]
	,B.[RB]
	,B.[RE]
	,B.[RG]
	,B.[RS]
	,B.[SD]
	,B.[SF]
	,B.[SL]
	,B.[SV]
	,B.[TA]
	,B.[TI]
	,B.[TQ]
	,CONCAT(ROUND(CONVERT(FLOAT, REPLACE(LOGADO_DELETAR, ',', '.')) / 24.0 * 100,0),'%')   AS [temp_logado2]
	,CONCAT(ROUND(A.tempo_ofiline,0) /24.0 *100,0,'%')                                     AS [temp_ofiline2]
	,A.campanha                                                                            AS [operacao2]
	,C.BUCKET                                                                              AS [bucket_original]
	,'ATIVO'                                                                               AS [celula_atendimento]
	,A.tempo_ocioso
	,A.tempo_tabulando
	,D.spin                                                                                AS [spin]
	,D.hit_rate                                                                            AS [hit_rate]
	,'WINOVER'                                                                             AS [eps]
	FROM #TEMPOS                             AS [A]
		INNER JOIN #DISCAGEM_ATC_GROUP       AS [B]
		ON A.EMPRESA = B.CARTEIRA
		AND A.[matricula/login] = B.DELETAR_LOGIN
	INNER JOIN #QUADRO_OPERACIONAL_CARREFOUR AS [C]
	ON A.[matricula/login] = C.LG_OLOS
		INNER JOIN #CALCULO                  AS [D]
		ON A.campanha = D.operacao2



--------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------  MSG BOT  ----------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------
DECLARE @MSG2 VARCHAR(500)
DECLARE @MAX DATE = (SELECT MAX(DATA) FROM EXPORT_REPORT.DBO.TBL_METADADOS_ATC_NEW)

SET @MSG2 = 'Metadados MIGI Carrefour atualizado até o dia ' + CONVERT(VARCHAR(10), @MAX, 103)

SELECT @MSG2 AS 'Mensagem'


INSERT INTO EXPORT_REPORT.DBO.SEND_TELEGRAM_PROCESSOS VALUES(CONVERT(DATE,GETDATE()),NULL,'#BotValidador',@MSG2,NULL,NULL,0)	

END