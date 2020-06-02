import { Router } from '@angular/router';
import { Component, OnInit, ViewChild } from '@angular/core';
import { isNullOrUndefined } from 'util';
import { PoDialogService, PoNotificationService, PoPageAction, PoTableColumn, PoTableAction, PoSelectOption } from '@portinari/portinari-ui';
import { GpsPageListComponent, IDisclaimerConfig } from 'totvs-gps-controls';
import { GpsPageFilter, GpsPageNavigation, GpsCRUDListModel } from 'totvs-gps-crud';
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

  pageNavigation:GpsPageNavigation = new GpsPageNavigation();
  pageController:GpsCRUDListModel<#[Table.module]#> = new GpsCRUDListModel<#[Table.module]#>();
  pageFilter:GpsPageFilter<I#[Table.module]#Filter> = new GpsPageFilter<I#[Table.module]#Filter>();

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
  ) {
    this.pageNavigation.setRouter(router);
  }

  ngOnInit(){
    this.initializePageController();
    this.setListColumns();
    this.setDisclaimerConfig();
    this.initEnums();
    this.setActions();
  }

  get filter():any{
    return this.pageFilter.filter;
  }

  private initEnums() {
    #[whileFields,!enumComponent=]#
    this.#[Field.enumComponent,ControllerName]#Options = [
      { value: #[IF,inputType=String]#''#[endIF]##[IF,inputType=Number]#0#[endIF]##[IF,inputType=Boolean]#null#[endIF]#, label: 'Todos' },
      ...#[Field.enumComponent,ModuleName]#Enum.#[Field.enumComponent,ModuleName]#
    ];
    #[endWhileFields]#
  }

  private setActions() {
    this.pageController.actions = [
      { label:'Adicionar',  action: this.onNew.bind(this) }
    ];
  }

  setListColumns(){
    this.pageController.listColumns = [
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
  }

  initializePageController(){
    this.pageController.title = "#[Table.description]#";
    this.pageController.advancedFilterTitle = "Filtrar busca";
    this.pageController.tableMessage = 'Utilize os campos de filtro para pesquisar';
  }

  setDisclaimerConfig(){
    let disclaimerConfig:IDisclaimerConfig[] = [
      { label: 'Pesquisa por', property: 'q' },
      #[whileFields,isFilter=true]#
      *[typescript/disclaimerConfigRangeField.txt,isRangeFilter=true]**[typescript/disclaimerConfigField.txt,isRangeFilter=false]*
      #[endWhileFields]#
    ];
    this.pageFilter.disclaimerConfig = disclaimerConfig;
  }

  //#region Pesquisa
  resetSearch() {
    if (!isNullOrUndefined(this.pageFilter.filter.q))
      return this.applySimpleFilter(this.pageFilter.filter.q);
    
    this.applyAdvancedFilter(this.pageFilter.filter);
  }

  applySimpleFilter(text) {
    this.pageFilter.setFilterText(text);
    this.resetPage();
    this.search();
  }

  applyAdvancedFilter(filter?) {
    this.pageFilter.filter.q = null;
    this.resetPage();
    this.search();
  }

  private search() {
    this.gpsPageList.showLoading('Pesquisando...');
    this.service.getByFilter(this.pageFilter)
      .then(result => { 
        this.resultSearch(result);
        this.gpsPageList.hideLoading();
      })
      .catch(() => this.gpsPageList.hideLoading());
  }

  resultSearch(result){
    this.pageFilter.resumeSearch(result);
    this.setItensTable(result.items);
    this.pageController.tableMessage = undefined; // volta a mensagem padrão da table
  }

  resetPage(){
    this.pageController.listItems = [];
    this.pageFilter.resetPage();
  }

  setItensTable(itens: Object[]){        
    itens.forEach((value) => {
        let _obj:#[Table.module]# = new #[Table.module]#();
        Object.assign(_obj,value);
        _obj = this.extend#[Table.module]#(_obj);
        this.pageController.listItems.push(_obj);
    });
  }
  //#endregion

  //#region Eventos
  onListShowMore() {
    this.pageFilter.nextPage();
    this.search();
  }

  onEdit(item:#[Table.module]#) {
    this.pageNavigation.editRegisterPage(item);
  }

  onRemove(item:#[Table.module]#) {
    this.dialogService.confirm({
      title: 'Remover',
      message: 'Deseja confirmar a remoção deste registro?',
      confirm: () => {
        this.gpsPageList.showLoading('Removendo...');
        this.service.removeByObject(item)
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
    this.pageNavigation.newRegisterPage();
  }

  onDetail(item:#[Table.module]#) {
    if(item == null)
            return;
            
    this.pageNavigation.detailRegisterPage(item);
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
