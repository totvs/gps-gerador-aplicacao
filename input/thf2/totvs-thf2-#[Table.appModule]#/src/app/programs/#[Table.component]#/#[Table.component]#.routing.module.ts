import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { #[Table.module]#ListComponent } from './list/#[Table.component]#-list.component';
import { #[Table.module]#EditComponent } from './edit/#[Table.component]#-edit.component';
import { #[Table.module]#DetailComponent } from './detail/#[Table.component]#-detail.component';

const routes: Routes = [
    { path: '',
        component: #[Table.module]#ListComponent,
    },
    { path: 'new',
        component: #[Table.module]#EditComponent,
    },
    { path: 'edit/' + 
            #[whileFields,isKey=true]#
            ':#[Field.name]##[IF,!isLast]#/#[endIF]#'#[IF,!isLast]# + #[endIF]##[IF,isLast]#,#[endIF]#
            #[endWhileFields]#
        component: #[Table.module]#EditComponent,
    },
    { path: 
        #[whileFields,isKey=true]#
        ':#[Field.name]##[IF,!isLast]#/#[endIF]#'#[IF,!isLast]# + #[endIF]##[IF,isLast]#,#[endIF]#
        #[endWhileFields]#
        component: #[Table.module]#DetailComponent,
    }
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class #[Table.module]#RoutingModule {}
