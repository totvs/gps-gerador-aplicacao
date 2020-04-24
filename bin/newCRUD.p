{bin/generateCRUD.i}

define input parameter nmDiretorioLocal    as character    no-undo.
define input parameter nmDiretorioSaves    as character    no-undo.
define input parameter nmDiretorioIncludes as character    no-undo.
define input parameter nmDiretorioInput    as character    no-undo.
define input parameter nmDiretorioOutput   as character    no-undo.


define variable lg-confirma-aux     as logical      no-undo.
define variable nmArquivoDados      as character    no-undo.

/* --- Definicoes de enumerador ---------------------------------------------------------------- */

define query qry-enum for tmpEnum scrolling.

define browse brw-enum query qry-enum
    display tmpEnum.component   column-label "Enumerador"   format "x(32)"
            tmpEnum.description column-label "Descricao"    format "x(62)"
            with title "Enumeradores" size 98 by 12 separators.

define frame f-enum
    brw-enum skip
    " F1 - Voltar, F5 - Incluir, F6 - Excluir, ENTER - Editar" //, F9 - Importar, F10 - Exportar"
    with no-box centered row 8 size 98 by 13.5.
    
define frame f-enumEdit
    tmpEnum.component       label "Enumerador"      format "x(32)" colon 15 
    "(Nome em ingles, hifen como separador)"  at 58
    tmpEnum.description     label "Descricao"       format "x(80)" colon 15
    tmpEnum.valueDatatype   label "Tipo de dado"    format "x(32)" colon 15
    with side-labels title "Enumerador" centered row 8 size 98 by 4.5.
    
/* --- Definicoes dos itens do enumerador ------------------------------------------------------ */
    
define query qry-enumItem for tmpEnumItem scrolling.

define browse brw-enumItem query qry-enumItem
    display tmpEnumItem.enumValue  column-label "Valor"     format "x(32)"
            tmpEnumItem.enumLabel  column-label "Descricao" format "x(62)"
            with title "Valores do enumerador" size 98 by 11 separators.

define frame f-enumItemList
    tmpEnum.component label "Enumerador" format "x(32)" skip
    brw-enumItem skip
    " F1 - Confirmar, F5 - Incluir, F6 - Excluir, ENTER - Editar selecionado"
    with no-box side-labels centered row 8 size 98 by 13.5.
    
define frame f-enumItemEdit
    tmpEnumItem.enumValue label "Valor"     format "x(32)" colon 12
    tmpEnumItem.enumLabel label "Descricao" format "x(62)" colon 12
    with title "Item do enumerador" side-labels centered row 14 size 76 by 3.5 overlay.

/* --- Definicoes de zoom ---------------------------------------------------------------------- */

define query qry-zoom for tmpZoom scrolling.

define browse brw-zoom query qry-zoom
    display tmpZoom.component   column-label "Zoom"         format "x(32)"
            tmpZoom.description column-label "Descricao"    format "x(62)"
            with title "Zooms" size 98 by 12 separators.

define frame f-zoom
    brw-zoom skip
    " F1 - Voltar, F5 - Incluir, F6 - Excluir, ENTER - Editar campos" //, F9 - Importar, F10 - Exportar"
    with no-box centered row 8 size 98 by 13.5.
    
define frame f-zoomEdit
    tmpZoom.name    label "Tabela"          format "x(32)" at 2
    with side-labels title "Zoom" centered row 8 size 42 by 2.5.
    
/* --- Definicoes dos itens do zoom ------------------------------------------------------------ */
    
define query qry-zoomItem for tmpZoomItem scrolling.

define browse brw-zoomItem query qry-zoomItem
    display tmpZoomItem.fieldName   column-label "Campo"     format "x(32)"
            tmpZoomItem.description column-label "Descricao" format "x(62)"
            tmpZoomItem.isLabel     column-label "Label"     format "Sim/Nao"
            with title "Campos do zoom" size 98 by 11 separators.

define frame f-zoomItemList
    tmpZoom.component label "Zoom" format "x(32)" skip
    brw-zoomItem skip
    " F1 - Confirmar, F5 - Incluir, F6 - Excluir, ENTER - Marcar como label"
    with no-box side-labels centered row 8 size 98 by 13.5.

define query qry-zoomSelect for tmpSaveField scrolling.

define browse brw-zoomSelect query qry-zoomSelect
    display tmpSaveField.fieldName      column-label "Campo"        format "x(32)"
            tmpSaveField.description    column-label "Descricao"    format "x(62)"
            with title "Incluir campo da tabela" size 98 by 11 separators.
    
define frame f-zoomSelect
    brw-zoomSelect skip
    " ENTER - Selecionar, ESC - Cancelar"
    with no-box side-labels centered row 9 size 98 by 12.5 overlay.


/* --- Definicoes de tabela/campos ------------------------------------------------------------- */

define frame f-tabela 
    tmpTable.name           label "Tabela"          format "x(32)" colon 15
    tmpTable.component      label "Componente"      format "x(40)" colon 15
    "(Nome em ingles, hifen como separador)"  at 58
    /*tmpTable.module         label "Modulo"          format "x(50)" colon 15
    tmpTable.controller     label "Controller"      format "x(50)" colon 15*/
    tmpTable.description    label "Descricao"       format "x(80)" colon 15
    tmpTable.pageTitle      label "Titulo Pagina"   format "x(80)" colon 15
    tmpTable.appModule      label "Modulo"          format "x(16)" colon 15
    tmpTable.appVersion     label "Versao API"      format "x(16)" colon 44
    tmpTable.minimumVersion label "Release"         format "x(16)" colon 71
    with side-labels title "Gerador de CRUD" centered row 1 size 98 by 6.5.
    
