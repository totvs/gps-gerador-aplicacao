import { Injectable } from '@angular/core';
import { TotvsGpsServices, TTalkCollection } from 'totvs-gps-services';
import { #[Zoom.module]# } from './models/#[Zoom.component]#';

@Injectable()
export class #[Zoom.module]#Service {

  private _url:string = '#[Zoom.appModule]#/#[Zoom.appVersion]#/#[Zoom.controller,Plural]#';
  private _urlKeys = this._url
#[whileZoom,isKey=true]# 
    + '/{{#[ZoomItem.name]#}}'
#[endWhileZoom]#
    ;

  public get#[Zoom.module]#ByFilter(searchObject?:any,pageNumber?:number,pageSize?:number,fields?:Array<string>,expand?:Array<string>): Promise<TTalkCollection<#[Zoom.module]#>> {
    return TotvsGpsServices
      .getInstance<#[Zoom.module]#>(#[Zoom.module]#, this._url)
      .setQueryParams(searchObject)
      .setPage(pageNumber).setPageSize(pageSize).setFields(fields).setExpand(expand)
      .getCollection();
  }

  public get#[Zoom.module]#ById(#[Zoom.controller]#:#[Zoom.module]#,fields?:Array<string>,expand?:Array<string>): Promise<#[Zoom.module]#> {
    return TotvsGpsServices
      .getInstance<#[Zoom.module]#>(#[Zoom.module]#, this._urlKeys)
      .setPathParams(#[Zoom.controller]#)
      .setFields(fields).setExpand(expand)
      .get();
  }

}
