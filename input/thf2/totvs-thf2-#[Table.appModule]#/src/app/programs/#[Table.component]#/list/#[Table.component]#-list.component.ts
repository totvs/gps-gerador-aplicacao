import { Router } from '@angular/router';
import { Component, OnInit, ViewChild } from '@angular/core';
import { isNullOrUndefined } from 'util';
import { PoDialogService, PoNotificationService, PoPageAction, PoTableColumn, PoTableAction, PoSelectOption } from '@portinari/portinari-ui';
import { GpsPageListComponent, IDisclaimerConfig } from 'totvs-gps-controls';
import { #[Table.module]#Service } from '../services/#[Table.component]#.service';
import { #[Table.module]#, I#[Table.module]#Filter } from '../models/#[Table.component]#';
import { #[Table.module]#Extended } from '../models/#[Table.component]#-extended';
#[whileFields,!enumComponent=]#
import { #[Field.enumComponent,ModuleName]#Enum } from '../enum/#[Field.enumComponent]#.enum';
#[endWhileFields]#
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]# } from '../models/#[Field.zoomComponent]#';
import { #[Field.zoomComponent,ModuleName]#Zoom } from '../zoom/#[Field.zoomComponent]#.zoom';
#[endWhileFields]#

@Component({
  selector: 'app-#[Table.component]#-list',
  templateUrl: './#[Table.component]#-list.component.html'
})

export class #[Table.module]#ListComponent implements OnInit {

  @ViewChild('gpsPageList', {static: true}) gpsPageList: GpsPageListComponent;

  //#region Parametros de tela
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
    { property: '#[IF,!zoomComponent=]#$#[endIF]##[IF,!enumComponent=]#$#[endIF]##[Field.name]##[IF,!zoomComponent=]#Description#[endIF]##[IF,!enumComponent=]#Description#[endIF]#', label: '#[Field.description]#' #[IF,databaseType=logical|enumComponent=]#, type: 'boolean'#[endIF]##[IF,databaseType=date|enumComponent=]#, type: 'date'#[endIF]##[IF,isLink=true]#, type: 'link', action: (value, row) => { this.onDetail(row); }#[endIF]#},
    #[endWhileFields]#
    { property: '$actions', label: 'Ações', type: 'icon', width: '3.5em', icons: 
      [
        { value: 'edit', icon: 'po-icon-edit', tooltip: 'Editar', action: this.onEdit.bind(this) },
        { value: 'remove', icon: 'po-icon-delete', tooltip: 'Remover', color: 'color-07', action: this.onRemove.bind(this) }
      ]
    }
  ];
  //#endregion

  //#region Enumeradores
  #[whileFields,!enumComponent=]#
  #[Field.enumComponent,ControllerName]#Options: PoSelectOption[];
  #[endWhileFields]#
  //#endregion

  constructor(
    #[whileFields,!zoomComponent=]#
    public #[Field.zoomComponent,ControllerName]#Zoom: #[Field.zoomComponent,ModuleName]#Zoom,
    #[endWhileFields]#
    private service:#[Table.module]#Service,
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
    #[whileFields,!enumComponent=]#
    this.#[Field.enumComponent,ControllerName]#Options = [
      { value: #[IF,inputType=String]#''#[endIF]##[IF,inputType=Number]#0#[endIF]##[IF,inputType=Boolean]#null#[endIF]#, label: 'Todos' },
      ...#[Field.enumComponent,ModuleName]#Enum.#[Field.enumComponent,ModuleName]#
    ];
    #[endWhileFields]#
  }

  private disclaimersConfig() {
    return <IDisclaimerConfig[]> [
      { label: 'Pesquisa por', property: 'q' },
      #[whileFields,isFilter=true]#
      *[typescript/disclaimerConfigRangeField.txt,isRangeFilter=true]**[typescript/disclaimerConfigField.txt,isRangeFilter=false]*
      #[endWhileFields]#
    ];
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
    if ((text || '').length > 0) {
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
    this.service.getByFilter(this.filter, this.listPage)
      .then(result => { 
        this.listItems = [...this.listItems,...result.items.map(item => this.extend#[Table.module]#(item))];
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
      title: 'Remover',
      message: 'Deseja confirmar a remoção deste registro?',
      confirm: () => {
        this.gpsPageList.showLoading('Removendo...');
        this.service.remove(#[inlineFields,isKey=true]#item.#[Field.name]##[IF,!isLast]#,#[endIF]##[endInlineFields]#)
          .then(result => {                
            this.gpsPageList.hideLoading();
            this.notificationService.success('Registro removido com sucesso!');
            this.resetSearch();                
          })
          .catch(() => this.gpsPageList.hideLoading());
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
  private extend#[Table.module]#(item:#[Table.module]#): #[Table.module]#Extended {
    let result = new #[Table.module]#Extended().parseJsonToObject(item);
    result.$actions = ['edit','remove'];
    #[whileFields,!enumComponent=]#
    result.$#[Field.name]#Description = #[Field.enumComponent,ModuleName]#Enum.getDescription(result.#[Field.name]#);
    #[endWhileFields]#
    #[whileFields,!zoomComponent=]#
    this.extend#[Field.zoomComponent,ModuleName]#(result);
    #[endWhileFields]#
    return result;
  }
  
  #[whileFields,!zoomComponent=]#
  private extend#[Field.zoomComponent,ModuleName]#(item:#[Table.module]#Extended) {
    let model = new #[Field.zoomComponent,ModuleName]#().parseJsonToObject({#[Field.zoomComponent,ZoomKeyField]#: item.#[Field.name]#});
    this.#[Field.zoomComponent,ControllerName]#Zoom.zoomById(model).then(value => item.$#[Field.name]# = value);
  }

  #[endWhileFields]#

  #[whileFields,!enumComponent=]#
  private get#[Field.enumComponent,ModuleName]#Description(value) {
    return #[Field.enumComponent,ModuleName]#Enum.getDescription(value);
  }
  #[endWhileFields]#
  //#endregion

}