define frame f-campo
    tmpField.id                   no-label              format "99999"   at row 1 column 135
    tmpField.fieldName      label " Campo da tabela"    format "x(32)"   at row 1 column 2
    tmpField.name           label "     Campo (API)"    format "x(60)"   at row 2 column 2
    tmpField.description    label "    Nome em tela"    format "x(60)"   at row 3 column 2
    tmpField.databaseType   label "  Tipo dado (BD)"    format "x(32)"   at row 4 column 2
    tmpField.inputType      label "Tipo dado (tela)"    format "x(32)"   at row 4 column 53
    tmpField.inputFormat    label " Formato entrada"    format "x(32)"   at row 5 column 2
    tmpField.maxSize        label "  Tamanho maximo"    format ">>>>9"   at row 5 column 53
    tmpField.defaultValue   label "   Valor inicial"    format "x(60)"   at row 6 column 2
    tmpField.fixedValue     label "      Valor fixo"    format "x(60)"   at row 7 column 2
    
    tmpField.inputComponent label "   Comp. Entrada"    format "x(60)"   at row 8 column 2
    tmpField.enumComponent  label "      Enumerador"    format "x(60)"   at row 9 column 2
    tmpField.zoomComponent  label "            Zoom"    format "x(60)"   at row 10 column 2
    "F5 - Componente de entrada, F6 - Enumerador, F7 - Zoom, F8 - Limpar" at row 12 column 19
    
    
    tmpField.isKey          label "   Chave primaria"   format "Sim/Nao" at row 4 column 115
    tmpField.isRequired     label "      Obrigatorio"   format "Sim/Nao" at row 5 column 115
    tmpField.isVisible      label "          Visivel"   format "Sim/Nao" at row 6 column 115
    tmpField.isEditable     label "         Editavel"   format "Sim/Nao" at row 7 column 115
    tmpField.isListable     label "  Listado no grid"   format "Sim/Nao" at row 8 column 115
    tmpField.isLink         label "Link para detalhe"   format "Sim/Nao" at row 9 column 115
    tmpField.isFilter       label "  Usado no filtro"   format "Sim/Nao" at row 10 column 115
    tmpField.isRangeFilter  label "   Filtro Ini/Fim"   format "Sim/Nao" at row 11 column 115
    with side-labels title "Colunas" centered row 8 size 139 by 13.5.
    
define query qry-campos for tmpField scrolling.

define browse brw-campos query qry-campos
    display tmpField.fieldName              column-label "Campo"        format "x(32)"
            tmpField.name                   column-label "Campo(THF)"   format "x(32)"
            tmpField.description            column-label "Descricao"    format "x(71)"
            with title "Campos incluidos" size 139 by 11 separators.

define frame f-campos
    brw-campos skip
    " F1 - Gerar, F4 - Cancelar, F5 - Incluir campo, F6 - Excluir campo, ENTER - Editar campo, F9 - Enumeradores, F10 - Zooms"
    with no-box centered row 9 size 139 by 12.5.

define frame f-salvar-dados
    nmArquivoDados       label "Arquivo de dados"    format "x(50)"
    with side-labels title "Salvar dados" centered row 11 overlay.
    
define query q-file for _file, _field.
    
define browse b-file query q-file
   disp _field._field-name  column-label "Campo"          format "x(23)"
        _field._desc        column-label "Descricao"      format "x(40)"
        with title "Selecione o campo da tabela" centered size 68 by 12.
            
define frame f-field-selection 
    b-file at 1
    with size 68 BY 12 centered no-box row 9.
    
/* --- Zoom de enumeradores -------------------------------------------------------------------- */
define buffer bz-tmpEnum for tmpEnum.
define query qry-zoomEnum for bz-tmpEnum scrolling.

define browse brw-zoomEnum query qry-zoomEnum
    display bz-tmpEnum.component   column-label "Enumerador"   format "x(32)"
            bz-tmpEnum.description column-label "Descricao"    format "x(62)"
            with title "Enumeradores" size 98 by 10 separators.

define frame f-zoomEnum
    brw-zoomEnum
    with no-box centered row 10 size 98 by 10.5 overlay.
    
/* --- Zoom de zooms --------------------------------------------------------------------------- */
define buffer bz-tmpZoom for tmpZoom.
define query qry-zoomZoom for bz-tmpZoom scrolling.

define browse brw-zoomZoom query qry-zoomZoom
    display bz-tmpZoom.component   column-label "Zoom"         format "x(32)"
            bz-tmpZoom.name        column-label "Tabela"       format "x(32)"
            bz-tmpZoom.description column-label "Descricao"    format "x(62)"
            with title "Zooms" size 130 by 10 separators.

define frame f-zoomZoom
    brw-zoomZoom
    with no-box centered row 10 size 130 by 10.5 overlay.
    
/* --- Zoom de componente de entrada ----------------------------------------------------------- */
define buffer bz-tmpInputComponent for tmpInputComponent.
define query qry-zoomInputComponent for bz-tmpInputComponent scrolling.

