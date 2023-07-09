{ pkgs, lib, ...}:

{
  home.file."green_forrest.jpg".source = ./green_forrest.jpg;
  home.file."green_forrest.jpg".target = ".config/swaylock/green_forrest.jpg";
}
