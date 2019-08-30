define temp-table tmpTable no-undo
    field name              as character
    field component         as character
    field module            as character
    field controller        as character
    field description       as character
    field pageTitle         as character
    field appModule         as character
    field appVersion        as character
    field minimumVersion    as character.
    
define temp-table tmpField no-undo
    field id                as integer
    field name              as character
    field fieldName         as character
    field description       as character
    field databaseType      as character
    field inputType         as character
    field inputFormat       as character
    field defaultValue      as character
    field fixedValue        as character
    field pipeClass         as character 
    field maxSize           as integer
    field isKey             as log format 'true/false'
    field isRequired        as log format 'true/false'
    field isVisible         as log format 'true/false'
    field isListable        as log format 'true/false'
    field isEditable        as log format 'true/false'
    field isLink            as log format 'true/false'
    field isFilter          as log format 'true/false'
    field isRangeFilter     as log format 'true/false'
    field inputComponent    as character
    field zoomComponent     as character
    field enumComponent     as character.
    
define temp-table tmpFiles no-undo
    field inputFileName     as character
    field outputFileName    as character.

define temp-table tmpTranslation no-undo
    field brText as character
    field usText as character.

define temp-table tmpShorten no-undo
    field shortText as character
    field fullText as character.

define temp-table tmpPipe no-undo
    field selector  as character
    field component as character.

define temp-table tmpEnum no-undo
    field idEnum        as integer
    field component     as character
    field module        as character
    field controller    as character
    field description   as character
    field valueDatatype as character.

define temp-table tmpEnumItem no-undo
    field idEnum        as integer
    field idSequence    as integer
    field enumValue     as character
    field enumLabel     as character.
    
define temp-table tmpInputComponent no-undo
    field component     as character
    field description   as character.
    
define temp-table tmpZoom no-undo
    like tmpTable
    field idZoom        as integer.

define temp-table tmpZoomItem no-undo
    like tmpField
    field idZoom        as integer
    field idSequence    as integer
    field isLabel       as logical.

/* Temps auxiliares que podem ser usadas dentro de loops */
define temp-table tmpFilterField like tmpField.
define temp-table tmpFilterEnumItem like tmpEnumItem.
define temp-table tmpFilterZoomItem like tmpZoomItem.

/* Temps auxiliares para serem usadas para salvar/carregar dados durante a configuracao */
define temp-table tmpSaveTable like tmpTable.
define temp-table tmpSaveField like tmpField.

function pascalCase returns character (input text-par as character):
    define variable ix  as integer   no-undo.
    define variable res as character no-undo.
    
    assign res = "".
    do ix = 1 to num-entries(text-par, "-"):
        assign res = res + caps (substring(entry(ix, text-par, "-"), 1, 1)) +
                           lower(substring(entry(ix, text-par, "-"), 2)).
    end.
    return res.
end function.

function camelCase returns character (input text-par as character):
    assign text-par = pascalCase(text-par)
           text-par = lower(substring(text-par, 1, 1)) +
                           (substring(text-par, 2)).
    return text-par.
end function.

function normaliza-path returns character (input nm-dir-par as character):
    assign nm-dir-par = replace(nm-dir-par, "~\", "/").
    if r-index(nm-dir-par, "/") < length(nm-dir-par)
    then assign nm-dir-par = nm-dir-par + "/".
    return nm-dir-par.
end function.

function appendToString returns character (input sOriginal as character, input sText as character, input sSeparator as character):
    if sOriginal <> ""
    then assign sOriginal = sOriginal + sSeparator.

    assign sOriginal = sOriginal + sText.
    return sOriginal.
end function.
    
function getTableHandle returns handle (input nmTable as character):
    case nmTable:
        when "Table"
        then return temp-table tmpTable:default-buffer-handle.
        
        when "Field"
        then return temp-table tmpFilterField:default-buffer-handle.
        
        when "Enum"
        then return temp-table tmpEnum:default-buffer-handle.
        
        when "EnumItem"
        then return temp-table tmpFilterEnumItem:default-buffer-handle.
        
        when "Zoom"
        then return temp-table tmpZoom:default-buffer-handle.
        
        when "ZoomItem"
        then return temp-table tmpFilterZoomItem:default-buffer-handle.
    end case.
end function.

function getSizeFromFormat returns integer (input formatString as character):
    
    if formatString matches ("x(*)")
    then return integer(substring(formatString, 3, length(formatString) - 3)).
    else return length(formatString).
    
end function.

function getInputFormat returns character (input databaseType as character, input formatString as character):

    if not (databaseType begins "char")
    then return "".
    
    if formatString matches ("x(*)")
    then return "".
    else return formatString.
    
end function.
    