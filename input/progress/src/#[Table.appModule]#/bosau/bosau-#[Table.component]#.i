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



define temp-table tmp#[Table.module]#Filter no-undo
    #[whileFields,isFilter=true]#
    *[progress/bo/defineTempTableRangeField.txt,isRangeFilter=true]**[progress/bo/defineTempTableField.txt,isRangeFilter=false]*
    #[endWhileFields]#  
    
define temp-table tmp#[Table.module]# no-undo
    #[whileFields]#
    field #[Field.fieldName,MaxAttributeSize]# as #[Field.databaseType,MaxAttributeSize]# serialize-name "#[Field.name]#"#[IF,isLast]#.#[endIF]#
    #[endWhileFields]#
