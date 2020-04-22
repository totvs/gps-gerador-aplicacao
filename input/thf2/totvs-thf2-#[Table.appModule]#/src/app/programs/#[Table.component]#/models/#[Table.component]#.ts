import { TotvsGpsJsonUtils } from "totvs-gps-utils";

export class #[Table.module]# {

  get ENTITY() { return '#[Table.module]#' };
  get primaryKeys() { return [#[inlineFields,isKey=true]##[IF,!isFirst]#,#[endIF]#'#[Field.name]#'#[endInlineFields]#] };

  #[whileFields]#
  #[Field.name]#:#[Field.inputType]#;
  #[endWhileFields]#
  
  constructor(){     
    #[whileFields]#   
    // this.#[Field.name]# = #[Field.defaultValue]#;       
    #[endWhileFields]# 
  }
  
  parseJsonToObject(jsonData): #[Table.module]# {
    TotvsGpsJsonUtils.getInstance().assign(this, jsonData);
    return this;
  }
}

export interface I#[Table.module]#Filter {
  q?:string;
  #[whileFields,isFilter=true]#
  *[typescript/declareRangeField.txt,isRangeFilter=true]**[typescript/declareField.txt,isRangeFilter=false]*
  #[endWhileFields]#
}
