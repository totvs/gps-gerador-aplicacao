import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router, Params } from '@angular/router';
import { PoDialogService, PoNotificationService } from '@portinari/portinari-ui';
import { GpsPageDetailComponent } from 'totvs-gps-controls';
import { #[Table.module]#Service } from '../services/#[Table.component]#.service';
import { #[Table.module]# } from '../models/#[Table.component]#';
import { #[Table.module]#Extended } from '../models/#[Table.component]#-extended';
#[whileFields,!enumComponent=]#
import { #[Field.enumComponent,ModuleName]#Enum } from '../enum/#[Field.enumComponent]#.enum';
#[endWhileFields]#
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]# } from '../models/#[Field.zoomComponent]#';
import { #[Field.zoomComponent,ModuleName]#Zoom } from '../zoom/#[Field.zoomComponent]#.zoom';
#[endWhileFields]#

@Component({
  selector: 'app-#[Table.component]#-detail',
  templateUrl: './#[Table.component]#-detail.component.html'
})
export class #[Table.module]#DetailComponent implements OnInit {

  @ViewChild('gpsPageDetail', {static:true}) gpsPageDetail: GpsPageDetailComponent;

  data:#[Table.module]#Extended;

  constructor(
    #[whileFields,!zoomComponent=]#
    public #[Field.zoomComponent,ControllerName]#Zoom: #[Field.zoomComponent,ModuleName]#Zoom,
    #[endWhileFields]#
    private service:#[Table.module]#Service,
    private activatedRoute: ActivatedRoute, 
    private router:Router,
    private dialogService:PoDialogService,
    private notificationService:PoNotificationService) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(
      (params: Params) => {
        this.gpsPageDetail.showLoading('Carregando');
        this.service.get(#[inlineFields,isKey=true]#params.#[Field.name]##[IF,!isLast]#,#[endIF]##[endInlineFields]#)
          .then(#[Table.controller]# => { 
            this.gpsPageDetail.hideLoading();
            this.setData(#[Table.controller]#);
          })
          .catch(() => this.onBack());
      }
    );
  }

  onBack() {
    this.router.navigate(['']);
  }

  onRemove() {
    this.dialogService.confirm({
      title: 'Remover',
      message: 'Deseja confirmar a remoção deste registro?',
      confirm: () => {
        this.gpsPageDetail.showLoading('Removendo...');
        this.service.remove(#[inlineFields,isKey=true]#this.data.#[Field.name]##[IF,!isLast]#,#[endIF]##[endInlineFields]#)
          .then(result => {
            this.gpsPageDetail.hideLoading();
            this.notificationService.success('Registro removido com sucesso!');
            this.onBack();
          })
          .catch(() => this.gpsPageDetail.hideLoading());
      }
    });
  }

  onEdit() {
    this.router.navigate([
      'edit',
      #[whileFields,isKey=true]#
      this.data.#[Field.name]##[IF,!isLast]#,#[endIF]#
      #[endWhileFields]#
    ]);
  }

  setData(value){     
    this.data = this.extend#[Table.module]#(value);
  }

  //#region Metodos de montagem dos dados
  private extend#[Table.module]#(item:#[Table.module]#): #[Table.module]#Extended {
    let result = new #[Table.module]#Extended().parseJsonToObject(item);
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
}
