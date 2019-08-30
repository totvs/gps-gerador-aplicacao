/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOSAU-#[Table.component,Upper]# 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i bosau-#[Table.component]# MUT}
&ENDIF

this-procedure:private-data = "bosau-#[Table.component]#".

/*
    Copyright (c) 2007, DATASUL S/A. Todos os direitos reservados.
    
    Os Programas desta Aplica��o (que incluem tanto o software quanto a sua
    documenta��o) cont�m informa��es propriet�rias da DATASUL S/A; eles s�o
    licenciados de acordo com um contrato de licen�a contendo restri��es de uso e
    confidencialidade, e s�o tamb�m protegidos pela Lei 9609/98 e 9610/98,
    respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
    reversa, descompila��o e desmontagem dos programas s�o proibidos. Nenhuma
    parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
    por nenhum meio, eletr�nico ou mec�nico, por motivo algum, sem a permiss�o
    escrita da DATASUL S/A.

*/

{rtp/rtrowerror.i}
{#[Table.appModule]#/bosau/bosau-#[Table.component]#.i}

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
{hdp/hdrunpersis.iv}

define variable h-query-utils-thf-aux         as handle          no-undo.
define variable h-query-buffers-list-aux      as handle extent 1 no-undo.
define variable ds-query-aux                  as character       no-undo.
define variable in-numero-registros-query-aux as integer         no-undo.
define variable lg-primeira-condicao-aux      as logical         no-undo.

function appendQueryOR returns character private (input ds-condition-par as character, input ds-query-par as character, input-output lg-first-par as logical) :
    if lg-first-par
    then assign ds-query-par = ds-query-par + " WHERE " + ds-condition-par
                lg-first-par = false.
    else assign ds-query-par = ds-query-par + " OR " + ds-condition-par.
    
    return ds-query-par.
end function.

function appendQueryAND returns character private (input ds-condition-par as character, input ds-query-par as character, input-output lg-first-par as logical) :
    if lg-first-par
    then assign ds-query-par = ds-query-par + " WHERE " + ds-condition-par
                lg-first-par = false.
    else assign ds-query-par = ds-query-par + " AND " + ds-condition-par.
    
    return ds-query-par.
end function.

function databaseFieldName returns character private (input nm-field-par as character):
    define variable ix as integer no-undo.
    repeat ix = 1 to temp-table tmp#[Table.module]#:default-buffer-handle:num-fields:
        if temp-table tmp#[Table.module]#:default-buffer-handle:buffer-field(ix):serialize-name = nm-field-par
        then return temp-table tmp#[Table.module]#:default-buffer-handle:buffer-field(ix):name.
    end.
end function.

function appendQueryOrder returns character private (input ds-order-par as character, input ds-query-par as character):
    define variable ix-field          as integer   no-undo.
    define variable is-descending-aux as logical   no-undo.
    define variable nm-field-aux      as character no-undo.
    
    if  (ds-order-par <> ?)
    and (ds-order-par <> "")
    then do:
        assign ds-query-par = ds-query-par + " BREAK ".
        repeat ix-field = 1 to num-entries(ds-order-par):
            assign nm-field-aux = entry(ix-field, ds-order-par).
            if substring(nm-field-aux, 1, 1) = "-"
            then assign nm-field-aux = substring(nm-field-aux, 2)
                        is-descending-aux = true.
            else assign is-descending-aux = false.
            assign nm-field-aux = databaseFieldName(nm-field-aux).
            if nm-field-aux <> ""
            then assign ds-query-par = ds-query-par + " BY " + nm-field-aux.
            if is-descending-aux
            then assign ds-query-par = ds-query-par + " DESC".
        end.
    end.
    
    return ds-query-par.
end function.

procedure get#[Table.module]#ById:
    #[whileFields,isKey=true]#
    define input        parameter #[Field.fieldName]#-par like #[Table.name]#.#[Field.fieldName]# no-undo.
    #[endWhileFields]#
    define output       parameter table for tmp#[Table.module]#.
    define input-output parameter table for rowErrors.         
            
    run getSelectInstruction(output ds-query-aux).
        
    #[whileFields,isKey=true]#
    #[IF,isFirst]#assign ds-query-aux =#[endIF]##[IF,!isFirst]#       ds-query-aux =#[endIF]# appendQueryAND("#[Field.fieldName]# = #[IF,!databaseType=character]#" + string(#[Field.fieldName]#-par)#[endIF]##[IF,databaseType=character]#'" + replace(#[Field.fieldName]#-par, "'", "") + "'"#[endIF]#, ds-query-aux, lg-primeira-condicao-aux)#[IF,isLast]#.#[endIF]#
    #[endWhileFields]#
        
    {hdp/hdrunpersis.i "utils/query-utils-thf.p" "h-query-utils-thf-aux"}
    run executeQuery in h-query-utils-thf-aux (input 1,   /*page number*/
                                               input 1,   /*page size*/
                                               input ds-query-aux,
                                               input buffer #[Table.name]#:handle,
                                               input "createTmp#[Table.module]#",
                                               output in-numero-registros-query-aux) no-error.
                                           
    return "OK".
    
end procedure.

procedure get#[Table.module]#ByFilter:

    define input        parameter startRow     as integer                 no-undo.
    define input        parameter thfPageSize  as integer                 no-undo.
    define input        parameter orderList    as character               no-undo.
    define input        parameter table       for tmp#[Table.module]#Filter.    
    define output       parameter hasNext      as logical                 no-undo.
    define output       parameter table       for tmp#[Table.module]#.
    define input-output parameter table       for rowErrors.         
            
    run getSelectInstruction(output ds-query-aux).
    
    for first tmp#[Table.module]#Filter no-lock:        

        #[whileFields,isFilter=true]#
        *[progress/bo/assignRangeFilter.txt,isRangeFilter=true]**[progress/bo/assignFilter.txt,isRangeFilter=false]*

        #[endWhileFields]#
    end.
    
    assign ds-query-aux = appendQueryOrder(orderList, ds-query-aux).
    
    {hdp/hdrunpersis.i "utils/query-utils-thf.p" "h-query-utils-thf-aux"}
    run executeQuery in h-query-utils-thf-aux (input startRow,   /*page number*/
                                               input thfPageSize,     /*page size*/
                                               input ds-query-aux,
                                               input buffer #[Table.name]#:handle,
                                               input "createTmp#[Table.module]#",
                                               output in-numero-registros-query-aux) no-error.
                                           
    if (startRow + thfPageSize - 1) < in-numero-registros-query-aux
    then hasNext = true.
    
    return "OK".
    
end procedure.

procedure get#[Table.module]#ByQuery:

    define input        parameter startRow     as integer                 no-undo.
    define input        parameter thfPageSize  as integer                 no-undo.
    define input        parameter orderList    as character               no-undo.
    define input        parameter searchQuery  as character               no-undo.
    define output       parameter hasNext      as logical                 no-undo.
    define output       parameter table       for tmp#[Table.module]#.
    define input-output parameter table       for rowErrors.         
    
    define variable in-search-value-aux         as integer no-undo.
    define variable lg-value-integer-aux        as logical no-undo.
    
    run getSelectInstruction(output ds-query-aux).
    
    assign in-search-value-aux = integer(searchQuery) no-error.
    assign lg-value-integer-aux = not error-status:error.
    
    #[whileFields,isFilter=true]#
    *[progress/bo/searchQueryCharacter.txt,databaseType=character]**[progress/bo/searchQueryInteger.txt,databaseType=integer]**[progress/bo/searchQueryOther.txt,!databaseType=integer|!databaseType=character]*

    #[endWhileFields]#
    
    assign ds-query-aux = appendQueryOrder(orderList, ds-query-aux).
    
    {hdp/hdrunpersis.i "utils/query-utils-thf.p" "h-query-utils-thf-aux"}
    run executeQuery in h-query-utils-thf-aux (input startRow,   /*page number*/
                                               input thfPageSize,     /*page size*/
                                               input ds-query-aux,
                                               input buffer #[Table.name]#:handle,
                                               input "createTmp#[Table.module]#",
                                               output in-numero-registros-query-aux) no-error.
                                           
    if (startRow + thfPageSize - 1) < in-numero-registros-query-aux
    then hasNext = true.
    
    return "OK".
    
end procedure.

procedure create#[Table.module]#:
    
    define input        param table for tmp#[Table.module]#.
    define input-output param table for rowErrors.   

    find first tmp#[Table.module]# no-lock no-error.        

    if not available tmp#[Table.module]#
    then do:
        run insertOtherError(input 0,
                             input "Nao foram encontrados dados para a insercao/atualizacao do registro",
                             input "",
                             input "GP",
                             input "ERROR",
                             input "",
                             input-output table rowErrors).
        return "NOK".
    end.
    
    if can-find(first #[Table.name]#
                #[whileFields,isKey=true]#   
                #[IF,isFirst]#where #[endIF]##[IF,!isFirst]#  and #[endIF]##[Table.name]#.#[Field.fieldName]# = tmp#[Table.module]#.#[Field.fieldName]#
                #[endWhileFields]#
                      no-lock)
    then do:
        run insertOtherError(input 0,
                             input "Registro com codigo informado ja existe",
                             input "",
                             input "GP",
                             input "ERROR",
                             input "",
                             input-output table rowErrors).
        return "NOK".
    end.
           
    run validate#[Table.module]#(input table tmp#[Table.module]#,
                              input-output table rowErrors).                
    
    if return-value = "OK"
    then do:
        create #[Table.name]#.    
        run assign#[Table.module]# no-error.

        if error-status:error
        then do:
            run insertOtherError(input 0,
                                 input "Dados invalidos para salvar o registro",
                                 input "",
                                 input "GP",
                                 input "ERROR",
                                 input "",
                                 input-output table rowErrors).
            return "NOK".
        end.
    end.        

