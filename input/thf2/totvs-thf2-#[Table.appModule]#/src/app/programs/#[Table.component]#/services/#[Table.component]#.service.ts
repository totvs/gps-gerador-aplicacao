import { Injectable } from '@angular/core';
import { TotvsGpsServices, TTalkCollection } from 'totvs-gps-services';
import { #[Table.module]#, I#[Table.module]#Filter } from '../models/#[Table.component]#';

@Injectable()
export class #[Table.module]#Service {

  private readonly url = '#[Table.appModule]#/#[Table.appVersion]#/#[Table.controller,Plural]#';
  private readonly urlKeys = `${this.url}#[inlineFields,isKey=true]#/{{#[Field.name]#}}#[endInlineFields]#`;

  getByFilter(search:I#[Table.module]#Filter,pageNumber?:number,pageSize?:number,expand?:string[],fields?:string[]): Promise<TTalkCollection<#[Table.module]#>> {
    return TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#, this.url)
      .setQueryParams(search)
      .setPage(pageNumber).setPageSize(pageSize).setFields(fields).setExpand(expand)
      .getCollection();
    }

  get(#[inlineFields,isKey=true]##[Field.name]#,#[endInlineFields]#expand?:string[],fields?:string[]): Promise<#[Table.module]#> {
    return TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#, this.urlKeys)
      .setPathParams({#[inlineFields,isKey=true]##[Field.name]#:#[Field.name]##[IF,!isLast]#, #[endIF]##[endInlineFields]#})
      .setFields(fields).setExpand(expand)
      .get();
  }

  remove(#[inlineFields,isKey=true]##[Field.name]##[IF,!isLast]#,#[endIF]##[endInlineFields]#): Promise<any> {
    return TotvsGpsServices
      .getInstance(#[Table.module]#, this.urlKeys)
      .setPathParams({#[inlineFields,isKey=true]##[Field.name]#:#[Field.name]##[IF,!isLast]#, #[endIF]##[endInlineFields]#})
      .delete();
  }

  insert(#[Table.controller]#: #[Table.module]#): Promise<#[Table.module]#> {
    return TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#)
      .post(#[Table.controller]#, this.url);
  }

  update(#[Table.controller]#: #[Table.module]#): Promise<#[Table.module]#> {
    return TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#)
      .setPathParams(#[Table.controller]#)
      .put(#[Table.controller]#, this.urlKeys);
  }

}
