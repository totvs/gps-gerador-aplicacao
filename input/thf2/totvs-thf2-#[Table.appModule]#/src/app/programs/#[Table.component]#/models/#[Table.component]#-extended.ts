import { isNullOrUndefined } from 'util';
import { #[Table.module]# } from './#[Table.component]#';
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]# } from '../models/#[Field.zoomComponent]#';
#[endWhileFields]#

export class #[Table.module]#Extended extends #[Table.module]# {

    $actions:string[];
 
    #[whileFields,!zoomComponent=]#
    $#[Field.name]#:#[Field.zoomComponent,ModuleName]#;
    #[endWhileFields]#
    #[whileFields,!enumComponent=]#
    $#[Field.name]#Description: string = '';
    #[endWhileFields]#
    
    #[whileFields,!zoomComponent=]#
    get $#[Field.name]#Description() {
        if (isNullOrUndefined(this.$#[Field.name]#))
            return '';
        return this.$#[Field.name]#.#[Field.zoomComponent,ZoomLabelField]#;
    }

    #[endWhileFields]#
    parseJsonToObject(jsonData): #[Table.module]#Extended {
        super.parseJsonToObject(jsonData);
        return this;
    }
    
}
