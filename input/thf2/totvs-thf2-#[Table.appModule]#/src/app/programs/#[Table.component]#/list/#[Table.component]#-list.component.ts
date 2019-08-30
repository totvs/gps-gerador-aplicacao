import { #[Table.module]#AdvancedFilter } from '../models/#[Table.component]#-advanced-filter';
import { ThfDialogService } from '@totvs/thf-ui/services/thf-dialog/thf-dialog.service';
import { ThfNotificationService } from '@totvs/thf-ui/services/thf-notification/thf-notification.service';
import { Router } from '@angular/router';

import { Component, OnInit, ViewChild } from '@angular/core';
import { ThfTableColumn, ThfTableAction } from '@totvs/thf-ui/components/thf-table';
import { ThfPageAction, ThfPageFilter } from '@totvs/thf-ui/components/thf-page';
import { #[Table.module]#Service } from '../services/#[Table.component]#.service';
import { #[Table.module]# } from '../models/#[Table.component]#';
import { #[Table.module]#Extended } from '../models/#[Table.component]#-extended';
import { ThfModalComponent } from '@totvs/thf-ui/components/thf-modal/thf-modal.component';
import { ThfModalAction } from '@totvs/thf-ui/components/thf-modal/thf-modal-action.interface';
import { SimpleFilter } from '../../../shared/models/simple-filter';
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

  public  pageTitle:string = '#[Table.description]#';  
  public  advancedFilterTitle:string = "Filtrar busca";
  private filterText:string = "";
  private route:string = '';
  public  objectList: Array<#[Table.module]#> = [];
  private pageNumber:number = 1;
  private pageSize:number   = 20;
  public  hasNext:boolean;
  public  #[Table.controller]#AdvancedFilter:#[Table.module]#AdvancedFilter = new #[Table.module]#AdvancedFilter();
  public  isWaiting: boolean = false;
  public  tableMessage: string = 'Utilize os campos de filtro para pesquisar';
  #[whileFields,!zoomComponent=]#
  private #[Field.zoomComponent,ControllerName]#List: Array<#[Field.zoomComponent,ModuleName]#> = [];
  #[endWhileFields]#

  constructor(private _#[Table.controller]#Service:#[Table.module]#Service,
              #[whileFields,!zoomComponent=]#
              private #[Field.zoomComponent,ControllerName]#Service: #[Field.zoomComponent,ModuleName]#Service,
              #[endWhileFields]#
              private _router:Router,
              private _thfDialogService:ThfDialogService,
              private _thfNotificationService:ThfNotificationService) { }

  @ViewChild(ThfModalComponent) thfModal: ThfModalComponent;

  //AÇÕES DA LISTA
  public readonly listActions: Array<ThfPageAction> = [
    { label: 'Adicionar', url: this.route + '/new' }
  ];

  //OBJETO DE FILTRO
  public readonly filterSettings: ThfPageFilter = {
    action: 'filterAction',
    advancedAction: 'openAdvancedFilter',
    ngModel: 'filterText',
    placeholder: 'Código ou Descrição'
  };

  //COLUNAS DA TABELA
  public tableColumns: Array<ThfTableColumn> = [
    #[whileFields,isListable=true]#    
        { column: '#[Field.name]##[IF,!zoomComponent=]#Description#[endIF]##[IF,!enumComponent=]#Description#[endIF]#', label: '#[Field.description]#' #[IF,databaseType=logical|enumComponent=]#, type: 'boolean'#[endIF]##[IF,databaseType=date|enumComponent=]#, type: 'date'#[endIF]##[IF,isLink=true]#, type: 'link', action: (value, row) => { this.onDetail(row); }#[endIF]#},
    #[endWhileFields]#   
  ];

  //AÇÕES DA TABELA
  public tableActions: Array<ThfTableAction> = [
    { label: 'Editar',      action: (row) => { this.onEdit(row);    } },    
    { label: 'Remover',     action: (row) => { this.onRemove(row);  } }
  ];

  //Ações do filtro avançado
  applyFilterAction: ThfModalAction = {
    action: () => {
      this.applyAdvancedFilter();
      this.thfModal.close();
    },
    label: 'Filtrar'
  };

  closeModalAction: ThfModalAction = {
    action: () => {
      this.thfModal.close();
    },
    label: 'Voltar'
  };

  /**
   * Função de inicialização da tela
   **/
  ngOnInit() {
    #[whileFields,!zoomComponent=]#
    this.#[Field.zoomComponent,ControllerName]#Service.get#[Field.zoomComponent,ModuleName]#ByFilter(new SimpleFilter())
      .then(list => { this.#[Field.zoomComponent,ControllerName]#List = list.items; });
    #[endWhileFields]#
  }

  /**
   * Função de buscar mais registros
   */
  showMoreFunction() {
    this.pageNumber = this.pageNumber + 1;   

    this.getObjectByFilter(this.#[Table.controller]#AdvancedFilter,true);
  }

  /**
   * Função de busca
   * @param searchObject objeto da busca
   * @param isMore sinaliza se é para concatenar os registros buscados ou não
   */
  getObjectByFilter(searchObject,isMore){
    if(!isMore) {
      this.objectList = [];
      this.pageNumber = 1;
      this.hasNext = false;
    }
    
    this.isWaiting = true;
    this._#[Table.controller]#Service.get#[Table.module]#ByFilter(searchObject,this.pageNumber,this.pageSize)
      .then(result => {
        this.isWaiting = false;
        this.hasNext = result.hasNext;
        this.setItensTable(result.items);
        this.tableMessage = undefined; // volta a mensagem padrão da table
      })
      .catch(error => {
        this.isWaiting = false;
      });
  }

  /**
   * Função que instancia os objetos que serão mostrados na table
   * @param items objetos da lista
   */
  setItensTable(items: #[Table.module]#[]) {
    items.forEach(item => {
      this.objectList.push(this.extend#[Table.module]#(item));
    });
  }
  
  /**
   * Expande o objeto #[Table.module]# para #[Table.module]#Extented
   * incluindo as descrições dos tipos de dados relacionados
   */
  private extend#[Table.module]#(source: #[Table.module]#): #[Table.module]#Extended {
    let _result: #[Table.module]#Extended = new #[Table.module]#Extended();
    Object.assign(_result, source);
    #[whileFields,!enumComponent=]#
    // Enumerador #[Field.enumComponent]#
    _result.#[Field.name]#Description = #[Field.enumComponent,ModuleName]#Enum.getLabel(_result.#[Field.name]#);
    #[endWhileFields]#
    #[whileFields,!zoomComponent=]#
    // Zoom #[Field.zoomComponent]#
    this.get#[Field.zoomComponent,ModuleName]#Description(_result.#[Field.name]#).then(value => { _result.#[Field.name]#Description = value });
    #[endWhileFields]#

    return _result;
  }
  
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

  /**
   * Função de busca dos objetos
   */

  /* TODO fazer o esquema do filtro avançado */ 
  filterAction(){            
    this.pageNumber = 1;            
    this.#[Table.controller]#AdvancedFilter = new #[Table.module]#AdvancedFilter();

    if((this.filterText != null) && (this.filterText != "")) {
      let simpleFilter: SimpleFilter = new SimpleFilter();
      simpleFilter.search = this.filterText;
      this.getObjectByFilter(simpleFilter,false);  
    }
    else {
      this.getObjectByFilter(null,false);
    }    
  }

  /**
    FUNCÃO RESPONSÁVEL POR CHAMAR A EDIÇÃO
    PARÂMETROS 
    **/
   public onEdit (#[Table.controller]#:#[Table.module]#) {
    if (#[Table.controller]# != null) {
        this._router.navigate([this.route,'edit',
        #[whileFields,isKey=true]#
        #[Table.controller]#.#[Field.name]##[IF,!isLast]#,#[endIF]#         
        #[endWhileFields]#
        ]);
    }        
  }

  /**
    FUNCÃO CHAMADA AO CLICAR NO BOTÃO REMOVER DA LISTAGEM
    PARÂMETROS: 
    **/
  public onRemove (row) {
    let #[Table.controller]#: #[Table.module]# = new #[Table.module]#();
    #[Table.controller]#.parseJsonToObject(row);
    
    if(#[Table.controller]# != null){
      this._thfDialogService.confirm({
        title: 'Confirmar exclusão',
        message: 'Deseja confirmar a exclusão deste #[Table.description]#?',
        confirm: () => {
          this._#[Table.controller]#Service.remove(#[Table.controller]#)
            .then(result => {                
              this._thfNotificationService.success("#[Table.description]# removido com sucesso!");
              this.filterAction();                
            });
        }
      });
    }
  }

  /**
    FUNCÃO RESPONSÁVEL CHAMAR A  TELA DE INCLUSÃO
  **/
  onNew(){        
    this._router.navigate(['/new']);
  }

  /**
    FUNCÃO RESPONSÁVEL CHAMAR A  TELA DE DETALHE
  **/      
  onDetail(#[Table.controller]#:#[Table.module]#){
    if(#[Table.controller]# != null)
        this._router.navigate([this.route,
          #[whileFields,isKey=true]#
          #[Table.controller]#.#[Field.name]##[IF,!isLast]#,#[endIF]#         
          #[endWhileFields]#
        ]);
  }

  openAdvancedFilter(){
    this.thfModal.open();
  }

  applyAdvancedFilter(){  
    this.filterText = "";
    this.getObjectByFilter(this.#[Table.controller]#AdvancedFilter,false);  
  }
}
