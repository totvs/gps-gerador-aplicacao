import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Router, Params } from '@angular/router';
import { PoDialogService, PoNotificationService } from '@portinari/portinari-ui';
import { GpsPageDetailComponent } from 'totvs-gps-controls';
import { GPSPageNavigation, GpsCRUDMaintenancePage } from 'totvs-gps-crud';
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

  private pageNavigation:GPSPageNavigation = new GPSPageNavigation();
  private maintenanceController:GpsCRUDMaintenancePage<#[Table.module]#>;

  constructor(
    #[whileFields,!zoomComponent=]#
    public #[Field.zoomComponent,ControllerName]#Zoom: #[Field.zoomComponent,ModuleName]#Zoom,
    #[endWhileFields]#
    private service:#[Table.module]#Service,
    private activatedRoute: ActivatedRoute, 
    private router:Router,
    private dialogService:PoDialogService,
    private notificationService:PoNotificationService) { 
      this.pageNavigation.setRouter(router);
      this.maintenanceController = new GpsCRUDMaintenancePage(activatedRoute,#[Table.module]#);
  }

  ngOnInit() {
    this.gpsPageDetail.showLoading('Carregando');
    this.maintenanceController.getObjectFromRouteParams()
      .then(result => {
        this.setData(result);
        this.service.getByObject(this.data)
          .then(result => { 
            this.gpsPageDetail.hideLoading();
            this.setData(result);
          })
          .catch(() => this.onBack());
      });
  }

  onBack() {
    this.pageNavigation.back();
  }

  onRemove() {
    this.dialogService.confirm({
      title: 'Remover',
      message: 'Deseja confirmar a remoção deste registro?',
      confirm: () => {
        this.gpsPageDetail.showLoading('Removendo...');
        this.service.removeByObject(this.data)
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
    this.pageNavigation.editRegisterPage(this.data);
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
