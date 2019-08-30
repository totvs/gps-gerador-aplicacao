/*******************************************************************************
 CT.............: CN_#[Table.controller]#_Busca#[Table.module]#PorFiltro.p
 Data ..........: 05/06/2018
 Programador ...: Gerador de CRUD
 Objetivo ......: Caso de teste com o objetivo de validar a consulta pelo filtro avançado
                  de #[Table.description]#
 Critério aceite: Registro de #[Table.description]# retornado
******************************************************************************/
{#[Table.appModule]#/bosau/bosau-#[Table.component]#.i}
{hdp/hdrunpersis.iv "new"}
{rtp/rtrowerror.i}
/* ---------------------------------- BIBLIOTECAS --------------------------- */
define variable h-bosau-#[Table.component]#-aux as handle no-undo.
define variable startRow                     as integer  initial 1  no-undo. 
define variable pageSize                     as integer  initial 20 no-undo.
define variable orderList                    as char     initial "" no-undo.
define variable hasNext                      as logical             no-undo. 
#[whileFields,fixedValue=]#
define variable #[Field.fieldName]#-aux as #[Field.databaseType]# no-undo.
#[endWhileFields]# 

procedure piBeforeExecute:        
    /*preparação de base*/
end procedure.
 
procedure piExecute:
    /*execução do teste propriamente dito*/
    define output parameter lPassed as logical.
    define output parameter cText   as longchar.
    
    define variable lg-achou-reg-aux as log initial no no-undo.
    
    assign lPassed = yes.
    
    empty temp-table tmp#[Table.module]#Filter.
    empty temp-table tmp#[Table.module]#.
    
    create tmp#[Table.module]#Filter.
    
    for last #[Table.name]# no-lock:
#[whileFields,fixedValue=]#
        #[IF,isFirst]#assign #[endIF]##[IF,!isFirst]#       #[endIF]##[Field.fieldName]#-aux = #[Table.name]#.#[Field.fieldName]##[IF,isLast]#.#[endIF]#
#[endWhileFields]#

#[whileFields,isFilter=true]#
        *[progress/tast/assignTmpFilter.txt,isRangeFilter=false]**[progress/tast/assignTmpFilterRange.txt,isRangeFilter=true]*
#[endWhileFields]#
    end.
    
    /*aqui devera ser construido o teste, como chamada de um
    metodo de um BO ou API*/                         
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}    
    run get#[Table.module]#ByFilter in h-bosau-#[Table.component]#-aux(input startRow,
                                                                   input pageSize,
                                                                   input orderList,
                                                                   input table tmp#[Table.module]#Filter,
                                                                   output hasNext,
                                                                   output table tmp#[Table.module]#,
                                                                   input-output table rowErrors) no-error.                                                                                      
         
    find first tmp#[Table.module]# no-lock no-error.               
    
    if not available tmp#[Table.module]#
    then assign lPassed = no
                cText   = "Nenhum registro encontrado na tabela #[Table.name]#.".
                    
    for each RowErrors no-lock:
    
        assign lPassed = no.
        
        if cText = ""
        then cText = RowErrors.ErrorDescription.
        else cText = cText + " ; " + RowErrors.ErrorDescription.
               
    end.

    if not lPassed
    then return.
    
    for first tmp#[Table.module]# no-lock:
#[whileFields,fixedValue=]#
        #[IF,isFirst]#if#[endIF]##[IF,!isFirst]#or#[endIF]# tmp#[Table.module]#.#[Field.fieldName,MaxAttributeSize]# <> #[Field.fieldName]#-aux
#[endWhileFields]#        
        then assign lPassed = no
                    cText   = "Resultado do metodo de pesquisa retornou dados que nao condizem com o que esta cadastrado na tabela #[Table.name]#.". 
        
        assign lg-achou-reg-aux = yes.
    end.
    
    if not lPassed
    then return.
    
    if not lg-achou-reg-aux
    then do:
           assign lPassed = no
                  cText   = "Nenhum registro retornado como resultado do metodo de pesquisa.". 
           return.
         end.
end.
 
procedure piAfterExecute:
    /*possíveis ações após execução do teste*/        
end procedure.
