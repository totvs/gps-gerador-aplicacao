{generateCRUD.i}

define input parameter nmDiretorioLocal    as character    no-undo.
define input parameter nmDiretorioSaves    as character    no-undo.
define input parameter nmDiretorioIncludes as character    no-undo.
define input parameter nmDiretorioInput    as character    no-undo.
define input parameter nmDiretorioOutput   as character    no-undo.
define input parameter nmArquivoDados      as character    no-undo.

if search(nmDiretorioSaves + "/" + nmArquivoDados + ".table.d") = ?
or search(nmDiretorioSaves + "/" + nmArquivoDados + ".field.d") = ?
then return.

run leDadosTable.
run leDadosField.
run leDadosEnum.
run leDadosZoom.
    
find first tmpTable no-error.

if not available tmpTable
then return.


run generateCRUD.p(input nmDiretorioLocal,
                   input nmDiretorioSaves,
                   input nmDiretorioIncludes,
                   input nmDiretorioInput,
                   input nmDiretorioOutput,
                   input table tmpTable,
                   input table tmpField,
                   input table tmpEnum,
                   input table tmpEnumItem,
                   input table tmpZoom,
                   input table tmpZoomItem) no-error.

procedure leDadosTable:
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".table.d") convert source "utf-8".
    repeat:
        create tmpTable.
        import tmpTable.
        release tmpTable.
    end.
    input close.
    
    // remove o lixo do baguio
    for each tmpTable where tmpTable.name = "":
        delete tmpTable.
    end.
    
end procedure.

procedure leDadosField:
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".field.d") convert source "utf-8".
    repeat:
        create tmpField.
        import tmpField.
        release tmpField.
    end.
    input close.
    
    // remove o lixo do baguio
    for each tmpField where tmpField.id = 0:
        delete tmpField.
    end.
    
end procedure.

procedure leDadosEnum:
    
    if search(nmDiretorioSaves + "/" + nmArquivoDados + ".enum.d") = ?
    or search(nmDiretorioSaves + "/" + nmArquivoDados + ".enum.item.d") = ?
    then return.
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".enum.d") convert source "utf-8".
    repeat:
        create tmpEnum.
        import tmpEnum.
        release tmpEnum.
    end.
    input close.
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".enum.item.d") convert source "utf-8".
    repeat:
        create tmpEnumItem.
        import tmpEnumItem.
        release tmpEnumItem.
    end.
    input close.
    
    // remove o lixo do baguio
    for each tmpEnum where tmpEnum.idEnum = 0:
        delete tmpEnum.
    end.
    for each tmpEnumItem where tmpEnumItem.idEnum = 0:
        delete tmpEnumItem.
    end.
    
end procedure.

procedure leDadosZoom:
    
    if search(nmDiretorioSaves + "/" + nmArquivoDados + ".zoom.d") = ?
    or search(nmDiretorioSaves + "/" + nmArquivoDados + ".zoom.item.d") = ?
    then return.
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".zoom.d") convert source "utf-8".
    repeat:
        create tmpZoom.
        import tmpZoom.
        release tmpZoom.
    end.
    input close.
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".zoom.item.d") convert source "utf-8".
    repeat:
        create tmpZoomItem.
        import tmpZoomItem.
        release tmpZoomItem.
    end.
    input close.
    
    // remove o lixo do baguio
    for each tmpZoom where tmpZoom.idZoom = 0:
        delete tmpZoom.
    end.
    for each tmpZoomItem where tmpZoomItem.idZoom = 0:
        delete tmpZoomItem.
    end.
    
end procedure.