define browse brw-zoomInputComponent query qry-zoomInputComponent
    display bz-tmpInputComponent.component   column-label "Componente"   format "x(32)"
            bz-tmpInputComponent.description column-label "Descricao"    format "x(62)"
            with title "Componentes de entrada" size 98 by 10 separators.

define frame f-zoomInputComponent
    brw-zoomInputComponent
    with no-box centered row 10 size 98 by 10.5 overlay.

/* --- Inicializacao --------------------------------------------------------------------------- */
    
run loadTranslation.
run loadShortText.
run loadComponents.
run initTableInput.

if not available tmpTable
then return.

/* --- Acoes do browse dos campos -------------------------------------------------------------- */

on f1 of brw-campos do:
    hide frame f-campos no-pause.
    
    /* salva resultado */
    repeat on endkey undo,leave:
        assign nmArquivoDados = tmpTable.name.
        update nmArquivoDados with frame f-salvar-dados.

        run gravaDadosTable(input nmArquivoDados).
        run gravaDadosField(input nmArquivoDados).
        run gravaDadosEnum(input nmArquivoDados).
        run gravaDadosZoom(input nmArquivoDados).

        run bin/generateCRUD.p(
            input nmDiretorioLocal,
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
                           
        if error-status:error
        then do:
            message "Ocorreu um erro ao tentar gerar os dados"
                    view-as alert-box info buttons ok.
            return.
        end.
        
        quit.
    end.
    
    apply "endkey" to brw-campos in frame f-campos.
end.

on f4 of brw-campos do:
    assign lg-confirma-aux = false.
    
    message "Deseja realmente cancelar?" skip 
            "Nenhuma informacao sera salva."
            view-as alert-box question buttons yes-no update lg-confirma-aux.
            
    if lg-confirma-aux
    then quit.
end.

on f5 of brw-campos do:
    run openFieldSelection.
    hide frame f-field-selection.
    
    if not available tmpField
    then leave.
    
    run createField no-error.
    
    if error-status:error
    and available tmpField
    then delete tmpField.
    
    hide frame f-campo no-pause.
    clear frame f-campo no-pause.
    hide message no-pause.

    apply "endkey" to brw-campos in frame f-campos.
end.

on f6 of brw-campos do:
    if not available tmpField
    then leave.
    
    assign lg-confirma-aux = false.
    message "Confirma exclusao do campo" tmpField.fieldName
            view-as alert-box question buttons yes-no update lg-confirma-aux.
            
    if lg-confirma-aux
    then do:
        delete tmpField.
        apply "endkey" to brw-campos in frame f-campos.
    end.
end.

on f9 of brw-campos do:
    hide frame f-field-selection.
    
    repeat on endkey undo,retry on stop undo,leave with frame f-enum:
    
        close query qry-enum.
        open query qry-enum for each tmpEnum.
        enable brw-enum with frame f-enum.

        wait-for endkey of brw-enum.
    end.

    apply "endkey" to brw-campos in frame f-campos.
end.

on f10 of brw-campos do:
    hide frame f-field-selection.
    
    repeat on endkey undo,retry on stop undo,leave with frame f-zoom:
    
        close query qry-zoom.
        open query qry-zoom for each tmpZoom.
        enable brw-zoom with frame f-zoom.

        wait-for endkey of brw-zoom.
    end.

    apply "endkey" to brw-campos in frame f-campos.
end.

on "return" of brw-campos do:
    if not available tmpField
    then leave.
    
    run createField no-error.
    
    hide frame f-campo no-pause.
    clear frame f-campo no-pause.

    apply "endkey" to brw-campos in frame f-campos.
end.

/* --- Acoes do browse do enumerador ----------------------------------------------------------- */

on f1 of brw-enum do:

    /* Valida se algum enumerador esta sem campos */
    for each tmpEnum:
        if not can-find(first tmpEnumItem where tmpEnumItem.idEnum = tmpEnum.idEnum)
        then do:
            message "Enumerador" tmpEnum.component "nao possui valores"
                    view-as alert-box info buttons ok.
            undo, return.
        end.
    end.

    apply "stop" to brw-enum in frame f-enum.
end.

on f5 of brw-enum do:
    hide frame f-enum.
    
    run createEnum no-error.
    
    if error-status:error
    and available tmpEnum
    then do:
        delete tmpEnum.
        release tmpEnum.
    end.
    
    hide frame f-enumEdit no-pause.
    clear frame f-enumEdit no-pause.
    
    if available tmpEnum
    then repeat on endkey undo,retry on stop undo,leave with frame f-enumItemList:
    
        close query qry-enumItem.
        open query qry-enumItem for each tmpEnumItem where tmpEnumItem.idEnum = tmpEnum.idEnum.
        disp tmpEnum.component with frame f-enumItemList.
        enable brw-enumItem with frame f-enumItemList.

        wait-for endkey of brw-enumItem.
    end.
    
    hide frame f-enumItemList no-pause.
    clear frame f-enumItemList no-pause.

    apply "endkey" to brw-enum in frame f-enum.
end.

on f6 of brw-enum do:
    if not available tmpEnum
    then leave.
    
    assign lg-confirma-aux = false.
    message "Confirma exclusao do enumerador" tmpEnum.component
            view-as alert-box question buttons yes-no update lg-confirma-aux.
            
    if lg-confirma-aux
    then do:
        for each tmpEnumItem
            where tmpEnumItem.idEnum = tmpEnum.idenum:
            delete tmpEnumItem.
        end.
        delete tmpEnum.
        apply "endkey" to brw-enum in frame f-enum.
    end.
end.

on "return" of brw-enum do:
    hide frame f-enumEdit no-pause.
    clear frame f-enumEdit no-pause.
    
    if available tmpEnum
    then repeat on endkey undo,retry on stop undo,leave with frame f-enumItemList:
    
        close query qry-enumItem.
        open query qry-enumItem for each tmpEnumItem where tmpEnumItem.idEnum = tmpEnum.idEnum.
        disp tmpEnum.component with frame f-enumItemList.
        enable brw-enumItem with frame f-enumItemList.

        wait-for endkey of brw-enumItem.
    end.
    
    hide frame f-enumItemList no-pause.
    clear frame f-enumItemList no-pause.

    apply "endkey" to brw-enum in frame f-enum.
end.

on f9 of brw-enum do:
    // importar
end.

on f10 of brw-enum do:
    // exportar
end.

/* --- Acoes do browse de itens do enumerador -------------------------------------------------- */

on f1 of brw-enumItem do:
    apply "stop" to brw-enumItem in frame f-enumItemList.
end.

on f5 of brw-enumItem do:
    run createEnumItem(input true) no-error.
    
    if error-status:error
    and available tmpEnumItem
    then do:
        delete tmpEnumItem.
        release tmpEnumItem.
    end.
    
    hide frame f-enumItemEdit no-pause.
    clear frame f-enumItemEdit no-pause.
    
    apply "endkey" to brw-enumItem in frame f-enumItemList.
end.

on f6 of brw-enumItem do:
    if not available tmpEnumItem
    then leave.
    
    assign lg-confirma-aux = false.
    message "Confirma exclusao do valor" tmpEnumItem.enumValue
            view-as alert-box question buttons yes-no update lg-confirma-aux.
            
    if lg-confirma-aux
    then do:
        delete tmpEnumItem.
        apply "endkey" to brw-enumItem in frame f-enumItemList.
    end.
end.

on "return" of brw-enumItem do:
    if not available tmpEnumItem
    then leave.
    
    run createEnumItem(input false) no-error.
    
    hide frame f-enumItemEdit no-pause.
    clear frame f-enumItemEdit no-pause.
    
    apply "endkey" to brw-enumItem in frame f-enumItemList.
end.

/* --- Acoes do browse do zoom ----------------------------------------------------------------- */

on f1 of brw-zoom do:

    /* Valida se algum zoom esta sem campos */
    for each tmpZoom:
        if not can-find(first tmpZoomItem where tmpZoomItem.idZoom = tmpZoom.idZoom)
        then do:
            message "Zoom" tmpZoom.name "nao possui campos"
                    view-as alert-box info buttons ok.
            undo, return.
        end.
    end.

    apply "stop" to brw-zoom in frame f-zoom.
end.

on f5 of brw-zoom do:
    hide frame f-zoom.
    
    run createZoom no-error.
    
    if error-status:error
    and available tmpZoom
    then do:
        delete tmpZoom.
        release tmpZoom.
    end.
    
    hide frame f-zoomEdit no-pause.
    clear frame f-zoomEdit no-pause.
    
    if available tmpZoom
    then repeat on endkey undo,retry on stop undo,leave with frame f-zoomItemList:
    
        close query qry-zoomItem.
        open query qry-zoomItem for each tmpZoomItem where tmpZoomItem.idZoom = tmpZoom.idZoom.
        disp tmpZoom.component with frame f-zoomItemList.
        enable brw-zoomItem with frame f-zoomItemList.

        wait-for endkey of brw-zoomItem.
    end.
    
    hide frame f-zoomItemList no-pause.
    clear frame f-zoomItemList no-pause.

    apply "endkey" to brw-zoom in frame f-zoom.
end.

on f6 of brw-zoom do:
    if not available tmpZoom
    then leave.
    
    assign lg-confirma-aux = false.
    message "Confirma exclusao do zoom" tmpZoom.component
            view-as alert-box question buttons yes-no update lg-confirma-aux.
            
    if lg-confirma-aux
    then do:
        for each tmpZoomItem
            where tmpZoomItem.idZoom = tmpZoom.idZoom:
            delete tmpZoomItem.
        end.
        delete tmpZoom.
        apply "endkey" to brw-zoom in frame f-zoom.
    end.
end.

on "return" of brw-zoom do:
    if not available tmpZoom
    then return.
    
    run carregaDadosTable(tmpZoom.name).
    run carregaDadosField(tmpZoom.name).

    hide frame f-zoomEdit no-pause.
    clear frame f-zoomEdit no-pause.
    
    repeat on endkey undo,retry on stop undo,leave with frame f-zoomItemList:
        close query qry-zoomItem.
        open query qry-zoomItem for each tmpZoomItem where tmpZoomItem.idZoom = tmpZoom.idZoom.
        disp tmpZoom.component with frame f-zoomItemList.
        enable brw-zoomItem with frame f-zoomItemList.

        wait-for endkey of brw-zoomItem.
    end.
    
    hide frame f-zoomItemList no-pause.
    clear frame f-zoomItemList no-pause.

    apply "endkey" to brw-zoom in frame f-zoom.
end.

on f9 of brw-zoom do:
    // importar
end.

on f10 of brw-zoom do:
    // exportar
end.

/* --- Acoes do browse de itens do zoom -------------------------------------------------------- */

on f1 of brw-zoomItem do:

    /* Consiste se existe pelo menos um campo com chave, e um campo com label */
    if can-find(first tmpZoomItem where tmpZoomItem.idZoom = tmpZoom.idZoom)
    then do:
        if not can-find(first tmpZoomItem where tmpZoomItem.idZoom = tmpZoom.idZoom and tmpZoomItem.isKey)
        then do:
            message "Adicione um campo de chave primaria no Zoom"
                    view-as alert-box info buttons ok.
            undo, return.
        end.
        if not can-find(first tmpZoomItem where tmpZoomItem.idZoom = tmpZoom.idZoom and tmpZoomItem.isLabel)
        then do:
            message "Adicione um campo de label no Zoom"
                    view-as alert-box info buttons ok.
            undo, return.
        end.
    end.

    apply "stop" to brw-zoomItem in frame f-zoomItemList.
end.

on f5 of brw-zoomItem do:
    run selectZoomItem no-error.
    hide frame f-zoomSelect.
    
    apply "endkey" to brw-zoomItem in frame f-zoomItemList.
end.

on f6 of brw-zoomItem do:
    if not available tmpZoomItem
    then leave.
    
    assign lg-confirma-aux = false.
    message "Confirma exclusao do campo" tmpZoomItem.fieldName
            view-as alert-box question buttons yes-no update lg-confirma-aux.
            
    if lg-confirma-aux
    then do:
        delete tmpZoomItem.
        apply "endkey" to brw-zoomItem in frame f-zoomItemList.
    end.
end.

on "return" of brw-zoomItem do:
    define buffer bf-tmpZoomItem for tmpZoomItem.
    
    if not available tmpZoomItem
    then leave.
    
    /* Permite apenas um item como label */
    for each bf-tmpZoomItem
        where bf-tmpZoomItem.idZoom = tmpZoom.idZoom:
        assign bf-tmpZoomItem.isLabel = false.
    end.
    assign tmpZoomItem.isLabel = true.
    
    apply "endkey" to brw-zoomItem in frame f-zoomItemList.
end.

/* --- Processo de inclusao dos dados da tabela ------------------------------------------------ */

repeat on endkey undo,return:
    update 
        tmpTable.name
        with frame f-tabela.

    if not can-find(first _file where _file-name = tmpTable.name no-lock)
    then do:
            message "Tabela nao encontrada"
                    view-as alert-box info buttons ok.
            undo,retry.
    end.
    
    assign tmpTable.component = tmpTable.name.
    
    update 
        tmpTable.component
        with frame f-tabela.
        
    if tmpTable.component = ""
    then undo,retry.
    
    run generateTableInput.
    
    update 
        /*tmpTable.module     
        tmpTable.controller */
        tmpTable.description
        tmpTable.pageTitle  
        tmpTable.appModule
        tmpTable.appversion
        tmpTable.minimumVersion
        with frame f-tabela.

    if tmpTable.module         = ""
    or tmpTable.controller     = ""
    or tmpTable.description    = ""
    or tmpTable.pageTitle      = ""
    or tmpTable.appModule      = ""
    or tmpTable.appVersion     = ""
    or tmpTable.minimumVersion = ""
    then do:
            message "Preencha todas as informacoes"
                    view-as alert-box info buttons ok.
    end.
    else leave.
    
end.

/* --- Processo de inclusao de campos ---------------------------------------------------------- */

repeat on endkey undo,retry with frame f-campos:
    
    close query qry-campos.
    open query qry-campos for each tmpField.
    enable brw-campos with frame f-campos.

    wait-for window-close of current-window
          or endkey of brw-campos.
end.

function unshorten returns character (input text-par as character):

    /*for each tmpShorten:
        if text-par = tmpShorten.shortText
        then return tmpShorten.fullText.
    end.*/
    
    return text-par.

end function.

function englishTranslate returns character (input text-par as character):

    define variable ix  as integer   no-undo.
    define variable res as character no-undo.
    define variable str as character no-undo.
    define variable prefix as character no-undo.
    define variable sufix  as character no-undo.
    
    assign res = ""
           str = ""
           prefix = ""
           sufix = "".

    do ix = 1 to num-entries(text-par, "-"):
        assign str = entry(ix, text-par, "-").

        if str = "cd"
        or str = "cod"
        or str = "cdn"
        then do:
            assign str = ""
                   sufix = "-code".
        end.
        
        if str = "ds"
        or str = "des"
        then do:
            assign str = ""
                   sufix = "-description".
        end.
        
        if str = "dt"
        or str = "dat"
        then do:
            assign str = ""
                   sufix = "-date".
        end.
        
        if str = "nm"
        or str = "nom"
        then do:
            assign str = ""
                   sufix = "-name".
        end.
        
        if str = "aa"
        then do:
            assign str = ""
                   sufix = "-year".
        end.
        
        if str = "mm"
        then do:
            assign str = ""
                   sufix = "-month".
        end.
        
        if str <> ""
        then assign res = res + (if res <> "" then "-" else "") + unshorten(str).
    end.
    
    for each tmpTranslation:
        assign res = replace(res, tmpTranslation.brText, tmpTranslation.usText).
    end.
    
    return prefix + res + sufix.

end function.

procedure loadTranslation:
    input from value(nmDiretorioSaves + "/translation.d").
    repeat:
        create tmpTranslation.
        import tmpTranslation.
    end.
    input close.
    
    for each tmpTranslation
       where tmpTranslation.brText = ""
          or tmpTranslation.usText = "":
          delete tmpTranslation.
    end.
end procedure.

procedure loadShortText:
    input from value(nmDiretorioSaves + "/shorttext.d").
    repeat:
        create tmpShorten.
        import tmpShorten.
    end.
    input close.
    
    for each tmpShorten
       where tmpShorten.shortText = ""
          or tmpShorten.fullText = "":
          delete tmpShorten.
    end.
end procedure. 

procedure loadComponents:
    input from value(nmDiretorioSaves + "/sys.components.d").
    repeat:
        create tmpInputComponent.
        import tmpInputComponent.
    end.
    input close.
    
    for each tmpInputComponent
       where tmpInputComponent.component = "":
          delete tmpInputComponent.
    end.
end procedure.

procedure generateTableInput:

    for first _file 
        where _file._file-name = tmpTable.name
              no-lock:

        assign tmpTable.module         = pascalCase(tmpTable.component)
               tmpTable.controller     = camelCase(tmpTable.component)
               tmpTable.description    = _file._desc
               tmpTable.pageTitle      = "Manutencao de " + lower(_file._desc)
               tmpTable.appModule      = "hcg"
               tmpTable.appVersion     = "v1"
               tmpTable.minimumVersion = "12.1.23".

    end.
    
end procedure.

procedure initTableInput:
    create tmpTable.
    assign tmpTable.name        = "tabela do banco"
           tmpTable.component   = "nome-da-entidade"
           tmpTable.module      = ""
           tmpTable.controller  = ""
           tmpTable.description = ""
           tmpTable.pageTitle   = ""
           tmpTable.appModule   = "hcg"
           tmpTable.appVersion  = "v1".
end procedure.

procedure generateFieldInput:
    define input parameter table-name-par as character no-undo.
    define input parameter field-name-par as character no-undo.
    
    define variable lg-pk as logical no-undo.
    
    for first _file
        where _file._file-name = table-name-par,
        first _field
        where _field._file-recid = recid(_file)
          and _field._field-name = field-name-par:
        
        /* Busca se campo pertence a PK */
        assign lg-pk = false.
        for first _index 
            where recid(_index) = _file._prime-index,
            first _index-field 
            where _index-field._field-recid = recid(_field)
              and _index-field._index-recid = recid(_index):
              assign lg-pk = true.
        end.
    
        create tmpField.
        assign tmpField.name           = camelCase(_field._field-name) //camelCase(englishTranslate(_field._field-name))
               tmpField.fieldName      = _field._field-name
               tmpField.description    = _field._Desc
               tmpField.databaseType   = _field._Data-Type
               tmpField.inputFormat    = getInputFormat(_field._Data-Type, _field._Format)
               tmpField.defaultValue   = "" //_field._Initial
               tmpField.fixedValue     = ""
               tmpField.isKey          = lg-pk
               tmpField.isEditable     = not lg-pk
               tmpField.isRequired     = lg-pk
               tmpField.isVisible      = true
               tmpField.isListable     = true
               tmpField.isLink         = false
               tmpField.inputComponent = ""
               tmpField.pipeClass      = ""
               tmpField.enumComponent  = ""
               tmpField.zoomComponent  = ""
               tmpField.isFilter       = lg-pk
               tmpField.isRangeFilter  = (lg-pk) and (_field._data-type begins "int")
               tmpField.maxSize        = getSizeFromFormat(_field._Format).

        if _field._Data-Type begins "int"
        then assign tmpField.inputType = "number"
                    tmpField.defaultValue = "0".
        else if _field._Data-Type matches "*char*"
        then assign tmpField.inputType = "string"
                    tmpField.defaultValue = "''".
        else if _field._Data-Type begins "log"
        then assign tmpField.inputType = "boolean"
                    tmpField.defaultValue = "false".
        else if _field._Data-Type = "date"
        then assign tmpField.inputType = "Date"
                    tmpField.defaultValue = "new Date()".
        else if _field._Data-Type begins "dec"
        then assign tmpField.inputType = "number"
                    tmpField.defaultValue = "0".

        /* Campos personalizados */
        case _field._field-name:
            when "dt-atualizacao" or
            when "dat-ult-atualiz"
            then assign tmpField.name = "updateDate"
                        tmpField.description = "Atualizacao"
                        tmpField.fixedValue = "today"
                        tmpField.isEditable = false.
                        
            when "hra-ult-atualiz"
            then assign tmpField.name = "updateHour"
                        tmpField.description = "Hora de Atualizacao"
                        tmpField.fixedValue = "string(time,~"HH:MM:SS~")"
                        tmpField.isEditable = false
                        tmpField.isListable = false
                        tmpField.isVisible  = false.
            
            when "cd-userid" or
            when "cod-usuar-ult-atualiz"
            then assign tmpField.name = "updateUser"
                        tmpField.description = "Usuario"
                        tmpField.fixedValue = "v_cod_usuar_corren"
                        tmpField.isEditable = false
                        tmpField.isListable = false.
        end.
    end.
    
end procedure.

procedure openFieldSelection:
    
    define variable lastId          as integer initial 0 no-undo.
    define variable nmField         as character         no-undo.
    define variable nrCont          as integer           no-undo.

    open query q-file                                         
         for each _file 
            where _file._file-name = tmpTable.name 
                  no-lock,  
             each _field 
            where _field._file-recid = recid(_file) 
              and (not _field._field-name begins "u-")
                  no-lock.

    update b-file go-on(return) with frame f-field-selection.

    if available _field
    then do:
            for last tmpField by id:
                assign lastId = tmpField.id.
            end.

            run generateFieldInput(input tmpTable.name,
                                   input _field._field-name).
            
            assign tmpField.id = lastId + 1.
    end.
    else release tmpField.

end procedure.

procedure gravaDadosTable:
    define input param nmArquivo as character no-undo.
    
    output to value(nmDiretorioSaves + "/" + nmArquivo + '.table.d') convert target "utf-8".
    for each tmpTable:
        export tmpTable.
    end.
    output close.
    
end procedure.

procedure gravaDadosField:
    define input param nmArquivo as character no-undo.
    
    output to value(nmDiretorioSaves + "/" + nmArquivo + '.field.d') convert target "utf-8".
    for each tmpField:
        export tmpField.
    end.
    output close.
    
end procedure.

procedure gravaDadosEnum:
    define input param nmArquivo as character no-undo.
    
    output to value(nmDiretorioSaves + "/" + nmArquivo + '.enum.d') convert target "utf-8".
    for each tmpEnum:
        export tmpEnum.
    end.
    output close.
    
    output to value(nmDiretorioSaves + "/" + nmArquivo + '.enum.item.d') convert target "utf-8".
    for each tmpEnumItem:
        export tmpEnumItem.
    end.
    output close.
    
end procedure.

procedure gravaDadosZoom:
    define input param nmArquivo as character no-undo.
    
    output to value(nmDiretorioSaves + "/" + nmArquivo + '.zoom.d') convert target "utf-8".
    for each tmpZoom:
        export tmpZoom.
    end.
    output close.
    
    output to value(nmDiretorioSaves + "/" + nmArquivo + '.zoom.item.d') convert target "utf-8".
    for each tmpZoomItem:
        export tmpZoomItem.
    end.
    output close.
    
end procedure.

procedure carregaDadosTable:
    define input parameter nmArquivoDados as character no-undo.
    
    empty temp-table tmpSaveTable.
    if search(nmDiretorioSaves + "/" + nmArquivoDados + ".table.d") = ?
    then return.
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".table.d") convert source "utf-8".
    repeat:
        create tmpSaveTable.
        import tmpSaveTable.
        release tmpSaveTable.
    end.
    input close.
    
    // remove o lixo do baguio
    for each tmpSaveTable where tmpSaveTable.name = "":
        delete tmpSaveTable.
    end.
    
