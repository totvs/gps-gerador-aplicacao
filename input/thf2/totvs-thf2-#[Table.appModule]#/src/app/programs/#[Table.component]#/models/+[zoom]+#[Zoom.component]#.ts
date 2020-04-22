import { TotvsGpsJsonUtils } from "totvs-gps-utils";

export class #[Zoom.module]# {

  get ENTITY() { return '#[Zoom.module]#' };
  get primaryKeys() { return [
    #[whileZoom,isKey=true]#
    '#[ZoomItem.name]#',
    #[endWhileZoom]#   
  ] };

  #[whileZoom]#
  #[ZoomItem.name]#:#[ZoomItem.inputType]#;
  #[endWhileZoom]#      

  parseJsonToObject(jsonData): #[Zoom.module]# {
    TotvsGpsJsonUtils.getInstance().assign(this,jsonData);
    return this;
  }

}
