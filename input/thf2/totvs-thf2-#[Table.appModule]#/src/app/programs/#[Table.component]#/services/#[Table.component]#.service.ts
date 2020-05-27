import { Injectable } from '@angular/core';
import { TotvsGpsServices, TTalkCollection } from 'totvs-gps-services';
import { #[Table.module]#, I#[Table.module]#Filter } from '../models/#[Table.component]#';
import { GPSPageFilter} from 'totvs-gps-crud';
import { isNullOrUndefined } from 'util';
import { GPSMaintenanceUrl } from 'totvs-gps-utils';

@Injectable()
export class #[Table.module]#Service {

  private readonly url = '#[Table.appModule]#/#[Table.appVersion]#/#[Table.controller,Plural]#';
  private readonly urlKeys = `${this.url}#[inlineFields,isKey=true]#/{{#[Field.name]#}}#[endInlineFields]#`;

  getByFilter(pageFilter?:GPSPageFilter<any>,expand?:string[],fields?:string[]): Promise<TTalkCollection<#[Table.module]#>> {
    let request =  TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#, this.url)
      .setPage(pageFilter.listPage)
      .setPageSize(pageFilter.listSize)
      .setFields(fields || pageFilter.fields)
      .setExpand(expand || pageFilter.expand)
      .setQueryParams(pageFilter.filter);

    return request.getCollection();
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

  getByObject(#[Table.controller]#:#[Table.module]#,expand?:string[],fields?:string[]): Promise<#[Table.module]#> {
    return TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#,GPSMaintenanceUrl.getUrl(#[Table.controller]#,this.url))
      .setPathParams(#[Table.controller]#)
      .setFields(fields).setExpand(expand)
      .get();
  }

  removeByObject(#[Table.controller]#:#[Table.module]#): Promise<any> {
    return TotvsGpsServices
      .getInstance<#[Table.module]#>(#[Table.module]#,GPSMaintenanceUrl.getUrl(#[Table.controller]#,this.url))
      .setPathParams(#[Table.controller]#)
      .delete();
  }
}