end procedure.

procedure carregaDadosField:
    define input parameter nmArquivoDados as character no-undo.
    
    empty temp-table tmpSaveField.
    if search(nmDiretorioSaves + "/" + nmArquivoDados + ".field.d") = ?
    then return.
    
    input from value(nmDiretorioSaves + "/" + nmArquivoDados + ".field.d") convert source "utf-8".
    repeat:
        create tmpSaveField.
        import tmpSaveField.
        release tmpSaveField.
    end.
    input close.
    
    // remove o lixo do baguio
    for each tmpSaveField where tmpSaveField.id = 0:
        delete tmpSaveField.
    end.
    
end procedure.

procedure createField:
    do on endkey undo, return error:
        /* Campos somente leitura, ou alimentados fora do update principal */
        display 
            tmpField.id
            tmpField.fieldName
            tmpField.inputcomponent
            //tmpField.pipeClass
            tmpField.enumComponent
            tmpField.zoomComponent
            with frame f-campo.
            
        update 
            tmpField.name          
            tmpField.description   
            tmpField.databaseType  
            tmpField.inputType     
            tmpField.inputFormat   
            tmpField.maxSize       
            tmpField.defaultValue  
            tmpField.fixedValue    
            tmpField.isKey         
            tmpField.isRequired    
            tmpField.isVisible     
            tmpField.iseditable    
            tmpField.isListable    
            tmpField.isLink        
            tmpField.isFilter      
            tmpField.isRangeFilter 
            with frame f-campo
            editing:
                readkey.
                case lastkey:
                    when keycode("f5")
                    then run selectFieldInputComponent.
                    
                    when keycode("f6")
                    then run selectFieldEnum.
                    
                    when keycode("f7")
                    then run selectFieldZoom.
                    
                    when keycode("f8")
                    then run selectFieldNone.
                    
                    /*when keycode("")
                    then run selectFieldPipe.*/
                    
                    otherwise apply lastkey.
                end case.
            end.
            
        release tmpField.
    end.
    
