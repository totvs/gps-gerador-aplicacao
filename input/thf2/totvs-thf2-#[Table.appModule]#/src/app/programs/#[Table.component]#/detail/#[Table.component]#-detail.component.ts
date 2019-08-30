import { ThfNotificationService } from '@totvs/thf-ui/services/thf-notification/thf-notification.service';
import { ThfDialogService } from '@totvs/thf-ui/services/thf-dialog/thf-dialog.service';
import { ActivatedRoute, Router, Params } from '@angular/router';
import { #[Table.module]#Service } from './../services/#[Table.component]#.service';
import { Component, OnInit } from '@angular/core';
import { #[Table.module]# } from '../models/#[Table.component]#';
import { #[Table.module]#Extended } from '../models/#[Table.component]#-extended';
import { take } from 'rxjs/operators';
#[whileFields,!enumComponent=]#
import { #[Field.enumComponent,ModuleName]#Enum } from '../../../shared/enum/#[Field.enumComponent]#.enum';
#[endWhileFields]#
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]# } from '../../../shared/models/#[Field.zoomComponent]#';
import { #[Field.zoomComponent,ModuleName]#Service } from '../../../shared/services/#[Field.zoomComponent]#.service';
#[endWhileFields]#

@Component({
  selector: 'app-#[Table.component]#-detail',
  templateUrl: './#[Table.component]#-detail.component.html',
  styleUrls: []
})
export class #[Table.module]#DetailComponent implements OnInit {

  private route:string = '';
  public  #[Table.controller]#:#[Table.module]# = new #[Table.module]#();
  public  isNew:boolean = true;  
  public  action:string = "Incluir";
  private id:Number;

  constructor(private #[Table.controller]#Service:#[Table.module]#Service,
              #[whileFields,!zoomComponent=]#
              private #[Field.zoomComponent,ControllerName]#Service: #[Field.zoomComponent,ModuleName]#Service,
              #[endWhileFields]#
              private _activatedRoute: ActivatedRoute, 
              private _router:Router,
              private _thfDialogService:ThfDialogService,
              private _thfNotificationService:ThfNotificationService) { }

  ngOnInit() {
    this._activatedRoute.params.pipe(take(1)).subscribe(
      (params: Params) => {
        #[whileFields,isKey=true]#
        #[IF,isFirst]#if(params.#[Field.name]# !== undefined#[endIF]##[IF,!isFirst]# || params.#[Field.name]# !== undefined #[endIF]##[IF,isLast]#){#[endIF]#
        #[endWhileFields]#
          #[whileFields,isKey=true]#
          this.#[Table.controller]#.#[Field.name]# = params.#[Field.name]#;
          #[endWhileFields]#
          this.#[Table.controller]#Service.get#[Table.module]#ById(this.#[Table.controller]#)
            .then(#[Table.controller]# => { this.setData(#[Table.controller]#) });
        }
      }
    );
  }

  back(){
    this._router.navigate([this.route]);
  }

  remove(){
    this._thfDialogService.confirm({
      title: 'Confirmar exclusão',
      message: 'Deseja confirmar a exclusão deste #[Table.description]#?',
      confirm: () => {
          this.#[Table.controller]#Service.remove(this.#[Table.controller]#)
            .then(result => {              
              this._router.navigate([this.route]);
              this._thfNotificationService.success("#[Table.description]# removido com sucesso!");              
            });
      }
    });
  }

  edit(){
    this._router.navigate([this.route,'edit',
              #[whileFields,isKey=true]#
              this.#[Table.controller]#.#[Field.name]##[IF,!isLast]#,#[endIF]#
              #[endWhileFields]#
           ]);
  }

  setData(#[Table.controller]#){     
    this.#[Table.controller]# = this.extend#[Table.module]#(#[Table.controller]#);
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
      let _#[Field.zoomComponent,ControllerName]# = new #[Field.zoomComponent,ModuleName]#();
      _#[Field.zoomComponent,ControllerName]#.#[Field.zoomComponent,ZoomKeyField]# = #[Field.name]#;
      this.#[Field.zoomComponent,ControllerName]#Service.get#[Field.zoomComponent,ModuleName]#ById(_#[Field.zoomComponent,ControllerName]#)
        .then(data => { resolve(data.#[Field.zoomComponent,ZoomLabelField]#) })
        .catch(error => { resolve('') });
    });
  }
  #[endWhileFields]#

}
