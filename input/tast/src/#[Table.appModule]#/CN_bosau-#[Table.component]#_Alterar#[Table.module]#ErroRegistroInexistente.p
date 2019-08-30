/*******************************************************************************
 CT.............: CN_providerGroup_IncluiGrupo.p
 Data ..........: 05/06/2018
 Programador ...: Andrei Facchin
 Objetivo ......: Caso de teste com o objetivo de validar a inclusao de um 
                  grupo de prestador
 Critério aceite: Guia incluida e com status de autorizada
******************************************************************************/
{#[Table.appModule]#/bosau/bosau-#[Table.component]#.i}
{hdp/hdrunpersis.iv "new"}
{rtp/rtrowerror.i}
/* ---------------------------------- BIBLIOTECAS --------------------------- */
define variable h-bosau-#[Table.component]#-aux as handle              no-undo.

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
    
    empty temp-table tmp#[Table.module]#Filter.
    empty temp-table tmp#[Table.module]#.
    
    for last #[Table.name]# no-lock         
        #[whileFields,isKey=true]#                         
        #[IF,isFirst]# break #[endIF]# #[IF,!isLast]# by #[Table.name]#.#[Field.fieldName]# #[endIF]# #[IF,isLast]# by #[Table.name]#.#[Field.fieldName]#: #[endIF]#
        #[endWhileFields]#                                          
   
        assign 
            #[whileFields,isKey=true]#                                                         
            #[Field.fieldName]#-aux = #[IF,databaseType=integer]# #[Table.name]#.#[Field.fieldName]# + 1 #[endIF]# #[IF,databaseType=character]# "TAST Teste automatico" + #[Table.name]#.#[Field.fieldName]# #[endIF]# #[IF,databaseType=logical]# yes #[endIF]# #[IF,databaseType=date]# #[Table.name]#.#[Field.fieldName]# #[endIF]# #[IF,isLast]# . #[endIF]#                                    
            #[endWhileFields]#                                         
    end.
    
    /* TESTE DA BUSCA POR CODIGO DO GRUPO (filtro avançado)*/
    /* CREATE DA TABELA DE PARAMETROS */ 
    
    create tmp#[Table.module]#.               
    assign        
        #[whileFields]# 
        tmp#[Table.module]#.#[Field.fieldName]# = #[IF,isKey=true]# #[Field.fieldName]#-aux #[endIF]# #[IF,databaseType=integer|isKey=false]# #[Table.name]#.#[Field.fieldName,MaxAttributeSize]# #[endIF]# #[IF,databaseType=character|isKey=false]# "TAST Teste automatico alteracao"  #[endIF]# #[IF,databaseType=logical|isKey=false]# not #[Table.name]#.#[Field.fieldName]# #[endIF]# #[IF,databaseType=date|isKey=false]# today + 5 #[endIF]# #[IF,isLast]# . #[endIF]#
        #[endWhileFields]#   
    
    /*aqui devera ser construido o teste, como chamada de um
    metodo de um BO ou API*/
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run update#[Table.module]# in h-bosau-#[Table.component]#-aux(input table tmp#[Table.module]#,
                                                          input-output table rowErrors) no-error.                                                                                     
         
    
    if error-status:error
    then assign lPassed = no
                cText   = "Erro ao executar o processo de alteracao. " + substr(error-status:get-message(error-status:num-messages),1,72).
        
    /* REALIZA O TESTE SE FOI RETORNADO O ERRO QUE REPRESENTA CAMPOS OBRIGATORIOS NAO PREENCHIDOS */    
    for first RowErrors
        where RowErrors.ErrorDescription matches "Registro * encontrado" 
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
