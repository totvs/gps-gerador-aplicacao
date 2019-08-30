/*******************************************************************************
 CT.............: CN_#[Table.controller]#_Exclusao#[Table.module]#.p
 Data ..........: 05/06/2018
 Programador ...: Gerador de CRUD
 Objetivo ......: Caso de teste com o objetivo de validar a exclusao de um 
                  #[Table.description]#
 Critério aceite: #[Table.description]# excluido
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
    
    assign lPassed = yes.
    
    for last #[Table.name]# //fields()
             no-lock:
#[whileFields,isKey=true]#
        #[IF,isFirst]#assign#[endIF]##[IF,!isFirst]#      #[endIF]# #[Field.fieldName]#-aux = #[Table.name]#.#[Field.fieldName]##[IF,isLast]#.#[endIF]#
#[endWhileFields]#
    end.
    
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
                    
    for each RowErrors no-lock:
    
        assign lPassed = no.
        
        if cText = ""
        then cText = RowErrors.ErrorDescription.
        else cText = cText + " ; " + RowErrors.ErrorDescription.
               
    end.

    if not lPassed
    then return.
    
    for first #[Table.name]#
#[whileFields,isKey=true]#
        #[IF,isFirst]#where#[endIF]##[IF,!isFirst]#  and#[endIF]# #[Table.name]#.#[Field.fieldName]# = #[Field.fieldName]#-aux
#[endWhileFields]#
              no-lock:
            
        assign lPassed = no
               cText   = "Resultado do metodo de exclusao nao foi realizado com sucesso. Registro ainda se encontra disponivel na tabela #[Table.name,Upper]#.".
    end.
    
    if not lPassed
    then return.
    
end.
 
procedure piAfterExecute:
    /*possíveis ações após execução do teste*/
   
end procedure.
