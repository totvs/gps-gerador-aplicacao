/* reajustes de tamanho da tela, titulo */
current-window:width-chars   = 150.
current-window:height-chars  = 21.
current-window:title         = "Gerador de CRUD".
session:debug-alert          = true.

define variable nmDiretorioLocal    as character    no-undo.
define variable nmDiretorioSaves    as character    no-undo.
define variable nmDiretorioIncludes as character    no-undo.
define variable nmDiretorioInput    as character    no-undo.
define variable nmDiretorioOutput   as character    no-undo.

define variable nmDatabase          as character    initial "shsrcadger" format "x(16)" view-as combo-box list-items "Selecione" size 16 by 1 no-undo.
define variable inTipoExecucao      as integer      no-undo.
define variable nmArquivoDados      as character    no-undo.

define variable ix                  as integer      no-undo.


assign file-info:file-name = this-procedure:file-name + "/../"
       nmDiretorioLocal    = replace(file-info:full-pathname, "~\", "/").

define frame f-diretorio-local
    skip(1)
    nmDiretorioLocal       format "x(140)"  at 2
    with no-labels title "Diretorio do Gerador CRUD" centered row 3 size 143 by 4.
    
define frame f-diretorios
    skip(1)
    nmDiretorioSaves    label "Arquivos salvos"   format "x(122)"  colon 18 
    nmDiretorioIncludes label "Includes padrao"   format "x(122)"  colon 18
    nmDiretorioInput    label "Templates"         format "x(122)"  colon 18
    nmDiretorioOutput   label "Resultado"         format "x(122)"  colon 18
    with side-labels title "Parametrizacao de Diretorios" centered row 8 size 143 by 7.
    
define frame f-tipo-execucao
    skip(1)
    nmDatabase          label "Banco de dados" at 2 
    inTipoExecucao      label "Tipo Execucao" at 40 view-as radio-set horizontal radio-buttons "Novo cadastro", 1, "Re-gerar", 2
    nmArquivoDados      label "Arquivo de dados" at 85 format "x(40)"
    with side-labels title "Execucao" centered row 16 size 143 by 4.5.
    
do on error undo,retry:
    hide all no-pause.
    
    update nmDiretorioLocal with frame f-diretorio-local.

    assign file-info:file-name = nmDiretorioLocal.
    if file-info:full-pathname = ?
    then do:
        message "Diretorio informado nao existe"
                view-as alert-box info buttons ok.
        undo,retry.
    end.
    
    assign nmDiretorioSaves    = nmDiretorioLocal + "/save"
           nmDiretorioIncludes = nmDiretorioLocal + "/include"
           nmDiretorioInput    = nmDiretorioLocal + "/input"
           nmDiretorioOutput   = nmDiretorioLocal + "/output".
    
    update nmDiretorioSaves nmDiretorioIncludes nmDiretorioInput nmDiretorioOutput with frame f-diretorios.
    

    assign nmArquivoDados = "".
    
    do on error undo,retry with frame f-tipo-execucao:
        repeat ix = 1 to num-dbs:
            assign nmDatabase:list-items = (if ix = 1 then "" else nmDatabase:list-items + ",") + ldbname(ix).
        end.
        
        update nmDatabase go-on("return").
        
        /* Atribui /bin no PROPATH */
        run adiciona-propath(input nmDiretorioLocal).
    
        /* Conecta no banco de dados */
        run conecta-banco(input nmDatabase).
        
        do on error undo,retry with frame f-tipo-execucao:
        
            update inTipoExecucao go-on("return").
            
            if inTipoExecucao = 1
            then do:
                hide all no-pause.
                
                run bin/newCRUD.p (
                    input nmDiretorioLocal,
                    input nmDiretorioSaves,
                    input nmDiretorioIncludes,
                    input nmDiretorioInput,
                    input nmDiretorioOutput) no-error.
            end.
            else if inTipoExecucao = 2
            then repeat on error undo,retry on endkey undo,leave with frame f-tipo-execucao:
                update nmArquivoDados.
                
                if search(nmDiretorioSaves + "/" + nmArquivoDados + ".table.d") = ?
                then do:
                    message "Arquivo de dados nao encontrado"
                            view-as alert-box info buttons ok.
                    undo,retry.
                end.
                
                run bin/rebuildCRUD.p (
                    input nmDiretorioLocal,
                    input nmDiretorioSaves,
                    input nmDiretorioIncludes,
                    input nmDiretorioInput,
                    input nmDiretorioOutput,
                    input nmArquivoDados) no-error.
                         
                if error-status:error
                then message "Ocorreu um erro ao tentar gerar o CRUD"
                             view-as alert-box info buttons ok.
                else message "CRUD gerado com sucesso!"
                             view-as alert-box info buttons ok.
            end.
        end.
    end.
    
end.

procedure adiciona-propath:
    define input parameter nm-propath-par as character no-undo.
    
    define variable ix as integer no-undo.
    
    repeat ix = 1 to num-entries(propath):
        if entry(ix, propath) = nm-propath-par
        then return.
    end.
    
    propath = nm-propath-par + "," + propath.
    
end procedure.

procedure conecta-banco:
    define input parameter nm-database-par as character no-undo.
    
    create alias "DICTDB" for database value(nm-database-par).
end procedure.
