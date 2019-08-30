import { TotvsGpsJsonUtils } from "totvs-gps-utils";

export class #[Zoom.module]# {

    #[whileZoom]#
    public #[ZoomItem.name]#:#[ZoomItem.inputType]#;
    #[endWhileZoom]#      

    public primaryKeys:Array<string> = [
        #[whileZoom,isKey=true]#
        "#[ZoomItem.name]#",
        #[endWhileZoom]#   
    ];

    public parseJsonToObject(param): #[Zoom.module]# {
        TotvsGpsJsonUtils.getInstance().assign(this,param);
        return this;
    }

}