end procedure.

procedure selectFieldInputComponent:
    do on error undo, retry on endkey undo, leave:
        close query qry-zoomInputComponent.
        open query qry-zoomInputComponent for each bz-tmpInputComponent.
        enable brw-zoomInputComponent with frame f-zoomInputComponent.

        update brw-zoomInputComponent go-on("return") with frame f-zoomInputComponent.
        
        assign tmpField.enumComponent  = ""
               tmpField.zoomComponent  = ""
               tmpField.inputComponent = bz-tmpInputComponent.component
               /*tmpField.pipeClass      = ""*/
               .
        disp tmpField.enumcomponent
             tmpField.zoomComponent
             tmpField.inputComponent
             //tmpField.pipeClass
             with frame f-campo.
    end.
    hide frame f-zoomInputComponent no-pause.
end procedure.

procedure selectFieldPipe:
end procedure.

procedure selectFieldEnum:
    do on error undo, retry on endkey undo, leave:
        close query qry-zoomEnum.
        open query qry-zoomEnum for each bz-tmpEnum.
        enable brw-zoomEnum with frame f-zoomEnum.

        update brw-zoomEnum go-on("return") with frame f-zoomEnum.
        
        if not available bz-tmpEnum
        then leave.
        
        assign tmpField.enumComponent  = bz-tmpEnum.component
               tmpField.zoomComponent  = ""
               tmpField.inputComponent = ""
               //tmpField.pipeClass      = ""
               .
        disp tmpField.enumcomponent
             tmpField.zoomComponent
             tmpField.inputComponent
             //tmpField.pipeClass
             with frame f-campo.
    end.
    hide frame f-zoomEnum no-pause.
