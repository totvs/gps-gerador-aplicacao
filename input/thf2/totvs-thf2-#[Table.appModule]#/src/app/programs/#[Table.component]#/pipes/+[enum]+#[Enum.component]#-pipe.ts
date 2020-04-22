import { Pipe, PipeTransform } from '@angular/core';
import { #[Enum.module]#Enum } from './enum/#[Enum.component]#.enum';

@Pipe({
	name: '#[Enum.controller]#Format'
})
export class #[Enum.module]#Pipe implements PipeTransform {
	transform(value): string {
		return #[Enum.module]#Enum.getDescription(value);
	}
}
