
import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';
import { environment } from './../environments/environment';
import { #[Table.module]#Module } from '../app/programs/#[Table.component]#/#[Table.component]#.module';
if (environment.production) {
    enableProdMode();
}
platformBrowserDynamic().bootstrapModule(#[Table.module]#Module)
.catch(err => console.log(err));
