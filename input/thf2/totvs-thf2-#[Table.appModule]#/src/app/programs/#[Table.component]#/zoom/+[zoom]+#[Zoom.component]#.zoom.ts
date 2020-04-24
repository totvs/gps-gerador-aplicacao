import { Injectable } from '@angular/core';
import { Observable, from } from 'rxjs';
import { PoLookupColumn } from '@portinari/portinari-ui';
import { TotvsGpsServices, TTalkCollection } from 'totvs-gps-services';
import { #[Zoom.module]# } from '../models/#[Zoom.component]#';

@Injectable()
export class #[Zoom.module]#Zoom {

    constructor() {
        this.createColumns();
    }

    //#region Service
    private readonly url = '#[Zoom.appModule]#/#[Zoom.appVersion]#/#[Zoom.controller,Plural]#';
    private readonly urlKeys = this.url
        #[whileZoom,isKey=true]# 
        + '/{{#[ZoomItem.name]#}}'
        #[endWhileZoom]#
        ;

    zoomByFilter(searchObject?:any,pageNumber?:number,pageSize?:number): Promise<TTalkCollection<#[Zoom.module]#>> {
        return TotvsGpsServices
            .getInstance<#[Zoom.module]#>(#[Zoom.module]#, this.url)
            .setQueryParams(searchObject)
            .setPage(pageNumber).setPageSize(pageSize)
            .getCollection();
    }

    zoomById(#[Zoom.controller]#:#[Zoom.module]#): Promise<#[Zoom.module]#> {
        return TotvsGpsServices
            .getInstance<#[Zoom.module]#>(#[Zoom.module]#, this.urlKeys)
            .setPathParams(#[Zoom.controller]#)
            .get();
    }
    //#endregion

    //#region Zoom definition
    private readonly columnNames = [
        #[whileZoom]#
        '#[ZoomItem.name]#',
        #[endWhileZoom]#
    ];
    private readonly columnDefinition = {
        #[whileZoom]#
        '#[ZoomItem.name]#': <PoLookupColumn>{ property: '#[ZoomItem.name]#', label: '#[ZoomItem.description]#' },
        #[endWhileZoom]#
    };

    COLUMNS: PoLookupColumn[];
	#[whileZoom,isLabel=true]#
    readonly FIELD_LABEL = '#[ZoomItem.name]#';
	#[endWhileZoom]#
	#[whileZoom,isKey=true]#
    readonly FIELD_VALUE = '#[ZoomItem.name]#';
	#[endWhileZoom]#

    private createColumns() {
        this.COLUMNS = [];
        this.columnNames.forEach(column => this.COLUMNS.push(this.columnDefinition[column]));
    }

    fieldFormat(value) {
        if (value) {
            #[whileZoom,isKey=true]#
            let _cod = value.#[ZoomItem.name]#;
            #[endWhileZoom]#
            #[whileZoom,isLabel=true]#
            let _des = value.#[ZoomItem.name]#;
            #[endWhileZoom]#
            return `${_cod} - ${_des}`;
        }
        return '';
    }

    getFilteredData(filter:string,page:number,pageSize:number): Observable<TTalkCollection<#[Zoom.module]#>> {
        let result = this.zoomByFilter({q:filter}, page, pageSize);
        return from(result);
    }

    getObjectByValue(value: string): Observable<any> {
        let #[Zoom.controller]#: #[Zoom.module]# = new #[Zoom.module]#();
		#[whileZoom,isKey=true]#
        #[Zoom.controller]#.#[ZoomItem.name]# = #[IF,ZoomItem.inputType=Number]#Number.parseInt(#[endIF]#value#[IF,ZoomItem.inputType=Number]#)#[endIF]#;
		#[endWhileZoom]#
        return from(this.zoomById(#[Zoom.controller]#));
    }
    //#endregion

}
