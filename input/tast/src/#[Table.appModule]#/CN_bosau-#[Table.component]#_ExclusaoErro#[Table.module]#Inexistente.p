/*******************************************************************************
 CT.............: CN_#[Table.controller]#_ExclusaoErro#[Table.module]#Inexistente.p
 Data ..........: 05/06/2018
 Programador ...: Gerador de CRUD
 Objetivo ......: Caso de teste com o objetivo de validar a exclusao de um 
                  #[Table.description]#
 Critério aceite: #[Table.description]# nao pode ser excluido
******************************************************************************/
{hdp/hdrunpersis.iv "new"}
{rtp/rtrowerror.i}
/* ---------------------------------- BIBLIOTECAS --------------------------- */
define variable h-bosau-#[Table.component]#-aux as handle no-undo.
#[whileFields,isKey=true]#
define variable #[Field.fieldName]#-aux as #[Field.databaseType]# no-undo.
#[endWhileFields]#

procedure piBeforeExecute:
    /*preparação de base*/
end procedure.
 
procedure piExecute:
    /*execução do teste propriamente dito*/
    define output parameter lPassed as logical.
    define output parameter cText   as longchar.
    
    assign lPassed = no.
    
    for last #[Table.name]# //fields()
             no-lock:
#[whileFields,isKey=true]#
        #[IF,isFirst]#assign#[endIF]##[IF,!isFirst]#      #[endIF]# #[Field.fieldName]#-aux = #[IF,databaseType=logical]#not #[endIF]##[Table.name]#.#[Field.fieldName]# #[IF,databaseType=integer]#+ 1#[endIF]##[IF,databaseType=character]#+ "Z"#[endIF]##[IF,isLast]#.#[endIF]#
#[endWhileFields]#
    end.
    
    assign lPassed = no.
    
    /*aqui devera ser construido o teste, como chamada de um
    metodo de um BO ou API*/
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run remove#[Table.module]# in h-bosau-#[Table.component]#-aux(
#[whileFields,isKey=true]#
                                                          input #[Field.fieldName]#-aux,
#[endWhileFields]#
                                                          input-output table rowErrors) no-error.

    if error-status:error
    then assign lPassed = no
                cText   = "Erro ao executar o processo de exclusao. " + substr(error-status:get-message(error-status:num-messages),1,72).
          
    for first RowErrors
        where RowErrors.ErrorDescription matches "Registro * encontrado" 
              no-lock:
    
    end.
        
    if available RowErrors
    then assign lPassed = yes.
    else assign lPassed = no
                cText   = "Nao foram realizadas as validacoes referentes a nao existencia do #[Table.description]# que esta sendo excluido.".
    
end.
 
procedure piAfterExecute:
    /*possíveis ações após execução do teste*/
   
end procedure.