end procedure.

procedure selectFieldZoom:
    do on error undo, retry on endkey undo, leave:
        close query qry-zoomZoom.
        open query qry-zoomZoom for each bz-tmpZoom.
        enable brw-zoomZoom with frame f-zoomZoom.

        update brw-zoomZoom go-on("return") with frame f-zoomZoom.
        
        if not available bz-tmpZoom
        then leave.
        
        assign tmpField.enumComponent  = ""
               tmpField.zoomComponent  = bz-tmpZoom.component
               tmpField.inputComponent = ""
               //tmpField.pipeClass      = ""
               .
        disp tmpField.enumcomponent
             tmpField.zoomComponent
             tmpField.inputComponent
             //tmpField.pipeClass
             with frame f-campo.
    end.
    hide frame f-zoomZoom no-pause.
end procedure.

procedure selectFieldNone:
    assign tmpField.enumComponent  = ""
           tmpField.zoomComponent  = ""
           tmpField.inputComponent = ""
           //tmpField.pipeClass      = ""
           .
    disp tmpField.enumcomponent
         tmpField.zoomComponent
         tmpField.inputComponent
         //tmpField.pipeClass
         with frame f-campo.
end procedure.

procedure createEnum:

    define variable lastId as integer initial 0 no-undo.
    
    do on endkey undo, return error:
        for last tmpEnum by tmpEnum.idEnum:
            assign lastId = tmpEnum.idEnum.
        end.
            
        create tmpEnum.
        assign tmpEnum.valueDatatype = "integer"
               tmpEnum.idEnum        = lastId + 1.
        
        update tmpEnum.component
               tmpEnum.description   
               tmpEnum.valueDatatype
               with frame f-enumEdit.
        assign tmpEnum.module     = pascalCase(tmpEnum.component)
               tmpEnum.controller = camelCase(tmpEnum.component).
    end.
