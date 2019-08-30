import { ThfNotificationService } from '@totvs/thf-ui/services/thf-notification/thf-notification.service';
import { Router, ActivatedRoute, Params } from '@angular/router';
import { #[Table.module]#Service } from '../services/#[Table.component]#.service';
import { Component, OnInit } from '@angular/core';
import { #[Table.module]# } from '../models/#[Table.component]#';
import { take } from 'rxjs/operators';
#[whileFields,!enumComponent=]#
import { #[Field.enumComponent,ModuleName]#Enum } from '../../../shared/enum/#[Field.enumComponent]#.enum';
#[endWhileFields]#
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]#Zoom } from '../../../shared/zoom/#[Field.zoomComponent,ControllerName]#.zoom';
#[endWhileFields]#

@Component({
  selector: 'app-#[Table.component]#-edit',
  templateUrl: './#[Table.component]#-edit.component.html',
  styleUrls: [],
  providers: [#[Table.module]#Service]
})
export class #[Table.module]#EditComponent implements OnInit {

  private route:string = '';
  public  #[Table.controller]#:#[Table.module]# = new #[Table.module]#();
  public  action:string = "Incluir";  
  public  isNew:boolean = true;
#[whileFields,!enumComponent=]#
  public  #[Field.enumComponent,ControllerName]#Options = #[Field.enumComponent,ModuleName]#Enum.#[Field.enumComponent,controllerName]#;
#[endWhileFields]#
  
  public loadingStatus = {
    active: false,
    message: '',
  }

  constructor(private _#[Table.controller]#Service:#[Table.module]#Service,
#[whileFields,!zoomComponent=]#
              public  #[Field.zoomComponent,ControllerName]#Zoom: #[Field.zoomComponent,ModuleName]#Zoom,
#[endWhileFields]#
              private _activatedRoute: ActivatedRoute, 
              private _router:Router,
              private _thfNotificationService:ThfNotificationService) { }

  ngOnInit() {
    this.#[Table.controller]# = new #[Table.module]#();
    this.isNew = true;
    #[whileFields,isKey=true]#
    this.#[Table.controller]#.#[Field.name]# = #[Field.defaultValue]#;
    #[endWhileFields]#

    this._activatedRoute.params.pipe(take(1)).subscribe(
      (params: Params) => {        
        #[whileFields,isKey=true]#
        #[IF,isFirst]#if(params.#[Field.name]# !== undefined#[endIF]##[IF,!isFirst]# || params.#[Field.name]# !== undefined #[endIF]##[IF,isLast]#){#[endIF]#
        #[endWhileFields]#
          #[whileFields,isKey=true]#
          this.#[Table.controller]#.#[Field.name]# = params.#[Field.name]#;
          #[endWhileFields]#
          this.isNew = false;
          this._#[Table.controller]#Service.get#[Table.module]#ById(this.#[Table.controller]#)
            .then(#[Table.controller]# => { this.setData(#[Table.controller]#) });
        }
      }
    );
  }

  cancel(){
    this._router.navigate([this.route]);
  }

  save(){
    this.showLoading('Salvando dados...');
    this._#[Table.controller]#Service.save(this.#[Table.controller]#, this.isNew)
      .then(result => {
        this._thfNotificationService.success("#[Table.description]# " 
                                              + (this.isNew ? "cadastrado" : "alterado")
                                              + " com sucesso!");
        this.hideLoading();
        this._router.navigate([this.route]);
      })
      .catch(error => {
        this.hideLoading();
      });
  }

  setData(#[Table.controller]#){    
    this.#[Table.controller]# = #[Table.controller]#;
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
