export class #[Table.module]#AdvancedFilter {

    #[whileFields,isFilter=true]#    
    *[typescript/declareRangeField.txt,isRangeFilter=true]**[typescript/declareField.txt,isRangeFilter=false]*
    #[endWhileFields]#

    constructor(){
        #[whileFields,isFilter=true]#    
        *[typescript/setDefaultRangeFieldValue.txt,isRangeFilter=true]**[typescript/setDefaultFieldValue.txt,isRangeFilter=false]*
        #[endWhileFields]#        
    }
}
