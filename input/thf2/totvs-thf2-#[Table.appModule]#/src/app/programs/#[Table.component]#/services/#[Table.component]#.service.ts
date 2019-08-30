import { Injectable } from '@angular/core';
import { TotvsGpsServices, TTalkCollection } from 'totvs-gps-services';
import { #[Table.module]# } from '../models/#[Table.component]#';

@Injectable()
export class #[Table.module]#Service {
  
    private _url = '#[Table.appModule]#/#[Table.appVersion]#/#[Table.controller,Plural]#';
    private _urlKeys = this._url
#[whileFields,isKey=true]# 
        + '/{{#[Field.name]#}}'
#[endWhileFields]#
        ;

    public get#[Table.module]#ByFilter(searchObject?:any,pageNumber?:number,pageSize?:number,fields?:Array<string>,expand?:Array<string>): Promise<TTalkCollection<#[Table.module]#>> {
        return TotvsGpsServices
            .getInstance<#[Table.module]#>(#[Table.module]#, this._url)
            .setQueryParams(searchObject)
            .setPage(pageNumber).setPageSize(pageSize).setFields(fields).setExpand(expand)
            .getCollection();
    }

    public get#[Table.module]#ById(#[Table.controller]#:#[Table.module]#,fields?:Array<string>,expand?:Array<string>): Promise<#[Table.module]#> {
        return TotvsGpsServices
            .getInstance<#[Table.module]#>(#[Table.module]#, this._urlKeys)
            .setPathParams(#[Table.controller]#)
            .setFields(fields).setExpand(expand)
            .get();
    }

    public remove(#[Table.controller]#:#[Table.module]#): Promise<any> {
        return TotvsGpsServices
            .getInstance(#[Table.module]#, this._urlKeys)
            .setPathParams(#[Table.controller]#)
            .delete();
    }

    public save(#[Table.controller]#: #[Table.module]#, isNew:boolean): Promise<#[Table.module]#> {
        let result = TotvsGpsServices.getInstance<#[Table.module]#>(#[Table.module]#);
        if (isNew)
            return result.post(#[Table.controller]#, this._url);
        else
            return result.setPathParams(#[Table.controller]#).put(#[Table.controller]#, this._urlKeys);
    }

}
