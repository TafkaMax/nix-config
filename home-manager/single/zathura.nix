{ pkgs, lib, ...}:

{
  home.file."zathura".text = ''
set guioptions none
set selection-clipboard clipboard
  '';
  home.file."zathura".target = ".config/zathura/zathurarc";
}
