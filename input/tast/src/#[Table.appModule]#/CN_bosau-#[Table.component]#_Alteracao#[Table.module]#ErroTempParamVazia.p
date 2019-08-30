/*******************************************************************************
 CT.............: CN_bosau-#[Table.component]#_Alteracao#[Table.module]#ErroTempParamVazia.p
 Data ..........: 05/06/2018
 Programador ...: Gerador de CRUD
 Objetivo ......: Caso de teste com o objetivo de validar o a falta de parametros para
                  #[Table.description]#
 Critério aceite: Erro de falta de parametros de entrada
******************************************************************************/
{#[Table.appModule]#/bosau/bosau-#[Table.component]#.i}
{hdp/hdrunpersis.iv "new"}
{rtp/rtrowerror.i}
/* ---------------------------------- BIBLIOTECAS --------------------------- */
define variable h-bosau-#[Table.component]#-aux as handle no-undo.

procedure piBeforeExecute:
    /*preparação de base*/
end procedure.
 
procedure piExecute:
    /*execução do teste propriamente dito*/
    define output parameter lPassed as logical.
    define output parameter cText   as longchar.
    
    define variable lg-achou-reg-aux as log initial no no-undo.
    
    assign lPassed = no.
    
    empty temp-table tmp#[Table.module]#Filter.
    empty temp-table tmp#[Table.module]#.
    
    /*aqui devera ser construido o teste, como chamada de um
    metodo de um BO ou API*/
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run update#[Table.module]# in h-bosau-#[Table.component]#-aux(
                                                          input        table tmp#[Table.module]#,
                                                          input-output table rowErrors) no-error.                                                                                     

    if error-status:error
    then assign lPassed = no
                cText   = "Erro ao executar o processo de atualizacao. " + substr(error-status:get-message(error-status:num-messages),1,72).
        
    /* REALIZA O TESTE SE FOI RETORNADO O ERRO QUE REPRESENTA CAMPOS OBRIGATORIOS NAO PREENCHIDOS */    
    for first RowErrors
        where RowErrors.ErrorDescription matches "Nao foram encontrados dados * registro" 
                                            
              no-lock:
    
    end.
        
    if available RowErrors
    then assign lPassed = yes.
    else assign lPassed = no
                cText = "Nao foram realizadas as validacoes referentes preenchimento das tabelas de entrada.".
    
end.
 
procedure piAfterExecute:
    /*possíveis ações após execução do teste*/
end procedure.
