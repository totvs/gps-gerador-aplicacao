import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { PoNotificationService } from '@portinari/portinari-ui';
import { GpsPageEditComponent } from 'totvs-gps-controls';
import { GPSPageNavigation, GpsCRUDMaintenancePage } from 'totvs-gps-crud';
import { #[Table.module]#Service } from '../services/#[Table.component]#.service';
import { #[Table.module]# } from '../models/#[Table.component]#';
#[whileFields,!enumComponent=]#
import { #[Field.enumComponent,ModuleName]#Enum } from '../enum/#[Field.enumComponent]#.enum';
#[endWhileFields]#
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]#Zoom } from '../zoom/#[Field.zoomComponent,ControllerName]#.zoom';
#[endWhileFields]#

@Component({
  selector: 'app-#[Table.component]#-edit',
  templateUrl: './#[Table.component]#-edit.component.html'
})
export class #[Table.module]#EditComponent implements OnInit {

  @ViewChild('gpsPageEdit', {static:true}) gpsPageEdit: GpsPageEditComponent;

  data:#[Table.module]#;
#[whileFields,!enumComponent=]#
  #[Field.enumComponent,ControllerName]#Options = [...#[Field.enumComponent,ModuleName]#Enum.#[Field.enumComponent,ModuleName]#];
#[endWhileFields]#

  private isNew:boolean = true;
  private pageNavigation:GPSPageNavigation = new GPSPageNavigation();
  private maintenanceController:GpsCRUDMaintenancePage<#[Table.module]#>;

  constructor(
    #[whileFields,!zoomComponent=]#
    public  #[Field.zoomComponent,ControllerName]#Zoom: #[Field.zoomComponent,ModuleName]#Zoom,
    #[endWhileFields]#
    private service:#[Table.module]#Service,
    private activatedRoute: ActivatedRoute, 
    private router:Router,
    private notificationService:PoNotificationService) { 
      this.pageNavigation.setRouter(router);
      this.maintenanceController = new GpsCRUDMaintenancePage(activatedRoute,#[Table.module]#);
  }

  ngOnInit() {
    this.gpsPageEdit.showLoading('Carregando');
    this.maintenanceController.getObjectFromRouteParams()
      .then(result => {
        this.setData(result);
        this.initializePage();
      });
  }

  private initializePage(){
    if(this.data == null){
      this.initializeAddPage();
      this.gpsPageEdit.hideLoading();
      return;
    }
    
    this.initializeEditPage();
  }

  private initializeAddPage(){
    this.isNew = true;
    this.setData(new #[Table.module]#());
  }

  private initializeEditPage(){
    this.service.getByObject(this.data)
    .then(result => { 
      this.gpsPageEdit.hideLoading();
      this.isNew = false;
      this.setData(result);
    })
    .catch(() => this.onBack());
  }

  private onBack() {
    this.pageNavigation.back();
  }

  onCancel() {
    this.onBack();
  }

  onSave() {
    this.gpsPageEdit.showLoading('Salvando dados...');
    let _promise: Promise<#[Table.module]#>;
    if (this.isNew)
      _promise = this.service.insert(this.data).then(value => { this.notificationService.success('Registro cadastrado com sucesso!'); return value; });
    else
      _promise = this.service.update(this.data).then(value => { this.notificationService.success('Registro alterado com sucesso!'); return value; });
    _promise
      .then(result => {
        this.gpsPageEdit.hideLoading();
        this.onBack();
      })
      .catch(() => this.gpsPageEdit.hideLoading());
  }

  setData(value){  
    if(this.data == null)  
      this.data = new #[Table.module]#();
    Object.assign(this.data,value);
  }

}