end procedure.

procedure update#[Table.module]#:

    define input        param table for tmp#[Table.module]#.
    define input-output param table for rowErrors.   

    find first tmp#[Table.module]# no-lock no-error.        

    if not available tmp#[Table.module]#
    then do:
        run insertOtherError(input 0,
                             input "Nao foram encontrados dados para a insercao/atualizacao do registro",
                             input "",
                             input "GP",
                             input "ERROR",
                             input "",
                             input-output table rowErrors).
        return "NOK".
    end.
         
    if not can-find(first #[Table.name]#
                    #[whileFields,isKey=true]#   
                    #[IF,isFirst]#where #[endIF]##[IF,!isFirst]#  and #[endIF]##[Table.name]#.#[Field.fieldName]# = tmp#[Table.module]#.#[Field.fieldName]#
                    #[endWhileFields]#
                    no-lock)
    then do:
        run insertOtherError(input 0,
                             input "Registro de #[Table.description]# nao encontrado",
                             input "",
                             input "GP",
                             input "ERROR",
                             input "",
                             input-output table rowErrors).
        return "NOK".
    end.
    
    find first #[Table.name]# 
         #[whileFields,isKey=true]#
         #[IF,isFirst]#where#[endIF]##[IF,!isFirst]#  and #[endIF]# #[Table.name]#.#[Field.fieldName]# = tmp#[Table.module]#.#[Field.fieldName]# 
         #[endWhileFields]#
               exclusive-lock no-error.                    
    
    run validate#[Table.module]#(input table tmp#[Table.module]#,
                              input-output table rowErrors).                
    
    if return-value = "OK"
    then do:
        run assign#[Table.module]# no-error.

        if error-status:error
        then do:
            run insertOtherError(input 0,
                                 input "Dados invalidos para salvar o registro",
                                 input "",
                                 input "GP",
                                 input "ERROR",
                                 input "",
                                 input-output table rowErrors).
            return "NOK".
        end.
    end.
