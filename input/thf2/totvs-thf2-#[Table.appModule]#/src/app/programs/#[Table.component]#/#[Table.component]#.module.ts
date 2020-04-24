import { NgModule } from '@angular/core';
import { #[Table.module]#ListComponent } from './list/#[Table.component]#-list.component';
import { #[Table.module]#DetailComponent } from './detail/#[Table.component]#-detail.component';
import { #[Table.module]#EditComponent } from './edit/#[Table.component]#-edit.component';
import { AppComponent } from '../../app.component';
import { #[Table.module]#RoutingModule } from './#[Table.component]#.routing.module';
import { AppModule } from '../../app.module';
import { #[Table.module]#Service } from './services/#[Table.component]#.service';
#[whileFields,!zoomComponent=]#
import { #[Field.zoomComponent,ModuleName]#Zoom } from './zoom/#[Field.zoomComponent]#.zoom';
#[endWhileFields]#

@NgModule({
  bootstrap: [AppComponent],
  imports: [
    #[Table.module]#RoutingModule,    
    AppModule
  ],  
  declarations: [
    #[Table.module]#ListComponent,
    #[Table.module]#EditComponent,
    #[Table.module]#DetailComponent,
  ],
  exports: [
    #[Table.module]#ListComponent,
  ],
  providers: [
    #[Table.module]#Service,
    #[whileFields,!zoomComponent=]#
    #[Field.zoomComponent,ModuleName]#Zoom,
    #[endWhileFields]#
  ]
})
export class #[Table.module]#Module { }
