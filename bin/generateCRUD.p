

/*

#[Table.ATTR]# = substitui pelo atributo (ATTR) da temp com dados da tabela
#[Field.ATTR,Metodo]# = substitui pelo atributo (ATTR) da temp com dados do campo (deve estar dentro de um laço dos campos)
O parametro Metodo eh opcional, e a funcao dele eh informar uma procedure especifica para formatar o resultado gerado.
Exemplos: 
#[Table.name]#
#[Field.databaseType]#
#[field.name,MaxAttributeSize]#
Metodos de formatacao disponiveis:
MaxAttributeSize = formata a saida baseado no maior tamanho dos campos
Upper = formata o texto em caixa alta
Lower = formata o texto em caixa baixa
JavaType = formata o tipo de dado especifico para Java
SwaggerType = formata o tipo de dado especifico para arquivos do swagger
ProgressCast = formata o tipo de para para a função de cast do progress

#[whileFields,Filter1|Filter2|FilterN]# = aplica loop dos campos. deve estar sozinho em uma linha.
Termina o loop quando encontrar #[endWhileFields]#
Os filtros não são obrigatorios
Exemplo: 
#[whileFields]#
Vai imprimir uma linha dessas por campo
[#endWhileFields]#

#[inlineFields,Filter1|Filter2|FilterN]# = aplica loop dos campos, dentro de uma única linha.
Termina com a condição #[endInlineFields]#
O inicio e o fim da condição devem estar em uma única linha
Os filtros não são obrigatorios
Exemplo: 
#[inlineFields]# #[Field.name]#, #[endInlineFields]#

#[IF,Filter1|Filter2|FilterN]# = condiciona uma saída de texto aos filtros.
Termina a condição com #[endIF]#
O inicio e o fim da condição devem estar em uma única linha
Exemplo: { column: 'dskjdhksaj', label: 'fjsdfdls'#[IF,isLink=true]#=, type: 'link'#[endIF]# }

*[IncludeFile,Filter1|Filter2|FilterN]* = inclui um arquivo de template (IncludeFile) caso o filtro seja atendido
Filtro não é obrigatorio

--

Filtros:
Atributo=Valor = verifica na tabela de Fields se o atributo do campo tem a valor especificado
isFirst = verifica se o campo atual é o primeiro
isLast = verifica se o campo atual é o ultimo
isOdd = verifica se o campo atual é impar
isEven = verifica se o campo atual é par
! = testa o filtro inverso (ex: !isFirst ou !dataType=boolean)

*/

&scoped-define SEPARADOR_ATTR "."
&scoped-define SEPARADOR_FILTRO "|"
&scoped-define SEPARADOR_REPETIDOR "@"
&scoped-define SEPARADOR_MULTIARQUIVOS "&"
&scoped-define SEPARADOR ","
&scoped-define NEGACAO "!"

&scoped-define LOOP_FIELDS 1
&scoped-define LOOP_ENUM 2
&scoped-define LOOP_ZOOM 3

{bin/generateCRUD.i}
    
/* Parametros */
define input parameter nmDiretorioLocal    as character    no-undo.
define input parameter nmDiretorioSaves    as character    no-undo.
define input parameter nmDiretorioInclude  as character    no-undo.
define input parameter nmDiretorioOrigem   as character    no-undo.
define input parameter nmDiretorioDestino  as character    no-undo.
define input parameter table for tmpTable.
define input parameter table for tmpField.
define input parameter table for tmpEnum.
define input parameter table for tmpEnumItem.
define input parameter table for tmpZoom.
define input parameter table for tmpZoomItem.

define variable nmArquivo          as character no-undo.
define variable nmArquivoPrefixo   as character no-undo.
define variable nmArquivoSufixo    as character no-undo.
define variable ixPosition         as integer   no-undo.
define variable ixIndex            as integer   no-undo.
define variable nmFilesAux         as character no-undo.

define buffer b-Files for tmpFiles.

/* Adiciona barra ao final dos diretorios */
assign nmDiretorioLocal   = normaliza-path(nmDiretorioLocal)
       nmDiretorioSaves   = normaliza-path(nmDiretorioSaves)
       nmDiretorioInclude = normaliza-path(nmDiretorioInclude)
       nmDiretorioOrigem  = normaliza-path(nmDiretorioOrigem)
       nmDiretorioDestino = normaliza-path(nmDiretorioDestino).

