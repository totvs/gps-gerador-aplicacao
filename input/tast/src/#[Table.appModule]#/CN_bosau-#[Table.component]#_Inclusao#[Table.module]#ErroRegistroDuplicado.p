/*******************************************************************************
 CT.............: CN_bosau-#[Table.component]#_Inclusao#[Table.module]#ErroRegistroDuplicado.p
 Data ..........: 05/06/2018
 Programador ...: Gerador de CRUD
 Objetivo ......: Caso de teste com o objetivo de validar a inclusao de um registro duplicado em
                  #[Table.description]#
 Critério aceite: Guia incluida e com status de autorizada
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
    
    assign lPassed = no.
    
    empty temp-table tmp#[Table.module]#Filter.
    empty temp-table tmp#[Table.module]#.
    
    /* CREATE DA TABELA DE PARAMETROS */ 
    for last #[Table.name]# //fields()
             no-lock:
        create tmp#[Table.module]#.
#[whileFields,fixedValue=]#
        #[IF,isFirst]#assign#[endIF]##[IF,!isFirst]#      #[endIF]# tmp#[Table.module]#.#[Field.fieldName,MaxAttributeSize]# = #[Table.name]#.#[Field.fieldName]##[IF,isLast]#.#[endIF]#
#[endWhileFields]#
    end.
    
    /*aqui devera ser construido o teste, como chamada de um
    metodo de um BO ou API*/
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run create#[Table.module]# in h-bosau-#[Table.component]#-aux(
                                                          input        table tmp#[Table.module]#,
                                                          input-output table rowErrors) no-error.                                                                                     
    
    if error-status:error
    then assign lPassed = no
                cText   = "Erro ao executar o processo de inclusao. " + substr(error-status:get-message(error-status:num-messages),1,72).
        
    /* REALIZA O TESTE SE FOI RETORNADO O ERRO QUE REPRESENTA CAMPOS OBRIGATORIOS NAO PREENCHIDOS */    
    for first RowErrors
        where RowErrors.ErrorDescription matches "Registro * existe" 
              no-lock:
    
    end.
        
    if available RowErrors
    then assign lPassed = yes.
    else assign lPassed = no
                cText = "Nao foram realizadas as validacoes referentes aos campos preenchidos.".
        
end.
 
procedure piAfterExecute:
    /*possíveis ações após execução do teste*/
end procedure.
