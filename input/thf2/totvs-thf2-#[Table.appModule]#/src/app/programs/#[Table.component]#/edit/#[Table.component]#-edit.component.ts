import { Component, OnInit } from '@angular/core';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { PoNotificationService } from '@portinari/portinari-ui';
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

  data:#[Table.module]#;
#[whileFields,!enumComponent=]#
  #[Field.enumComponent,ControllerName]#Options = [...#[Field.enumComponent,ModuleName]#Enum.#[Field.enumComponent,ModuleName]#];
#[endWhileFields]#
  loadingStatus = {
    active: false,
    message: '',
  };

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
        this.service.get(#[inlineFields,isKey=true]#params.#[Field.name]##[IF,!isLast]#,#[endIF]##[endInlineFields]#).then(#[Table.controller]# => { this.setData(#[Table.controller]#) });
      }
    );
  }

  private back() {
    this.router.navigate(['']);
  }

  cancel() {
    this.back();
  }

  save() {
    this.showLoading('Salvando dados...');
    let _promise: Promise<#[Table.module]#>;
    if (this.isNew)
      _promise = this.service.insert(this.data).then(value => { this.notificationService.success('Registro cadastrado com sucesso!'); return value; });
    else
      _promise = this.service.update(this.data).then(value => { this.notificationService.success('Registro alterado com sucesso!'); return value; });
    _promise
      .then(result => {
        this.hideLoading();
        this.back();
      })
      .catch(error => {
        this.hideLoading();
      });
  }

  setData(value){    
    this.data = value;
  }
  
  private showLoading(message?:string) {
    this.loadingStatus.message = (message || '');
    this.loadingStatus.active = true;
  }

  private hideLoading() {
    this.loadingStatus.active = false;
    this.loadingStatus.message = '';
  }
}