//run criaDadosTT.

find first tmpTable no-error.

if not available tmpTable
then return "NOK".

run importaListaArquivos(input nmDiretorioOrigem).

/* Gera arquivos */
for each tmpFiles:
    run processaArquivo(input tmpFiles.inputFileName,
                        input tmpFiles.outputFileName).
end.


function getValor  returns character (valor as character):

    if valor = "yes"
    then return "true".
    if valor = "no"
    then return "false".
    
    return valor.

end function.

function getFieldCount returns integer (input tbHandle as handle):

    define variable bfRowid as rowid no-undo.
    define variable iAux as integer initial 0 no-undo.

    assign bfRowid = tbHandle:rowid.
    if tbHandle:find-last()
    then assign iAux = tbHandle:buffer-field("id"):buffer-value.
    else assign iAux = 0.
    
    tbHandle:find-by-rowid(bfRowid).
    return iAux.
end function.

procedure importaListaArquivos:
    define input param nmDir       as character no-undo.
    
    run varreDiretorio(input nmDir,
                       input "",
                       input "").

end procedure.

procedure varreDiretorio private:
    define input param nmDir       as character no-undo.
    define input param nmOutputDir as character no-undo.
    define input param nmRepetidor as character no-undo.
    
    define variable nmFilesAux         as character no-undo.
    define variable nmProp             as character no-undo.
    define variable nmArquivo          as character no-undo.
    define variable nmArquivoPrefixo   as character no-undo.
    define variable nmArquivoSufixo    as character no-undo.
    define variable ixPosition         as integer   no-undo.
    define variable ixIndex            as integer   no-undo.
    
    if nmOutputDir = ""
    then assign nmOutputDir = nmDir.
    
    input from os-dir(nmDir).
    repeat:
        import nmArquivo.
        if  nmArquivo = '.'
        or nmArquivo = '..'
        then next.
        
        /* Busca tag de repetidor de arquivo/diretorio */
        if nmArquivo matches ("*+[*]+*")
        then do:
            assign ixPosition       = index(nmArquivo, "+[")
                   nmArquivoPrefixo = substring(nmArquivo, 1, ixPosition - 1)
                   nmArquivoSufixo  = substring(nmArquivo, index(nmArquivo, "]+", ixPosition) + 2)
                   nmFilesAux       = ""
                   nmProp           = substring(nmArquivo, ixPosition + 2, index(nmArquivo, "]+", ixPosition) - ixPosition - 2).
            run montaListaRepetidor(input nmProp, output nmFilesAux).
        end.
        else do:
            assign nmFilesAux       = nmArquivo
                   nmArquivoPrefixo = ""
                   nmArquivoSufixo  = ""
                   nmProp           = "".
        end.

        assign file-info:file-name = nmDir + nmArquivo.
        if file-info:file-type matches ("*D*")
        then do:
            repeat ixIndex = 1 to num-entries(nmFilesAux, {&SEPARADOR_MULTIARQUIVOS}):
                run varreDiretorio(input nmDir + nmArquivo + "~/", 
                                   input nmOutputDir + nmArquivoPrefixo + entry(ixIndex, nmFilesAux, {&SEPARADOR_MULTIARQUIVOS}) + nmArquivoSufixo + "~/",
                                   input nmRepetidor + entry(ixIndex, nmFilesAux, {&SEPARADOR_MULTIARQUIVOS})).
            end.
        end.
        else do:
            repeat ixIndex = 1 to num-entries(nmFilesAux, {&SEPARADOR_MULTIARQUIVOS}):
                create tmpFiles.
                assign tmpFiles.inputFilename  = nmDir + nmArquivo
                       tmpFiles.outputFilename = replace(nmOutputDir, nmDiretorioOrigem, nmDiretorioDestino) /*+ nmRepetidor*/ + nmArquivoPrefixo + entry(ixIndex, nmFilesAux, {&SEPARADOR_MULTIARQUIVOS}) + nmArquivoSufixo.
            end.
        end.
        
    end.
    input close.
    
end procedure.

