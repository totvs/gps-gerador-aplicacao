/*******************************************************************************
 CT.............: CN_#[Table.controller]#_Incluir.p
 Data ..........: 05/06/2018
 Programador ...: Gerador de CRUD
 Objetivo ......: Caso de teste com o objetivo de validar a inclusao de um
                  registro de #[Table.description]#
 Critério aceite: Inclusao realizada com sucesso
******************************************************************************/
{#[Table.appModule]#/bosau/bosau-#[Table.component]#.i}
{hdp/hdrunpersis.iv "new"}
{rtp/rtrowerror.i}
/* ---------------------------------- BIBLIOTECAS --------------------------- */
define variable h-bosau-#[Table.component]#-aux as handle              no-undo.

#[whileFields,isKey=true]#
define variable #[Field.fieldName]#-aux         as #[Field.databaseType]#             no-undo.
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
    
    if not available #[Table.name]#
    then assign 
             #[whileFields,isKey=true]#      
             #[Field.fieldName]#-aux = #[IF,databaseType=integer]# 1 #[endIF]# #[IF,databaseType=character]# "TAST Teste automatico chave" #[endIF]# #[IF,databaseType=logical]# yes #[endIF]# #[IF,databaseType=date]# today #[endIF]# #[IF,isLast]# . #[endIF]#
             #[endWhileFields]#                          
   
    assign
        #[whileFields,isKey=true]#                                                         
        tmp#[Table.module]#.#[Field.fieldName]# = #[Field.fieldName]#-aux               
        #[endWhileFields]#                                  
        #[whileFields,isKey=false]# 
        tmp#[Table.module]#.#[Field.fieldName]# = #[IF,databaseType=integer]# #[Field.fieldName]#-aux + 1 #[endIF]# #[IF,databaseType=character]# "TAST Teste automatico" #[endIF]# #[IF,databaseType=logical]# yes #[endIF]# #[IF,databaseType=date]# today #[endIF]# #[IF,isLast]# . #[endIF]#
        #[endWhileFields]#
    
    /*aqui devera ser construido o teste, como chamada de um
    metodo de um BO ou API*/    
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run create#[Table.module]# in h-bosau-#[Table.component]#-aux(input table tmp#[Table.module]#,
                                                           input-output table rowErrors) no-error.                                                                                     
         
    
    if error-status:error
    then assign lPassed = no
                cText   = "Erro ao executar o processo de inclusao. " + substr(error-status:get-message(error-status:num-messages),1,72).
                    
    for each RowErrors no-lock:
    
        assign lPassed = no.
        
        if cText = ""
        then cText = RowErrors.ErrorDescription.
        else cText = cText + " ; " + RowErrors.ErrorDescription.
               
    end.

    if not lPassed
    then return.
        
    for first tmp#[Table.module]# no-lock,
        first #[Table.name]#          
        #[whileFields,isKey=true]#
        #[IF,isFirst]# where #[endIF]# #[IF,!isFirst]# and #[endIF]# #[Table.name]#.#[Field.fieldName]# = tmp#[Table.module]#.#[Field.fieldName]#
        #[endWhileFields]#            
        no-lock:
                
        #[whileFields,isEditable=true]#                         
        #[IF,isFirst]# if #[endIF]# #[IF,!isFirst]# or #[endIF]# #[IF,!isKey]# tmp#[Table.module]#.#[Field.fieldName]# <> #[Table.name]#.#[Field.fieldName]# #[endIF]#                                                                                                                            
        #[endWhileFields]#
        then assign lPassed = no
                    cText   = "Resultado do metodo de inclusao retornou dados que nao condizem com o que esta cadastrado na tabela #[Table.name]#.".                         
        
        assign lg-achou-reg-aux = yes.
        leave.
    end.
    
    if not lPassed
    then return.
    
    if not lg-achou-reg-aux
    then do:
           assign lPassed = no
                  cText   = "Nao foi criado nenhum registro durante o processo de inclusao". 
           return.
         end.
       
end.
 
procedure piAfterExecute:
    /*possíveis ações após execução do teste*/        
end procedure.