end procedure.

procedure createEnumItem:
    define input parameter isNew as logical no-undo.

    define variable lastId as integer initial 0 no-undo.
    
    do on endkey undo, return error:
        if isNew 
        then do:
            for last tmpEnumItem
                where tmpEnumItem.idEnum = tmpEnum.idEnum
                      by tmpEnumItem.idSequence:
                assign lastId = tmpEnumItem.idSequence.
            end.
                
            create tmpEnumItem.
            assign tmpEnumItem.idSequence = lastId + 1
                   tmpEnumItem.idEnum     = tmpEnum.idEnum.
        end.
        
        update tmpEnumItem.enumValue
               tmpEnumItem.enumLabel
               with frame f-enumItemEdit.
    end.
end procedure.

procedure createZoom:

    define variable lastId as integer initial 0 no-undo.
    
    do on endkey undo, return error:
        for last tmpZoom by tmpZoom.idZoom:
            assign lastId = tmpZoom.idZoom.
        end.
            
        create tmpZoom.
        assign tmpZoom.idZoom = lastId + 1.
        
        do on endkey undo, return error:
        
            update tmpZoom.name
                   with frame f-zoomEdit.
                   
            /* Carrega dados */
            run carregaDadosTable(tmpZoom.name).
            run carregaDadosField(tmpZoom.name).
            
            if not can-find(first tmpSaveTable)
            then do:
                message "Arquivo de dados da tabela nao encontrado"
                        view-as alert-box info buttons ok.
                undo, return error.
            end.
            
            for first tmpSaveTable:
                buffer-copy tmpSaveTable to tmpZoom.
            end.
        end.
    end.
end procedure.

procedure selectZoomItem:
    define variable lastId as integer initial 0 no-undo.
    
    do on endkey undo, return error:
        /* Mostra tela de selecao de campo */
        close query qry-zoomSelect.
        open query qry-zoomSelect for each tmpSaveField.
        enable brw-zoomSelect with frame f-zoomSelect.

        update brw-zoomSelect go-on("return") with frame f-zoomSelect.
        
        if not available tmpSaveField
        then leave.
    
        for last tmpZoomItem
            where tmpZoomItem.idZoom = tmpZoom.idZoom
                  by tmpZoomItem.idSequence:
            assign lastId = tmpZoomItem.idSequence.
        end.
        
        create tmpZoomItem.        
        buffer-copy tmpSaveField to tmpZoomItem.
        assign tmpZoomItem.idSequence = lastId + 1
               tmpZoomItem.idZoom     = tmpZoom.idZoom
               tmpZoomItem.isLabel    = false.
    end.
end procedure.