procedure processaArquivo:
    define input param nmArquivoOrigem  as character no-undo.
    define input param nmArquivoDestino as character no-undo.
    
    define variable nmDiretorioDestino as character no-undo.
    define variable ix                 as integer   no-undo.
    define variable linha              as character no-undo.
    
    /* percorre linhas e vai substituindo as linhas */
    assign nmArquivoOrigem  = replace(nmArquivoOrigem, "~\", "~/")
           nmArquivoDestino = replace(nmArquivoDestino, "~\", "~/").
    
    run processaRepetidor(input-output nmArquivoDestino).
    run processaLinha(input-output nmArquivoDestino).
    
    /* Cria diretorio de destino, caso não exista */
    assign ix = r-index(nmArquivoDestino, "~/")
           nmDiretorioDestino = substring(nmArquivoDestino, 1, ix).
           
    run criaDiretorio(input nmDiretorioDestino).
    
    /* Cria arquivo de destino */
    output to value(nmArquivoDestino) convert target "utf-8".
    input from value(nmArquivoOrigem) convert source "utf-8".
    
    repeat:
        import unformatted linha.
        
        run processaLinha(input-output linha).
        
        if linha = ""
        then put unformatted skip(1).
        else put unformatted linha skip.
    end.
    
    input close.
    output close.

end procedure.

procedure processaLinhasDoTemplate:
    define input  param nmArquivo  as character no-undo.
    define output param conteudo   as character no-undo.
    
    define variable linha              as character no-undo.
    define variable primeiraLinha      as logical initial yes no-undo.

    input from value(search(nmDiretorioInclude + nmArquivo)) convert source "utf-8".
    
    repeat:
        import unformatted linha.
        
        run processaLinha(input-output linha).
        
        if primeiraLinha
        then assign primeiraLinha = false.
        else assign conteudo = conteudo + "~n".
        
        assign conteudo = conteudo + linha.
    end.
    
    input close.

end procedure.

procedure processaLinha:
    define input-output  param linha as character no-undo.
    
    define variable posIni as integer no-undo.
    define variable posFim as integer no-undo.
    define variable posAux as integer no-undo.
    define variable conteudo as character no-undo.
    define variable conteudoAux as character no-undo.
    define variable isValid as logical no-undo.
    define variable filtro as character no-undo.
    define variable arquivo as character no-undo.
    define variable atributo as character no-undo.
    define variable formatacao as character no-undo.
    define variable linhaAux as character no-undo.
    define variable strPadLeft as character no-undo.
    define variable tipoLoop as integer no-undo.
    define variable hTable as handle no-undo.
    
    /* Loop de campos */
    if (linha matches ("*whileFields*"))
    or (linha matches ("*whileEnum*"))
    or (linha matches ("*whileZoom*"))
    then do:
        if linha matches ("*whileFields*")
        then assign tipoLoop = {&LOOP_FIELDS}.
        else if linha matches ("*whileEnum*")
             then assign tipoLoop = {&LOOP_ENUM}.
             else if linha matches ("*whileZoom*")
             then assign tipoLoop = {&LOOP_ZOOM}.
        
        assign filtro   = trim(linha)
               posIni   = index(filtro, {&SEPARADOR})
               posFim   = index(filtro, "]#", posIni + 1).
               
        if posIni = 0
        or posFim = 0
        then assign filtro = "".
        else assign filtro = substring(filtro, posIni + 1, posFim - posIni - 1).
        
        assign conteudo = ""
               linha    = "".
               
        /* vai lendo as linhas até encontrar o final do loop */
        repeat:
            import unformatted linhaAux.
            
            if (tipoLoop = {&LOOP_FIELDS} and trim(linhaAux) = "#[endWhileFields]#")
            or (tipoLoop = {&LOOP_ENUM} and trim(linhaAux) = "#[endWhileEnum]#")
            or (tipoLoop = {&LOOP_ZOOM} and trim(linhaAux) = "#[endWhileZoom]#")
            then leave.
            
            assign conteudo = conteudo + linhaAux + "~n".
        end.

        if tipoLoop = {&LOOP_FIELDS}
        then do:
            empty temp-table tmpFilterField.
            for each tmpField:
                create tmpFilterField.
                buffer-copy tmpField to tmpFilterField.

                run validateField("Field",
                                  input filtro,
                                  output isValid).
                                   
                if not isValid
                then delete tmpFilterField.
            end.

            assign posAux = 0.
            for each tmpFilterField:
                assign conteudoAux       = conteudo
                       posAux            = posAux + 1
                       tmpFilterField.id = posAux.
                run processaLinha(input-output conteudoAux).
                assign linha = linha + conteudoAux.
            end.
        end.
        else if tipoLoop = {&LOOP_ENUM}
        then do:
            empty temp-table tmpFilterEnumItem.
            for each tmpEnumItem
                where tmpEnumItem.idEnum = tmpEnum.idEnum:
                create tmpFilterEnumItem.
                buffer-copy tmpEnumItem to tmpFilterEnumItem.
                
                run validateField("EnumItem",
                                  input filtro,
                                  output isValid).
                                   
                if not isValid
                then delete tmpFilterEnumItem.
            end.

            assign posAux = 0.
            for each tmpFilterEnumItem:
                assign conteudoAux                  = conteudo
                       posAux                       = posAux + 1
                       tmpFilterEnumItem.idSequence = posAux.
                run processaLinha(input-output conteudoAux).
                assign linha = linha + conteudoAux.
            end.
        end.
        else if tipoLoop = {&LOOP_ZOOM}
        then do:
            empty temp-table tmpFilterZoomItem.
            for each tmpZoomItem
                where tmpZoomItem.idZoom = tmpZoom.idZoom:
                create tmpFilterZoomItem.
                buffer-copy tmpZoomItem to tmpFilterZoomItem.
                
                run validateField("ZoomItem",
                                  input filtro,
                                  output isValid).
                                   
                if not isValid
                then delete tmpFilterZoomItem.
            end.

            assign posAux = 0.
            for each tmpFilterZoomItem:
                assign conteudoAux                 = conteudo
                       posAux                       = posAux + 1
                       tmpFilterZoomItem.idSequence = posAux.
                run processaLinha(input-output conteudoAux).
                assign linha = linha + conteudoAux.
            end.
        end.

        /* remove a ultima quebra de linha */
        if linha <> ""
        then linha = substring(linha, 1, length(linha) - 1).
    end.
    
    /* Loop de campos na mesma linha */
    repeat:
        assign posIni = index(linha, "#[inlineFields")
               posFim = index(linha, "]#", posIni + 1).

        if (posIni = 0) 
        or (posFim = 0)
        then leave.
        
        assign posAux = index(linha, {&SEPARADOR}, posIni).
        
        if  posAux > posIni
        and posAux < posFim
        then assign filtro = substring(linha, posAux + 1, posFim - posAux - 1).
        else assign filtro = "".
        
        assign posAux = index(linha, "#[endInlineFields]#").
        
        if posAux = 0
        then leave.
        
        assign conteudo = substring(linha, posFim + 2, posAux - posFim - 2)
               posFim   = index(linha, "]#", posAux) + 2.

        empty temp-table tmpFilterField.
        
        for each tmpField:

            create tmpFilterField.
            buffer-copy tmpField to tmpFilterField.
            
            run validateField("Field",
                              input filtro,
                              output isValid).
                               
            if not isValid
            then delete tmpFilterField.
        end.
        
        assign posAux   = 0
               linhaAux = "".
        for each tmpFilterField:
            assign conteudoAux       = conteudo
                   posAux            = posAux + 1
                   tmpFilterField.id = posAux.
            run processaLinha(input-output conteudoAux).
            assign linhaAux = linhaAux + conteudoAux.
        end.
        
        assign linha = substring(linha, 1, posIni - 1) + linhaAux + substring(linha, posFim).
    end.
    
    
    /* Texto condicional */
    repeat:
        assign posIni = index(linha, "#[IF")
               posFim = index(linha, "]#", posIni + 4).

        if (posIni = 0) 
        or (posFim = 0)
        then leave.
        
        assign posAux = index(linha, {&SEPARADOR}, posIni).
        
        if  posAux > posIni
        and posAux < posFim
        then assign filtro = substring(linha, posAux + 1, posFim - posAux - 1).
        else leave.
        
        assign posAux = index(linha, "#[endIf]#").
        
        if posAux = 0
        then leave.
        
        assign conteudo = substring(linha, posFim + 2, posAux - posFim - 2).
        
        run validateField("Field",
                          input filtro,
                          output isValid).
                          
        if not isValid
        then assign conteudo = "".
        
        assign linha = substring(linha, 1, posIni - 1) + conteudo + substring(linha, posAux + 9).
    end.
    
    
    /* Atributo da tabela ou campo */
    repeat:
        assign posIni = index(linha, "#[")
               posFim = index(linha, "]#", posIni + 2).
               
        if (posIni = 0) 
        or (posFim = 0)
        then leave.
        
        assign conteudo = substring(linha, posIni + 2, posFim - posIni - 2).
        
        if num-entries(conteudo, {&SEPARADOR}) = 2
        then assign atributo   = entry(1, conteudo, {&SEPARADOR})
                    formatacao = entry(2, conteudo, {&SEPARADOR}).
        else if num-entries(conteudo, {&SEPARADOR}) = 1
        then assign atributo   = conteudo
                    formatacao = "".
        else leave.
        
        run getConteudo(input atributo,
                        input formatacao,
                        output conteudo) no-error.
        assign linha = substring(linha, 1, posIni - 1) + conteudo + substring(linha, posFim + 2).
    end.
    
    
    /* Inclusao de templates */
    repeat:
        assign posIni = index(linha, "*[")
               posFim = index(linha, "]*", posIni + 2).
               
        if (posIni = 0) 
        or (posFim = 0)
        then leave.
        
        assign conteudo = substring(linha, posIni + 2, posFim - posIni - 2).
        
        if num-entries(conteudo, {&SEPARADOR}) = 2
        then assign arquivo = entry(1, conteudo, {&SEPARADOR})
                    filtro  = entry(2, conteudo, {&SEPARADOR}).
        else if num-entries(conteudo, {&SEPARADOR}) = 1
        then assign arquivo = conteudo
                    filtro  = "".
        else leave.
        
        assign conteudo = "".
        
        run validateField("Field",
                          input filtro,
                          output isValid).
                           
        if isValid
        then do:
            // calcula espacos em branco para alinhamento
            assign strPadLeft = "".
            do while length(strPadLeft) < (posIni - 1):
                assign strPadLeft = strPadLeft + " ".
            end.
            
            run processaLinhasDoTemplate(input  arquivo,
                                         output conteudoAux).
                                         
            assign conteudoAux = replace(conteudoAux, "~n", "~n" + strPadLeft)
                   conteudo    = conteudo + conteudoAux.
        end.
        else assign conteudo = "".
        
        assign linha = substring(linha, 1, posIni - 1) + conteudo + substring(linha, posFim + 2).
    end.
    
end procedure.

procedure getConteudo:
    define input  param atributo   as character no-undo.
    define input  param formatacao as character no-undo.
    define output param conteudo   as character no-undo.
    
    define variable nmTemp as character no-undo.
    define variable nmAttr as character no-undo.
    define variable hTable as handle    no-undo.
    
    if num-entries(atributo, {&SEPARADOR_ATTR}) <> 2
    then leave.
    
    assign nmTemp = entry(1, atributo, {&SEPARADOR_ATTR})
           nmAttr = entry(2, atributo, {&SEPARADOR_ATTR})
           hTable = getTableHandle(nmTemp).
        
    if valid-handle(hTable)
    then assign conteudo = getValor(hTable:buffer-field(nmAttr):buffer-value()).
    
    /* Formatacao */
    if formatacao <> ""
    then run value("format" + formatacao) (input        nmAttr,
                                           input-output conteudo) no-error.
    
end procedure.

procedure validateField:
    define input  param defaultTable as character no-undo.
    define input  param filter as character no-undo.
    define output param isValid as logical initial true no-undo.
    
    define variable tbHandle as handle no-undo.
    define variable nmTabela as character no-undo.
    define variable iX as integer no-undo.
    define variable iQtd as integer no-undo.
    define variable filtro as character no-undo.
    define variable campo as character no-undo.
    define variable valor as character no-undo.
    define variable negacao as logical no-undo.
    define variable validoAux as logical no-undo.
    
    assign iQtd = num-entries(filter, {&SEPARADOR_FILTRO}).
    
    do iX = 1 to iQtd:
        assign filtro = entry(iX, filter, {&SEPARADOR_FILTRO}).
        
        if substring(filtro, 1, 1) = {&NEGACAO}
        then do:
            assign negacao = true
                   filtro  = substring(filtro, 2).
        end.
        else assign negacao = false.
        
        /* Funções de comparação com campos */
        if num-entries(filtro, "=") = 2
        then do:
            assign campo = entry(1, filtro, "=")
                   valor = entry(2, filtro, "=").
                   
            if num-entries(campo, {&SEPARADOR_ATTR}) = 1
            then assign nmTabela = defaultTable.
            else assign nmTabela = entry(1, campo, {&SEPARADOR_ATTR})
                        campo    = entry(2, campo, {&SEPARADOR_ATTR}).
                   
            assign tbHandle = getTableHandle(nmTabela)
                   campo    = tbHandle:buffer-field(campo):buffer-value().
            
            if ((    negacao) and (getValor(campo)  = getValor(valor)))
            or ((not negacao) and (getValor(campo) <> getValor(valor)))
            then do:
                assign isValid = false.
                return.
            end.
        end.
        /* Funções especificas */
        else do:
            if num-entries(filtro, {&SEPARADOR_ATTR}) = 1
            then assign nmTabela = defaultTable.
            else assign nmTabela = entry(1, filtro, {&SEPARADOR_ATTR})
                        filtro   = entry(2, filtro, {&SEPARADOR_ATTR}).
                        
            assign tbHandle  = getTableHandle(nmTabela)
                   validoAux = true.
            
            case filtro:
                when "isFirst"
                then if tbHandle:buffer-field("id"):buffer-value <> 1
                     then assign validoAux = false.
                
                when "isLast"
                then if tbHandle:buffer-field("id"):buffer-value <> getFieldCount(tbHandle)
                     then assign validoAux = false.
                     
                when "isOdd"
                then if (tbHandle:buffer-field("id"):buffer-value mod 2) <> 1
                     then assign validoAux = false.
                     
                when "isEven"
                then if (tbHandle:buffer-field("id"):buffer-value mod 2) <> 0
                     then assign validoAux = false.
                     
                otherwise assign validoAux = false.
            end case.
            
            if ((not negacao) and (not validoAux))
            or ((    negacao) and (    validoAux))
            then do:
                assign isValid = false.
                return.
            end.
        end.
    end.
    
end procedure.

procedure criaDiretorio:
    define input param nmDiretorio as character no-undo.
    
    define variable nmDiretorioAnterior as character no-undo.
    define variable nmDiretorioSemBarra as character no-undo.
    
    assign nmDiretorio = replace(nmDiretorio, "~\", "~/")
           nmDiretorioSemBarra = substring(nmDiretorio, 1, length(nmDiretorio) - 1)
           file-info:file-name = nmDiretorioSemBarra.
           
    if index(nmDiretorioSemBarra, "~/") = 0
    then leave.
           
    if file-info:full-pathname = ?
    then do:
        assign nmDiretorioAnterior = substring(nmDiretorio, 1, r-index(nmDiretorioSemBarra, "~/")).
        
        run criaDiretorio(input nmDiretorioAnterior).
        
        os-create-dir value(nmDiretorio).
    end.
    
end procedure.

procedure montaListaRepetidor:
    define input  param attrName   as character no-undo.
    define output param variations as character no-undo.

    if attrName = "enum"
    then do:
        for each tmpEnum:
            assign variations = appendToString(variations, "+[Enum" + {&SEPARADOR_REPETIDOR} + tmpEnum.component + "]+", {&SEPARADOR_MULTIARQUIVOS}).
        end.
    end.
    else if attrName = "zoom"
    then do:
        for each tmpZoom:
            assign variations = appendToString(variations, "+[Zoom" + {&SEPARADOR_REPETIDOR} + tmpZoom.component + "]+", {&SEPARADOR_MULTIARQUIVOS}).
        end.
    end.
    
end procedure.

procedure processaRepetidor:
    define input-output parameter nmArquivo as character no-undo.
    
    define variable posIni as integer no-undo.
    define variable posFim as integer no-undo.
    define variable conteudo as character no-undo.
    define variable valor as character no-undo.
    define variable atributo as character no-undo.
    
    /* Posiciona tabelas auxiliares */
    repeat:
        assign posIni = index(nmArquivo, "+[")
               posFim = index(nmArquivo, "]+", posIni + 1).
               
        if (posIni = 0) 
        or (posFim = 0)
        then leave.
        
        assign conteudo  = substring(nmArquivo, posIni + 2, posFim - posIni - 2)
               nmArquivo = substring(nmArquivo, 1, posIni - 1) + substring(nmArquivo, posFim + 2).
        
        if num-entries(conteudo, {&SEPARADOR_REPETIDOR}) = 2
        then assign atributo = entry(1, conteudo, {&SEPARADOR_REPETIDOR})
                    valor    = entry(2, conteudo, {&SEPARADOR_REPETIDOR}).
        else assign atributo = ""
                    valor    = "".
        
        if atributo = "enum"
        then find first tmpEnum where tmpEnum.component = valor no-lock no-error.
        else if atributo = "zoom"
             then find first tmpZoom where tmpZoom.component = valor no-lock no-error.
             else leave.
    end.
    
end procedure.

/* Funcoes de formatacao */
procedure formatMaxAttributeSize:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    define buffer b-field for temp-table tmpFilterField.
    define variable tamanho as integer initial 0 no-undo.
    define variable tamanhoAux as integer no-undo.
    
    for each b-field:
        assign tamanhoAux = length(buffer b-field:handle:buffer-field(atributo):buffer-value()).
        if tamanhoAux > tamanho
        then assign tamanho = tamanhoAux.
    end.
    
    do while length(texto) < tamanho:
        assign texto = texto + " ".
    end.
    
end procedure.

procedure formatUpper:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = caps(texto).
    
end procedure.

procedure formatLower:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = lower(texto).
    
end procedure.

procedure formatPlural:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    define variable ds-caracter-aux as character no-undo.
    assign ds-caracter-aux = substring(texto, length(texto), 1).
    integer(ds-caracter-aux) no-error.
    
    if  (ds-caracter-aux = "y")
    then assign texto = substring(texto, 1, length(texto) - 1) + "ies".
    else if  (ds-caracter-aux <> "s")
         and (error-status:error)
         then assign texto = texto + "s".
    
end procedure.

procedure formatJavaType:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    if texto begins "int"
    then assign texto = "integer".
    else if texto matches "*char*"
    then assign texto = "string".
    else if texto begins "log"
    then assign texto = "boolean".
    
end procedure.

procedure formatSwaggerType:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = lower(texto).
    
    if texto begins "int"
    then assign texto = "integer".
    else if texto begins "dec"
    then assign texto = "number".
    else if texto begins "log"
    then assign texto = "boolean".
    else assign texto = "string".
    
end procedure.

procedure formatProgressCast:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = lower(texto).
    
    if texto begins "int"
    then assign texto = "integer".
    else if texto begins "dec"
    then assign texto = "decimal".
    else if texto begins "log"
    then assign texto = "logical".
    else assign texto = "string".
end procedure.

procedure formatPascalCase:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = pascalCase(texto).
    
end procedure.

procedure formatCamelCase:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = camelCase(texto).
    
end procedure.

procedure formatModuleName:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = pascalCase(texto).
    
end procedure.

procedure formatControllerName:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    assign texto = camelCase(texto).
    
end procedure.

procedure formatZoomLabelField:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    define buffer bf-Zoom for tmpZoom.
    define buffer bf-ZoomItem for tmpZoomItem.
    
    for first bf-Zoom
        where bf-Zoom.component = texto,
        first bf-ZoomItem
        where bf-ZoomItem.idZoom = bf-Zoom.idZoom
          and bf-ZoomItem.isLabel:
          
          assign texto = bf-ZoomItem.name.
          
    end.
    
end procedure.

procedure formatZoomKeyField:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    define buffer bf-Zoom for tmpZoom.
    define buffer bf-ZoomItem for tmpZoomItem.
    
    for first bf-Zoom
        where bf-Zoom.component = texto,
        first bf-ZoomItem
        where bf-ZoomItem.idZoom = bf-Zoom.idZoom
          and bf-ZoomItem.isKey:
          
          assign texto = bf-ZoomItem.name.
          
    end.
    
end procedure.

procedure formatNot:
    define input        param atributo as character no-undo.
    define input-output param texto    as character no-undo.
    
    if texto = "true"
    then assign texto = "false".
    else if texto = "false"
         then assign texto = "true".
    
end procedure.

