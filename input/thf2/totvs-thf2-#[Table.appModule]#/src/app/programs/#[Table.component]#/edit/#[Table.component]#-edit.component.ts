import { Component, OnInit, ViewChild } from '@angular/core';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { PoNotificationService } from '@portinari/portinari-ui';
import { GpsPageEditComponent } from 'totvs-gps-controls';
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

  constructor(
    #[whileFields,!zoomComponent=]#
    public  #[Field.zoomComponent,ControllerName]#Zoom: #[Field.zoomComponent,ModuleName]#Zoom,
    #[endWhileFields]#
    private service:#[Table.module]#Service,
    private activatedRoute: ActivatedRoute, 
    private router:Router,
    private notificationService:PoNotificationService) { }

  ngOnInit() {
    this.activatedRoute.params.subscribe(
      (params: Params) => {
        if (Object.keys(params).length == 0) {
          this.isNew = true;
          this.data = new #[Table.module]#();
          #[whileFields,!defaultValue=]#
          this.data.#[Field.name]# = #[Field.defaultValue]#;
          #[endWhileFields]#
        }
        else {
          this.gpsPageEdit.showLoading('Carregando');
          this.service.get(#[inlineFields,isKey=true]#params.#[Field.name]##[IF,!isLast]#,#[endIF]##[endInlineFields]#)
            .then(#[Table.controller]# => { 
              this.gpsPageEdit.hideLoading();
              this.isNew = false;
              this.setData(#[Table.controller]#);
            })
            .catch(() => this.back());
        }
      }
    );
  }

  private back() {
    this.router.navigate(['']);
  }

  onCancel() {
    this.back();
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
        this.back();
      })
      .catch(() => this.gpsPageEdit.hideLoading());
  }

  setData(value){    
    this.data = value;
  }

}
