using classes.json.GpsJsonUtils.
{utp/ut-api.i}
{utp/ut-api-utils.i}
{utp/ut-api-action.i get#[Table.module]#ByFilter GET    / }
{utp/ut-api-action.i get#[Table.module]#ById     GET    /#[inlineFields,isKey=true]#~*/#[endInlineFields]# }
{utp/ut-api-action.i create#[Table.module]#      POST   / }
{utp/ut-api-action.i update#[Table.module]#      PUT    /#[inlineFields,isKey=true]#~*/#[endInlineFields]# }
{utp/ut-api-action.i remove#[Table.module]#      DELETE /#[inlineFields,isKey=true]#~*/#[endInlineFields]# }
{utp/ut-api-notfound.i}

{#[Table.appModule]#/bosau/bosau-#[Table.component]#.i}
{hdp/hdrunpersis.iv "new"}

define variable expandables as character   no-undo.
define variable startRow    as integer     no-undo.    
define variable pageSize    as integer     no-undo.
define variable queryParams as JsonObject  no-undo.
define variable fieldList   as character   no-undo.
define variable pathParams  as JsonArray   no-undo.
define variable hasNext     as logical     no-undo.
define variable payload     as longchar    no-undo.
define variable oHeaders    as JsonObject  no-undo.
define variable orderList   as character   no-undo.

define variable jsonArray#[Table.module]# as JsonArray  no-undo.
define variable json#[Table.module]#      as JsonObject no-undo.

define variable h-bosau-#[Table.component]#-aux as handle no-undo.

define variable oGpsJsonUtils as GpsJsonUtils no-undo.

procedure setupInputParameters private:
    define input parameter pJsonInput as JsonObject no-undo.
    
    /* bloco copiado da ut-api-utils.i (procedure parseInputParameters) pois nao devolve o parametro "order" */
    define variable oRequestParser as JsonAPIRequestParser no-undo.

    oRequestParser = new JsonAPIRequestParser(pJsonInput).

    assign oHeaders     = oRequestParser:getHeaders()
           pathParams   = oRequestParser:getPathParams()
           queryParams  = oRequestParser:getQueryParams()
           startRow     = oRequestParser:getStartRow()
           pageSize     = oRequestParser:getPageSize()
           fieldList    = oRequestParser:getFieldsChar()
           expandables  = oRequestParser:getExpandChar()
           payload      = oRequestParser:getPayloadLongChar().
    /* fim - ut-api-utils.i */
    
    assign orderList = oRequestParser:getOrderChar().

    assign oGpsJsonUtils                   = new GpsJsonUtils()
           oGpsJsonUtils:outputFields      = fieldList
           oGpsJsonUtils:outputExpandables = expandables.

end.

procedure get#[Table.module]#ById:

    define input  parameter jsonInput  as JsonObject        no-undo.
    define output parameter jsonOutput as JsonObject        no-undo.
    
    #[whileFields,isKey=true]#
    define variable #[Field.fieldName]#-aux as #[Field.databaseType]# no-undo.
    #[endWhileFields]#
    
    run setupInputParameters(input jsonInput).
    
    #[whileFields,isKey=true]#
    #[IF,isFirst]#assign#[endIF]##[IF,!isFirst]#      #[endIF]# #[Field.fieldName]#-aux = #[Field.databaseType,ProgressCast]#(pathParams:getCharacter(#[Field.id]#))#[IF,isLast]#.#[endIF]#
    #[endWhileFields]#

    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run get#[Table.module]#ById in h-bosau-#[Table.component]#-aux(
        #[whileFields,isKey=true]#
        input  #[Field.fieldName]#-aux,
        #[endWhileFields]#
        output table tmp#[Table.module]#,
        input-output table rowErrors) no-error.
    if error-status:error
    then run insertErrorProgress(input "", input "", input-output table rowErrors).
    else assign json#[Table.module]# = oGpsJsonUtils:getJsonObjectFromTable(temp-table tmp#[Table.module]#:default-buffer-handle).
    run createJsonResponse(json#[Table.module]#, input table RowErrors, input false, output jsonOutput). 

end procedure.

procedure get#[Table.module]#ByFilter:

    define input  parameter jsonInput  as JsonObject no-undo.
    define output parameter jsonOutput as JsonObject no-undo.       

    define variable searchQueryAux  as character     no-undo.
    
    run setupInputParameters(input jsonInput).
                             
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    if queryParams:has("search")
    then do:
        assign searchQueryAux = queryParams:GetJsonArray("search"):getCharacter(1).
            
        run get#[Table.module]#ByQuery in h-bosau-#[Table.component]#-aux(
            input  startRow,
            input  pageSize,
            input  orderList,
            input  searchQueryAux,
            output hasNext,
            output table tmp#[Table.module]#,
            input-output table rowErrors) no-error.
    end.
    else do:
        run getTempFilter(input  queryParams,
                          output table tmp#[Table.module]#Filter).                          

        run get#[Table.module]#ByFilter in h-bosau-#[Table.component]#-aux(
            input  startRow,
            input  pageSize,
            input  orderList,
            input  table tmp#[Table.module]#Filter,
            output hasNext,
            output table tmp#[Table.module]#,
            input-output table rowErrors) no-error.
    end.

    if error-status:error
    then run insertErrorProgress(input "", input "", input-output table rowErrors).
    else assign jsonArray#[Table.module]# = oGpsJsonUtils:getJsonArrayFromTable(temp-table tmp#[Table.module]#:default-buffer-handle).

    run createJsonResponse(jsonArray#[Table.module]#, input table RowErrors, input hasNext, output jsonOutput). 
    
end procedure.

procedure create#[Table.module]#:

   define input  parameter jsonInput  as JsonObject no-undo.
   define output parameter jsonOutput as JsonObject no-undo.
   
   define variable jsonPayload as JsonObject no-undo.
   
   run setupInputParameters(input jsonInput).
   
   assign jsonPayload = oGpsJsonUtils:longcharToJsonObject(payload).
   
   run getTempTable(input jsonPayload,
                    output table tmp#[Table.module]#) no-error.
                     
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run create#[Table.module]# in h-bosau-#[Table.component]#-aux(
        input        table tmp#[Table.module]#,
        input-output table rowErrors) no-error.

    if error-status:error
    then run insertErrorProgress(input "", input "", input-output table rowErrors).
    
    run createJsonResponse(new JsonObject(), input table RowErrors, input false, output jsonOutput). 

end.


procedure update#[Table.module]#:

   define input  parameter jsonInput  as JsonObject no-undo.
   define output parameter jsonOutput as JsonObject no-undo.
   
   define variable jsonPayload as JsonObject no-undo.
   
   run setupInputParameters(input jsonInput).
   
   assign jsonPayload = oGpsJsonUtils:longcharToJsonObject(payload).
   
   run getTempTable(input jsonPayload,
                    output table tmp#[Table.module]#) no-error.
                     
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run update#[Table.module]# in h-bosau-#[Table.component]#-aux(
        input        table tmp#[Table.module]#,
        input-output table rowErrors) no-error.
    
    if error-status:error
    then run insertErrorProgress(input "", input "", input-output table rowErrors).
    
    run createJsonResponse(new JsonObject(), input table RowErrors, input false, output jsonOutput). 

end procedure.

procedure remove#[Table.module]#:

    define input  parameter jsonInput  as JsonObject no-undo.
    define output parameter jsonOutput as JsonObject no-undo.
    
    run setupInputParameters(input jsonInput).
    
    {hdp/hdrunpersis.i "#[Table.appModule]#/bosau/bosau-#[Table.component]#.p" "h-bosau-#[Table.component]#-aux"}
    run remove#[Table.module]# in h-bosau-#[Table.component]#-aux(
        #[whileFields,isKey=true]#
        input        #[Field.databaseType,ProgressCast]#(pathParams:getCharacter(#[Field.id]#)),
        #[endWhileFields]#
        input-output table rowErrors) no-error.

    if error-status:error
    then run insertErrorProgress(input "", input "", input-output table rowErrors).
                                                                                                                        
    run createJsonResponse(new JsonObject(), input table RowErrors, input false, output jsonOutput). 

end procedure.

procedure getTempTable private:

    define input  parameter jsonPayload as JsonObject.
    define output parameter table for tmp#[Table.module]#.

    create tmp#[Table.module]#.     
    #[whileFields]#
    #[IF,isFirst]#assign#[endIF]##[IF,!isFirst]#      #[endIF]# tmp#[Table.module]#.#[Field.fieldName,MaxAttributeSize]# = jsonPayload:get#[Field.databaseType]#(temp-table tmp#[Table.module]#:default-buffer-handle:buffer-field("#[Field.fieldName]#"):serialize-name)#[IF,isLast]#.#[endIF]#
    #[endWhileFields]#
    
end procedure.

procedure getTempFilter private:

    define input  parameter queryParams      as JsonObject no-undo.
    define output parameter table           for tmp#[Table.module]#Filter.
                                            
    create tmp#[Table.module]#Filter.
    #[whileFields,isFilter=true]#
    *[progress/api/assignTmpFilterRange.txt,isRangeFilter=true]**[progress/api/assignTmpFilter.txt,isRangeFilter=false]*
    #[endWhileFields]#        

end procedure.

finally:
    {hdp/hddelpersis.i}
end.
