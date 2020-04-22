import { ThfDialogService } from '@totvs/thf-ui/services/thf-dialog/thf-dialog.service';
import { ThfNotificationService } from '@totvs/thf-ui/services/thf-notification/thf-notification.service';
import { Router } from '@angular/router';

import { Component, OnInit, ViewChild } from '@angular/core';
import { ThfTableColumn, ThfTableAction } from '@totvs/thf-ui/components/thf-table';
import { PoPageAction, PoPageFilter } from '@totvs/thf-ui/components/thf-page';
import { #[Table.module]#Service } from '../services/#[Table.component]#.service';
import { #[Table.module]#, I#[Table.module]#Filter } from '../models/#[Table.component]#';
import { #[Table.module]#Extended } from '../models/#[Table.component]#-extended';
import { TTalkCollection } from 'totvs-gps-services';
#[whileFields,!enumComponent=]#
import { #[Field.enumComponent,ModuleName]#Enum } from '../../../shared/enum/#[Field.enumComponent]#.enum';
#[endWhileFields]#
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]# } from '../../../shared/models/#[Field.zoomComponent]#';
import { #[Field.zoomComponent,ModuleName]#Service } from '../../../shared/services/#[Field.zoomComponent]#.service';
#[endWhileFields]#

@Component({
  selector: 'app-#[Table.component]#-list',
  templateUrl: './#[Table.component]#-list.component.html',
  styleUrls: []
})

export class #[Table.module]#ListComponent implements OnInit {

  @ViewChild('gpsPageList', {static: true}) gpsPageList: GpsPageListComponent;

  //#region Parametros de tela
  pageTitle:string = '#[Table.description]#';
  pageDisclaimerConfig: IDisclaimerConfig[];
  pageActions: PoPageAction[] = [
    { label: 'Adicionar', url: '/new' }
  ];
  filterModel: string;
  filter: I#[Table.module]#Filter = {};
  listItems: #[Table.module]#[];
  listPage: number;
  listHasNext: boolean;
  listColumns: PoTableColumn[] = [
    #[whileFields,isListable=true]#    
    { property: '#[Field.name]##[IF,!zoomComponent=]#Description#[endIF]##[IF,!enumComponent=]#Description#[endIF]#', label: '#[Field.description]#' #[IF,databaseType=logical|enumComponent=]#, type: 'boolean'#[endIF]##[IF,databaseType=date|enumComponent=]#, type: 'date'#[endIF]##[IF,isLink=true]#, type: 'link', action: (value, row) => { this.onDetail(row); }#[endIF]#},
    #[endWhileFields]#   
  ];
  listActions: PoTableAction[] = [
    { label: 'Editar', action: this.onEdit.bind(this) },    
    { label: 'Remover', action: this.onRemove.bind(this) }
  ];
  //#endregion

  //#region Zooms
  // TODO
  #[whileFields,!zoomComponent=]#
  private #[Field.zoomComponent,ControllerName]#List: Array<#[Field.zoomComponent,ModuleName]#> = [];
  #[endWhileFields]#
  //#endregion

  //#region Enumeradores
  // TODO
  // movementTypeOptions: PoSelectOption[] = [];
  // statusOptions: PoSelectOption[] = [];
  //#endregion

  constructor(
    private #[Table.controller]#Service:#[Table.module]#Service,
    #[whileFields,!zoomComponent=]#
    private #[Field.zoomComponent,ControllerName]#Service: #[Field.zoomComponent,ModuleName]#Service,
    #[endWhileFields]#
    private router:Router,
    private dialogService:PoDialogService,
    private notificationService:PoNotificationService
  ) { }

  ngOnInit() {
    this.init();
  }

  private init() {
    let _defaults = this.defaults();

    this.listItems = [];
    this.listPage = 0;
    this.listHasNext = false;
    this.filter = _defaults.filter;
    this.pageDisclaimerConfig = this.disclaimersConfig();

    this.initEnums();
    this.applyAdvancedFilter();
  }

  private initEnums() {
    // TODO
    // this.movementTypeOptions = [
    //   { value: '', label: 'Todos' },
    //   ...SibMovementTypeEnum.SibMovementTypes
    // ];
    // this.statusOptions = [
    //   { value: 0, label: 'Todos' },
    //   ...SibMovementStatusEnum.SibMovementStatus
    // ];
  }

  private disclaimersConfig() {
    return null;
    // TODO
    // return <IDisclaimerConfig[]> [
    //   { label: 'Pesquisa por', property: 'q' },
    //   { label: 'Carteira', property: 'cardNumber' },
    //   { label: 'CCO', property: 'operationalCode', type: 'number' },
    //   { label: 'CPF', property: 'taxpayerRegistry' },
    //   { label: 'Data', property: 'startDate', type: 'date', group: 'data', value: (v) => { return `de ${v}` } },
    //   { label: 'Data', property: 'endDate', type: 'date', group: 'data', separator: ' ', value: (v) => { return `até ${v}` } },
    //   { label: 'Tipo', property: 'movementType', type: 'number', value: this.getTypeDescription },
    //   { label: 'Situação', property: 'status', type: 'number', value: this.getStatusDescription },
    //   { label: 'Modalidade', property: 'modality', type: 'number', group: 'benef', separator: '/' },
    //   { label: 'Proposta', property: 'proposal', type: 'number', group: 'benef', separator: '/' },
    //   { label: 'Beneficiário', property: 'beneficiary', type: 'number', group: 'benef', separator: '/' },
    // ];
  }

  private defaults() {
    return {
      filter: <I#[Table.module]#Filter>{  }
    }
  }

  //#region Pesquisa
  resetSearch() {
    if (!isNullOrUndefined(this.filter.q))
      this.applySimpleFilter(this.filter.q);
    else
      this.applyAdvancedFilter(this.filter);
  }

  applySimpleFilter(text) {
    if ((text || '').length == 0) {
      // pesquisa o padrao
      this.filter = this.defaults().filter;
      this.applyAdvancedFilter();
    }
    else {
      this.filter = { q: text };
      this.listPage = 1;
      this.listHasNext = false;
      this.listItems = [];
      this.search();
    }
  }

  applyAdvancedFilter(filter?) {
    this.filter.q = null;
    this.listPage = 1;
    this.listHasNext = false;
    this.listItems = [];
    this.search();
  }

  restoreAdvancedFilterDefaults() {
    Object.keys(this.filter).forEach(k => { if(isNullOrUndefined(this.filter[k])) delete this.filter[k]});
    let _filter = Object.assign(this.defaults().filter, this.filter);
    Object.assign(this.filter, _filter);
  }

  private search() {
    this.gpsPageList.showLoading('Pesquisando...');
    this._service.getByFilter(this.filter, this.listPage, this.pageSize)
      .then(result => { 
        this.listItems = [...this.listItems,...result.items.map(item => this.extendItem(item))];
        this.listHasNext = result.hasNext;
        this.gpsPageList.hideLoading();
      })
      .catch(() => this.gpsPageList.hideLoading());
  }
  //#endregion

  //#region Eventos
  onListShowMore() {
    this.listPage++;
    this.search();
  }

  onEdit(item:#[Table.module]#) {
    this.router.navigate([
      'edit',
      #[whileFields,isKey=true]#
      item.#[Field.name]##[IF,!isLast]#,#[endIF]#
      #[endWhileFields]#
    ]);
  }

  onRemove(item:#[Table.module]#) {
    this.dialogService.confirm({
      title: 'Confirmar exclusão',
      message: 'Deseja confirmar a exclusão deste registro?',
      confirm: () => {
        this.#[Table.controller]#Service.remove(item)
          .then(result => {                
            this.notificationService.success("Registro removido com sucesso!");
            this.resetSearch();                
          });
      }
    });
  }

  onNew() {
    this.router.navigate(['new']);
  }

  onDetail(item:#[Table.module]#) {
    this.router.navigate([
      #[whileFields,isKey=true]#
      item.#[Field.name]##[IF,!isLast]#,#[endIF]#
      #[endWhileFields]#
    ]);
  }
  //#endregion

  //#region Metodos de montagem dos dados
  private extendItem(source: #[Table.module]#): #[Table.module]#Extended {
    // TODO
    let _result: #[Table.module]#Extended = new #[Table.module]#Extended().parseJsonToObject(source);
    #[whileFields,!enumComponent=]#
    // Enumerador #[Field.enumComponent]#
    _result.$#[Field.name]#Description = #[Field.enumComponent,ModuleName]#Enum.getDescription(_result.#[Field.name]#);
    #[endWhileFields]#


    // TODO
    #[whileFields,!zoomComponent=]#
    // Zoom #[Field.zoomComponent]#
    this.get#[Field.zoomComponent,ModuleName]#Description(_result.#[Field.name]#).then(value => { _result.#[Field.name]#Description = value });
    #[endWhileFields]#

    return _result;
  }

  // TODO
  #[whileFields,!zoomComponent=]#
  private get#[Field.zoomComponent,ModuleName]#Description(#[Field.name]#: #[Field.inputType]#): Promise<string> {
    return new Promise<string>(resolve => {
      let _result: #[Field.zoomComponent,ModuleName]# = this.#[Field.zoomComponent,ControllerName]#List.find(item => item.#[Field.zoomComponent,ZoomKeyField]# == #[Field.name]#);
      if (_result !== undefined) {
        resolve(_result.#[Field.zoomComponent,ZoomLabelField]#);
      }
      else {
        let _#[Field.zoomComponent,ControllerName]# = new #[Field.zoomComponent,ModuleName]#();
        _#[Field.zoomComponent,ControllerName]#.#[Field.zoomComponent,ZoomKeyField]# = #[Field.name]#;
        this.#[Field.zoomComponent,ControllerName]#Service.get#[Field.zoomComponent,ModuleName]#ById(_#[Field.zoomComponent,ControllerName]#)
          .then(data => {
            if (!this.#[Field.zoomComponent,ControllerName]#List.find(item => item.#[Field.zoomComponent,ZoomKeyField]# == #[Field.name]#)) {
              this.#[Field.zoomComponent,ControllerName]#List.push(data);
            }
            resolve(data.#[Field.zoomComponent,ZoomLabelField]#);
          })
          .catch(error => {
            resolve('');
          });
      }
    });
  }
  #[endWhileFields]#
  //#endregion





  // TODO - ver se precisa usar essa logica ai...
  _ngOnInit() {
    #[whileFields,!zoomComponent=]#
    this.#[Field.zoomComponent,ControllerName]#Service.get#[Field.zoomComponent,ModuleName]#ByFilter(new SimpleFilter())
      .then(list => { this.#[Field.zoomComponent,ControllerName]#List = list.items; });
    #[endWhileFields]#
  }


}
