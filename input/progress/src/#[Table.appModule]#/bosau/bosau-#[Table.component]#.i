/*
    Copyright (c) 2007, DATASUL S/A. Todos os direitos reservados.
    
    Os Programas desta Aplicação (que incluem tanto o software quanto a sua
    documentação) contém informações proprietárias da DATASUL S/A; eles são
    licenciados de acordo com um contrato de licença contendo restrições de uso e
    confidencialidade, e são também protegidos pela Lei 9609/98 e 9610/98,
    respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
    reversa, descompilação e desmontagem dos programas são proibidos. Nenhuma
    parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
    por nenhum meio, eletrônico ou mecânico, por motivo algum, sem a permissão
    escrita da DATASUL S/A.

*/



define temp-table tmp#[Table.module]#Filter no-undo
    #[whileFields,isFilter=true]#
    *[progress/bo/defineTempTableRangeField.txt,isRangeFilter=true]**[progress/bo/defineTempTableField.txt,isRangeFilter=false]*
    #[endWhileFields]#  
    
define temp-table tmp#[Table.module]# no-undo
    #[whileFields]#
    field #[Field.fieldName,MaxAttributeSize]# as #[Field.databaseType,MaxAttributeSize]# serialize-name "#[Field.name]#"#[IF,isLast]#.#[endIF]#
    #[endWhileFields]#
