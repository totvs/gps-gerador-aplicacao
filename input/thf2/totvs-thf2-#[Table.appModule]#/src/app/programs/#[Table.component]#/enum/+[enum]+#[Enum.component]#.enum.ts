export class #[Enum.module]#Enum {
  static #[Enum.module]# = [
#[whileEnum]#
    { value: #[IF,Enum.valueDatatype=character]#'#[endIF]##[EnumItem.enumValue]##[IF,Enum.valueDatatype=character]#'#[endIF]#, label: '#[EnumItem.enumLabel]#' },
#[endWhileEnum]#
  ];

  static getDescription(value) {
    let _item = this.#[Enum.module]#.find(item => item.value == value);
    if (_item)
        return _item.label;
    return '';
  }
}
