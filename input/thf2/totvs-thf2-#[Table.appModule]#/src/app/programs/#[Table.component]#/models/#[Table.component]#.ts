import { TotvsGpsJsonUtils } from "totvs-gps-utils";

export class #[Table.module]# {
 
    #[whileFields]#
    public #[Field.name]#:#[Field.inputType]#;
    #[endWhileFields]#      
    
    public primaryKeys:Array<string> = [
        #[whileFields,isKey=true]#
        "#[Field.name]#",
        #[endWhileFields]#
    ];

    constructor(){     
        #[whileFields]#   
        this.#[Field.name]# = #[Field.defaultValue]#;       
        #[endWhileFields]# 
    }
    
    public parseJsonToObject(jsonData): #[Table.module]# {
        TotvsGpsJsonUtils.getInstance().assign(this, jsonData);
        return this;
    }

}