end.

procedure validate#[Table.module]# private:
    define input        parameter table for tmp#[Table.module]#.
    define input-output parameter table for rowErrors.   
    
    for first tmp#[Table.module]# no-lock:
        #[whileFields,isRequired=true]#
        #[IF,isFirst]#if#[endIF]##[IF,!isFirst]#or#[endIF]# tmp#[Table.module]#.#[Field.fieldName]# = ?
        or tmp#[Table.module]#.#[Field.fieldName]# = #[IF,databaseType=character]#""#[endIF]##[IF,databaseType=logical]#?#[endIF]##[IF,!databaseType=character|!databaseType=logical]#0#[endIF]#
        #[endWhileFields]#
        then do:
            run insertOtherError(input 0,
                                 input "Preencha os campos obrigatorios",
                                 input "",
                                 input "GP",
                                 input "ERROR",
                                 input "",
                                 input-output table rowErrors).
            return "NOK".
        end.
    end.

    return "OK".
end procedure.

procedure assign#[Table.module]# private:   
    
    buffer-copy tmp#[Table.module]#
          using #[inlineFields,fixedValue=]##[Field.fieldName]# #[endInlineFields]#
             to #[Table.name]#.
    #[whileFields,!fixedValue=]#
    #[IF,isFirst]#assign#[endIF]##[IF,!isFirst]#      #[endIF]# #[Table.name]#.#[Field.fieldName,MaxAttributeSize]# = #[Field.fixedValue]##[IF,isLast]#.#[endIF]#
    #[endWhileFields]#

    validate #[Table.name]# no-error.
    if error-status:error
    then return error.

end procedure.

procedure remove#[Table.module]#:
    
    #[whileFields,isKey=true]#
    def input        param #[Field.fieldName]#-par like #[Table.name]#.#[Field.fieldName]#  no-undo.
    #[endWhileFields]#
    def input-output param table for rowErrors.  
    
    if not can-find(first #[Table.name]#
                    #[whileFields,isKey=true]#   
                    #[IF,isFirst]#where #[endIF]##[IF,!isFirst]#  and #[endIF]##[Table.name]#.#[Field.fieldName]# = #[Field.fieldName]#-par 
                    #[endWhileFields]#
                          no-lock)
                    
    then do:
        run insertOtherError(input 0,
                             input "Registro de #[Table.description]# nao encontrado",
                             input "",
                             input "GP",
                             input "ERROR",
                             input "",
                             input-output table rowErrors).
        return "NOK".
    end.
         
    for first #[Table.name]# 
        #[whileFields,isKey=true]#   
        #[IF,isFirst]#where#[endIF]##[IF,!isFirst]#  and #[endIF]# #[Table.name]#.#[Field.fieldName]# = #[Field.fieldName]#-par
        #[endWhileFields]#        
              exclusive-lock:

        delete #[Table.name]#.
    end.
    
end.

procedure createTmp#[Table.module]#:

    create tmp#[Table.module]#.
    buffer-copy #[Table.name]# to tmp#[Table.module]#.

end.

procedure getSelectInstruction private:
    define output parameter ds-query-par as character no-undo.
    
    assign lg-primeira-condicao-aux = true.
    assign ds-query-par = "PRESELECT EACH #[Table.name]# FIELDS (" +
                          "#[inlineFields]# #[Field.fieldName]##[endInlineFields]#" +
                          ") ".

end procedure.
