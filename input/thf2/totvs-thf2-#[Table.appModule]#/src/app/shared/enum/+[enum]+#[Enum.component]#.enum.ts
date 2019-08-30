export class #[Enum.module]#Enum
{
    public static #[Enum.controller]# = [
#[whileEnum]#
        { value: #[IF,Enum.valueDatatype=character]#'#[endIF]##[EnumItem.enumValue]##[IF,Enum.valueDatatype=character]#'#[endIF]#, label: '#[EnumItem.enumLabel]#' },
#[endWhileEnum]#
    ];

    public static getLabel(value) {
        for(let i in this.#[Enum.controller]#) {
            if(this.#[Enum.controller]#[i].value == value) {
                return this.#[Enum.controller]#[i].label;
            }
        }
        return '';
    }
}
