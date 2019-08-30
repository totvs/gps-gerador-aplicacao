import { Injectable } from '@angular/core';
import { Observable, from } from 'rxjs';
import { ThfLookupColumn } from '@totvs/thf-ui/components/thf-field';
import { ZoomServiceInterface } from './interface/zoom.service.interface';
import { SimpleFilter } from '../models/simple-filter';
import { #[Zoom.module]#Service } from '../services/#[Zoom.component]#.service';
import { #[Zoom.module]# } from '../models/#[Zoom.component]#';
import { TTalkCollection } from 'totvs-gps-services';


@Injectable()
export class #[Zoom.module]#Zoom implements ZoomServiceInterface {

    private readonly columnNames = [
		#[whileZoom]#
        '#[ZoomItem.name]#',
        #[endWhileZoom]#
	];
    private readonly columnDefinition = {
		#[whileZoom]#
        '#[ZoomItem.name]#': <ThfLookupColumn> { column: '#[ZoomItem.name]#', label: '#[ZoomItem.description]#' },
        #[endWhileZoom]#
    };
    public COLUMNS: Array<ThfLookupColumn>;
	#[whileZoom,isLabel=true]#
    public FIELD_LABEL: string = '#[ZoomItem.name]#';
	#[endWhileZoom]#
	#[whileZoom,isKey=true]#
    public FIELD_VALUE: string = '#[ZoomItem.name]#';
	#[endWhileZoom]#

    constructor(private service: #[Zoom.module]#Service) { 
        this.createColumns();
    }

    private createColumns() {
        this.COLUMNS = [];
        this.columnNames.forEach(column => this.COLUMNS.push(this.columnDefinition[column]));
    }

    public getFilteredData(filter: string, page: number, pageSize: number): Observable<TTalkCollection<#[Zoom.module]#>> {
        let sf = new SimpleFilter();
        sf.search = filter;
        return from(this.service.get#[Zoom.module]#ByFilter(sf, page, pageSize));
    }

    public getObjectByValue(value: string): Observable<#[Zoom.module]#> {
        let #[Zoom.controller]#: #[Zoom.module]# = new #[Zoom.module]#();
		#[whileZoom,isKey=true]#
        #[Zoom.controller]#.#[ZoomItem.name]# = #[IF,ZoomItem.inputType=Number]#Number.parseInt(#[endIF]#value#[IF,ZoomItem.inputType=Number]#)#[endIF]#;
		#[endWhileZoom]#
        return from(this.service.get#[Zoom.module]#ById(#[Zoom.controller]#));
    }
}
